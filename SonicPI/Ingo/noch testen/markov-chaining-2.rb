#markov-chaining-2.rb
#https://in-thread.sonic-pi.net/u/Eli
#https://in-thread.sonic-pi.net/t/generative-piano-using-markov-chaining/1168/9

use_bpm 60 # global bpm
M = 4.0 # measure size
R = 59 # root note
S = scale(R, :minor) # working scale
set :root, 0 # initialize root note (relative)

SAMPLE = "path/to/vocal/sample/vocals.wav"

# A hash to control loop levels in a single place
LEVELS = {
  hats: 0.0,
  snares: 1.75,
  kicks: 3.0,
  right: 0.15,
  left: 0.5,
  subbass: 0.5,
  vox: 2.75
}

# This hash simulates a markov chain.
# Each key is the state and the array
# value represents the next state from
# which to choose at random.
H = {
  8 => [0],
  7 => [8],
  6 => [2],
  5 => [2, 2, 0, 0, 7, 7],
  4 => [1, 1, 2, 2, 6, 6],
  3 => [5],
  2 => [4, 4, 0],
  1 => [3, 3, 3, 0, 0, 0],
  0 => [-2, 2, 4, 4, 0],
  -1 => [-3, -3, 0, 0],
  -2 => [-4, -4, 0],
  -3 => [-5],
  -4 => [-1, -1, -2, -2, -6, -6],
  -5 => [-2, -2, 0, 0, -7, -7],
  -6 => [2],
  -7 => [8],
  -8 => [0],
}

# Rhythm Patterns
p1 = (bools 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0) # kick drums
p2 = (bools 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0) # snare drums
p3 = (knit, M/16, 4, M/24, 6, M/16, 4, M/24, 6, M/16, 4, M/64, 8) # hihats
sb = (50..100).ring.mirror # simulate fade-up -> fade-down
ds = (0..9).map {|n| n * 0.1}.ring
# Random durations
d1 = (knit M/8, 8, M/16, 4, M/-8, 2, M/-16, 2)

# State machine utility functions
define :markov do |a, h| h[a].sample; end # Chooses the next state at  random from hash
define :gg do get[:root]; end # simplified root note in scale getter
define :g do S[R + get[:root]]; end # simplified raw root note getter
define :s do |n| set :root, n; end # simplified root note setter

# play function with duration baked in and the ability to play rests using negative (-) time (i.e. M/-4 would be a quarter rest).
define :pplay do |n, d|
  play n if d >= 0
  sleep d.abs
end

# Rhythm Components
live_loop :kicks do # kick drum loop
  l = LEVELS[:kicks] || 0 # keeping this outside of the do...end block ensures a consistent level across the measure
  16.times do # using 16 times here makes the grid loops better synced to measures
    with_fx :level, amp: l do
      sample :bd_tek if p1.tick
      sleep M / 16
    end
  end
end

live_loop :snares do # snares loop
  l = LEVELS[:snares] || 0 # keeping this outside of the do...end block ensures a consistent level across the measure
  16.times do  # using 16 times here makes the grid loops better synced to measures
    with_fx :level, amp: l do
      sample :sn_dolf if p2.tick
      sleep M / 16
    end
  end
end

live_loop :hats do # hi-hats loop
  l = LEVELS[:hats] || 0 # keeping this outside of the do...end block ensures a consistent level across the measure
  16.times do
    with_fx :level, amp: l do
      with_fx :eq, high: -0.5, mid: -0.9 do
        with_fx :distortion, mix: 0.9 do
          sample :drum_cymbal_closed, sustain: 0, release: 0.01 , rate: 1, amp: 2 + rrand(-0.5, 0.5) if p3.tick >= 0
          sleep p3.look.abs
        end
      end
    end
  end
end

# Vox samples
live_loop :vox do
  with_fx :level, amp: LEVELS[:vox] || 0 do
    with_fx :reverb, mix: ds.tick, room: 0.4 do
      with_fx :echo, mix: ds.look * 0.2, decay: 0.25 do
        # sample SAMPLE, rate: 1.0, amp: 2.5 # play your vocal sample
      end
    end
  end
  sleep M * 16 # I chose a 16-measure vocal sample
end

# Melodic Components
live_loop :right do
  with_fx :level, amp: LEVELS[:right] || 0 do
    with_fx :reverb, mix: 0.9, room: 0.8 do
      with_fx :echo, mix: 0.5 do
        use_synth [:fm, :prophet, :piano].choose
        ##| use_synth :fm
        n1 = S[markov(gg, H)] + 12 # choose 1st random note in scale
        n2 = S[markov(gg, H)] + 12 # choose 2nd random note in scale
        d = d1.choose # choose random duration
        play n1, release: M/2, sustain: M/2
        play n2 if (bools 1, 0, 0, 0).tick # plays a chord on leading edge of measures
        sleep M/4
        sleep d.abs
        2.times do
          pplay S[markov(gg, H)] + 12, d
          sleep (M/4 - d.abs)
        end
      end
    end
  end
end

live_loop :left do
  use_synth :sine
  with_fx :level, amp: LEVELS[:left] || 0 do
    with_fx :reverb, mix: 0.8, room: 0.8 do
      with_fx :echo, mix: 0.5 do
        use_synth [:pluck, :blade].choose
        s markov(gg, H) # update the state using markov chaining
        pplay (S[gg] - 12), M/8 # down one octave from root
        sleep (M / 4) + (M / 8)
        pplay (S[gg - 5] - 12), M/8 # down a fifth and an octave from the root
        sleep (M / 4) - (M / 8)
      end
    end
  end
end

live_loop :subbass do
  n = g - 24 # down two octaves from current root
  d = (sb.tick * 0.01) - 0.01
  with_fx :level, amp: LEVELS[:subbass] || 0 do
    with_fx :reverb, mix: 0.8 do
      with_fx :distortion, distort: 0.2 do
        use_synth :pretty_bell
        play n, release: 4, sustain: 4, amp: d
        sleep M / 1
      end
    end
  end
end

comment do
  
  use_synth [:pulse, :fm].choose
  notes = (ring, 72, 74, 75, 77, 79)
  
  live_loop :r do
    with_transpose -12 do
      if one_in(5) then
        sleep [0.5,0.25].choose
        next
      else
        if rand() > 0.75 then
          notes = (ring, 72, 74, 75, 77, 79)
        else
          notes = notes.shuffle
        end
        play notes.tick, release: 2, amp: 0.125
        sleep [0.5,0.25].choose
        
      end
    end
  end
  
end

