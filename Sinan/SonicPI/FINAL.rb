#ticking
live_loop :pulse do
  with_fx :level, amp: 5.0 do
    with_fx :lpf do
      synth :hollow, note: :Fs4, release: 2, amp: rrand(0.5,1.0)
      synth :mod_beep, note: :A2, amp: 0.7
      synth :sine, amp: rrand(0.3,0.5), sustain: 0.1, decay: 0.02, release: 0.2, attack: 0.1,note: chord(:D2, :major).choose
      synth :blade, amp: rrand(0.5,0.9), sustain: 0.01, decay: 0.01, release: 0.0, attack: 0.125,note: chord(:D4, :major)
      with_fx :echo, decay: 1, mix: 0.3, amp: 1.0 do
        synth :dpulse, amp: rrand(0.0,0.4), sustain: 0.01, decay: 0.01, release: 0.01, attack: 0.03,note: :d5, cutoff: 47
      end
      with_fx :echo, decay: 2, mix: 0.9, amp: 0.5, phase: 0.125 do
        synth :cnoise, amp: rrand(0.1,0.3), sustain: 0.001, decay: 0.001, release: 0.005, attack: 0,note: :d6
      end
      
      sleep 0.25
      with_fx :echo, decay: 1, mix: 1, amp: 0.25 do
        with_fx :gverb do
          synth :mod_saw, amp: rrand(0.1,0.2), sustain: 0.02, decay: 0.02, release: 0.5, attack: 0.03,note: chord(:D3, :major)
        end
        
      end
      
      sleep 0.25
    end
  end
end

#drum

define :drumloop1 do
  in_thread do
    4. times do
      with_fx :reverb, mix: rrand(0.3,0.5) do
        sample :drum_bass_hard
      end
      sleep 1
      with_fx :reverb, mix: rrand(0.5,0.6) do
        sample :drum_snare_hard
      end
      sleep 1
    end
  end
end

define :drumloop2 do
  in_thread do
    32. times do
      sample :drum_cymbal_closed, amp: rrand(0,1)
      sleep 0.25
    end
  end
end

define :drumloop3 do
  in_thread do
    64. times do
      sample :drum_cymbal_closed, finish: 0.03, amp: rrand(0,1)
      sleep 0.125
    end
  end
end

define :drumloop4 do
  in_thread do
    4. times do
      
      sleep 0.125
      sample :drum_tom_lo_soft, amp: rrand(0.5,1), beat_stretch: 2, rate: 3
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :drum_tom_lo_soft, amp: rrand(0.5,1), beat_stretch: 2.5, rate: 3
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :drum_tom_lo_soft, amp: rrand(0.5,1), beat_stretch: 3, rate: 3
      sleep 0.125
      
      sleep 0.125
      sample :drum_tom_lo_soft, amp: rrand(0.5,1), beat_stretch: 1.5, rate: 3
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
    end
  end
end

define :drumloop5 do
  in_thread do
    4. times do
      sample :drum_cymbal_open, rate: -1, release: 2, beat_stretch: 2
      sleep 2
    end
  end
end

define :drumloop6 do
  in_thread do
    4. times do
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :drum_cowbell, amp: rrand(0.12,0.3)
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :drum_cowbell, amp: rrand(0.12,0.3)
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :drum_cowbell, amp: rrand(0.12,0.3)
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :drum_cowbell, amp: rrand(0.12,0.3)
      sleep 0.125
      sample :drum_cowbell, amp: rrand(0.12,0.3)
      sleep 0.125
    end
  end
end

define :drumloop7 do
  in_thread do
    4. times do
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :drum_snare_hard, beat_stretch: rrand(0.1,0.25), amp: rrand(0.2,0.8)
      sleep 0.125
      sample :drum_snare_hard, beat_stretch: rrand(0.1,0.25), amp: rrand(0.2,0.8)
      sleep 0.125
      sample :drum_snare_hard, beat_stretch: rrand(0.1,0.25), amp: rrand(0.2,0.8)
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :drum_snare_hard, beat_stretch: rrand(0.1,0.25), amp: rrand(0.2,0.8)
      sleep 0.125
      sample :drum_snare_hard, beat_stretch: rrand(0.1,0.25), amp: rrand(0.2,0.8)
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
    end
  end
end

