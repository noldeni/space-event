#arp2
notes = (ring 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72)

live_loop :midiin do
  
  use_real_time
  n, v = sync "/midi/launchkey_mini/0/1/note_on"
  if get(:b) == 0
    if get(:a) != n
      set :b, n
    end
  end
  
  set :a, n
  n, v = sync "/midi/launchkey_mini/0/1/note_off"
  set :a, 0
  
end

live_loop :xsaw do
  a = get(:a)
  if a != 0
    synth :dtri, note: a, decay: 0.01, sustain: 0.1, release: 0
    
    
  end
  sleep 0.125
end


