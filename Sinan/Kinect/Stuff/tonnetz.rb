define :bass do |a,b,c|
  d = [a,b,c].choose
  synth :dsaw, amp: 0.3, note: d-36, cutoff: rrand(30,50)
  synth :sine, amp: 0.3, note: d-36
end


define :kadenz do |a,b,c|
  in_thread do
    with_fx :echo, mix: 0.2, decay: 0.2, phase: 0.166, amp: 0.5 do
      synth :beep, amp: rrand(0.01,0.6), note: a, release: 0.2, sustain: 0.0, decay: 0.2
      sleep 0.25
      synth :beep, amp: rrand(0.01,0.6), note: b, release: 0.2, sustain: 0.0, decay: 0.2
      sleep 0.25
      synth :beep, amp: rrand(0.01,0.6), note: c, release: 0.2, sustain: 0.0, decay: 0.2
      sleep 0.25
      synth :beep, amp: rrand(0.01,0.6), note: b, release: 0.2, sustain: 0.0, decay: 0.2
    end
  end
end


define :ambient do |a,b,c|
  synth :hollow, note: a
  synth :hollow, note: b
  synth :hollow, note: c
end



live_loop :riemann do
  use_real_time
  tone = sync "/osc/tonnetz"
  if tone
    set :counterA, rrand_i(2,4)
    set :counterB, rrand_i(2,4)
    set :counterC, rrand_i(2,4)
    set :counterD, rrand_i(2,4)
  end
  
  if tone[0] == 99
    set :a, :as4
    set :b, :cs5
    set :c, :fs5
  end
  if tone[0] == 133
    set :a, :as4
    set :b, :cs5
    set :c, :f4
  end
  if tone[0] == 103
    set :a, :gs5
    set :b, :cs5
    set :c, :f4
  end
  if tone[0] == 137
    set :a, :gs5
    set :b, :c4
    set :c, :f4
  end
  if tone[0] == 107
    set :a, :gs5
    set :b, :c4
    set :c, :ds5
  end
  if tone[0] == 141
    set :a, :g4
    set :b, :c4
    set :c, :ds5
  end
  if tone[0] == 111
    set :a, :g4
    set :b, :as5
    set :c, :ds5
  end
  if tone[0] == 145
    set :a, :g4
    set :b, :as5
    set :c, :d4
  end
  if tone[0] == 115
    set :a, :f5
    set :b, :as5
    set :c, :d4
  end
  if tone[0] == 149
    set :a, :f5
    set :b, :a4
    set :c, :d4
  end
  if tone[0] == 119
    set :a, :f5
    set :b, :a4
    set :c, :c5
  end
  if tone[0] == 153
    set :a, :e4
    set :b, :a4
    set :c, :c5
  end
  if tone[0] == 123
    set :a, :e4
    set :b, :g5
    set :c, :c5
  end
  if tone[0] == 157
    set :a, :e4
    set :b, :g5
    set :c, :b4
  end
  
  if tone[0] == 128
    set :a, :a6
    set :b, :cs5
    set :c, :fs5
  end
  if tone[0] == 130
    set :a, :a6
    set :b, :cs5
    set :c, :e6
  end
  if tone[0] == 132
    set :a, :gs5
    set :b, :cs5
    set :c, :e6
  end
  if tone[0] == 134
    set :a, :gs5
    set :b, :b6
    set :c, :e6
  end
end

live_loop :bassline do
  x = get :a
  y = get :b
  z = get :c
  if get(:counterA) != 0
    bass(x,y,z)
  end
  
  sleep choose([0.25,0.375,0.5,0.625,0.75])
end


live_loop :main do
  x = get :a
  y = get :b
  z = get :c
  if get(:counterB) != 0
    kadenz(x,y,z)
    ambient(x,y,z)
  end
  if get(:counterC) != 0
    sample :bd_808, amp: 0.5
    sample :bd_boom, amp: 0.25
  end
  sleep 0.5
end


live_loop :ticking do
  sample :drum_cymbal_closed, amp: rrand(0.1,0.6), beat_stretch: 0.1
  sleep 0.125
end

live_loop :piano do
  x = get(:a)
  y = get(:b)
  z = get(:c)
  print (x-12)%12+48
  if get(:counterD) != 0
    synth :dtri, note: (x+12)%12+48, decay: 0.01, sustain: 0.1, release: 0
    sleep 0.125
    synth :dtri, note: (y+12)%12+48, decay: 0.01, sustain: 0.1, release: 0
    sleep 0.125
    synth :dtri, note: (z+12)%12+48, decay: 0.01, sustain: 0.1, release: 0
    sleep 0.125
    synth :dtri, note: (x+12)%12+60, decay: 0.01, sustain: 0.1, release: 0
    sleep 0.125
    synth :dtri, note: (y+12)%12+60, decay: 0.01, sustain: 0.1, release: 0
    sleep 0.125
    synth :dtri, note: (z+12)%12+60, decay: 0.01, sustain: 0.1, release: 0
    sleep 0.125
    synth :dtri, note: (x+12)%12+72, decay: 0.01, sustain: 0.1, release: 0
    sleep 0.125
    synth :dtri, note: (z+12)%12+72, decay: 0.01, sustain: 0.1, release: 0
    sleep 0.125
  else
    sleep 1
  end
end

live_loop :counter do
  A = get :counterA
  B = get :counterB
  C = get :counterC
  D = get :counterD
  
  if A != 0
    A = A - 1
  end
  
  if B != 0
    B = B - 1
  end
  
  if C != 0
    C = C - 1
  end
  
  if D != 0
    D = D - 1
  end
  set :counterA, A
  set :counterB, B
  set :counterC, C
  set :counterD, D
  print A
  print B
  print C
  print D
  sleep 1
end
