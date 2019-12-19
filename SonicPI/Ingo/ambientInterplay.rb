#ambientInterplay.rb
#by Robin Newman, November 2018
#best with good speakers, especially bass response.

use_random_seed 1984 #try different seeds


define :wow do |pe,pix|
  in_thread do
    dur=[2.5,4,8].choose
    use_synth [:growl,:hoover,:hoover,:hoover].choose
    with_fx :level,amp: 0.2 do |lv|
      control lv,amp: 1,amp_slide: dur
      with_fx :gverb,room: 20,mix: 0.7 do
        with_fx :echo, amp: 2,phase: pe, mix: 0.5 do
          with_fx :ixi_techno, phase: pix,cutoff_max: 100,mix: 0.7 do
            k=play rrand_i(48,60),release: 2*dur,pan: -1
            control k,pan: 1,pan_slide: dur
            sleep dur
            control lv,amp: 0.2,amp_slide: dur
            control k,pan: 1,pan_slide: dur
            sleep dur
          end
        end
      end
    end
  end
end

with_fx :level,amp: 0 do |ml|
  
  set :ml,ml #fade in and out at start and end
  at [0,100,120],[1,0.2,0] do |x|
    control get(:ml),amp: x,amp_slide: 20,slide_shape: 4
  end
  at [140] do
    # use stop-all-jobs sent to server OSC port to stop
    osc_send "localhost",4557,"/stop-all-jobs","rbnguid"
  end
  
  live_loop :go do
    wow rrand(0.4,1.2),rrand(1,4)
    sleep rrand_i(1,5)
  end
  
end