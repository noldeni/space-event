#Whale-Song.rb
#https://in-thread.sonic-pi.net/u/Eli
#https://in-thread.sonic-pi.net/t/whale-song-anyone/260/10
use_bpm 90

live_loop :beat do
  use_sample_defaults amp: 0.7
  cue :kick
  sleep 4
end

comment do
  
  with_fx :echo, phase: 0.375 do
    live_loop :sonar do
      use_synth :sine
      use_synth_defaults note_slide: 5.02, amp: 0.125
      sync :kick
      sync :kick
      notes =  scale( :g5, :minor)
      play notes.tick, release: 6
      sleep 0.25
      31.times do
        control note: notes.choose
        sleep [0.25].choose
        tick
      end
      sleep 2
    end
  end
  
end


with_fx :echo, mix: 0.8, phase: 0.75, decay: 4 do
  live_loop :whales do
    with_fx :flanger, stereo_invert_wave: 1, feedback: 0.5, amp: 0.25 do
        sync :kick
        use_synth :fm
        repeater = [6,7,8,9,12].choose
        use_synth_defaults res: 0.9, attack: 0.25, noise: 2, release: 2 , cutoff: 100, amp: 0.3,
          note_slide: 5.02, sustain: 0.25 * repeater / 1.25, decay: 0.25 * repeater / 1.25, sustain_level: 0.8,
          mod_range: 0.5, mod_phase: 0.125, mod_wave: 2, pulse_width: 0.2
        mynote =  note_range( :g3, :g5, pitches:  scale( :g6, :minor))
        play mynote.tick
        repeater.times do
          control note: mynote.tick + [0, 12].choose
          sleep [0.25, 0.25, 0.5].choose
        end
        sleep 2.5
      end
    end
  end