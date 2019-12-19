# control-example-2.rb
# https://in-thread.sonic-pi.net/u/PiEaterAndPlayer
# https://in-thread.sonic-pi.net/t/control-a-running-synth-ambient-soundscape/2331/4

use_bpm 60

define :envfm2 do |nn=60, pan=0|
  
  use_synth_defaults sustain: 0, release: 1
  
  voice1 = play note( nn ), divisor: 1.0/3, depth: 7, depth_slide: 0.5, amp: 0.5, pan: pan
  voice2 = play note( nn ) * 2, divisor: 1.0/4, depth: 7, depth_slide: 0.5, amp: 0.3, pan: pan
  voice3 = play note( nn ) * 3, divisor: 1.0/5.7, depth: 7, depth_slide: 0.5, amp: 0.2, pan: pan
  
  control voice1, depth: 3
  control voice2, depth: 1
  control voice3, depth: 5
end

notes = (scale :a1, :minor_pentatonic, num_octaves: 3)
notes1 = (scale :a2, :minor_pentatonic, num_octaves: 1)

with_fx :reverb, mix: 0.7, amp: 0.1 do
  
  live_loop :bongs do
    use_synth :mod_sine
    envfm2( notes.choose, rrand( -1, 1 ))
    use_synth :piano
    envfm2( notes1.choose, rrand( -1, 1 ))
    sleep 0.25
  end
end

bassnotes = (ring :a2, :a1, :a1, :c2, :d2, :a1, :a1, :c2, :d2,
             :d2, :e2,  :g2, :g2, :gs2  )

live_loop :bass do
  
  use_synth :dsaw
  use_synth_defaults sustain: 0, release: 0.3, res: 0.3, cutoff: 60
  
  index = 0
  
  with_fx :eq, low_shelf: 1.2  do
    
    at [0.0, 0.25, 0.75, 1.0, 1.25, 1.75, 2,
    2.25, 2.75, 3, 3.25, 3.5, 3.75, 3.825] do
      play bassnotes[index]
      index = index + 1
    end
  end
  
  
  sleep 4
end

live_loop :drums do
  
  at [0.0, 0.375, 0.75, 1.25, 2, 2.375, 2.75, 3.25, 3.75 ] do
    sample :bd_haus
  end
  
  with_fx :reverb, mix: 0.5 do
    
    at [0.5, 1.5, 2.5, 3.5, 3.75] do
      sample :sn_dolf
    end
    
    at [0.25, 0.75, 1.25, 1.75, 2.25, 2.75, 3.25, 3.75, 3.875 ] do
      sample :drum_cymbal_closed
    end
  end
  
  sleep 4
end
