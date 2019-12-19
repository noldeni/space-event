Über OSC kommen folgende messages:
  /kinect/hr1=1
  /kinect/hr1=0
  /kinect/hr3=1
  /kinect/hr3=0

In Sonic PI kommen diese wie folgt an:
  /osc/kinect/hr1   [1.0]
  /osc/kinect/hr1   [0.0]
  /osc/kinect/hr3   [1.0]
  /osc/kinect/hr3   [0.0]
  
Auswertung der messages:
live_loop :pon do								# loop für message ON(1)
  b = sync "/osc/kinect/*"						# sync auf die message "/osc/kinect/*"
  if b[0]==1									# wenn value=1
    r=parse_sync_address "/osc/kinect/*"		# liefert ein array: ["osc", "kinect", "hr2"]
    ns= r[2]									# ns = "hr2"
    set ("c"+ns).to_sym,1						# set chr2=1
    doCommandSelect(ns)							# call loop function
  end
end
live_loop :poff do								# loop für message OFF(0)
  b = sync "/osc/kinect/*"						# sync auf die message "/osc/kinect/*"
  if b[0]==0									# wenn value=0
    r=parse_sync_address "/osc/kinect/*"		# liefert ein array: ["osc", "kinect", "hr2"]
    ns= r[2]									# ns = "hr2"
    set ("c"+ns).to_sym,0						# set chr2=0
  end
end

#####################################################################
# example controlling three live loops 
# which can independently be stopped and started
# https://in-thread.sonic-pi.net/t/best-way-to-toggle-between-2-different-live-loops/2991/2
# 28.11.2019
#####################################################################
use_synth :tri

define :lone do |action|
  if action==1
    set :k1,false
    live_loop :one do
      play scale(:c5,:minor_pentatonic).choose,release: 0.1
      sleep 0.1
      stop if get(:k1)
    end
  else
    set :k1,true
  end
end

define :ltwo do |action|
  if action==1
    set :k2,false
    live_loop :two do
      
      play scale(:g5,:minor_pentatonic).choose,release: 0.1
      sleep 0.1
      stop if get(:k2)
    end
  else
    set :k2,true
  end
end

define :lthree do |action|
  if action==1
    set :k3,false
    live_loop :three do
      play scale(:c6,:minor_pentatonic).tick,release: 0.1
      sleep 0.1
      stop if get(:k3)
    end
  else
    set :k3,true
  end
end


live_loop :control do
  puts "start live_loop :lone"
  lone 1
  sleep 4
  puts "stop live_loop :lone"
  puts "start live_loop :ltwo"
  lone 0
  ltwo 1
  sleep 4
  puts "stop live_loop :ltwo"
  puts "start live_loop :lthree"
  ltwo 0
  lthree 1
  sleep 4
  puts "ADD live_loop :lone"
  lone 1
  sleep 2
  puts "ADD live_loop :ltwo"
  ltwo 1
  sleep 4
  puts "stop live_loop :one"
  puts "stop live_loop :ltwo"
  puts "stop live_loop :lthree"
  lone 0
  ltwo 0
  lthree 0
  sleep 2
end
#####################################################################

#####################################################################
# little drum beat, with 2 different ‘backgrounds’, 
# fading into each other and providing a composite background
# https://in-thread.sonic-pi.net/t/smoothly-fading-samples-and-synths/528/28
# https://in-thread.sonic-pi.net/u/Eli
# 23.05.2018
#####################################################################
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
      
      stop
      
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

#####################################################################

#####################################################################
# two switchable live loops with fx slicer applied
# https://in-thread.sonic-pi.net/t/launch-fx-at-midi-cc/995/10
# 22.04.2018
#####################################################################
set :mval,0
#send osc to intialise toggle switcheds on TouchOSC
osc_send "192.168.1.240",9000,"/1/toggle1",1
osc_send "192.168.1.240",9000,"/1/toggle2",1
osc_send "192.168.1.240",9000,"/1/toggle4",0
use_osc "localhost",4559
#end osc to start livel_loop :a and :b
osc "/1/toggle1",1
osc "/1/toggle2",1
define :doLoop1 do
  set :go1,true
  
  with_fx :slicer, mix: 0 do |m1| #control volume of live_loopa
    in_thread do
      loop do
        control m1,mix: get(:mval)
        sleep 0.05
      end
    end
    live_loop :a do
      sample :ambi_choir, beat_stretch: 4
      sleep 4
      stop if get(:go1)==false
    end #live_loop
  end
