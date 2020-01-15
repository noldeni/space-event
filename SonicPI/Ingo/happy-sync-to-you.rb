## happy-sync-to-you.rb
## https://in-thread.sonic-pi.net/u/nlb
## https://in-thread.sonic-pi.net/t/happy-sync-a-way-to-use-sync/1995
##
## NLB - Happy Sync to You
## 12/02/2019

use_bpm 120

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
  
end

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
end

live_loop :crash, delay: 1 + 4 do
  sync :_4_measures
  sample :drum_splash_soft
  sleep 1
  sample :drum_splash_hard
end

live_loop :riff_B do
  use_synth :pluck
  sync :_4_measures
  use_octave 1
  play_pattern_timed [:c3, :e3, :g3, :c4], 0.25, amp: 2, attack: 0, sustain: 0.2, release: 2
end

live_loop :riff_B do
  #stop
  use_synth :dark_ambience
  sync :_4_measures
  use_octave 1
  play_pattern_timed [:c4, :e4, :g4, :c5], 4, attack: 0.25, sustain: 3.75 , amp:1.5
end

### BASS ###

live_loop :_bass_ do
  #stop
  sync :_1_measure
  use_synth :saw
  with_fx :reverb do
    use_synth_defaults attack: 0.1, delay: 0.1, sustain: 0.1, cutoff: 150, amp: 0.4
    play_pattern_timed [:c2, :c3, :e3, :e3],[0.5,1,0.5,1.5]
  end
end


live_loop :scale_A, delay: 1 + 32 do
  #stop
  use_synth :subpulse
  sync :_1_measure
  play scale(:g4,:dorian,num_octaves: 1).tick, release:1, sustain: 3, sustain_level: 0.5, amp:0.7
end

live_loop :scale_B do
  #stop
  sync :_4_measures
  use_synth :sine
  use_synth_defaults amp: 0.5, attack: 0, delay: 0.1, sustain: 0.3, release: 1, cutoff: 120
  play_pattern_timed scale(:c4,:blues_major,num_octaves: 2), [0.25, 0.5, 0.75, 0.25]
end


live_loop :with_a_sample do
  #stop
  sync :_8_measures
  with_fx :echo, mix:0.8, phase: 1 do
    sample :loop_mika, amp: 0.7, release: 8
  end
end


### RIFF ###

riff_01 = (ring :c2,:e3,:c3,:d3,:r,:c3,:r,:c3,
           :c2,:e3,:c3,:d3,:r,:r,:g3, :f3)

# pluck riff
live_loop :_riff_ do
  #stop
  sync :_4_measures
  use_synth :piano
  with_fx :echo do
    use_synth_defaults amp: 0.8, attack: 0, sustain: 0.5, release: 1, cutoff: 100
    play_pattern_timed riff_01, 1
  end
end


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