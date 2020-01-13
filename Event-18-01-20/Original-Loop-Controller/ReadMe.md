NOW UPDATED TO INCLUDE CONTROL OF THE BACKGROUND PULSE AND SCREEEN
BOTH PROGRAM AND TOUCHOSC TEMPLATE CHANGED

A SEPARATE VERSION TUNED FOR Pi3 IS ALSO INCLUDED
The original question was concerned with using mekey-makey as the "switch input" source.
Here I have used a TouchOSC template with 11 pushbuttons on it as the input source. To make it more interesting,
I also drive a large "LED" on the TouchOSC screen with OSC commands from the Sonic Pi program.
The program has been streamlined to use just ONE live loop to detect the switches being pushed,
and another to detect them being released. Sonic Pi supports wild cards in OSC addresses, and using the undocumented get_event
function I have parsed the received address and obtained the information as to which switch has been activated.
In the original development separate live Loops were used for each button.
Also, in the first versions I developed separate functions for dealing with each button, which led to some repetition in code.
In this version I have developed generic functions for each required use, into which the samples to be used, plus information about which button has been pressed, can be fed.

To produce the TouchOSC template, download the index.xml file and compress, or zip it. REname the resulting .zip file as
Loop.Control.touchosc  YOu can then load it into the TouchOSC editor and send it via WiFi to the tablet or phone with TouchOSC
on it.  TouchOSC is produced by https://hexler.net/

The Sonic PI file SPloopController.rb should be copied to a Sonic Pi buffer and run there. You should adjust the IP address in the program to suit your Tablet or Phone running TouchOSC, and set that to point to the IP address of the machine running Sonic Pi
USE THE SEPARATE VERSION FRO PI3. Differences: slightly less agressive timings in the functions and live loops
places less stress on the program. Most fx wrappers removed which stops distortion and crashing. It works quite well, although response time is slightly worse. YOu may get better performacne using a wired network connection, rather than wireless. I have also tried this on a new Pi3 B+ just released. This has much faster wifi access.