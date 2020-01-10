# arp


define :arp do |p|
  
  4.times do
    synth :chiplead, note: choose(scale(:c4, :minor_pentatonic).reverse) , amp: 1, release: 0.04, sustain: 0.01, decay: 0.03, pitch: p
    synth :chipnoise, note: notes.tick, release: 0.01, sustain: 0.01, decay: 0.01, freq_band: 0.3, amp: 0.5
    sleep 0.03
  end
end


arp 14
