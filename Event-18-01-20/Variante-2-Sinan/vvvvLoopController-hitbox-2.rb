# vvvvLoopController-hitbox-2.rb

# Global settings
use_real_time
use_osc "127.0.0.1",9000 #adjust for output IP to which to send LED on/off signals (TouchOSC)
oscmessage="/osc/kinect/*"
use_debug false
use_osc_logging false

# Initialize Time System Variables
set :chr1,0
set :chr2,0
set :chr3,0
set :chr4,0
set :chl1,0
set :chl2,0
set :chl3,0
set :chl4,0
set :cdb1,0
set :cdl1,0
set :cmelody,0

###################################################
# Helpers
###################################################

###################################################
# OSC Loops
###################################################
#define :lone do |action|
#  if action==1
#    set :k1,false
#    live_loop :ttt do
#      # LOOP
#      stop if get(:k1)
#    end
#  else
#    set :k1,true
#  end
#end

###################################################
# End of OSC Loops
###################################################



###################################################
# Master Loop and Background
###################################################

#ticking
live_loop :pulse do
  with_fx :level, amp: 5.0 do
    with_fx :lpf do
      synth :hollow, note: :Fs4, release: 2, amp: rrand(0.5,1.0)
      synth :mod_beep, note: :A2, amp: 0.7
      synth :sine, amp: rrand(0.3,0.5), sustain: 0.1, decay: 0.02, release: 0.2, attack: 0.1,note: chord(:D2, :major).choose
      synth :blade, amp: rrand(0.5,0.9), sustain: 0.01, decay: 0.01, release: 0.0, attack: 0.125,note: chord(:D4, :major)
      with_fx :echo, decay: 1, mix: 0.3, amp: 1.0 do
        synth :dpulse, amp: rrand(0.0,0.4), sustain: 0.01, decay: 0.01, release: 0.01, attack: 0.03,note: :d5, cutoff: 47
      end
      with_fx :echo, decay: 2, mix: 0.9, amp: 0.5, phase: 0.125 do
        synth :cnoise, amp: rrand(0.1,0.3), sustain: 0.001, decay: 0.001, release: 0.005, attack: 0,note: :d6
      end
      
      sleep 0.25
      with_fx :echo, decay: 1, mix: 1, amp: 0.25 do
        with_fx :gverb do
          synth :mod_saw, amp: rrand(0.1,0.2), sustain: 0.02, decay: 0.02, release: 0.5, attack: 0.03,note: chord(:D3, :major)
        end
        
      end
      
      sleep 0.25
    end
  end
end

#drum

define :drumloop1 do
  in_thread do
    4. times do
      with_fx :reverb, mix: rrand(0.3,0.5) do
        sample :drum_bass_hard
      end
      sleep 1
      with_fx :reverb, mix: rrand(0.5,0.6) do
        sample :drum_snare_hard
      end
      sleep 1
    end
  end
end

define :drumloop2 do
  in_thread do
    32. times do
      sample :drum_cymbal_closed, amp: rrand(0,1)
      sleep 0.25
    end
  end
end

define :drumloop3 do
  in_thread do
    64. times do
      sample :drum_cymbal_closed, finish: 0.03, amp: rrand(0,1)
      sleep 0.125
    end
  end
end

define :drumloop4 do
  in_thread do
    4. times do
      
      sleep 0.125
      sample :drum_tom_lo_soft, amp: rrand(0.5,1), beat_stretch: 2, rate: 3
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :drum_tom_lo_soft, amp: rrand(0.5,1), beat_stretch: 2.5, rate: 3
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :drum_tom_lo_soft, amp: rrand(0.5,1), beat_stretch: 3, rate: 3
      sleep 0.125
      
      sleep 0.125
      sample :drum_tom_lo_soft, amp: rrand(0.5,1), beat_stretch: 1.5, rate: 3
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
    end
  end
end

define :drumloop5 do
  in_thread do
    4. times do
      sample :drum_cymbal_open, rate: -1, release: 2, beat_stretch: 2
      sleep 2
    end
  end
end

define :drumloop6 do
  in_thread do
    4. times do
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :drum_cowbell, amp: rrand(0.12,0.3)
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :drum_cowbell, amp: rrand(0.12,0.3)
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :drum_cowbell, amp: rrand(0.12,0.3)
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :drum_cowbell, amp: rrand(0.12,0.3)
      sleep 0.125
      sample :drum_cowbell, amp: rrand(0.12,0.3)
      sleep 0.125
    end
  end
end

define :drumloop7 do
  in_thread do
    4. times do
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :drum_snare_hard, beat_stretch: rrand(0.1,0.25), amp: rrand(0.2,0.8)
      sleep 0.125
      sample :drum_snare_hard, beat_stretch: rrand(0.1,0.25), amp: rrand(0.2,0.8)
      sleep 0.125
      sample :drum_snare_hard, beat_stretch: rrand(0.1,0.25), amp: rrand(0.2,0.8)
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :drum_snare_hard, beat_stretch: rrand(0.1,0.25), amp: rrand(0.2,0.8)
      sleep 0.125
      sample :drum_snare_hard, beat_stretch: rrand(0.1,0.25), amp: rrand(0.2,0.8)
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
    end
  end
