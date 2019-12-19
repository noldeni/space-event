
#bubble-sort-2.rb
#https://in-thread.sonic-pi.net/u/robin.newman
#https://in-thread.sonic-pi.net/t/teaching-algorithms-by-creating-audio-representations-of-them-with-sonic-pi/2669/2
#
#merge sort medley by Robin Newman
use_synth :dsaw
use_random_seed 20190926
use_bpm 90
define :mergesort do |array|
  define :mg do |left_sorted, right_sorted|
    res = []
    l = 0
    r = 0
    loop do
      break if r >= right_sorted.length and l >= left_sorted.length
      
      if r >= right_sorted.length or (l < left_sorted.length and left_sorted[l] < right_sorted[r])
        res << left_sorted[l]
        l += 1
        synth :pluck,note: left_sorted[l-1],amp: 2,pan: -1
      else
        res << right_sorted[r]
        r += 1
        synth :pluck,note: right_sorted[r-1],amp: 2,pan: 1
      end
      res.each do |n|
        play n,release: 0.2
        sleep 0.2
      end
    end
    return res
  end
  
  define :ms_iter do |array_sliced|
    return array_sliced if array_sliced.length <= 1
    
    mid = array_sliced.length/2 - 1
    left_sorted = ms_iter(array_sliced[0..mid])
    right_sorted = ms_iter(array_sliced[mid+1..-1])
    sample :perc_snap,amp: 3
    return mg(left_sorted, right_sorted)
  end
  ms_iter(array)
end


a=scale(:c2,:minor_pentatonic,num_octaves:3)
c= a.shuffle
puts "original unsorted c #{c.to_a}"
d=c.reverse
sleep 1
with_fx :reverb,room: 0.8 do
  in_thread do
    puts "Sorted 1c: #{mergesort(c)}"
  end
  in_thread do
    use_bpm 180
    2.times do
      puts  "Sorted 2c: #{mergesort(c)}"
    end
  end
  use_synth :pulse
  use_transpose 12
  in_thread do
    puts  "Sorted 3d: #{mergesort(d)}"
  end
  use_bpm 180
  2.times do
    puts  "Sorted 4d: #{mergesort(c)}"
  end
end
