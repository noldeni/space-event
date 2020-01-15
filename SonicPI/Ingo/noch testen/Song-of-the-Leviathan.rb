#Song-of-the-Leviathan.rb
#https://in-thread.sonic-pi.net/u/Eli
#https://in-thread.sonic-pi.net/t/whale-song-anyone/260/10


#Eli...

use_debug false
use_bpm 120

tracker = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

use_random_seed 66776

sonar_vol = 1
whale_vol = 0.2


round = (ring 50,48,62,48,62)
x=0
distance = 4.0

define :start_loop do |i|
  tracker[i] = 1
end


define :stop_loop do |i|
  tracker[i] = 0
end

drum_vol = (line 0.2, 2, inclusive: true, steps: 5).ramp



define :stop_all do
  tracker[0] = 0
  tracker[1] = 0
  tracker[2] = 0
  tracker[3] = 0
  tracker[4] = 0
  tracker[5] = 0
  tracker[6] = 0
  tracker[7] = 0
  tracker[8] = 0
  tracker[9] = 0
  tracker[10] = 0
  tracker[11] = 0
end

live_loop :bar do
  sleep 1
end

live_loop :beats do
  sync :bar
  sleep 4
end


with_fx :echo, mix: 0.8, phase: 0.75, decay: 4 do
  live_loop :swirl do
    if tracker[1]>0 then
      with_fx :flanger, stereo_invert_wave: 1, feedback: 0.5, amp: 0.5 do
        sync :beats
        use_synth :mod_beep
        rps = (range 3, 6).choose
        use_synth_defaults res: 0.9, attack: 0.25, noise: 2, release: 2 , cutoff: 100, amp: 0.2,
          note_slide: 0.02, sustain: 0.5 * rps / 1.25, decay: 0.25 * rps / 1.25, sustain_level: 0.8,
          mod_range: 0.5, mod_phase: 0.5, mod_wave: 7, pulse_width: 0.2
        mynote = (note_range, :g2, :g4, pitches: (scale, :g, :minor_pentatonic))
        play mynote.reverse.tick
        rps.times do
          control note: mynote.tick - [0, 12].choose
          sleep [0.25, 0.25, 0.5, 0.5, 0.75].choose
        end
        sleep 2.5
      end
    else
      sleep 0.25
    end
  end
end

with_fx :echo, mix: 0.8, phase: 0.75, decay: 4 do
  live_loop :swirl1 do
    if tracker[2]>0 then
      with_fx :flanger, stereo_invert_wave: 1, feedback: 0.5, amp: 0.5 do
        sync :beats
        use_synth :mod_beep
        rps = (range 6, 9).choose
        use_synth_defaults res: 0.9, attack: 0.25, noise: 2, release: 2 , cutoff: 100, amp: 0.2 ,
          note_slide: 0.02, sustain: 0.25 * rps / 1.25, decay: 0.25 * rps / 1.25, sustain_level: 0.8,
          mod_range: 0.5, mod_phase: 0.125, mod_wave: 2, pulse_width: 0.2
        mynote = (note_range, :g4, :g6, pitches: (scale, :g, :minor_pentatonic))
        play mynote.reverse.tick
        rps.times do
          control note: mynote.tick - [0, 12].choose
          sleep [0.25, 0.25, 0.5, 0.5, 0.75].choose
        end
        sleep 2.5
      end
    else
      sleep 0.25
    end
  end
end

with_fx :echo, mix: 0.8, phase: 0.75, decay: 4 do
  with_fx :flanger, stereo_invert_wave: 1, feedback: 0.5, amp: 0.25 do
    
    live_loop :whales do
      if tracker[3]>0 then
        sync :beats
        use_synth :fm
        if look < 20 then
          whale_vol +=0.4
        end
        if look > 64 then
          whale_vol -=0.2
        end
        if whale_vol < 0.2
          whale_vol = 0.1
        end
        
        puts look
        puts whale_vol
        
        repeater = [6,7,8,9,12].choose
        use_synth_defaults res: 0.9, attack: 0.25, noise: 2, release: 2 , cutoff: 100, amp: 0.3 * whale_vol,
          note_slide: 5.02, sustain: 0.25 * repeater / 1.25, decay: 0.25 * repeater / 1.25, sustain_level: 0.8,
          mod_range: 0.5, mod_phase: 0.125, mod_wave: 2, pulse_width: 0.2
        mynote =  note_range( :g3, :g5, pitches:  scale( :g6, :minor))
        play mynote.tick
        repeater.times do
          control note: mynote.tick + [0, 12].choose
          sleep [0.25, 0.25, 0.5].choose
        end
        sleep 2.5
      else
        sleep 0.1
      end
    end
  end
end

with_fx :echo, phase: 0.375 do
  
  live_loop :sonar do
    if tracker[4]>0 then
      if look == 1 then
        use_bpm 60
        distance = 4.0
      end
      if look == 3 then
        use_bpm 90
        distance = 3.0
      end
      if look ==  5 then
        use_bpm 240
        distance = 2.0
      end
      if look > 7 then
        use_bpm 480
        distance = 1.0
      end
      if look == 64 then
        use_bpm 480
        distance = 1.0
      end
      if look == 80 then
        use_bpm 240
        distance = 2.0
      end
      if look ==  82 then
        use_bpm 120
        distance = 3.0
      end
      if look > 84 && look < 74 then
        use_bpm 90
        distance = 4.0
      end
      if look > 86 then
        use_bpm 60
        distance = 4.0
      end
      puts look
      use_synth :sine
      use_synth_defaults note_slide: 5.02, amp: 0.125
      repeater = rrand_i(1,2)
      repeater.times do
        sync :beats
      end
      notes =  :g5
      play notes, release: 2
      sleep 0.25 * distance
      play notes, release: 2
      tick
    else
      sleep 0.25
    end
  end
end


with_fx :reverb, mix: 0.5 do
  use_bpm 30
  live_loop :oceans do
    if tracker[0]>0 then
      s = synth [:bnoise, :cnoise, :gnoise].choose, amp: rrand(0.175, 0.2), attack: rrand(0, 4),
        sustain: rrand(0, 2), release: rrand(1, 3),
        cutoff_slide: rrand(0, 5), cutoff: rrand(60, 100), pan: rrand(-1, 1), pan_slide: rrand(1, 5),
        amp: rrand(0.05, 0.1)
      control s, pan: rrand(-1, 1), cutoff: rrand(60, 70)
      sleep rrand(2, 4)
    else
      sleep 0.1
    end
  end
end

oceans=0
swirl=1
swirl1=2
whales=3
sonar=4


3.times do
  start_loop swirl
  start_loop swirl1
  sleep 4
  stop_loop swirl
  stop_loop swirl1
end
start_loop oceans
sleep 8
start_loop sonar
sleep 12
start_loop whales
sleep 40
stop_loop whales
sleep 4
stop_loop sonar
sleep 8
stop_loop oceans