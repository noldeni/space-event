# control-fade.rb
# https://in-thread.sonic-pi.net/t/control-a-running-synth-ambient-soundscape/2331

use_bpm 120

live_loop :suenth do
  use_synth :tri # try different synths ...
  use_synth :dsaw
  use_synth :dtri
  use_synth_defaults attack: 0.25, release: 3
  
  n = (chord [:c3, :f3, :g3, :bb2].choose, [:sus4, :sus2].choose, num_octaves: 3)
  
  with_fx :reverb, room: 0.75, mix: 0.75 do
    with_fx :level, amp: 0 do |lvl|
      with_fx :rhpf, res: 0.85, cutoff: 30 do |rhp|
        
        with_fx :panslicer, phase: 0.5 do
          in_thread do
            64.times do
              play note: n.choose if one_in 2
              sleep 0.25
            end
          end
        end
        
        puts "Fade in ..."
        control rhp, cutoff: 90, cutoff_slide: 8
        control lvl, amp: 1, amp_slide: 8
        sleep 8
        puts "... fade out."
        
        control rhp, cutoff: 20, cutoff_slide: 8
        control lvl, amp: 0, amp_slide: 8
        sleep 8
        
      end
    end
  end
end