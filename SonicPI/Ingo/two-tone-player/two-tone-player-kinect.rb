#two-tone-player.rb
#https://in-thread.sonic-pi.net/u/robin.newman
#https://in-thread.sonic-pi.net/t/using-controllers-with-sonic-pi-3/306

#two tone player. Two oscillators controlled independently
#by TouchOSC sliders. Notes sound continuosly.
#Stop and Restart buttons
#Slider range selector +- 0.1,1,4,7,12 semitones
#Can illustrate "beats" between the notes on the bottom two ranges 0.1 and 1
#written by Robin Newman, October 2017

use_osc "127.0.0.1",4559
remote_ip="127.0.0.1" #adjust to IP address of TouchOSC device
#reset sliders and note values
osc "/notegen/reset"
use_synth :sine
set :kv1,0;set :kv2,0;set :n1,0;set :n2,0;set :range,12 #initalise set values
set :hlxmin,0.0; set :hlymin,0.0;set :hlzmin,0.0
set :hlxmax,0.0; set :hlymax,0.0;set :hlzmax,0.0
#set correct range button
osc_send remote_ip,9000,"/notegen/range",1

define :rescale do |n|
  # rescales the input from -1 to 1 into 0 to 1
  # call rescale -0.6 returns 0.2
  return (n+1)/2
end

define :remap do |input, inMin, inMax, outMin, outMax|
  return (input - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end


with_fx :reverb,room: 0.8 do
  
  live_loop :getnote1 do #loop plays first (left slider) note
    use_real_time
    #b = sync "/osc/notegen/note1"
    hrx, hry, hrz, _ = sync "/osc/kinect/hr"
    osc_send "127.0.0.1",9000,"/notegen/note1",hry
    set :n1,hry #store note value
    k=get(:kv1) #get pointer to previous note (if any)
    if k!=0 #if exists, fade out and ill previous note
      control k,amp: 0,amp_slide: 0.025
      sleep 0.025
      kill k
    end
    r=get(:range)# get range scaler
    puts "r is ",r
    #when n1 is zero centre note is 72
    k=play get(:n1)*r+72,release: 100,attack: 0.01 #start new "long" note
    set :kv1,k
    sleep 0.01 #set minimum loop time to reduce "crackle"
  end
  
  live_loop :getnote2 do #loop plays second (right slider) note
    use_real_time
    #b = sync "/osc/notegen/note2"
    hlx, hly, hlz, _ = sync "/osc/kinect/hl"
    osc_send "127.0.0.1",9000,"/notegen/note2",hly
    set :n2,hly #store note value
    k=get(:kv2) #get pointer to previous note
    if k!=0 #if exists, fade out and kill note
      control k,amp: 0,amp_slide: 0.025
      sleep 0.025
      kill k
    end
    r=get(:range) #get current range scaler
    #when n2 is zero centre note is 72
    k=play get(:n2)*r+72,release: 100,attack: 0.01 #start new "long" note
    set :kv2,k
    sleep 0.01 #set minimum loop time to reduce "crackle"
  end
  live_loop :killnote do #=used by red "stop" button
    use_real_time
    b = sync "/osc/notegen/kill"
    if b[0]>0 #if button is pushed (not released)
      k=get(:kv1) # get current note1 pointer
      if k!=0 #if it exists kill the note
        control k,amp: 0,amp_slide: 0.04
        sleep 0.04
        kill k
      end
      k=get(:kv2) #gtet current note23 pointer
      if k!=0 #if it exists kill the note
        control k,amp: 0,amp_slide: 0.04
        sleep 0.04
        kill k
      end
    end
  end
  live_loop :startnote do #used by update and astart green button
    use_real_time
    b = sync "/osc/notegen/start"
    if b[0]>0 #check if depressed
      osc "/notegen/note1",get(:n1) #send OSC message to getnote1 liveloop to (re)start the note
      osc "/notegen/note2",get(:n2) #send OSC message to getnote2 liveloop to (re)start the note
    end
    
  end
end

define :getbtn do |address| #"/osc/notegen/range/*/1" returns * value which will be 1->5
  #uses unpublished get_event function which may alter in future versions
  return get_event(address).to_s.split(",")[6][address.length-1..-4].to_i
end

live_loop :getrange do #get range set on TouchOSC multitoggle switch
  use_real_time
  b = sync "/osc/notegen/range"
  if b[0]>0 #only respond as button is set, not cleared
    #r= getbtn("/osc/notegen/range/*/1") #function gets * match which will be 1->5 depending on button selected
    #set :range,[0.1,1,4,7,12][r-1]
    set :range,b[0]
    puts"range set to ",get(:range)
  end
end

live_loop :kinect do #get range set on TouchOSC multitoggle switch
  use_real_time
  hlx, hly, hlz, _ = sync "/osc/kinect/hl"
  hrx, hry, hrz, _ = sync "/osc/kinect/hr"
  puts"Kinect get:",hlx,"--",hly,"--",hlz
  set :n1,hlx
  set :n2,hrx
  if (hlx > get(:hlxmax))
    set :hlxmax,hlx
  end
  if (hlx < get(:hlxmin))
    set :hlxmin,hlx
  end
  
  if (hly > get(:hlymax))
    set :hlymax,hly
  end
  if (hly < get(:hlymin))
    set :hlymin,hly
  end
  
  if (hlz > get(:hlzmax))
    set :hlzmax,hlz
  end
  if (hlz < get(:hlzmin))
    set :hlzmin,hlz
  end
  puts"Max:",get(:hlxmax),"--",get(:hlymax),"--",get(:hlzmax)
  puts"Min:",get(:hlxmin),"--",get(:hlymin),"--",get(:hlzmin)
end


live_loop :resetsliders do #responds to YellowZero Sliders button to set silders to mid position 0 (range -1,1)
  use_real_time
  b = sync "/osc/notegen/reset"
  osc_send remote_ip,9000,"/notegen/note1",0 #send osc messages to zero sliders
  osc_send remote_ip,9000,"/notegen/note2",0
  set :n1,0 #reset n1 and n2 values to 0
  set :n2,0
end

