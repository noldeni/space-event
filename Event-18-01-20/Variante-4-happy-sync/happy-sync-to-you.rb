## happy-sync-to-you.rb
## https://in-thread.sonic-pi.net/u/nlb
## https://in-thread.sonic-pi.net/t/happy-sync-a-way-to-use-sync/1995
##
## NLB - Happy Sync to You
## 12/02/2019
use_real_time
use_osc "127.0.0.1",9000 #adjust for output IP to which to send LED on/off signals (TouchOSC)
use_bpm 120

use_debug false
use_osc_logging false

# Initialize Time System Variables
set :c0,0
set :c1,0
set :c2,0
set :c3,0
set :c4,0
set :c5,0
set :c6,0
set :c7,0
set :c8,0
set :c9,0
set :c10,0
set :c99,0

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

define :lone do |action|
  if action==1
    set :k1,false
    live_loop :drums do
      sync :_4_measures
      7.times do
        sample :drum_bass_hard
        sleep 1
        sample :drum_snare_hard
        sleep 1
      end
      
      sample :drum_bass_hard
      sleep 0.5
      sample :drum_bass_hard
      sleep 0.5
      sample :drum_snare_hard
      sleep 0.5
      sample :drum_snare_hard
      sleep 0.5
      
      stop if get(:k1)
    end
  else
    set :k1,true
  end
end


define :ltwo do |action|
  if action==1
    set :k2,false
    live_loop :hits_hats do
      sync :_4_measures # 16 beats
      15.times do
        sample :drum_cymbal_closed
        sleep 0.5
        sample :drum_cymbal_closed
        sleep 0.5
      end
      sample :drum_cymbal_closed
      sleep 0.5
      sample :drum_cymbal_open
      sleep 0.5
      stop if get(:k2)
    end
  else
    set :k2,true
  end
end

define :lthree do |action|
  if action==1
    set :k3,false
    live_loop :crash, delay: 1 + 4 do
      sync :_4_measures
      sample :drum_splash_soft
      sleep 1
      sample :drum_splash_hard
      stop if get(:k3)
    end
  else
    set :k3,true
  end
end

define :lfour do |action|
  if action==1
    set :k4,false
    live_loop :riff_B do
      use_synth :pluck
      sync :_4_measures
      use_octave 1
      play_pattern_timed [:c3, :e3, :g3, :c4], 0.25, amp: 2, attack: 0, sustain: 0.2, release: 2
      stop if get(:k4)
    end
  else
    set :k4,true
  end
end

define :lfive do |action|
  if action==1
    set :k5,false
    live_loop :riff_B2 do
      #stop
      use_synth :dark_ambience
      sync :_4_measures
      use_octave 1
      play_pattern_timed [:c4, :e4, :g4, :c5], 4, attack: 0.25, sustain: 3.75 , amp:1.5
      stop if get(:k5)
    end
  else
    set :k5,true
  end
end

### BASS ###
define :lsix do |action|
  if action==1
    set :k6,false
    live_loop :_bass_ do
      #stop
      sync :_1_measure
      use_synth :saw
      with_fx :reverb do
        use_synth_defaults attack: 0.1, delay: 0.1, sustain: 0.1, cutoff: 150, amp: 0.4
        play_pattern_timed [:c2, :c3, :e3, :e3],[0.5,1,0.5,1.5]
      end
      stop if get(:k6)
    end
  else
    set :k6,true
  end
end

define :lseven do |action|
  if action==1
    set :k7,false
    live_loop :scale_A, delay: 1 + 32 do
      #stop
      use_synth :subpulse
      sync :_1_measure
      play scale(:g4,:dorian,num_octaves: 1).tick, release:1, sustain: 3, sustain_level: 0.5, amp:0.7
      stop if get(:k7)
    end
  else
    set :k7,true
  end
end

define :leight do |action|
  if action==1
    set :k8,false
    live_loop :scale_B do
      #stop
      sync :_4_measures
      use_synth :sine
      use_synth_defaults amp: 0.5, attack: 0, delay: 0.1, sustain: 0.3, release: 1, cutoff: 120
      play_pattern_timed scale(:c4,:blues_major,num_octaves: 2), [0.25, 0.5, 0.75, 0.25]
      stop if get(:k8)
    end
  else
    set :k8,true
  end
end

define :lnine do |action|
  if action==1
    set :k9,false
    live_loop :with_a_sample do
      #stop
      sync :_8_measures
      with_fx :echo, mix:0.8, phase: 1 do
        sample :loop_mika, amp: 0.7, release: 8
      end
      stop if get(:k9)
    end
  else
    set :k9,true
  end
end


### RIFF ###

riff_01 = (ring :c2,:e3,:c3,:d3,:r,:c3,:r,:c3,
           :c2,:e3,:c3,:d3,:r,:r,:g3, :f3)

# pluck riff
define :lten do |action|
  if action==1
    set :k10,false
    live_loop :_riff_ do
      #stop
      sync :_4_measures
      use_synth :piano
      with_fx :echo do
        use_synth_defaults amp: 0.8, attack: 0, sustain: 0.5, release: 1, cutoff: 100
        play_pattern_timed riff_01, 1
      end
      stop if get(:k10)
    end
  else
    set :k10,true
  end
end
###################################################
# End of OSC Loops
###################################################


####  It's your turn   ##########

beats_per_measure = 4

live_loop :_every_1_measure, delay: 1 do
  cue :_1_measure
  sleep beats_per_measure
end

live_loop :_every_4_measure, delay: 1 do
  cue :_4_measures
  sleep 4 * beats_per_measure
end

live_loop :_every_8_measures, delay: 1 do
  cue :_8_measures
  sleep 8 * beats_per_measure
end

live_loop :_every_16_measures, delay: 1 do
  cue :_16_measures
  sleep 16 * beats_per_measure
end
#####################
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
    if get[("c"+ns).to_sym] == 1
      set ("c"+ns).to_sym,0
    else
      set ("c"+ns).to_sym,1
    end
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
    lone v
  when "2"
    ltwo v
  when "3"
    lthree v
  when "4"
    lfour v
  when "5"
    lfive v
  when "6"
    lsix v
  when "7"
    lseven v
  when "8" #dark bass
    leight v
  when "9" #dark lead
    lnine v
  when "10" #melody
    lten v
  else
    puts "nothing"
  end
end

###################################################
# End of Process OSC Input
###################################################
