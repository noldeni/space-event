#strings

define :cbass do |p,d|
  wav = "C:/Users/Sincap/Documents/GitHub/space-event/SonicPI/Sinan/samples/contrabass/"
  t = p % 24
  sample wav, t, amp: 1.0, start: 0.1, finish: 0.8, sustain: d, release: 0.2, attack: 0.1
end

define :cello do |p|
  wav = "C:/Users/Sincap/Documents/GitHub/space-event/SonicPI/Sinan/samples/cello/"
  t = p % 24
  sample wav, t, amp: 1.0, start: 0.01, finish: 0.5, sustain: 1.0, release: 0.2, attack: 0.1
end

define :viola do |p|
  wav = "C:/Users/Sincap/Documents/GitHub/space-event/SonicPI/Sinan/samples/viola/"
  t = p % 24
  sample wav, t, amp: 1.0, start: 0.1, finish: 0.4, sustain: 1.0, release: 0.2, attack: 0.1
end

define :violin do |p|
  wav = "C:/Users/Sincap/Documents/GitHub/space-event/SonicPI/Sinan/samples/violin/"
  t = p % 24
  sample wav, t, amp: 1.0, start: 0.1, finish: 0.5, sustain: 1.0, release: 0.2, attack: 0.1
end






define :pacherbel do |i|
  cbass(14,0.75)
  cello(18)
  sleep 1.2
  cbass(9,0.75)
  cello(16)
  sleep 1.2
  cbass(11,0.75)
  cello(14)
  sleep 1.2
  cbass(6,0.75)
  cello(13)
  sleep 1.2
  cbass(7,0.75)
  cello(11)
  sleep 1.2
  cbass(2,0.75)
  cello(9)
  sleep 1.2
  cbass(7,0.75)
  cello(11)
  sleep 1.2
  cbass(9,0.75)
  cello(13)
  sleep 1.2
  #cello(6)
  #viola(9)
  #violin(2)
  /sleep 1
  cbass(9)
  cello(1)
  viola(4)
  violin(9)/
end

pacherbel(0)


