# vvvvLoopController-pattern.rb

# Global settings
use_real_time
use_osc "127.0.0.1",9000 #adjust for output IP to which to send LED on/off signals (TouchOSC)
oscmessage="/osc/kinect/*"
use_bpm 128

use_debug false
use_osc_logging false

# Initialize Time System Variables
set :chr1,0
set :chr2,0
set :chr3,0
set :chr4,0
set :chl1,0
set :chl2,0
set :chl3,0
set :chl4,0
set :cdb1,0
set :cdl1,0
set :cmelody,0

###################################################
# Helpers
###################################################
define :pclear do |s|
  s.gsub(/\s+/, "") #replace space with nothing
end

# Global variables
use_synth :tri

bg1 = (ring 0.0,0.1,0.2,0.3,0.4,0.5,0.0,0.0).mirror
bg2 = (ring 0.5,0.4,0.3,0.2,0.1,0.0,0.0,0.0).mirror

melody_1 = [:c4,:r,:ds4,:ds4,:g4,:c4,:r,:gs4,:r,:r,:gs3,:r,:g3,:r,:r,:r].ring
stevereichphase = (ring :E4, :Fs4, :B4, :Cs5, :D5, :Fs4,
                   :E4, :Cs5, :B4, :Fs4, :D5, :Cs5)

base_dir = "C:/Users/noldeni/Music/SonicPi/aimxhaisse/dune"
notes = [:E2,  :E2,  :E2,  :E2,  :E2,  :E2,  :E2,  :E2,  :E2,  :E2,  :E2,  :E2,  :E2,  :E2,  :F2,  :G2].ring
empty = ".... .... .... .... .... .... .... .... .... .... .... .... .... .... .... ...."
patterntemplate = [
  pclear("k... ...."),
  pclear(".... .... s... ...."),
  pclear("h... .... .... .... .... .... .... ...."),
  pclear(".... .... x... ...."),
  pclear("y... .... .... ...."),
  pclear("f... .... .... .... .... .... .... .... .... .... .... .... .... .... .... ...." + empty),
  pclear("t... .... .... .... .... .... .... .... .... .... .... .... .... .... .... ...." + empty),
  pclear("b... ...."),
]
set :patterns,(ring "","","","","","","","")

###################################################
# Loops
###################################################

define :lone do |action|
  if action==1
    set :k1,false
    live_loop :dark_bass, sync: :main do
      c = 0
      with_fx :wobble, phase: 1, res: 0, smooth_down: 0.2, smooth_down: 0.2 do
        notes.each do |n|
          use_synth :fm
          use_synth_defaults env_curve: 7
          with_fx :krush, mix: 0.5, cutoff: n + 36 + c do
            sleep 0.5
            play n + 12, release: 0.60, amp: 0.4
            sleep 0.5
          end
        end
      end
      stop if get(:k1)
    end
  else
    set :k1,true
  end
end
define :ltwo do |action|
  if action==1
    set :k2,false
    live_loop :dark_lead, sync: :main do
      c = 0
      with_fx :wobble, phase: 1, wave: 1, cutoff_min: :E2 + c, cutoff_max: :E6 do
        with_fx :bitcrusher do
          s1 = synth :fm, sustain: notes.length, release: 0
          s2 = synth :tech_saws, sustain: notes.length, release: 0
          notes.each do |n|
            n = n + 12
            control s1, note: n, cutoff: n + c, amp: 0.5
            control s2, note: n + 12, cutoff: n + c, amp: 0
            sleep 1
          end
        end
      end
      stop if get(:k2)
    end
  else
    set :k2,true
  end
end

define :lthree do |action|
  if action==1
    set :k3,false
    live_loop :melody, sync: :main do
      with_fx :panslicer, phase: 0.5, mix: 0.125 do
        with_fx :wobble, invert_wave: 1, phase: 1, cutoff_min: 60, cutoff_max: 80 do
          with_fx :lpf, cutoff: 40, cutoff_slide: 16 do |s|
            control s, cutoff: 80
            with_fx :flanger do
              [
                [[:E3, 0.5], [:E3, 0.25], [:E3, 0.75], [:E3, 1], [:E3, 0.5], [:G3, 0.25], [:E3, 1]],
                [[:E3, 0.5], [:E3, 0.25], [:E3, 0.75], [:E3, 1], [:E3, 0.5], [:G3, 0.25], [:E3, 1]],
                [[:E3, 0.5], [:E3, 0.25], [:E3, 0.75], [:E3, 1], [:E3, 0.5], [:G3, 0.25], [:E3, 1]],
                [[:E3, 0.5], [:E3, 0.25], [:G3, 0.75], [:E3, 1], [:Gs3, 0.5], [:G3, 0.25], [:G3, 1]],
              ].each do |mel|
                total = 0
                mel.each do |n, r|
                  synth :tech_saws, note: n + 12, res: 0, release: r, amp: 1.5
                  synth :dpulse, note: n + 12, res: 0, release: r, amp: 1.20
                  synth :pluck, note: n + 12, res: 0, release: r, amp: 1.50
                  
                  sleep r
                  total = total + r
                end
                sleep 4 - total
              end
            end
          end
        end
      end
      stop if get(:k3)
    end
  else
    set :k3,true
  end
