
mamp1 = 0
mamp2 = 0
mamp3 = 0
mamp4 = 0
mamp5 = 0
mamp6 = 0
mamp7 = 0
mamp8 = 0

mtone1 = 0
mtone2 = 0
mtone3 = 0
mtone4 = 0
mtone5 = 0
mtone6 = 0
mtone7 = 0
mtone8 = 0

harmonic = (ring :G3, :G4, :D5, :G5, :B5, :D6, :F6, :G6, :A6, :B6, :Cs7, :D7)

live_loop :midi_piano do
  use_real_time
  id,value  = sync "/midi/launch_control_xl/1/9/control_change"
  synth :sine, note: :G3+, amp: mamp1, sustain: 0.25, release: 0.1, attack: 0.1
  synth :sine, note: :G4, amp: mamp2, sustain: 0.25, release: 0.1, attack: 0.1
  synth :sine, note: :D5, amp: mamp3, sustain: 0.25, release: 0.1, attack: 0.1
  synth :sine, note: :G5, amp: mamp4, sustain: 0.25, release: 0.1, attack: 0.1
  synth :sine, note: :B5, amp: mamp5, sustain: 0.25, release: 0.1, attack: 0.1
  synth :sine, note: :D6, amp: mamp6, sustain: 0.25, release: 0.1, attack: 0.1
  synth :sine, note: :F6, amp: mamp7, sustain: 0.25, release: 0.1, attack: 0.1
  synth :sine, note: :G6, amp: mamp8, sustain: 0.25, release: 0.1, attack: 0.1
  
  if id==49
    
    mtone1 = value
  end
  if id==50
    mtone2 = value
  end
  if id==51
    mtone3 = value
  end
  if id==52
    mtone4 = value
  end
  if id==53
    mtone5 = value
  end
  if id==54
    mtone6 = value
  end
  if id==55
    mtone7 = value
  end
  if id==56
    mtone8 = value
  end
  
  if id==77
    mamp1 = value / 127.0
  end
  if id==78
    mamp2 = value / 127.0
  end
  if id==79
    mamp3 = value / 127.0
  end
  if id==80
    mamp4 = value / 127.0
  end
  if id==81
    mamp5 = value / 127.0
  end
  if id==82
    mamp6 = value / 127.0
  end
  if id==83
    mamp7 = value / 127.0
  end
  if id==84
    mamp8 = value / 127.0
  end
end