end

define :doLoop2 do
  set :go2,true
  
  with_fx :slicer, amp: 1 do |m2| #control volume of live_loopa
    in_thread do
      loop do
        control m2,mix: get(:mval)
        sleep 0.05
      end
    end
    live_loop :b,sync: :a do
      sample :ambi_drone, beat_stretch: 4
      sleep 4
      stop if get(:go2)==false
    end #live_loop
  end
end


live_loop :control1 do
  use_real_time
  b = sync "/osc/1/toggle1"
  if b[0]==1
    doLoop1
  else
    set :go1,false
  end
end

live_loop :control2 do
  use_real_time
  b = sync "/osc/1/toggle2"
  if b[0]==1
    #sync :a #uncomment to sync slicer pulsesd, but delays turn on one cuycle
    doLoop2
  else
    set :go2,false
  end
end

live_loop :controlSlicer do
  use_real_time
  b = sync "/osc/1/toggle4"
  set :mval,b[0]
end
#####################################################################

#####################################################################
# leaving the live loops running all the time, but switching their volume to 0
# https://in-thread.sonic-pi.net/t/launch-fx-at-midi-cc/995/2 
# 21.04.2018
#####################################################################

set :mval,0 #set initial mix value
set :vola,0
set :volb,0

#initialise virtual toggle switches on TouchOSC
osc_send "192.168.1.240",9000, "/1/toggle1",1
osc_send "192.168.1.240",9000, "/1/toggle2",1
osc_send "192.168.1.240",9000, "/1/toggle4",0

use_osc "localhost",4559 #send initial OSC messages to Sonic Pi
osc "/1/toggle1",1 #turn on live_loop a
osc "/1/toggle2",1 #turn on live_loop b
osc "/1/toggle4",0 #turn off mix on slicer



with_fx :slicer,mix: 0 do |m1| #applied to all enclosed live loops
  in_thread do
    loop do
      control m1,mix: get(:mval)
      sleep 0.05
    end
  end
  
  with_fx :level, amp: 1 do |vol| #control volume of live_loopa
    in_thread do
      loop do
        control vol,amp: get(:vola)
        sleep 0.05
      end
    end
    live_loop :a do
      sample :ambi_choir, beat_stretch: 4
      sleep 4
    end #live_loop
  end #fx level a
  
  with_fx :level, amp: 1 do |vol| #control volume of live_loop b
    in_thread do
      loop do
        control vol,amp: get(:volb)
        sleep 0.05
      end
    end
    live_loop :b,sync: :a do
      sample :ambi_drone, beat_stretch: 4
      sleep 4
    end #live_loop
  end #fx level b
  
  
end #fx slicer



live_loop :getVol1 do #control 2nd live_loop on/off
  use_real_time
  b= sync "/osc/1/toggle1" #returns 0 or 1
  if b[0]==1
    set :vola,1
  else
    set :vola,0
  end
  puts "vola is #{get(:vola)}"
end


live_loop :getVol2 do #control 2nd live_loop on/off
  use_real_time
  b= sync "/osc/1/toggle2" #returns 0 or 1
  sync :a #change at start of loop a #omit if you want to change immediately
  if b[0]==1
    set :volb,1
  else
    set :volb,0
  end
  puts "volb is #{get(:volb)}"
end


live_loop :getMix do #control fx mix
  use_real_time
  b = sync "/osc/1/toggle4" #returns 0 or 1
  set :mval,b[0]
  puts "mix value #{get(:mval)}"
end
#####################################################################
