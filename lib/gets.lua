local get = {}

function get.bit(voice_id)
  return voice[voice_id].bit
end

function get.window(voice_id)
  return(voice[voice_id].window)
end

function get.low_note(voice_id)
  return(voice[voice_id].low)
end

function get.high_note(voice_id)
  return(voice[voice_id].high)
end

function get.current_seed(t)
  return help.binary_to_number(help.table_to_string(t))
end

return get