local nsFn = function(nsName, replace)
  local path = nsName:split"%."
  local loc = _G
  for i, elem in ipairs(path) do
    if not loc[elem]
      or (replace and i == #path)
    then
      loc[elem] = {}
    end
    loc = loc[elem]
  end
  return loc
end

local ns = nsFn("urtellikUL.impl.util", true)
ns.ns = nsFn

function ns.safeGet(name)
  local path = name:split"%."
  local loc = _G
  for _, elem in ipairs(path) do
    if not loc[elem] then
      return nil
    end
    loc = loc[elem]
  end
  return loc
end