## Eastern pluck & 'safari' percussion
## Coded by Nanomancer
## https://gist.github.com/Nanomancer/32db5ba5c78fc86816e56424ec64121c

##| set_volume! 5
##| puts "SYNC"
##| sample :elec_blip, amp: 0.5
##| sleep 8

set_volume! 0.55
# set_mixer_control! amp: 0.1, amp_slide: 0.1
set_mixer_control! amp: 0.1, amp_slide: 0.1
sleep 1
set_mixer_control! amp: 5, amp_slide: 12
use_bpm 120

live_loop :safari, delay: 32 do
  with_fx :reverb, mix: 0.4, room: 0.6 do
    if one_in(3) then sample :loop_safari, amp: 0.9, finish: 0.5, rate: 0.5, beat_stretch: 16
    elsif one_in(2) then sample :loop_safari, amp: 0.9, start: 0.5, rate: 0.5, beat_stretch: 16 end
    
    if one_in(3) then sample :loop_safari, amp: 0.35, rate: 1, beat_stretch: 16 end
    sleep 16
  end
  ##| stop
end

live_loop :low_boom, delay: 8 do
  sample :bd_boom, rate: 0.75, amp: 0.2
  sleep [7,1,8].ring.tick
end

seeds = [323699.5012207031, 323705.5012207031, 323723.5012207031,
         323729.5012207031, 323735.5012207031, 323747.5012207031,
         323759.5012207031, 323771.5012207031, 323831.5012207031,
         323837.5012207031, 323861.5012207031, 323867.5012207031,
         323897.5012207031, 323993.5012207031, 324017.5012207031,
         323729.5012207031, 323755.5012207031, 323677.5012207031,
         323761.5012207031].ring

##| autoseeder = []
vol = 0.3

live_loop :eastern_twang do |idx|
  use_synth :pluck
  
  with_random_seed seeds[idx] do
    puts "SEED: #{current_random_seed} loop no.: #{idx}"
    ##| autoseeder << current_random_seed
    notes = scale(:a3, :harmonic_minor, num_octaves: dice(2)).pick(4)
    multi = [0.5,1,1.5,2].choose
    
    cut = range(50, 130, step: 2.5).mirror.ring
    slp = [1,1.5,0.5,1].ring
    if multi == 0.5 || multi == 1 then reps = 16
    else reps = 8 end
    
    with_fx :echo, mix: 0.4, phase: 2, max_phase: 4 do
      with_fx :reverb, mix: 0.65, room: 0.85 do
        reps.times do
          play notes.tick, amp: vol*rdist(0.09, 1),
            cutoff: rdist(15, 115), pitch: rdist(0.1, 0)
          sleep slp.look*multi
          if idx >= 22 && vol >= 0.0125 then vol -= 0.0125 end
        end
      end
    end
    if one_in(3) then sleep 8 end
    idx+=1
  end
end