end


###################################################
# End of Loops
###################################################


###################################################
# Process OSC Input
###################################################
#input on and off live_loops to detect inputs
define:parse_sync_address do |address|
  v= get_event(address).to_s.split(",")[6]#[address.length+1..-2].to_i
  if v != nil
    return v[3..-2].split("/")
  else
    return ["error"]
  end
end

live_loop :pon do
  b = sync "/osc/kinect/*"
  if b[0]==1
    r=parse_sync_address "/osc/kinect/*"
    ns= r[2]
    puts "vorher channel "+ns, get[("c"+ns).to_sym]
    if get[("c"+ns).to_sym] == 1
      set ("c"+ns).to_sym,0
    else
      set ("c"+ns).to_sym,1
    end
    puts "nachher channel "+ns, get[("c"+ns).to_sym]
    doCommandSelect(ns, get[("c"+ns).to_sym])
  end
end
live_loop :poff do
  b = sync "/osc/kinect/*"
  if b[0]==0
    r=parse_sync_address "/osc/kinect/*"
    ns= r[2]
    #set ("c"+ns).to_sym,0
    #doCommandSelect(ns, 0)
  end
end

define :doCommandSelect do |n, v|
  puts n
  case n
  when "hr1"
    if v == 1
      old_p = get[:patterns]
      new_p = old_p.put(0, patterntemplate[0])
    else
      old_p = get[:patterns]
      new_p = old_p.put(0, "")
    end
    set :patterns,new_p
  when "hr2"
    if v == 1
      old_p = get[:patterns]
      new_p = old_p.put(1, patterntemplate[1])
    else
      old_p = get[:patterns]
      new_p = old_p.put(1, "")
    end
    set :patterns,new_p
  when "hr3"
    if v == 1
      old_p = get[:patterns]
      new_p = old_p.put(2, patterntemplate[2])
    else
      old_p = get[:patterns]
      new_p = old_p.put(2, "")
    end
    set :patterns,new_p
  when "hr4"
    if v == 1
      old_p = get[:patterns]
      new_p = old_p.put(3, patterntemplate[3])
    else
      old_p = get[:patterns]
      new_p = old_p.put(3, "")
    end
    set :patterns,new_p
  when "hl1"
    if v == 1
      old_p = get[:patterns]
      new_p = old_p.put(4, patterntemplate[4])
    else
      old_p = get[:patterns]
      new_p = old_p.put(4, "")
    end
    set :patterns,new_p
  when "hl2"
    if v == 1
      old_p = get[:patterns]
      new_p = old_p.put(5, patterntemplate[5])
    else
      old_p = get[:patterns]
      new_p = old_p.put(5, "")
    end
    set :patterns,new_p
  when "hl3"
    if v == 1
      old_p = get[:patterns]
      new_p = old_p.put(6, patterntemplate[6])
    else
      old_p = get[:patterns]
      new_p = old_p.put(6, "")
    end
    set :patterns,new_p
  when "hl4"
    if v == 1
      old_p = get[:patterns]
      new_p = old_p.put(7, patterntemplate[7])
    else
      old_p = get[:patterns]
      new_p = old_p.put(7, "")
    end
    set :patterns,new_p
  when "db1"
    lone v
  when "dl1"
    ltwo v
  when "melody"
    lthree v
  else
    puts "nothing"
  end
end

###################################################
# End of Process OSC Input
###################################################

###################################################
# Master Loop and Background
###################################################

define :mplay do |c|
  if c == 'k'
    sample base_dir, /^kick/
  end
  if c == 'b'
    sample base_dir, /^big-kick/, amp: 0.75
  end
  if c == 's'
    sample base_dir, /^snare/, amp: 0.75, rate: 1
  end
  if c == 'h'
    sample base_dir, /^hat/, amp: 1, beat_stretch: 8, rate: 1
  end
  if c == 'x'
    sample base_dir, /^perc/, amp: 0.8, rate: 0.77
  end
  if c == 'f'
    sample base_dir, /fx/, amp: 1
  end
  if c == 't'
    sample base_dir, /^long-perc/, amp: 1, rate: rrand(0.75, 0.9)
  end
  if c == 'y'
    #sample base_dir, /^il-macquillage-lady/, amp: 0.75
    #sample base_dir, /^funk.wav/, amp: 0.75
    #sample base_dir, /^mad/, amp: 0.75
    #sample "C:/Users/noldeni/Music/SonicPi/aimxhaisse/dune/mad.wav", amp: 0.75, beat_stretch: 8
    sample :ambi_dark_woosh, amp: 0.75
  end
end

live_loop :main do
  128.times do |i|
    pat = get[:patterns]
    pat.each do |s|
      mplay s.ring[i]
    end
    
    sleep 0.125
  end
end

###################################################
# End of Master Loop and Background
###################################################
