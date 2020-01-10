define :violin do |p,a,s,r|
  
  synth :sine, note: :G3+p, amp: 0.92, release: r, decay: 0.3, attack: a, sustain: s
  synth :sine, note: :G4+p, amp: 0.53, release: r, decay: 0.3, attack: a, sustain: s
  synth :sine, note: :D5+p, amp: 0.15, release: r, decay: 0.3, attack: a, sustain: s
  synth :sine, note: :G5+p, amp: 0.06, release: r, decay: 0.3, attack: a, sustain: s
  synth :sine, note: :B5+p, amp: 0.08, release: r, decay: 0.3, attack: a, sustain: s
  synth :sine, note: :D6+p, amp: 0.06, release: r, decay: 0.3, attack: a, sustain: s
  synth :sine, note: :F6+p, amp: 0.05, release: r, decay: 0.3, attack: a, sustain: s
  synth :sine, note: :G6+p, amp: 0.05, release: r, decay: 0.3, attack: a, sustain: s
  synth :sine, note: :A6+p, amp: 0.05, release: r, decay: 0.3, attack: a, sustain: s
  synth :sine, note: :B6+p, amp: 0.05, release: r, decay: 0.3, attack: a, sustain: s
  
end

live_loop :string do
  
  violin 0,0,0.5,0
  sleep 4
end
