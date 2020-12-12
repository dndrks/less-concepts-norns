local parameters = {}

function parameters.init()
  params:add_separator("less concepts")

  local p_add =
  {
    {"voice","bit",0,128,0}  
  , {"voice","window",1,128,128}
  , {"voice","low",1,29,1}
  , {"voice","high",1,29,14}
  , {"voice","octave",-3,3,0}
  }

  local p_functions =
  {
    [1] = set.bit
  , [2] = set.window
  , [3] = set.low_note
  , [4] = set.high_note
  , [5] = set.octave
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