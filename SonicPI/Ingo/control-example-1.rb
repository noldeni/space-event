# control-example-1.rb
# https://in-thread.sonic-pi.net/u/Eli
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

with_fx :reverb, mix: 0.7 do
  
  live_loop :bongs do
    use_synth :mod_sine
    envfm2( notes.choose, rrand( -1, 1 ))
    use_synth :piano
    envfm2( notes1.choose, rrand( -1, 1 ))
    sleep 0.25
  end
end