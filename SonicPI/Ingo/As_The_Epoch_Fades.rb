# As_The_Epoch_Fades.rb 
## As The Epoch Fades - Video Version
## Coded by Nanomancer 13.04.2016
## Sonic Pi version 2.9

=begin
About:
An experiment in sending values between live_loops to increase 'intelligence' of generative abilities:
eg loops that can change speed/key depending on another
WARNING! there's some funny(ish) stuff going on to force certain events at certain times, and the
interaction between Darkharp and bassthrob caused some headaches with recalling events in the random stream. (coded with v2.9 - before introduction of current_random_seed)
Still needs some tidying
=end

set_volume! 5
use_debug false
use_cue_logging false
$global_clock = 0
max_t = 3.34
rseed = 236249
# rseed = Time.now.usec # uses the value of the microseconds part of your computers clock as a seed
use_random_seed rseed

# File.open('Sync/sonic_pi/epoch_fall.txt', 'a+') do |f|
#   ## open or create a txt file and append the value of rseed to it. Doesn't affect SP's output
#   ## just for dev/debugging really, useful to capture the results of
#   ## a particular clock seed if it does a good run!
#   ## put in your own path if you wish to use it, comment out otherwise.
#   f.puts("Seed: #{rseed}")
# end

# 236249
# puts "Seed: #{rseed}"

# puts "sync!"
# sample :elec_blip, amp: 0.6
# puts "As The Epoch Falls"
puts "Coded by Nanomancer"
sleep 1

############ DEFINE FUNCTIONS #################

define :stopwatch do |int, max, fade|
  ## interval in seconds (display for log timer),
  ## max in mins, fade in secs
  count = 0
  set_mixer_control! amp: 5, amp_slide: 0.1
  with_bpm 60 do
    ctrl = true
    while count / 60.0 <= max
      if count / 60.0 == 1.0 then use_random_seed rseed end
      if count % int == 0
        puts "Time: #{count / 60.0} Minutes"
      end
      count += 1
      sleep 1
      $global_clock = count / 60.0
      if count >= (max*60) - fade && ctrl == true
        set_mixer_control! amp: 0.01, amp_slide: fade
        puts "Stopping - #{fade} sec fadeout"
        ctrl = false
      end
    end
  end
end

define :autocue do |id, time|
  return cue id if $global_clock >= time
end

define :autostop do |time|
  return stop if $global_clock >= time
end

define :varichord do |chord_arr, vol, len=8|
  # takes an array of MIDI note numbers(preferably some sort of chord) and
  # plays each note with different env/filt settings on each call
  
  play chord_arr[0], amp: vol*rdist(0.05, 1),
    attack: len*rrand(0.5, 0.8), sustain: len*rrand(0.25, 0.6),
    release: len*rrand(0.5, 0.8), cutoff: rrand(75,110), pan: -1
  play chord_arr[1], amp: vol*rdist(0.05, 1),
    attack: len*rrand(0.4, 0.7), sustain: len*rrand(0.25, 0.6),
    release: len*rrand(0.4, 0.7), cutoff: rrand(75,110)
  play chord_arr[2], amp: vol*rdist(0.05, 1),
    attack: len*rrand(0.3, 0.6), sustain: len*rrand(0.25, 0.6),
    release: len*rrand(0.3, 0.6), cutoff: rrand(75,110), pan: 1
  # play chord_arr[3], amp: vol*rrand(0.8, 1.2),
  #   attack: len*rrand(0.3, 0.6), sustain: len*rrand(0.25, 0.5),
  #   release: len*rrand(0.3, 0.6), cutoff: rrand(75,110), pan: 0.5
end

define :mk_rand_scale do |scale, len = 8|
  # takes a scale array as input and generates a randomised ring array that
  # may have the same note multiple times, default length 8
  rand_s = [] # initialises an empty array
  len.times do
    rand_s << scale.choose ## the 'double less-than' (<<) appends the value of scale.choose to the array
  end
  return rand_s.ring # making it a ring here means less work elsewhere!
end


