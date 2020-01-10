# Welcome to Sonic Pi v3.1
"/osc/kinect/hr/1"


define :foo do
  play 62
end


b = sync "/osc/kinect/hr/2"
loop do
  if b[0]==1
    play 62
  end
  sleep 0.1
end