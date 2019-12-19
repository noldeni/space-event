
#bubble-sort-3.rb
#https://in-thread.sonic-pi.net/u/EarthToAbigail
#https://in-thread.sonic-pi.net/t/teaching-algorithms-by-creating-audio-representations-of-them-with-sonic-pi/2669/2
#
use_bpm 70
unsorted_arr = [79, 76, 67, 59, 55, 71, 52, 64, 74, 83, 62, 86]

def play_list arr, vol, p = 0
  if arr.length < 1
    sample :ambi_swoosh, pan: p, amp: 2.5
  else
    arr.each do |n|
      play n, pan: p, amp: vol, release: 0.05, sustain: 0.1, decay: 0.05
      sleep 0.25
    end
  end
end

# Non-recursive merge function
def merge left, right
  
  sample :perc_bell2, amp: 1
  
  use_synth :beep
  in_thread do
    play_list left, 0.8, -1
  end
  play_list right, 0.8, 1
  
  sorted = []
  while !left.empty? && !right.empty?
    if left.first < right.first
      sorted.push(left.shift)
    else
      sorted.push(right.shift)
    end
    
    in_thread do
      play_list left, 0.5, -1
    end
    
    play_list right, 0.5, 1
  end
  
  play_list left, 1, -1
  play_list right, 1, 1
  play_list sorted.concat(right).concat(left), 1
  sorted
end

# Main function
def merge_sort arr, side = nil
  
  sample :glitch_perc1, amp: 1
  
  use_synth :square
  
  p = (side == "left") ? -1 : (side == "right") ?  1 : 0
  play_list arr, 1, p
  
  if arr.length <= 1
    sample :elec_chime, amp: 1.5
    sleep 0.5
    return arr
  end
  
  mid = arr.length / 2
  left = merge_sort arr.slice(0...mid), "left"
  right = merge_sort arr.slice(mid..arr.length), "right"
  
  merge left, right
end


with_fx :reverb, room: 0.9 do
  live_loop :merge_sort do
    merge_sort unsorted_arr.dup
  end
  
  live_loop :beat do
    in_thread do
      sample :bd_zome, amp: 2
      sleep 0.5
      3.times do
        sample :drum_cymbal_closed, amp: 0.6
        sleep 0.5
      end
    end
    use_synth :dsaw
    play :e2, cutoff: 50, amp: 0.9, sustain: 1, release: 0.5, decay: 0.5, attack: 0.25
    sleep 2
  end
end