end

define :drumloop8 do
  in_thread do
    4. times do
      with_fx :reverb, mix: rrand(0,0.5) do
        sample :drum_cymbal_open, beat_stretch: 0.5
      end
      sleep 1
      with_fx :reverb, mix: rrand(0,0.5) do
        sample :drum_snare_hard, beat_stretch: 0.2
      end
      sleep 1
    end
  end
end

define :drumloop9 do
  in_thread do
    32. times do
      
      sample :elec_tick, amp: rrand(0.5,0.9)
      sleep 0.25
    end
  end
end

define :drumloop10 do
  in_thread do
    16. times do
      sleep 0.5
      sample :drum_tom_hi_hard, amp: rrand(0.3,0.6), beat_stretch: 0.8, finish: 0.01
      
    end
  end
end

define :drumloop11 do
  in_thread do
    64. times do
      sample :bd_ada, amp: rrand(0.3,0.6), beat_stretch: 0.8, finish: 0.05
      sleep 0.125
    end
  end
end

define :drumloop12 do
  in_thread do
    4. times do
      sample :loop_perc1, amp: rrand(0.1,0.35)
      sleep 2
    end
  end
end

define :drumloop13 do
  in_thread do
    4. times do
      sample :loop_mehackit1, amp: rrand(0.3,0.6), beat_stretch: 0.9
      sleep 2
    end
  end
end

define :drumloop14 do
  in_thread do
    4. times do
      sleep 0.25
      sample :glitch_perc1, amp: rrand(0.3,0.6)
      sleep 1.75
    end
  end
end

define :drumloop15 do
  in_thread do
    4. times do
      sleep 0.25
      sample :glitch_perc2, amp: rrand(0.13,0.3)
      sleep 1.75
    end
  end
end

define :drumloop16 do
  in_thread do
    4. times do
      sleep 0.5
      sample :glitch_perc3, amp: rrand(0.2,0.5)
      sleep 1.5
    end
  end
end

define :drumloop17 do
  in_thread do
    4. times do
      sleep 1
      sample :glitch_perc4, amp: rrand(0.3,0.6)
      sleep 1
    end
  end
end

define :drumloop18 do
  in_thread do
    4. times do
      sample :glitch_perc5, amp: rrand(0.1,0.4), beat_stretch: 2
      sleep 2
    end
  end
end

define :drumloop19 do
  in_thread do
    4. times do
      sleep 0.25
      sample :glitch_robot1, amp: rrand(0.3,0.6)
      sleep 1.75
    end
  end
end

define :drumloop20 do
  in_thread do
    4. times do
      sleep 0.5
      sample :glitch_robot2, amp: rrand(0.1,0.4)
      sleep 1.5
    end
  end
end

define :drumloop21 do
  in_thread do
    8. times do
      with_fx :level, amp: rrand(0,1) do
        8. times do
          sleep 0.125
          sample :bd_mehackit, amp: rrand(0.0,0.5)
        end
      end
    end
  end
end

define :drumloop22 do
  in_thread do
    4. times do
      sample :mehackit_phone2
      sample :bd_klub
      sleep 0.125
      
      sleep 0.125
      sample :bd_klub
      sleep 0.125
      
      sleep 0.125
      with_fx :reverb do
        sample :drum_snare_hard, amp: 0.5
      end
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :bd_klub
      sleep 0.125
      
      sleep 0.125
      sample :bd_klub
      sleep 0.125
      sample :drum_tom_lo_soft, amp: rrand(0.5,1), beat_stretch: 3, rate: 3
      sleep 0.125
      
      sleep 0.125
      with_fx :reverb do
        sample :drum_snare_hard, amp: 0.5
      end
      sleep 0.125
      sample :drum_tom_lo_soft, amp: rrand(0.5,1), beat_stretch: 3, rate: 3
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
    end
  end
end

define :drumloop23 do
  in_thread do
    4. times do
      sample :bd_808, amp: 3
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :bd_808, amp: 3
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      with_fx :reverb do
        sample :drum_snare_soft, amp: 0.5
      end
      sleep 0.125
      sample :bd_klub
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      with_fx :reverb do
        sample :drum_snare_soft, amp: 0.5
      end
      sleep 0.125
      
      sleep 0.125
      sample :bd_808, amp: 3
      sleep 0.125
      
      sleep 0.125
    end
  end
end

define :drumloop24 do
  in_thread do
    8. times do
      sample :bd_boom, amp: 0.5
      sleep 1
    end
  end
end

