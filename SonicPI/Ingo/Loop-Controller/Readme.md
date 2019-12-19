OSC send: /osc/1/push1 [1.0]

  b = sync "/osc/1/push*"
  puts b -> [1.0]
  
  u= get_event(address) -> #<SonicPi::CueEvent:[[1576244484.49172, 0, #<SonicPi::ThreadId [-1]>, 0, 0.0, 60.0], "/osc/1/push1", [1.0]]
    [0] #<SonicPi::CueEvent:[[1576244484.49172
	[1] 0
	[2] #<SonicPi::ThreadId [-1]>
	[3] 0
	[4] 0.0
	[5] 60.0]
	[6] "/osc/1/push1"
	[7] [1.0]]
  v= u.to_s.split(",")[6] -> " \"/osc/1/push1\""
  v[3..-2] -> "osc/1/push1"
  v[3..-2].split("/") -> ["osc", "1", "push1"]

  r=parse_sync_address "/osc/1/push*" -> ["osc", "1", "push1"]
  r[2] -> push1 
  r[2][4..-1] -> 1
  
OSC send: /osc/1/push1 [1.0]
  live_loop :pon do
    set ("c1").to_sym,1
	doCommandSelect("1".to_i)
  live_loop :poff do
    set ("c1").to_sym,0
