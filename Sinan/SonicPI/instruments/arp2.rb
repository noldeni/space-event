#arp2
notes = (ring 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72)

live_loop :xsaw do
  if get(:a) != 0
    synth :dtri, note: get(:a), decay: 0.01, sustain: 0.1, release: 0
    sleep 0.1
  end
  if get(:b) != 0
    synth :dtri, note: get(:b), decay: 0.01, sustain: 0.1, release: 0
    sleep 0.1
  end
  if get(:c) != 0
    synth :dtri, note: get(:c), decay: 0.01, sustain: 0.1, release: 0
    sleep 0.1
  end
  if get(:d) != 0
    synth :dtri, note: get(:d), decay: 0.01, sustain: 0.1, release: 0
    sleep 0.1
  end
  if (get(:a) == 0) && (get(:b) == 0) && (get(:c) == 0) && (get(:d) == 0)
    sleep 0.1
  end
end

live_loop :midion do
  use_real_time
  n, v = sync "/midi/launchkey_mini/0/1/note_on"
  if (get(:d) != n) && (get(:c) != n) && (get(:b) != n) && (get(:a) != n)
    if get(:a) == 0
      set :a, n
    end
  end
  if (get(:d) != n) && (get(:c) != n) && (get(:b) != n) && (get(:a) != n)
    if get(:b) == 0
      set :b, n
    end
  end
  if (get(:d) != n) && (get(:c) != n) && (get(:b) != n) && (get(:a) != n)
    if get(:c) == 0
      set :c, n
    end
  end
  if (get(:d) != n) && (get(:c) != n) && (get(:b) != n) && (get(:a) != n)
    if get(:d) == 0
      set :d, n
    end
  end
end

live_loop :midioff do
  use_real_time
  n, v = sync "/midi/launchkey_mini/0/1/note_off"
  if get(:a) == n
    set :a, 0
  end
  if get(:b) == n
    set :b, 0
  end
  if get(:c) == n
    set :c, 0
  end
  if get(:d) == n
    set :d, 0
  end
end


