# control-example-4.rb
# https://in-thread.sonic-pi.net/u/Martin
# https://in-thread.sonic-pi.net/t/control-a-running-synth-ambient-soundscape/2331/4

set :toggle1, 0.25
set :fx1, 3
set :fx2, 0.1
set :fx3, 3
set :amp1, 0

live_loop :change do
  change = (line 0.1, 2, inclusive: true, steps: 15).repeat(5)
  set :fx2, change.look
  # puts change.look
  tick
  sleep 1
end



live_loop :loop1 do
  if (get(:amp1) > 0) then
    with_fx :echo, reps: 32 do |f|
      control f, mix: get(:toggle1) * get(:fx1), decay: 1 + (1 * get(:fx2)), phase: get(:fx3)
      # Or try this one...
      sample  [:bass_trance_c,:elec_blup, :elec_blip,:elec_blip2,:drum_heavy_kick].choose,
        #sample [:bass_trance_c,:elec_blup, :elec_blip,:elec_blip2,:ambi_piano].choose,
        
      amp: get(:amp1),rate: rrand(0.4,0.6),pan: rrand(-1,1)
      sleep 0.25
      
    end
    
  else
    sleep 1
  end
end