# artiphone-guitar_advanced.rb
# https://in-thread.sonic-pi.net/u/robin.newman
# https://in-thread.sonic-pi.net/t/code-for-artiphone-instrument1/2922/3
#
#modified code for Artipohone instrument
#allows for repeating sample loops
#and has option for note_on/note_off control of single notes
#by Robin Newman, Nvoember 2019
use_debug false
use_midi_logging false
use_bpm 120
artiphon_address= "/midi/*/*/*/"
artiphon_synth= :pluck

all_guitar_string=(ring 40,45,50,55,59,64)
chord_C=(ring 45+3,50+2,55,59+1,64)
chord_D=(ring 50,55+2,59+3,64+2)
chord_E=(ring 40,45+2,50+2,55+1,59,64)
chord_F=(ring 50+3,55+2,59+1,64+1)
chord_G=(ring 43,47,50,55,59,67)
chord_A=(ring 45,50+2,55+2,59+2,64)
chord_B=(ring 50+4,55+4,59+4,64+2)

chord_Cm=(ring 45+3,50+1,55)
chord_Dm=(ring 50,55+2,59+3,64+1)
chord_Em=(ring 40,47,52,55,59,64)
chord_Fm=(ring 50+3,55+1,59+1,64+1)
chord_Gm=(ring 50,55+3,59+3,64+3)
chord_Am=(ring 45,52,57,60,64)
chord_Bm=(ring 50+4,55+4,59+3,64+2)

remap_chord={28 => all_guitar_string,\
             29 => chord_C,\
             30 => chord_D,\
             31 => chord_E,\
             32 => chord_F,\
             33 => chord_G,\
             34 => chord_A,\
             35 => chord_B,\
             
             20 => chord_Cm,\
             21 => chord_Dm,\
             22 => chord_Em,\
             23 => chord_Fm,\
             24 => chord_Gm,\
             25 => chord_Am,\
             26 => chord_Bm,\
             }

remap_sample={16 => :guit_harmonics,\
              17 => :guit_e_fifths,\
              18 => :guit_e_slide,\
              19 => :guit_em9,\
              15 => :loop_industrial,\
              14=> :loop_compus,\
              13=> :loop_amen,\
              12=> :loop_amen_full,\
              11=> :loop_garzul,\
              10=> :loop_mika,\
              9=> :loop_breakbeat,\
              8=> :loop_safari,\
              7=> :loop_tabla,\
              6=> :loop_3d_printer,\
              5=> :loop_drone_g_97,\
              4=> :loop_electric,\
              3=> :loop_mehackit1,\
              2=> :loop_mehackit2,\
              1=> :loop_perc1,\
              0=> :loop_perc2,\
              }

with_fx :reverb do
  ######## CHORD PLAY #################
  live_loop :artiphon_chord do
    use_real_time
    note, velocity = sync artiphon_address+"note_on"
    if remap_chord.keys.include?(note)
      note=remap_chord[note]
      puts "note is",note
      synth artiphon_synth, \
        note: note, \
        release: 1.5,\
        amp: velocity*2/127.0
    end
  end
end #reverb

########## LOOPED SAMPLES #############

#three lists with data to control looping samples
#sFin  is fraction of sample to play from start
sFin=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,        1,0.6667,1,0.6]
#bStretch is beat_stretch value to apply
bStretch=[4,4,4,4,4,8,16,20,16,4,16,16,12,4,12,2,   8,12,8,20]
#sVol is applitude of sample
sVol=[0.8,0.8,0.8,0.8,1,0.8,0.8,1,0.8,0.8,0.8,0.8,0.6,1,0.8,0.8,1,0.8,0.8,0.8]
#uncomment to print sample data for checking
##| 20.times do |n|
##|   puts n, bst[n]*bs[n]
##|   puts n, (sample_duration remap_sample[n]),remap_sample[n],vols[n]
##| end
##| stop


#initilise control flag for the running sample loop
define :setC do |c|
  #set all controls to off
  20.times do |n|
    set ("c"+n.to_s).to_sym,0
  end
  set ("c"+c.to_s).to_sym,1 if c>=0 #set selected sample control to on
end

define :startSampleLoop do |n|
  puts "remap",remap_sample[n]
  doLoop n,sVol[n],remap_sample[n],bStretch[n],sFin[n]
end

live_loop :artiphon_sample do
  use_real_time
  b = sync "/midi/*/*/*/note_on"
  n=b[0]
  puts n
  if n<20
    setC n.to_i #set new sampleLoop flag,: stops existing one
    puts remap_sample[n]
    startSampleLoop n
  end
