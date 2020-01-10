#ticking

live_loop :pulse do
  with_fx :level, amp: 1.5 do
    with_fx :lpf do
      synth :hollow, note: :Fs4, release: 2, amp: rrand(0.5,1.0)
      synth :mod_beep, note: :A2, amp: 0.7
      synth :sine, amp: rrand(0.3,0.5), sustain: 0.1, decay: 0.02, release: 0.2, attack: 0.1,note: chord(:D2, :major).choose
      synth :blade, amp: rrand(0.5,0.9), sustain: 0.01, decay: 0.01, release: 0.0, attack: 0.125,note: chord(:D4, :major)
      with_fx :echo, decay: 1, mix: 0.3, amp: 1.0 do
        synth :dpulse, amp: rrand(0.0,0.4), sustain: 0.01, decay: 0.01, release: 0.01, attack: 0.03,note: :d5, cutoff: 47
      end
      with_fx :echo, decay: 2, mix: 0.9, amp: 0.5, phase: 0.125 do
        synth :cnoise, amp: rrand(0.1,0.3), sustain: 0.001, decay: 0.001, release: 0.005, attack: 0,note: :d6
      end
      
      sleep 0.25
      with_fx :echo, decay: 1, mix: 1, amp: 0.25 do
        with_fx :gverb do
          synth :mod_saw, amp: rrand(0.1,0.2), sustain: 0.02, decay: 0.02, release: 0.5, attack: 0.03,note: chord(:D3, :major)
        end
        
      end
      
      sleep 0.25
    end
  end
end
