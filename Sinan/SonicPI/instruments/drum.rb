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
          sample :drum_bass_hard
        end
        sleep 0.5
        with_fx :reverb, mix: rrand(0.0,0.3) do
          sample :drum_snare_hard
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
  sleep 2
end
