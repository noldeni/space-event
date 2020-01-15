# artiphone-guitar_key_remap.rb
# https://in-thread.sonic-pi.net/u/goldengrape
# https://in-thread.sonic-pi.net/t/code-for-artiphone-instrument1/2922

artiphon_address= "/midi/instrument1/*/*/"
artiphon_synth= :dsaw

all_guitar_string=(ring 40,45,50,55,59,64)
chord_C=(ring 45+3,50+2,55,59+1,64)
chord_D=(ring 50,55+2,59+3,64+2)
chord_E=(ring 40,45+2,50+2,55+1,59,64)
chord_F=(ring 50+3,55+2,59+1,64+1)
chord_G=(ring 43,47,50,55,59,67)
chord_A=(ring 45,50+2,55+2,59+2,64)
chord_B=(ring 50+4,55+4,59+4,64+2)

chord_Cm=(ring 45+3,50+1,55)
chord_Dm=(ring 50,55+2,59+3,64+1)
chord_Em=(ring 40,47,52,55,59,64)
chord_Fm=(ring 50+3,55+1,59+1,64+1)
chord_Gm=(ring 50,55+3,59+3,64+3)
chord_Am=(ring 45,52,57,60,64)
chord_Bm=(ring 50+4,55+4,59+3,64+2)

remap_chord={28 => all_guitar_string,\
             29 => chord_C,\
             30 => chord_D,\
             31 => chord_E,\
             32 => chord_F,\
             33 => chord_G,\
             34 => chord_A,\
             35 => chord_B,\
             
             20 => chord_Cm,\
             21 => chord_Dm,\
             22 => chord_Em,\
             23 => chord_Fm,\
             24 => chord_Gm,\
             25 => chord_Am,\
             26 => chord_Bm,\
             }

remap_sample={16 =>  :guit_harmonics,\
              17 => :guit_e_fifths,\
              18 => :guit_e_slide,\
              19 => :guit_em9,\
              15 => :loop_industrial,\
              14=> :loop_compus,\
              13=> :loop_amen,\
              12=> :loop_amen_full,\
              11=> :loop_garzul,\
              10=> :loop_mika,\
              9=> :loop_breakbeat,\
              8=> :loop_safari,\
              7=> :loop_tabla,\
              6=> :loop_3d_printer,\
              5=> :loop_drone_g_97,\
              4=> :loop_electric,\
              3=> :loop_mehackit1,\
              2=> :loop_mehackit2,\
              1=> :loop_perc1,\
              0=> :loop_perc2,\
              }


define :artiphon_normal do |synth_name, event_address|
  use_real_time
  note, velocity = sync event_address+"note_on"
  if note>39
    # synth the audio
    synth synth_name, \
      note: note, \
      release: 1.5,\
      amp: velocity/127.0
  end
end

define :artiphon_chord do |synth_name, event_address|
  use_real_time
  note, velocity = sync event_address+"note_on"
  if remap_chord.keys.include?(note)
    note=remap_chord[note]
    synth synth_name, \
      note: note, \
      release: 1.5,\
      amp: velocity*2/127.0
  end
end

define :artiphon_sample do |synth_name, event_address|
  use_real_time
  note, velocity = sync event_address+"note_on"
  if remap_sample.keys.include?(note)
    sample remap_sample[note]
  end
end


with_fx :reverb do
  live_loop :normal_play do
    artiphon_normal artiphon_synth,artiphon_address
  end
end

with_fx :reverb do
  live_loop :chord_play do
    artiphon_chord artiphon_synth,artiphon_address
  end
end

live_loop :sample_play do
  artiphon_sample artiphon_synth,artiphon_address
end
