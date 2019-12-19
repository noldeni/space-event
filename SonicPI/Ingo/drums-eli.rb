# drums-eli.rb
# https://in-thread.sonic-pi.net/u/Eli

use_bpm 60
set_volume! 5
use_random_seed 999

live_loop :drums do
  this_sample = [:loop_compus, :loop_tabla, :loop_safari].ring
  start = [ 0.0 , 0.125 , 0.25 , 0.375 , 0.5 , 0.625 , 0.75 , 0.875 ].ring
  sample this_sample.look , beat_stretch: 4, start: start.look, rate: 0.5
  sleep 1
  tick
end