end

#this next loop added to allow all looping samples to be stopped.
#it sets all of the stopFlags to 0 in the setC function.
live_loop :killSamples do #any midi_cc 12 value kills sample loops
  use_real_time
  b = sync "/midi/*/*/*/control_change"
  setC -1 if b[0]==12
end

######### CODE FOR STOPPABLE LIVE LOOPS ###############
#general function to set up stoppable live_loop
define :doLoop do |n,vol,sampleName,bs,sFin|
  set ("kill"+n.to_s).to_sym,false #intialise kill flag
  ln=("name"+n.to_s).to_sym #generate name for live_loop
  in_thread do #Thread monitors when to stop live_loop
    loop do
      if get( ("c"+n.to_s).to_sym)==0
        s= get( ("s"+n.to_s).to_sym)
        kill s
        set ("kill"+n.to_s).to_sym, true
        stop
      end
      sleep 0.2
    end
  end
  #start live_loop for selected sample
  #sync start to metro timing loop
  live_loop  ln, sync: :metro do
    s=sample sampleName,beat_stretch: bs,\
      amp: vol,finish: sFin
    set ("s"+n.to_s).to_sym,s #store pointer to sample
    k=(bs/0.25).to_i
    #test stop flag whilst sample runs
    k.times do
      sleep (bs*sFin).to_f/k
      stop if get( ("kill"++n.to_s).to_sym)
    end
  end
end

live_loop :metro do #metronome to sync stuff together
  sleep 1
end

###REMOVE ALL CODE FROM HERE ONWARDS FOR ALTERNATIVE VERSION ####
with_fx :reverb do
  ########## NORMAL NOTES #################
  live_loop :artiphon_normal do
    use_real_time
    note, velocity = sync artiphon_address+"note_on"
    if note>39
      #synth the audio
      synth artiphon_synth, \
        note: note, \
        release: 1.5,\
        amp: velocity/127.0
    end
  end
  
end #reverb

#### ALTERNATIVE CODE FOR NORMAL NOTES USING NOTE_ON NOTE_OFF ###
#polyphonic midi input program with sustained notes
#experimental program by Robin Newman, November 2017

plist=[] #list to contains references to notes to be killed
ns=[] #array to store note playing references
nv=[0]*128 #array to store state of note for a particlar pitch 1=on, 0 = 0ff

128.times do |i|
  ns[i]=("n"+i.to_s).to_sym #set up array of symbols :n0 ...:n127
end
#puts ns #for testing

define :sv do |sym| #extract numeric value associated with symbol eg :n64 => 64
  return sym.to_s[1..-1].to_i
end
#puts sv(ns[64]) #for testing

define :geton do |address|
  v= get_event(address).to_s.split(",")[6]#[address.length+1..-2].to_i
  return v.include?"note_on"
end
define :parse_sync_address do |address|
  v= get_event(address).to_s.split(",")[6]#[address.length+1..-2].to_i
  if v != nil
    return v[3..-2].split("/")
  else
    return ["error"]
  end
end

live_loop :midi_piano_on do #this loop starts 5 second notes for spcified pitches and stores reference
  use_real_time
  note, vol = sync "/midi/*/*/*/note_*"
  res= parse_sync_address "/midi/*/*/*/*"
  puts res[4]
  #note = note+12*get(:octave)
  if note>39
    #select ONE of the next two lines
    #if res[4]=="note_on" #select for separate note_on/ note_off
    if vol>0#select to use note_on with vel=0 for end of note
      puts note,nv[note]
      if nv[note]==0 #check if new start for the note
        nv[note]=1 #mark note as started for this pitch
        use_synth artiphon_synth
        #max duration of note set to 5 on next line. Can increase if you wish.
        x = play note, amp: vol*2/127.0,sustain: 50 #play note
        set ns[note],x #store reference in ns array
      end
    else
      if nv[note]==1 #check if this pitch is on
        nv[note]=0 #set this pitch off
        plist << get(ns[note])
      end
    end
  end
end

live_loop :notekill,auto_cue: false,delay: 0.25 do
  use_real_time
  if plist.length > 0 #check if notes to be killed
    k=plist.pop
    control k,amp: 0,amp_slide: 0.02 #fade note out in 0.02 seconds
    sleep 0.02
    kill k #kill the note referred to in ns array
  end
  sleep 0.01
end