define :drumloop25 do
  in_thread do
    4. times do
      sample :bd_808, amp: 4
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :bd_808, amp: 4
      sleep 0.125
      
      sleep 0.125
      with_fx :reverb do
        sample :drum_snare_soft, amp: 0.5
      end
      sleep 0.125
      sample :bd_klub
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :bd_808, amp: 4
      sleep 0.125
      
      sleep 0.125
      sample :bd_808, amp: 4
      sleep 0.125
      
      sleep 0.125
    end
  end
end

define :drumloop26 do
  in_thread do
    8. times do
      with_fx :echo, mix: 0.1 do
        with_fx :reverb, mix: rrand(0.1,0.3) do
          sample :drum_bass_hard, beat_stretch: 0.3
        end
        sleep 0.5
        with_fx :reverb, mix: rrand(0.0,0.3) do
          sample :drum_snare_hard, beat_stretch: 0.3
        end
        sleep 0.5
      end
    end
  end
end

define :drumloop27 do
  in_thread do
    4. times do
      sample :drum_snare_hard, finish: 0.05
      sleep 0.125
      sample :drum_snare_hard, finish: 0.05
      sleep 0.125
      sample :drum_snare_hard, finish: 0.05
      sleep 0.125
      sample :drum_snare_hard, finish: 0.05
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :drum_snare_hard, finish: 0.05
      sleep 0.125
      sample :drum_snare_hard, finish: 0.05
      sleep 0.125
      sample :drum_snare_hard, finish: 0.05
      sleep 0.125
      sample :drum_snare_hard, finish: 0.05
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
    end
  end
end



#strings

define :cbass do |p,d,r|
  wav = "C:/vvvv/Projects/space-event-sinan/Sinan/SonicPI/samples/contrabass/"
  t = p % 24
  sample wav, t, amp: 4.0, start: 0.1, finish: 0.8, sustain: d, release: r, attack: 0.05
end

define :cello do |p,d,r|
  wav = "C:/vvvv/Projects/space-event-sinan/Sinan/SonicPI/samples/cello/"
  t = p % 24
  sample wav, t, amp: 2.0, start: 0.01, finish: 0.5, sustain: d, release: r, attack: 0.1
end

define :viola do |p,d,r|
  wav = "C:/vvvv/Projects/space-event-sinan/Sinan/SonicPI/samples/viola/"
  t = p % 24
  sample wav, t, amp: 2.0, start: 0.1, finish: 0.4, sustain: d, release: r, attack: 0.1
end

define :violin do |p|
  wav = "C:/vvvv/Projects/space-event-sinan/Sinan/SonicPI/samples/violin/"
  t = p % 24
  sample wav, t, amp: 1.0, start: 0.1, finish: 0.5, sustain: 1.0, release: 0.2, attack: 0.1
end

counter1 = 0
counter2 = 0
bg = (ring 14,9,11,6,7,2,7,9)
voice1 = (ring 18,16,14,13,11,9,11,13,14,13,11,9,7,6,7,4)
voice2 = (ring 2,6,9,7,6,2,6,4,2,4,2,9,7,11,9,7,6,2,4,13,14,18,21,9,11,7,9,6,2,14,14,13)

#live_loop :canon do
#  cbass(bg[counter1],0.8,1.5)
#  cello(voice1[counter1],0.8,1.5)
#  sleep 0.5
#  cello(bg[counter1],0.5,1)
#  sleep 1.5
#  counter1 += 1
#end

#live_loop :canon2 do
#  viola(voice2[counter2],0.5,0.5)
#  sleep 1
#  counter2 += 1
#end
###################################################
# Process OSC Input
###################################################
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
    puts "vorher channel "+ns, get[("c"+ns).to_sym]
    if get[("c"+ns).to_sym] == 1
      set ("c"+ns).to_sym,0
    else
      set ("c"+ns).to_sym,1
    end
    puts "nachher channel "+ns, get[("c"+ns).to_sym]
    doCommandSelect(ns, get[("c"+ns).to_sym])
  end
end

live_loop :poff do
  b = sync "/osc/kinect/*"
  if b[0]==0
    r=parse_sync_address "/osc/kinect/*"
    ns= r[2]
    #set ("c"+ns).to_sym,0
    #doCommandSelect(ns, 0)
  end
end

define :doCommandSelect do |n, v|
  puts n
  case n
  when "0"
  when "1"
    cbass(bg[counter1],0.8,1.5)
  when "2"
    cello(voice1[counter1],0.8,1.5)
  when "3"
    cello(bg[counter1],0.5,1)
  when "4"
    viola(voice2[counter2],0.5,0.5)
  when "5"
    drumloop1
  when "6"
    drumloop5
  when "7"
    drumloop12
  when "8" #dark bass
    drumloop17
  when "9" #dark lead
    drumloop22
  when "10" #melody
    drumloop27
  else
    puts "nothing"
  end
end

#  cbass(bg[counter1],0.8,1.5)
#  cello(voice1[counter1],0.8,1.5)
#  cello(bg[counter1],0.5,1)

#  viola(voice2[counter2],0.5,0.5)

###################################################
# End of Process OSC Input
###################################################
