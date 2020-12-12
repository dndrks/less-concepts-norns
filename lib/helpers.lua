local helper = {}

string.gfind = string.gfind or string.gmatch

function helper.number_to_hex(num)
  return (string.format("%x", num))
end

function helper.number_to_binary_string(x)
  local hex = helper.number_to_hex(x)
  return(helper.hex_to_binary(hex))
end

function helper.hex_to_binary(s)
  local hex2bin = {
    ["0"] = "0000",
    ["1"] = "0001",
    ["2"] = "0010",
    ["3"] = "0011",
    ["4"] = "0100",
    ["5"] = "0101",
    ["6"] = "0110",
    ["7"] = "0111",
    ["8"] = "1000",
    ["9"] = "1001",
    ["a"] = "1010",
    ["b"] = "1011",
    ["c"] = "1100",
    ["d"] = "1101",
    ["e"] = "1110",
    ["f"] = "1111"
    }
  local ret = ""
  local i = 0
  for i in string.gfind(s, ".") do
    i = string.lower(i)
    ret = ret..hex2bin[i]
  end
  return ret
end

function helper.split(str)
  if #str>0 then return str:sub(1,1),helper.split(str:sub(2)) end
end

function helper.binary_to_number(binary_string)
  return tonumber(binary_string,2)
end

function helper.table_to_string(t)
  local strng = {}
  for k,v in pairs(t) do
    strng[k] = tostring(v)
  end
  return table.concat(strng)
end

function helper.midi_to_hz(note)
  return (440 / 32) * (2 ^ ((note - 9) / 12))
end

function helper.window_to_note_ceil(target)
  return ((2^util.clamp(1,63,target.window))-1)
end

-- 1751700991579521821
-- 1298074214633706907132624082305023

function helper.scale(lo, hi, received, target)
  return math.floor(((((received-1) / (helper.window_to_note_ceil(target))) * (hi - lo) + lo)))
end

function helper.construct_osc_string(s,m,e)
  return tostring(s.."_"..m.."_"..e)
end

function helper.construct_params_string(s,m,e)
  return tostring(s.." "..m.." "..e)
end

return helper