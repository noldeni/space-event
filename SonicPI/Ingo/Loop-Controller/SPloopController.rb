# SPloopController.rb 
# https://gist.github.com/rbnpi/a86ced02b74817f3070887df30fb0701#file-sploopcontrolpi3-rb
# https://youtu.be/cEz-fOEF3M0
# 13.03.2018
#
#Sonic Pi Loop Controller by Robin Newman
#VERSION 2 ADDS CONTROL OF BACKGROUND PULSE AND SCREEN
#Tested on a Mac: this version NOT sutiable for Pi3
#in particular uses some new :loop samples only in version 3.1
#These can be copied to teh samples folder on version 3.0.1 if required
#or you can specify different ones.
#Also may have to cut down use of fx calls on Pi3 as may overload it otherwise.
#This version uses 11 push buttons on TouchOSC for input and 1 LED on TouchOSC for output
#Can be modified to use any suitable OSC source thant can give on/off signals when a button is pressed
#
#OSC-Messages
# /1/push1
# /1/push2
# /1/push3
# /1/push4
# /1/push5
# /1/push6
# /1/push7
# /1/push8
# /1/push9
# /1/push10
# /1/push11
# /1/bg

use_real_time
use_osc "192.168.1.240",9000 #adjust for output IP to which to send LED on/off signals (TouchOSC)
use_bpm 120
path="~/Desktop/samples/"
#turn background sound and led offloo
set :bg,0
osc "/1/bg",0

use_debug false
use_osc_logging false
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
  b = sync "/osc/1/push*"
  if b[0]==1
    r=parse_sync_address "/osc/1/push*"
    ns= r[2][4..-1]
    set ("c"+ns).to_sym,1
    doCommandSelect(ns .to_i)
  end
end
live_loop :poff do
  b = sync "/osc/1/push*"
  if b[0]==0
    r=parse_sync_address "/osc/1/push*"
    ns= r[2][4..-1]
    set ("c"+ns).to_sym,0
  end
end

define :doCommandSelect do |n|
  puts n
  case n
  when 1
    with_fx :gverb,room: 25,mix: 0.8 do
      doLoop 1,0.5,:loop_amen,4 #parameters: channel,vol,samplename,beatstrech value
    end
  when 2
    doLoop 2,0.5,:loop_garzul,16
  when 3
    with_fx :gverb,room: 25,mix: 0.8 do
      doLoop 3,0.8,:loop_compus,16
    end
  when 4
    doLoop 4,0.9,:loop_mehackit1,4
  when 5
    with_fx :gverb,room: 25,mix: 0.8 do
      doLongNote 5,0.5,:fm,:c3,4 #parameters channel, vol,synth,note,repeat duration*****
      #*** can add an optiona beat_stretch, but probably not required
    end
  when 6
    with_fx :gverb,room: 25,mix: 0.8 do
      doLoopSequence 6,0.1,:tb303 #parameters channel, vol,synth
    end
  when 7
    doLoop 7,0.7,:loop_mika, 16
  when 8
    doLoop 8,0.7, :loop_weirdo, 4
  when 9
    doLoop 9,0.9,:loop_safari,16 #doSingleSample
  when 10
    doLoop 10,0.7, :loop_mehackit2,4
  when 11
    with_fx :gverb,room: 20,mix: 0.8 do
      doOneShot 11,4,path+"testsample.flac" #parameters channel,vol,sample
      #as a singleShot plays once so only sync the start
    end
  else
    puts "nothing"
  end
end

#general function to set up stoppable live_loop
define :doLoop do |n,vol,sampleName,bs,|
  set ("kill"+n.to_s).to_sym,false
  ln=("name"+n.to_s).to_sym
  in_thread do
    loop do
      if get( ("c"+n.to_s).to_sym)==0
        s= get( ("s"+n.to_s).to_sym)
        kill s
        set ("kill"+n.to_s).to_sym, true
        stop
      end
      sleep 0.1
    end
  end
  live_loop  ln, sync: :metro do
    s=sample sampleName,beat_stretch: bs,amp: vol
    set ("s"+n.to_s).to_sym,s
    k=(bs/0.1).to_i
    k.times do
      sleep bs.to_f/k
      stop if get( ("kill"++n.to_s).to_sym)
    end
  end
end

#general function to start stoppable single shot sample
define :doOneShot do |n,vol,sampleName,bs=0|
  sync :metro
  if bs >0
    s=sample sampleName,beat_stretch: bs,amp: vol
  else
    s=sample sampleName,amp: vol
  end
  in_thread do
    loop do
      if get( ("c"++n.to_s).to_sym)==0
        kill s
        stop
      end
      sleep 0.1
    end
  end
end

#general function to set up long repeating note
define :doLongNote do |n,vol,synth,note,dur|
  set ("kill"+n.to_s).to_sym,false
  ln=("name"+n.to_s).to_sym
  in_thread do
    loop do
      if get( ("c"+n.to_s).to_sym)==0
        s= get( ("s"+n.to_s).to_sym)
        control s,amp: 0,amp_slide: 0.05
        sleep 0.05
        kill s
        set ("kill"+n.to_s).to_sym, true
        stop
      end
      sleep 0.1
    end
  end
  live_loop  ln, sync: :metro do
    use_synth synth
    s=play note,sustain: dur-1,release: 1,cutoff: 100,amp: vol
    set ("s"+n.to_s).to_sym,s
    k=(dur/0.1).to_i
    k.times do
      sleep dur.to_f/k
      stop if get( ("kill"++n.to_s).to_sym)
    end
  end
end

#function to setup sequence of notes (stoppable)
define :doLoopSequence do |n,vol,synth|
  set ("kill"+n.to_s).to_sym,false
  ln=("name"+n.to_s).to_sym
  in_thread do
    loop do
      if get( ("c"+n.to_s).to_sym)==0
        set ("kill"+n.to_s).to_sym, true
        stop
      end
      sleep 0.1
    end
  end
  live_loop  ln, sync: :metro do
    use_synth synth
    
    play scale(:c3,:minor_pentatonic,num_octaves: 2).choose,release: 0.20,amp: vol,cutoff: rrand_i(60,120)
    10.times do #do this to get a quicker response time
      sleep 0.25 / 10
      stop if get(("kill"+n.to_s).to_sym)
    end
  end
  
end


live_loop :metro do #metronome to sync stuff together
  sleep 1
end

live_loop:background do
  b = sync "/osc/1/bg"
  set :bg,b[0]
end


#Optional repeating pulse
with_fx :gverb,room: 15,mix: 0.8,amp: 0.5 do
  live_loop :alwaysplaying,sync: :metro do #runs continuously playing
    use_synth :fm
    play :c3,release: 1,amp: 1,pan: -0.8 if get(:bg)==1
    play :c4,release: 2,amp: 0.2,pan: -0.8 if get(:bg)==1
    osc "/1/led1",1  if get(:bg)==1#switch on large LED on TouchOSC screen
    sleep 1
    osc "/1/led1",0  #switch on large LED on TouchOSC screen
    sleep 1
    play :c3,release: 2,amp: 1,pan: 0.8 if get(:bg)==1
    osc "/1/led1",1  if get(:bg)==1#switch on large LED on TouchOSC screen
    sleep 1
    osc "/1/led1",0 #switch off large LED on TouchOSC screen
    sleep 1
  end
end