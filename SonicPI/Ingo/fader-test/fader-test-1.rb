#Test program to illustrate use of TouchOSC with Sonic Pi 3
#by Robin Newman, October 2017


set :trans,0 #set initial slider recorded position
#optional reset slider on TouchOSC
osc_send "127.0.0.1",9000,"/test/fader1",0
#optional reset onoff toggle to off
osc_send "127.0.0.1",9000,"/test/toggle1",0
sleep 0.2 #allow it to happen

#live loop to handle the push button
live_loop :b1 do
  use_real_time
  b = sync "/osc/test/push1" #match the push button address
  puts "button 1 is ",b[0]
  if b[0]>0 # only proceed when button is pushed, not released
    use_synth :tri
    10.times do #use 10 times loop to play some notes
      play scale(:e3,:minor_pentatonic).choose,release: 0.1
      sleep 0.1
    end
  end
end

#live loop to read slider position and record it with set :trans
live_loop :slider do
  use_real_time
  b = sync "/osc/test/fader1"
  puts "slider is ",b[0]
  set :trans,b[0]*12 #scale to +- octave
end

#live loop to respond to presses on the toggle switch toggle1
#this is used to switch on and off a long (1000 sec) note
#The pitch of the note is controlled by the slider value
live_loop :toggle do
  use_real_time
  b = sync "/osc/test/toggle1"
  puts "toggle1 is ",b[0]
  if b[0]>0 #if it is active (pressed and on)
    use_synth :tri
    x=play note(:c4)+get(:trans),sustain: 1000 #start a very long note and record referece in x
    set :x,x #save x in :x for retrieval in following loop
    in_thread do #a thread containing a continuously running loop
      loop do
        #get the control value and alter the pitch
        #using the stored :trans value. Alter over a 0.1 slide time
        control get(:x),note: note(:c4)+get(:trans),note_slide: 0.1
        sleep 0.1 # wait for slide to finish and rerun loop
      end
    end
  else #toggle has just been switched to off
    control get(:x),amp: 0,amp_slide: 0.1 #fade out note
    sleep 0.1
    kill get(:x) #kill the long note (sustain: 1000)
  end
end