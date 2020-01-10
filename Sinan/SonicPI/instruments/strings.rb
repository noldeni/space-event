define :cello do |p|
  sample "C:/Users/Sincap/Documents/GitHub/space-event/SonicPI/Sinan/samples/strings/Kawai-K5000W-Cello-C2.wav", amp: 1.0, pitch: p
end

define :violin do |p|
  sample "C:/Users/Sincap/Documents/GitHub/space-event/SonicPI/Sinan/samples/strings/Roland-SC-88-Violin-C5.wav", amp: 1.0, pitch: p
end

define :viola do |p|
  sample "C:/Users/Sincap/Documents/GitHub/space-event/SonicPI/Sinan/samples/strings/Kawai-K5000W-Viola-C4.wav", amp: 1.0, pitch: p
end

define :cbass do |p|
  sample "C:/Users/Sincap/Documents/GitHub/space-event/SonicPI/Sinan/samples/strings/E-Mu-Proteus-FX-CntraBas-C2.wav", amp: 1.0, pitch: p
end


define :pacherbel do |p|
  cbass(0)
  cello(0)
  viola(0)
  violin(0)
end


pacherbel(0)