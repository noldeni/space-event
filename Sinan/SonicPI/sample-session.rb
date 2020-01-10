sample1 = "C:/Users/Sincap/Documents/GitHub/space-event/SonicPI/Sinan/samples/drum.wav"
sample2 = "C:/Users/Sincap/Documents/GitHub/space-event/SonicPI/Sinan/samples/pianopeggio.wav"
sample3 = "C:/Users/Sincap/Documents/GitHub/space-event/SonicPI/Sinan/samples/strings+pizo.wav"
sample4 = "C:/Users/Sincap/Documents/GitHub/space-event/SonicPI/Sinan/samples/techarp.wav"

live_loop :drumloop do
  sample sample1, amp: 0.3
  sleep sample_duration(sample1)
end

live_loop :pianopeggio do
  sample sample2, amp: 1.0
  sleep sample_duration(sample2)
end

live_loop :pizostring do
  sample sample3, amp: 0.8
  sleep sample_duration(sample3)
end

live_loop :techarp do
  sample sample4, amp: 0.5
  sleep sample_duration(sample4)
end
