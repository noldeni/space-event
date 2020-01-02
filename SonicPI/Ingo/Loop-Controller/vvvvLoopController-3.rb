# vvvvLoopController-3.rb
use_real_time
use_osc "127.0.0.1",9000 #adjust for output IP to which to send LED on/off signals (TouchOSC)
oscmessage="/osc/kinect/*"
use_bpm 120

use_debug false
use_osc_logging false
#input on and off live_loops to detect inputs

set :chr1,1
set :chr2,1

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
    set ("c"+ns).to_sym,1
    doCommandSelect(ns,1)
  end
end
live_loop :poff do
  b = sync "/osc/kinect/*"
  if b[0]==0
    r=parse_sync_address "/osc/kinect/*"
    ns= r[2]
    set ("c"+ns).to_sym,0
    doCommandSelect(ns,0)
  end
end

define :doCommandSelect do |n, v|
  puts n
  case n
  when "hr1"
    set :chr1,v
    puts n
  when "hr2"
    set :chr2,v
    puts n
  when "hr3"
    puts n
  when "hr4"
    puts n
  when "hl1"
    puts n
  when "hl2"
    puts n
  when "hl3"
    puts n
  when "hl4"
    puts n
  else
    puts "nothing"
  end
end

# Marks the beats
live_loop :beat do
  sample :elec_blip2, rate: 1, amp: 0.5
  sleep 1 # counts every beat
end

# Marks 4 bars
live_loop :four_bars, sync: :beat do
  sample :elec_blip2, rate: 1.5, amp: 0.5
  sleep 16 # counts 4 bars
end

# Bass Line "Radio Musicola", Nik Kershaw
bassline = (ring :b2,:b3,:e2,:e2,:r,:r,:e3,:g2,
            :r,:e2,:g3,:e2,:r,:g3,:e2,:g2,
            :r,:e3,:e2,:g3,:e2,:r,:g2,:r,
            :e2,:g3,:e2,:g2,:r,:d2,:e2,:g2,
            :a2,:r,:e2,:a2,:r,:e3,:a3,:a2,
            :gs2,:r,:r,:e2,:gs2,:gs3,:e2,:gs3,
            :r,:e2,:e3,:gs3,:e2,:r,:gs3,:e2,
            :gs2,:r,:e3,:gs2,:r,:e2,:a2,:as2)

# bassline
live_loop :bass_line, sync: :four_bars do
  stop if get(:chr1) == 0 # comment to start loop; should be in sync with :pad
  use_synth :fm
  use_synth_defaults amp: 1.0, attack: 0.0, attack_level: 1.5, sustain: 0.15, release: 0.05, cutoff: 70
  play_pattern_timed bassline, 0.25
end

# chords
live_loop :pad, sync: :four_bars do
  stop  if get(:chr2) == 0 # comment to start loop; should be in sync with :bass
  use_synth :fm
  use_synth_defaults amp: 0.25, attack: 0.1, sustain: 0.5, release: 3
  with_fx :echo, phase: 1.0, decay: 2 do
    with_fx :reverb, room: 0.75, mix: 0.75 do
      with_fx :flanger do
        with_transpose 12 do
          play [:b3, :b4, :d4, :fs4, :a4, :fs5]
          sleep 1.5
          play [:d3, :g4, :a4, :d4, :g5], release: 6
          sleep 6.5
          play [:a3, :e4, :a4, :b4, :e5]
          sleep 1.5
          play [:gs3, :gs4, :e4, :b4, :e5], release: 6
          sleep 6.5
        end
      end
    end
  end
end