define :drumloop8 do
  in_thread do
    4. times do
      with_fx :reverb, mix: rrand(0,0.5) do
        sample :drum_cymbal_open, beat_stretch: 0.5
      end
      sleep 1
      with_fx :reverb, mix: rrand(0,0.5) do
        sample :drum_snare_hard, beat_stretch: 0.2
      end
      sleep 1
    end
  end
end

define :drumloop9 do
  in_thread do
    32. times do
      
      sample :elec_tick, amp: rrand(0.5,0.9)
      sleep 0.25
    end
  end
end

define :drumloop10 do
  in_thread do
    16. times do
      sleep 0.5
      sample :drum_tom_hi_hard, amp: rrand(0.3,0.6), beat_stretch: 0.8, finish: 0.01
      
    end
  end
end

define :drumloop11 do
  in_thread do
    64. times do
      sample :bd_ada, amp: rrand(0.3,0.6), beat_stretch: 0.8, finish: 0.05
      sleep 0.125
    end
  end
end

define :drumloop12 do
  in_thread do
    4. times do
      sample :loop_perc1, amp: rrand(0.1,0.35)
      sleep 2
    end
  end
end

define :drumloop13 do
  in_thread do
    4. times do
      sample :loop_mehackit1, amp: rrand(0.3,0.6), beat_stretch: 0.9
      sleep 2
    end
  end
end

define :drumloop14 do
  in_thread do
    4. times do
      sleep 0.25
      sample :glitch_perc1, amp: rrand(0.3,0.6)
      sleep 1.75
    end
  end
end

define :drumloop15 do
  in_thread do
    4. times do
      sleep 0.25
      sample :glitch_perc2, amp: rrand(0.13,0.3)
      sleep 1.75
    end
  end
end

define :drumloop16 do
  in_thread do
    4. times do
      sleep 0.5
      sample :glitch_perc3, amp: rrand(0.2,0.5)
      sleep 1.5
    end
  end
end

define :drumloop17 do
  in_thread do
    4. times do
      sleep 1
      sample :glitch_perc4, amp: rrand(0.3,0.6)
      sleep 1
    end
  end
end

define :drumloop18 do
  in_thread do
    4. times do
      sample :glitch_perc5, amp: rrand(0.1,0.4), beat_stretch: 2
      sleep 2
    end
  end
end

define :drumloop19 do
  in_thread do
    4. times do
      sleep 0.25
      sample :glitch_robot1, amp: rrand(0.3,0.6)
      sleep 1.75
    end
  end
end

define :drumloop20 do
  in_thread do
    4. times do
      sleep 0.5
      sample :glitch_robot2, amp: rrand(0.1,0.4)
      sleep 1.5
    end
  end
end

define :drumloop21 do
  in_thread do
    8. times do
      with_fx :level, amp: rrand(0,1) do
        8. times do
          sleep 0.125
          sample :bd_mehackit, amp: rrand(0.0,0.5)
        end
      end
    end
  end
end

define :drumloop22 do
  in_thread do
    4. times do
      sample :mehackit_phone2
      sample :bd_klub
      sleep 0.125
      
      sleep 0.125
      sample :bd_klub
      sleep 0.125
      
      sleep 0.125
      with_fx :reverb do
        sample :drum_snare_hard, amp: 0.5
      end
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :bd_klub
      sleep 0.125
      
      sleep 0.125
      sample :bd_klub
      sleep 0.125
      sample :drum_tom_lo_soft, amp: rrand(0.5,1), beat_stretch: 3, rate: 3
      sleep 0.125
      
      sleep 0.125
      with_fx :reverb do
        sample :drum_snare_hard, amp: 0.5
      end
      sleep 0.125
      sample :drum_tom_lo_soft, amp: rrand(0.5,1), beat_stretch: 3, rate: 3
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
    end
  end
end

define :drumloop23 do
  in_thread do
    4. times do
      sample :bd_808, amp: 3
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :bd_808, amp: 3
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      with_fx :reverb do
        sample :drum_snare_soft, amp: 0.5
      end
      sleep 0.125
      sample :bd_klub
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      with_fx :reverb do
        sample :drum_snare_soft, amp: 0.5
      end
      sleep 0.125
      
      sleep 0.125
      sample :bd_808, amp: 3
      sleep 0.125
      
      sleep 0.125
    end
  end
end

define :drumloop24 do
  in_thread do
    8. times do
      sample :bd_boom, amp: 0.5
      sleep 1
    end
  end
end

