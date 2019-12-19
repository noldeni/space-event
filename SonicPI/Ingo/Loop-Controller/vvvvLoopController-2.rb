use_real_time
use_osc "127.0.0.1",9000 #adjust for output IP to which to send LED on/off signals (TouchOSC)
oscmessage="/osc/kinect/*"
use_bpm 120

use_debug false
use_osc_logging false

use_synth :tri

bg1 = (ring 0.0,0.1,0.2,0.3,0.4,0.5,0.0,0.0).mirror
bg2 = (ring 0.5,0.4,0.3,0.2,0.1,0.0,0.0,0.0).mirror

melody_1 = [:c4,:r,:ds4,:ds4,:g4,:c4,:r,:gs4,:r,:r,:gs3,:r,:g3,:r,:r,:r].ring
stevereichphase = (ring :E4, :Fs4, :B4, :Cs5, :D5, :Fs4,
                   :E4, :Cs5, :B4, :Fs4, :D5, :Cs5)

define :lone do |action|
  #steve-reich-phase.rb
  #From Essentials_Sonic_Pi-v1.pdf chapter 1
  #One of the interesting
  #things about using multiple live_loops is that they each manage their
  #own time. This means it’s really easy to create interesting polyrhythmical
  #structures and even play with phasing, Steve Reich style.
  if action==1
    set :k1,false
    live_loop :slow do
      use_synth [:subpulse, :pulse].choose
      play stevereichphase.tick, release: 0.25
      sleep 0.3
      stop if get(:k1)
    end
    live_loop :faster do
      use_synth [:subpulse, :pulse].choose
      play stevereichphase.tick, release: 0.25
      sleep 0.295
      stop if get(:k1)
    end
  else
    set :k1,true
  end
end

define :ltwo do |action|
  if action==1
    set :k2,false
    with_fx :reverb, mix: 0.5, room: 0.9 do
      with_fx :ixi_techno, mix: 0.75, room: 0.9 do
        live_loop :background2 do
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
          stop if get(:k2)
        end
      end
    end
  else
    set :k2,true
  end
end

define :lthree do |action|
  if action==1
    set :k3,false
    live_loop :three do
      play scale(:c3,:minor_pentatonic).tick,release: 0.1
      sleep 0.1
      stop if get(:k3)
    end
  else
    set :k3,true
  end
end


#input on and off live_loops to detect inputs
define:parse_sync_address do |address|
  v= get_event(address).to_s.split(",")[6]#[address.length+1..-2].to_i
  if v != nil
    return v[3..-2].split("/")
  else
    return ["error"]
  end
end

live_loop :pon do
  b = sync "/osc/kinect/*"
  if b[0]==1
    r=parse_sync_address "/osc/kinect/*"
    ns= r[2]
    set ("c"+ns).to_sym,1
    doCommandSelect(ns, 1)
  end
end
live_loop :poff do
  b = sync "/osc/kinect/*"
  if b[0]==0
    r=parse_sync_address "/osc/kinect/*"
    ns= r[2]
    set ("c"+ns).to_sym,0
    doCommandSelect(ns, 0)
  end
end

define :doCommandSelect do |n, v|
  puts n
  case n
  when "hr1"
    lone v
    puts n
  when "hr2"
    ltwo v
    puts n
  when "hr3"
    lthree v
    puts n
  when "hr4"
    puts n
  when "hl1"
    puts n
  when "hl2"
    puts n
  when "hl3"
    puts n
  when "hl4"
    puts n
  else
    puts "nothing"
  end
end

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
