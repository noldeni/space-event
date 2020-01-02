#Spiralysis.rb
#Spiralysis
#by Eli...

use_bpm 120

bg1 = (ring 0.0,0.1,0.2,0.3,0.4,0.5,0.0,0.0).mirror
bg2 = (ring 0.5,0.4,0.3,0.2,0.1,0.0,0.0,0.0).mirror

melody_1 = [:c4,:r,:ds4,:ds4,:g4,:c4,:r,:gs4,:r,:r,:gs3,:r,:g3,:r,:r,:r].ring

live_loop :beats do
  sleep 1
end

live_loop :bar do
  sleep 4
end

live_loop :mixer do
  tick
  set :bvol1, bg1.look
  set :bvol2, bg2.look
  sync :bar
end

live_loop :kick, sync: :beats  do
  sample :bd_haus
  sleep 1.5
  sample :bd_haus
  sleep 1
  sample :bd_haus
  sample :drum_cymbal_closed
  sleep 1
  sample :bd_haus
  sample :drum_cymbal_closed
  sleep 0.5
end

live_loop :kick1, sync: :bar do
  sample :bd_ada
  sleep 1
  sample :bd_ada
  sample :sn_dolf, sustain: 0, release: 0.08, hpf: 80
  sleep 1
end

live_loop :tom, sync: :beats  do
  sample :drum_tom_lo_soft
  sleep 0.5
end

live_loop :snap, sync: :beats  do
  sleep 1
  if rand(1) < 0.75 then
    sample :perc_snap, amp: 0.5
  else
    sample :perc_snap2, amp: 0.5
  end
  sleep 1
end

with_fx :reverb, mix: 0.5, room: 0.9 do
  with_fx :ixi_techno, mix: 0.75, room: 0.9 do
    
    live_loop :background1, sync: :beats do
      
      #stop
      
      this_vol = get :bvol1
      use_synth_defaults amp: this_vol * 4
      use_synth (ring :supersaw, :prophet, :prophet, :tech_saws).tick
      3.times do
        play :C4, cutoff: rrand(60,80)
        sleep 0.5
        play :G3, cutoff: rrand(60,90)
        sleep 0.5
        play :C4, cutoff: rrand(60,70)
        sleep 0.5
        play :Gs3, cutoff: rrand(60,80)
        sleep 0.25
        play :Gs3, cutoff: rrand(70,100)
        sleep 0.25
      end
      1.times do
        play :c4, cutoff: rrand(60,80), release: 1
        sleep 0.5
        play :g4, cutoff: rrand(60,90), release: 1
        sleep 0.5
        play :c4, cutoff: rrand(60,70), release: 1
        sleep 0.5
        play :gs3 + 7, cutoff: rrand(80,100), release: 1
        sleep 0.5
      end
    end
    
    live_loop :background2 do
      
      stop
      
      sync :beats if rand(1) < 0.5
      this_vol = get :bvol2
      
      use_synth_defaults cutoff: 70, release: 1.2, amp: this_vol * 4, pulse_width: rrand(0,1)
      use_synth [:subpulse, :pulse].choose
      if rand(1) < 0.75 then
        with_fx :ixi_techno, mix: 0.55, room: 0.85, damp: 0.8 do
          16.times do
            play melody_1.look - 12
            sleep 0.25
            tick
          end
        end
      else
        use_synth :prophet
        16.times do
          play melody_1.look - 12
          sleep 0.25
          tick
        end
      end
    end
  end
end
