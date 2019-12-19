# control-example-3.rb
# https://in-thread.sonic-pi.net/u/Martin
# https://in-thread.sonic-pi.net/t/control-a-running-synth-ambient-soundscape/2331/4

use_bpm 120

live_loop :suenth do
  n = (chord [:c2, :f2, :g2, :e2].choose, :sus4, invert: [-1, 0, 1, 2].choose, num_octaves: 4)
  puts "Fade in ..."
  with_fx :rhpf, res: 0.5, cutoff: 30 do |rhp|
    
    with_fx :slicer, smooth: 0.5 do
      
      with_fx :panslicer, phase: [0.25, 0.5, 0.75].choose, smooth_down: 0.25, smooth_up: 0.25 do
        
        s = synth :dsaw, note: n, sustain: 64, cutoff: 80, amp: 0.0
        control s, amp: 1, amp_slide: 128
        control rhp, res: 0.925, res_slide: 16, cutoff: 90, cutoff_slide: 32
        sleep 32
        puts "... fade out."
        control s, amp: 0.0, amp_slide: 24
        control rhp, res: 0.65, res_slide: 16, cutoff: 50, cutoff_slide: 16
        sleep 16
        
      end
    end
    
  end
end