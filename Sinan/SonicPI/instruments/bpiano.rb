#Bright Piano

define :bpiano do |n|
  synth :piano, note: n-12, sustain: 1, release: 0.5, amp: 0.05
  synth :piano, note: n, sustain: 1, release: 0.5
  synth :piano, note: n+12, sustain: 1, release: 0.5, amp: 0.1
  synth :sine, note: n, amp: 0.4
end