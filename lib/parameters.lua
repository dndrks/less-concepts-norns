local parameters = {}

function parameters.init()
  
  -- separator: less concepts --
  params:add_separator("less concepts")

  local p_add =
  {
    {"voice","bit",0,128,0}
  , {"voice","window",1,16,8} --changed window to max 16, def 8
  , {"voice","low",1,29,1}
  , {"voice","high",1,29,14}
  , {"voice","octave",-3,3,0}
  , {"voice","velocity",0,127,100}
  }

  local p_functions =
  {
    [1] = set.bit
  , [2] = set.window
  , [3] = set.low_note
  , [4] = set.high_note
  , [5] = set.octave
  , [6] = set.velocity
  }

  local c_o_s = help.construct_osc_string
  local c_p_s = help.construct_params_string

  params:add_number("rule","rule",1,18446744073709552000,30)
  params:set_action("rule", function(x) set.rule(stream[1],x) end)
  params:add_number("seed","seed",1,18446744073709552000,36)
  params:set_action("seed", function(x)
    -- if x < 256 then -- TODO: this needs to scale up to 18446744073709552000 depending on the voice[x].window
      pass_seed(stream[1],x)
    -- else
      -- params:set("seed",256,true)
    -- end
  end)

  local outputs = {}
  outputs.voice_destination = {}
  for i = 1,#voice do
    outputs.voice_destination[i] = {"passersby", "crow ii JF", "crow 1/2", "crow 3/4", "midi"} -- change below if change order here
  end

  --[[
  local function jf_checker()
    if outputs.voice_destination["crow ii JF"] == nil then
      crow.ii.jf.mode(0)
      return false
    else
      return true
    end
  end
  --]]

  for i = 1, #outputs.voice_destination do
    params:add{type = "option", id = "output_"..i, name = "output "..i,
      options = outputs.voice_destination[i],
      action = function(value)
        if value == 1 then
          --
        elseif value == 2 then
          --
        elseif value == 3 then
          --crow.output[2].action = "{to(5,0),to(0,0.25)}"
        elseif value == 4 then
          --crow.output[4].action = "{to(5,0),to(0,0.25)}"
        end
      end
    }
  end

  -- separator: just friends --
  params:add_separator("just friends")
  params:add_option("jfmode", "JF mode", {"off", "on"}, 1)
  params:set_action("jfmode", function(x)
    if x == 2 then
      crow.ii.jf.mode(1)
    else
      crow.ii.jf.mode(0)
    end
  end)

  -- separator: midi --
  params:add_separator("midi")
  for i = 1,#voice do
    params:add_number("midi_device_voice_"..i, "midi device:  vox "..i, 1,4,1)
    params:set_action("midi_device_voice_"..i, function (x) set.mididevice(i, x) end)
    params:add_number("midi_channel_voice_"..i, "midi channel: vox "..i, 1,16,1)
    params:set_action("midi_channel_voice_"..i, function (x) 
      set.midichannel(i, x)
    end)
  end
  
  -- separators: voices --
  for i = 1,2 do
    params:add_separator("voice "..i)
    for j = 1,#p_add do
      local id = p_add[j]
      params:add_number(c_o_s(id[1],i,id[2]),c_p_s(id[1],i,id[2]),id[3],id[4],id[5])
      params:set_action(c_o_s(id[1],i,id[2]), function(x) p_functions[j](i,x) end)
    end
  end
end

return parameters
