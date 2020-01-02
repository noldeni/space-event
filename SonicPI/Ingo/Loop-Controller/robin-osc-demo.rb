#robin-osc-demo.rb
#demo program by Robin Newman
#IN: funktioniert
use_osc "localhost",4559 #send OSC messages to localhost ie this program
set :continueplay,3 # set a dummy value (not 0 or 1 for continueplay, to start with)


live_loop :startcue do #wait for incoming /start OSC message
  use_real_time
  b = sync "/osc/start"
  puts "started"
  set :continueplay,1 # stat continueplay flag to 1
end

live_loop :stopcue do #wait for incvoming /stop OSC message
  use_real_time
  b = sync "/osc/stop"
  puts "stopping"
  set :continueplay,0 #set continueflag to 0
end

live_loop :play do # play loop
  play :E3 if get(:continueplay)==1 # play :E3 if continueflag is 1
  sleep 1
  stop if get(:continueplay) ==0 #stop this loop (althouhg NOT the complete program if continue flag 0
end


osc "/start" #start message (This could be sent from an external source)
sleep 10
osc "/stop" #stop message (This could be sent from an external source)

