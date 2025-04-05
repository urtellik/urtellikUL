local nsFn = function(a, b)
  local nsName = b or a
  local loc = b and a or _G
  local path = nsName:split"%."
  for _, elem in ipairs(path) do
    if not loc[elem] then
      loc[elem] = {}
    end
    loc = loc[elem]
  end
  return loc
end

local ns = nsFn("urtellikUL.util")
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

function ns.round(n)
  int, frac = math.modf(n)
  if frac >= 0.5 then
    return int+1
  else
    return int
  end
end