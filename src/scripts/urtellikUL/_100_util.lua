urtellikUL.util = urtellikUL.util or {}
local ns = urtellikUL.util
local baseLogger = urtellikUL.baseLogger

local nsLogger = function(prefix)
  local prefix = "("..name..") "
  return setmetatable({
    log = function(self, msg, level)
      return baseLogger:log(prefix..msg, level)
    end
  }, {__index=baseLogger})
end

function ns.safeGetInit(name)
  local path = name:split"%."
  local loc = _G
  for _, elem in ipairs(path) do
    if not loc[elem] then
      loc[elem] = {}
    end
    loc = loc[elem]
  end
  return loc
end

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

function ns.ns(name)
  return ns.safeGetInit(name), nsLogger(name)
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
