
#bubble-sort-1.rb
#https://in-thread.sonic-pi.net/u/robin.newman
#https://in-thread.sonic-pi.net/t/teaching-algorithms-by-creating-audio-representations-of-them-with-sonic-pi/2669/2
#
#Bubble Sort With Sonic Pi: triple audio sort adjusted by Robin Newman Aug 31 2019
#based on earthtoabigail's great article
# Link to tutorial: https://www.earthtoabigail.com/blog/bubble-sort-ruby-sonicpi
#VERSION 2 CORRECTS ERRORS IN PRINTED COUNTS
use_cue_logging false #added version 2
unsorted_arr = [81, 79, 69, 59, 55, 71, 83, 52, 64, 74, 76, 62, 57, 67, 86, 88]
use_bpm 90

def sorted arr, pan
  
  4.times do
    in_thread do
      arr.each { |n|
        play n,pan: pan, release: 0.1
        sleep 0.25
      }
    end
    in_thread do # Keeps track of the One
      sample :bd_tek, pan: pan
      sleep 16
    end
    # Gives a nice and steady rythm that marks we have successfully sorted the list
    sample :loop_breakbeat, beat_stretch: 4, amp: 2,pan: pan
    sleep 4
  end
end

def bubble_sort array,pan
  case pan
  when 0
    shift=-12;rate=0.5 #adjust base note and sample rate for :elec_blip2 (45bpm)
  when 1
    shift=0;rate=1 #adjust base note and sample rate for :elec_blip2 (90bpm)
  when -1
    shift=12;rate=2 #adjust base note and sample rate for :elec_blip2 (180 bpm)
  end
  arr = array.dup
  swapped = false
  r = arr.length - 2
  
  # DATA - Tracking variables
  array_states = []
  total_swaps = 0
  swaps_per_iter = []
  num_iters = 0
  time_of_exec = 0
  
  arr.each { |n| play n,pan: pan; sleep 0.25 }
  
  start_time = Time.now # Start calculating time of execution
  
  while true do
      swaps = 0
      num_iters += 1 # Keep track on the number of iterations we did so far
      
      in_thread do
        use_synth :dsaw # Gives a base frequency (take lowest value of array)
        #adjust base note with shift
        play 52+shift, amp: 0.5, attack: 2, sustain: 6, decay: 2, release: 4, cutoff: 60,pan: pan
        sample :bd_tek,pan: pan # Tracking when we are entering the loop
      end
      
      in_thread do # Gives a sense of how many iterations we've done so far
        num_iters.times do |i|
          sample :drum_cymbal_closed, amp: 1.0 + (i.to_f / 2.0), rate: 2,pan: pan
          sleep (2.0 / num_iters).round(2)
        end
      end
      
      for i in 0..r # inclusive range
        play arr[i], release: 0.1,pan: pan
        sleep 0.25
        if arr[i] > arr[i+1]
          arr[i], arr[i+1] = arr[i+1], arr[i]
          swapped = true if !swapped
          sample :elec_blip2, amp: 1.5,pan: pan,rate: rate
          sleep 0.25
          play arr[i],pan: pan # hear the value which the current value is being compared to
          sleep 0.25
          swaps += 1
        end
      end
      total_swaps += swaps
      swaps_per_iter.push(swaps) # remember how many swaps occured in this iteration
      
      swapped ? swapped = false : break
      
      array_states.push(arr.dup) # save a copy of the current state of the array
    end
    
    time_of_exec = Time.now - start_time
    
    # Calling sorted function with sorted array
    sorted arr,pan
    # return the sorted array and all the tracking data
    [arr, total_swaps, swaps_per_iter, num_iters, time_of_exec, array_states]
  end
  
  
  set :n1,0;set :n2,0; set :n3,0 #initialise counters added version 2
  
  with_fx :reverb, room: 1 do
    puts "Triple stream bubble sort with Sonic Pi"
    puts "(use a good stereo system for best results)"
    puts "Sorting at 90bpm on Full Right Pan"
    puts "Sorting at 180bpm on Full Left Pan"
    puts "Sorting at 45pbm at Center Pan 0"
    puts
    live_loop :sort do
      in_thread do
        with_bpm 45 do
          data=bubble_sort unsorted_arr,0
          set :n1,get(:n1)+1 #added version2
          #puts statement changed version 2
          puts "Centre pan (45 bpm) completed #{get(:n1)}. Sort time #{((data[4]*100).round.to_i/100.0).to_f}"
          puts "Sorted Array: #{data[0]}"
        end
      end
      
      in_thread do
        2.times do
          data=bubble_sort unsorted_arr,1
          set :n2,get(:n2)+1  #added version2
          #puts statement changed version 2
          puts "Right pan (90bpm) completed #{get(:n2)}. Sort time #{((data[4]*100).round.to_i/100.0).to_f}"
        end
      end
      
      with_bpm 180 do
        4.times do
          data=bubble_sort unsorted_arr,-1
          set :n3,get(:n3)+1  #added version2
          #puts statement changed version 2
          puts "Left pan (180bpm) completed #{get(:n3)}.  Sort time #{((data[4]*100).round.to_i/100.0).to_f}"
        end
      end
    end
  end
  