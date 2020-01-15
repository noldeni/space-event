#markov-chaining.rb
#https://in-thread.sonic-pi.net/u/nabisco
#https://in-thread.sonic-pi.net/t/generative-piano-using-markov-chaining/1168/12

T = 4.0

# State machine utility functions
define :markov do |a, h| h[a].sample; end # Chooses the next state at  random from hash
define :g do |k| get[k]; end # simplified root note in scale getter
define :s do |k, n| set k, n; end # simplified root note setter
define :mnote do |key,chain| s key, (markov (g key), chain); g key; end

# Initializes states for all state machines
set :k, 1
set :b, 0
set :s, 0
set :y, 0

# Scale
sc_root = :F2
sc_type = :major
sc = scale(sc_root, sc_type)

# Chords in scale -- chords are defined here.
chords = (1..7).map {|n| chord_degree n, sc_root, sc_type }.ring

K = {
  1 => [1,1,4,5],
  4 => [5],
  5 => [1,4]
}

B = {
  0 => [0,1],
  1 => [0,1]
}

S = {
  0 => [0,0,0,0, 0,0,0,1], # 1/8 chance of choosing snare pattern 2
  1 => [0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1] # 1/16 chance of choosing snare pattern 2
}

kick_patterns = [
  (bools, 1,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0), # Kick Pattern 1 / C
  (bools, 1,0,0,0, 0,0,1,0, 0,1,1,0, 0,1,1,0) # Kick Pattern 2 / C
].ring

snare_patterns = [
  (bools, 0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0), # Snare Pattern 1 / G
  (bools, 1,0,1,0, 1,0,0,0, 0,0,0,0, 1,0,1,0)  # Snare Pattern 2 / G
].ring

# Melody Maker -- makes a single melody pattern of length len and moves away from root in range 2
define :make_melody do |len = 16, rng = 2|
  (1..len).map{|n| ((rng*-1)..rng).to_a.sample }.ring  # This uses a .sample and a range, but can also be done with cosine functions.
end

# Generates 4 melody patterns
melodies = (1..4).map{|n| make_melody(16,2)}.ring

# Melodies -- markov chain for switching patterns
Y = {
  0 => [1],
  1 => [0, 1, 2],
  2 => [1, 2],
  3 => [1]
}

live_loop :kicks do
  pat = kick_patterns[mnote :b, B] # markov select pattern
  pat.length.times do
    sample :bd_mehackit if pat.tick
    sleep T/16
  end
end

live_loop :snares do
  pat = snare_patterns[mnote :s, S] # markov select pattern
  pat.length.times do
    sample :sn_dolf if pat.tick
    sleep T/16
  end
end

live_loop :chords do
  use_synth :fm
  chr = chords[mnote :k, K]
  dur = T/1
  play chr[0], release: dur
  play chr[1], release: dur
  play chr[2], release: dur
  play chr[3], release: dur
  
  melody = melodies[mnote :y, Y]
  use_synth :pretty_bell
  4.times do
    play sc[melody.tick] + 36
    sleep T/4
  end
end