define :drumloop25 do
  in_thread do
    4. times do
      sample :bd_808, amp: 4
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :bd_808, amp: 4
      sleep 0.125
      
      sleep 0.125
      with_fx :reverb do
        sample :drum_snare_soft, amp: 0.5
      end
      sleep 0.125
      sample :bd_klub
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :bd_808, amp: 4
      sleep 0.125
      
      sleep 0.125
      sample :bd_808, amp: 4
      sleep 0.125
      
      sleep 0.125
    end
  end
end

define :drumloop26 do
  in_thread do
    8. times do
      with_fx :echo, mix: 0.1 do
        with_fx :reverb, mix: rrand(0.1,0.3) do
          sample :drum_bass_hard, beat_stretch: 0.3
        end
        sleep 0.5
        with_fx :reverb, mix: rrand(0.0,0.3) do
          sample :drum_snare_hard, beat_stretch: 0.3
        end
        sleep 0.5
      end
    end
  end
end

define :drumloop27 do
  in_thread do
    4. times do
      sample :drum_snare_hard, finish: 0.05
      sleep 0.125
      sample :drum_snare_hard, finish: 0.05
      sleep 0.125
      sample :drum_snare_hard, finish: 0.05
      sleep 0.125
      sample :drum_snare_hard, finish: 0.05
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      sample :drum_snare_hard, finish: 0.05
      sleep 0.125
      sample :drum_snare_hard, finish: 0.05
      sleep 0.125
      sample :drum_snare_hard, finish: 0.05
      sleep 0.125
      sample :drum_snare_hard, finish: 0.05
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
      
      sleep 0.125
    end
  end
end



live_loop :drum do
  n = rrand_i(0,26)
  case n
  when 26
    drumloop27
  when 25
    drumloop26
  when 24
    drumloop25
  when 23
    drumloop24
  when 22
    drumloop23
  when 21
    drumloop22
  when 20
    drumloop21
  when 19
    drumloop20
  when 18
    drumloop19
  when 17
    drumloop18
  when 16
    drumloop17
  when 15
    drumloop16
  when 14
    drumloop15
  when 13
    drumloop14
  when 12
    drumloop13
  when 11
    drumloop12
  when 10
    drumloop11
  when 9
    drumloop10
  when 8
    drumloop9
  when 7
    drumloop8
  when 6
    drumloop7
  when 5
    drumloop6
  when 4
    drumloop5
  when 3
    drumloop4
  when 2
    drumloop3
  when 1
    drumloop2
  when 0
    drumloop1
  end
  sleep 1
end

#strings

define :cbass do |p,d,r|
  wav = "C:/Users/Sincap/Documents/GitHub/space-event/SonicPI/Sinan/samples/contrabass/"
  t = p % 24
  sample wav, t, amp: 4.0, start: 0.1, finish: 0.8, sustain: d, release: r, attack: 0.05
end

define :cello do |p,d,r|
  wav = "C:/Users/Sincap/Documents/GitHub/space-event/SonicPI/Sinan/samples/cello/"
  t = p % 24
  sample wav, t, amp: 2.0, start: 0.01, finish: 0.5, sustain: d, release: r, attack: 0.1
end

define :viola do |p,d,r|
  wav = "C:/Users/Sincap/Documents/GitHub/space-event/SonicPI/Sinan/samples/viola/"
  t = p % 24
  sample wav, t, amp: 2.0, start: 0.1, finish: 0.4, sustain: d, release: r, attack: 0.1
end

define :violin do |p|
  wav = "C:/Users/Sincap/Documents/GitHub/space-event/SonicPI/Sinan/samples/violin/"
  t = p % 24
  sample wav, t, amp: 1.0, start: 0.1, finish: 0.5, sustain: 1.0, release: 0.2, attack: 0.1
end

counter1 = 0
counter2 = 0
bg = (ring 14,9,11,6,7,2,7,9)
voice1 = (ring 18,16,14,13,11,9,11,13,14,13,11,9,7,6,7,4)
voice2 = (ring 2,6,9,7,6,2,6,4,2,4,2,9,7,11,9,7,6,2,4,13,14,18,21,9,11,7,9,6,2,14,14,13)

live_loop :canon do
  cbass(bg[counter1],0.8,1.5)
  cello(voice1[counter1],0.8,1.5)
  sleep 0.5
  cello(bg[counter1],0.5,1)
  sleep 1.5
  counter1 += 1
end

live_loop :canon2 do
  viola(voice2[counter2],0.5,0.5)
  sleep 1
  counter2 += 1
end