define :bass_patt do |rst, no_rest, rst_harp, deg, multi, slp|
  
  ## Gets called twice in the bass throb loop, avoids duplicating code
  ## needs some tidying, posssibly too many arguments(inputs to the function)
  ## variable names are confusing - edit
  
  play (degree deg, :A1, :hungarian_minor), # degree is an SP builtin, see help
    amp: 0.13, attack: rdist(0.01, 0.02),
    release: slp.tick(:slp)*multi*1.25*rdist(0.1, 1),
    cutoff: rdist(2.1, 80) unless rst # no sound if rst=TRUE
  unless rst then puts "BASS - Deg: #{deg} | Len: #{slp.look(:slp)*multi}" end# used for dev/debug
  
  sleep slp.look(:slp) *0.5*multi # sleep even if bass is resting, waits for half of the length of a bass note before darkharp gets cued
  unless no_rest && multi == 2 # this block only executes if both values are false
    if multi == 2 && one_in(2) && rst_harp == false then cue :d_harp, degree: deg, multi: multi # 'transmits' the cue msg, note/degree of scale and relative speed
    elsif multi == 1 && one_in(3) && rst_harp == false then cue :d_harp, degree: deg #
    end
  else cue :d_harp, degree: deg # must be for emergency?
  end
  sleep slp.look(:slp) *0.5*multi # cueing complete, the other half of the sleep
end


#############  CLOCK  #####################

in_thread do
  stopwatch(30, max_t, 20)
end

# in_thread do
#   # if $global_clock >= max then use_random_seed rseed end
#   while $global_clock * 60 < 90
#     puts $global_clock * 60
#     sleep 2
#   end
# end

#############  PAD  ###############

live_loop :ambipad do
  # map = sync :a_pad
  use_synth :hollow
  tick_reset
  
  3.times do
    len = [8, 8, 16].ring.tick
    puts "Ambipad - len: #{len}"
    chords2 = (chord_invert (chord_degree [:i, [:vii, :v].choose, :i].ring.look,
                             :A2, :hungarian_minor, 3), rrand_i(0,3))
    # puts "Ambipad: #{chords2} | length: #{len}"
    
    with_fx :reverb, mix: 0.6 do
      varichord(chords2, 0.35, len)
      sleep len
    end
  end
  if one_in 3 then sleep [8,16,32].choose end
  autostop(max_t)
end


############ GENERATE WHISPER SEQUENCE  ##############

## uses the mk_rand_scale function to generate two different scale patterns
## this is outside the live loop so only regenerates on run, not each iteration of the whisper loop

scales_arr = []
2.times do # increasing the number of loops here will give more melodic patterns for the whisper live_loop below to choose from
  scl = scale(:a3, :hungarian_minor, num_octaves: 2)
  scales_arr << mk_rand_scale(scl, 3)
end
puts "Generated patterns for whisper loop:\n#{scales_arr}" # just checking, puts is your friend and will make debugging so much easier :)


############### WHISPER LEAD ##################

# live_loop :whisper, delay: [16, 32].choose do
live_loop :whisper, delay: 16 do
  
  autostop(rrand max_t*0.9, max_t)
  use_synth :dark_ambience
  
  notes = scales_arr.choose # remember our array - 'scales_arr' is multidimensional - it's lists within a list, so this
  slp = [[2,2,4], [2,2], [4,4,8], [4,4], [2,1.5,0.5,4]].choose.ring
  if look == 0 then rand_back(4) end
  2.times do
    # puts "Whisper seq: #{slp}"
    tick_reset
    slp.size.times do
      puts "Whisper - Len: #{slp.look}"
      att, sus, rel = slp.tick * 0.1, slp.look * 0.4, slp.look * 0.6
      phase = [0.25, 0.5, 0.75, 1].choose
      with_fx :echo, mix: 0.25, phase: 1.5, decay: 4 do
        with_fx :slicer, mix: rrand(0.2, 0.5), smooth_up: phase * 0.5, smooth_down: phase * 0.125, phase: phase do
          play notes.look, amp: 0.4, attack: att, sustain: sus, release: rel, cutoff: 85 # unless one_in(3)
          sleep slp.look
        end
      end
    end
    sleep 8
  end
  if one_in(3) then sleep [8, 16, 32].choose end
end


####################################################

################  DARKHARP HIT ################

