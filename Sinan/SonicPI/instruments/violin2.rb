# Welcome to Sonic Pi v3.1
define :violin do |p|
  synth :sine, note: :G3+p, amp: 0.9980, sustain: 0.25, release: 0.1, attack: 0.1
  synth :sine, note: :G4+p, amp: 0.6535, sustain: 0.25, release: 0.1, attack: 0.1
  synth :sine, note: :D5+p, amp: 0.4409, sustain: 0.25, release: 0.1, attack: 0.1
  synth :sine, note: :G5+p, amp: 0.2047, sustain: 0.25, release: 0.1, attack: 0.1
  synth :sine, note: :B5+p, amp: 0.1811, sustain: 0.25, release: 0.1, attack: 0.1
  synth :sine, note: :D6+p, amp: 0.0236, sustain: 0.25, release: 0.1, attack: 0.1
  synth :sine, note: :F6+p, amp: 0.0157, sustain: 0.25, release: 0.1, attack: 0.1
  synth :sine, note: :G6+p, amp: 0.0236, sustain: 0.25, release: 0.1, attack: 0.1
end

violin 0
violin 4
violin 9