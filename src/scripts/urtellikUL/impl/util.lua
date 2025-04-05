local nsFn = function(nsName)
  local path = nsName:split"%."
  local loc = _G
  for _, elem in ipairs(path) do
    if not loc[elem] then
      loc[elem] = {}
    end
    loc = loc[elem]
  end
  return loc
end

local ns = nsFn("urtellikUL.impl.util")
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

function ns.numToPct(num)
  return string.format("%f%%", 100*num)
end

function ns.hideAllIn(tbl)
  for _,v in pairs(tbl) do
    if type(v) == "table" and v.hide then
      v:hide()
    end
  end
end

function ns.mvWins(old, new)
  local old = old or {}
  for _,v in ipairs(old.windows or {}) do
    old.windowList[v]:changeContainer(new)
  end
  return new
end