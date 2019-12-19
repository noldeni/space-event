use_real_time
use_osc "127.0.0.1",9000 #adjust for output IP to which to send LED on/off signals (TouchOSC)
oscmessage="/osc/kinect/*"
use_bpm 120

use_debug false
use_osc_logging false

use_synth :tri

define :lone do |action|
  if action==1
    set :k1,false
    live_loop :one do
      play scale(:c4,:minor_pentatonic).choose,release: 0.1
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

