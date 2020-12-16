-- lc3
-- cellular automata sequencer

ca = require 'elca'
engine.name = 'Passersby'
passersby = include 'passersby/lib/passersby_engine'
help = include 'lib/helpers'
parameters = include 'lib/parameters'
get = include 'lib/gets'
set = include 'lib/sets'
fn = include 'lib/fn'

function new_stream(id)
  stream[id] = ca.new()
end

function pass_seed(target,seed)
  target:clear()
  local binary_string = help.number_to_binary_string(seed)
  local incoming = {help.split(string.reverse(binary_string))} -- 11110 = {0,1,1,1,1}
  for i = 1,string.len(binary_string) do
    target.state[(target.NUM_STATES+1)-i] = tonumber(incoming[i])
  end
end

function iterate(target)
  print(get.current_seed(stream[1]:window(voice[1].window)), table.concat(stream[1].state))
  redraw()
  for i = 1,#voice do
    if target.state[get.bit(i)] == 1 then
      -- notes_off(1)
      -- print(get.current_seed(stream[1]:window(voice[i].window)))
      local note = notes[note_pool][help.scale(get.low_note(i),get.high_note(i),math.abs(get.current_seed(stream[1]:window(get.window(i)))),voice[i])]
      if note ~= nil then
        -- JF
        -- make velocity dynamic
        if params:get("output_"..i) == 1 then
          engine.noteOn(i,help.midi_to_hz((note)+(48+(voice[i].octave * 12))),127)
        elseif params:get("output_"..i) == 2 then
          crow.ii.jf.play_note((note+(voice[i].octave * 12))/12,5)
        end
      end
      -- table.insert(voice[1].active_notes,note)
    end
  end
  target:update()
end

function redraw()
  screen.clear()
  screen.level(15)
  for i = 1,2 do
    for j = 1,voice[i].window+1 do
      if stream[1].state[j] == 1 then
        screen.pixel((j*118/voice[i].window)-2,i == 1 and 0 or 45)
      end
      screen.pixel((voice[i].bit*118/voice[i].window)-2,i == 1 and 10 or 55)
    end
  end
  screen.fill()
  screen.update()
end

function notes_off(id)
  engine.noteOff(id)
  -- for i=1,#voice[id].active_notes do
  --   m:note_off(voice[id].active_notes[i],0,voice[id].ch)
  -- end
  -- voice[id].active_notes = {}
end

function enc(n,d)
  if n == 2 then
    params:delta("voice_1_bit",d)
  elseif n == 3 then
    params:delta("voice_2_bit",d)
  end
end

function init()

  voice = {}
  for i = 1,2 do
    voice[i] = {}
    voice[i].octave = 0
    voice[i].bit = 0
    voice[i].low = 1
    voice[i].high = 14
    voice[i].window = 8 -- shouldn't go larger than 32
  end

  parameters.init()

  stream = {}
  new_stream(1)
  set.mode(stream[1],"classic")
  set.rule(stream[1],30)
  pass_seed(stream[1],36)

  notes = { {0,2,4,5,7,9,11,12,14,16,17,19,21,23,24,26,28,29,31,33,35,36,38,40,41,43,45,47,48},
          {0,2,3,5,7,8,10,12,14,15,17,19,20,22,24,26,27,29,31,32,34,36,38,39,41,43,44,46,48},
          {0,2,3,5,7,9,10,12,14,15,17,19,21,22,24,26,27,29,31,33,34,36,38,39,41,43,45,46,48},
          {0,1,3,5,7,8,10,12,13,15,17,19,20,22,24,25,27,29,31,32,34,36,37,39,41,43,44,46,48},
          {0,2,4,6,7,9,11,12,14,16,18,19,21,23,24,26,28,30,31,33,35,36,38,40,42,43,45,47,48},
          {0,2,4,5,7,9,10,12,14,16,17,19,21,22,24,26,28,29,31,33,34,36,38,40,41,43,45,46,48},
          {0,3,5,7,10,12,15,17,19,22,24,27,29,31,34,36,39,41,43,46,48,51,53,55,58,60,63,65,67},
          {0,2,4,7,9,12,14,16,19,21,24,26,28,31,33,36,38,40,43,45,48,50,52,55,57,60,62,64,67},
          {0,2,5,7,10,12,14,17,19,22,24,26,29,31,34,36,38,41,43,46,48,50,53,55,58,60,62,65,67},
          {0,3,5,8,10,12,15,17,20,22,24,27,29,32,34,36,39,41,44,46,48,51,53,56,58,60,63,65,68},
          {0,2,5,7,9,12,14,17,19,21,24,26,29,31,33,36,38,41,43,45,48,50,53,55,57,60,62,65,67},
          {0,1,3,6,7,8,11,12,13,15,18,19,20,23,24,25,27,30,31,32,35,36,37,39,42,43,44,47,48},
          {0,1,4,6,7,8,11,12,13,16,18,19,20,23,24,25,28,30,31,32,35,36,37,40,42,43,44,47,48},
          {0,1,4,6,7,9,11,12,13,16,18,19,21,23,24,25,28,30,31,33,35,36,37,40,42,43,45,47,48},
          {0,1,4,5,7,8,11,12,13,16,17,19,20,23,24,25,28,29,31,32,35,36,37,40,41,43,44,47,48},
          {0,1,4,5,7,9,10,12,13,16,17,19,21,22,24,25,28,29,31,33,35,36,37,40,41,43,45,47,48},
          {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28} }
  note_names = {"ionian","aeolian", "dorian", "phrygian", "lydian", "mixolydian", "minor_pent", "major_pent", "shang", "jiao", "zhi", "todi", "purvi", "marva", "bhairav", "ahirbhairav", "chromatic"}
  note_pool = 1

  y_offset = {0,0}
  screen_cycle = {"down","up"}

  passersby.add_params()

  go = clock.run(main_clock)
end

function main_clock()
  while true do
    clock.sync(1/4)
    iterate(stream[1])
  end
end