live_loop :darkharp, auto_cue: false do |loopcount|
  # autostop(rrand max_t*0.7, max_t)
  autostop(max_t)
  
  rand_skip(1)
  map = sync :d_harp
  use_synth :zawa
  if loopcount == 5
    rand_reset
    rand_skip(1)
  elsif loopcount == 11
    rand_reset
    rand_back(2)
  end
  chords2 = (chord_degree map[:degree], :A3, :hungarian_minor, 5)
  puts "DARKHARP - No: #{loopcount}"
  # puts "Darkharp degree: #{map[:degree]}"
  
  if map[:multi] == 2 then slp = [0.25,0.5,0.75].choose
  else slp = 0.25
  end
  # slp = 0.75
  note1 = [0, 1].choose
  if one_in(3) then reps = 1
  else reps = 2
  end
  ## explain this block. pattern/rule to enable simplification mathmetically?
  ##
  # rand_back(4)
  if map[:degree] == :i || map[:degree] == :viii && note1 == 0 then note2 = note1 + [1,2,3,4].choose
  elsif map[:degree] == :i || map[:degree] == :viii && note1 == 1 then note2 = note1 + [1,3,4].choose
  elsif map[:degree] == :iii && note1 == 0 then note2 = note1 + [1,3].choose
  elsif map[:degree] == :iii && note1 == 1 then note2 = note1 + [1,2,4].choose
    
  elsif map[:degree] == :vii && note1 == 0 then note2 = note1 + [1,4].choose
  elsif map[:degree] == :vii && note1 == 1 then note2 = note1 + [3,4].choose
  end
  with_fx :echo, mix: 0.4, phase: 1.5, decay: 10 do
    with_fx :reverb, mix: 0.7, room: 0.6, amp: 0.5 do
      reps.times do
        
        oct = [12, -12].choose
        # puts "Darkharp notes- N1= #{note1+1} - N2= #{note2+1}"
        play chords2[note1]+oct, amp: 0.081, attack: rdist(0.01, 0.06), release: rdist(0.125, 1.25), cutoff: rdist(3, 95), pan: 1
        sleep slp
        play chords2[note2], amp: 0.082, attack: rdist(0.01, 0.07), release: rdist(0.1, 1.5), cutoff: rdist(3, 95), pan: -1
        sleep slp
      end
    end
  end
  loopcount += 1
end


############### BASS THROB ################


live_loop :throb do |loopcount|
  
  # puts "BASSCOUNT #{loopcount}"
  if loopcount == 2
    rand_reset
  end
  # if idx == 1 then use_random_seed rseed end
  
  ## the heart of it all, generates the bassline and lets ambipad and darkharp know what to play
  use_synth :prophet
  autostop(max_t)
  # set relative speed of bassline
  # if basscount == 4 then multi = 0.5
  if one_in 4 then multi = 2
  elsif one_in 2 then multi = 0.5
  else multi = 1
  end
  # multi = 2
  rst, rst_harp, no_rest = one_in(4), one_in(11), one_in(4) # rest chances - lets get these variable names a little more clear!
  if look == 0
    rst, rst_harp = true, true
  elsif loopcount == 3
    rst, rst_harp = false, false
  end
  slp = [4,2,2].ring
  cue :a_pad, multi: multi # lets ambipad know what's going on :)
  deg1_reps = [3,9].choose
  with_fx :slicer, phase: 0.5, mix: 0.5, smooth_up: 0.125 do
    2.times do
      repcount += 1
      # puts "repcount #{repcount}"
      deg1_reps.times do
        
        deg1 = [[:i, :viii].ring.tick(:oct), :i, :vii].ring.tick # yeah, I'm confused too. Alternates octaves...
        bass_patt(rst, no_rest, rst_harp, deg1, multi, slp) #
      end
      
      3.times do
        deg2 = [:i, :iii, :vii].ring.tick
        bass_patt(rst, no_rest, rst_harp, deg2, multi, slp)
      end
    end
  end
  # idx += 1
  loopcount += 1
end

###############  DRUMS 1  ################

# live_loop :doombeat, delay: [32, 64].choose do
live_loop :doombeat, delay: 16 do
  
  # autostop(rrand max_t*0.8, max_t*0.95)
  autostop(rrand max_t*0.85, max_t)
  
  if one_in(5) || look == 0
    # cut = rrand(70, 80)
    tick_reset
    8.times do
      cut = range(66, 72, step: 2).mirror.ring
      puts "DOOMBEAT slow | Cutoff: #{cut.look}"
      sample :loop_industrial, beat_stretch: 4, amp: 0.25, cutoff: cut.tick
      sleep 2
      puts "DOOMBEAT Bigsnare"
      sleep 2
    end
    
  elsif one_in(3)
    tick_reset
    16.times do
      cut = range(62, 76, step: 2).mirror.ring
      puts "DOOMBEAT sweep | Cutoff: #{cut.look}"
      sample :loop_industrial, beat_stretch: 2, amp: 0.225, cutoff: cut.tick
      sleep 2
    end
    
  else
    cut = rrand(68, 78)
    8.times do
      puts "DOOMBEAT | Cutoff: #{cut.round(2)}" # using your own debugging makes it clear what part of the loop is executing(or not) at any given time
      sample :loop_industrial, beat_stretch: 2, amp: 0.225, cutoff: cut
      sleep 2
    end
  end
  if one_in(2) then sleep [8, 8, 16].choose end #
end

###