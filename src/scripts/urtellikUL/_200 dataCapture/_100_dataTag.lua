local uul = urtellikUL
local ut = uul.util
local ns = ut.ns(uul, "dataCapture.dataTag")
local sg = ut.ns(uul, "state.game")
local loginator = require("urtellikUL.mdk.loginator")
local log = loginator:new({
  name = "urtellikUL.dataCapture.dataTag",
  level = "info"
})

function ns.parseScalar(str)
  if str == "" then
    return nil
  end
  local num = tonumber(str)
  if num then
    return num
  else
    return str
  end
end

function ns.parseCurMax(data)
  local cur, max = unpack(data:split":")
  return {cur=tonumber(cur), max=tonumber(max)}
end

function ns.parseList(data, elemParser)
  elemParser = elemParser or ns.parseScalar
  local arr = data:split":"
  for i, v in ipairs(arr) do
    arr[i] = elemParser(v)
  end
  return arr
end

function ns.listParserFn(elemParser)
  return function(data)
    return ns.parseList(data, elemParser)
  end
end

function ns.parseTable(data)
  local result = {}
  for _, row in pairs(data:split"|") do
    local k, v = unpack(row:split":")
    result[k] = ns.parseScalar(v)
  end
  return result
end

function ns.parserCaptorFn(parser)
  return function(tag, data)
    local before = sg[tag]
    local after = parser(data)
    sg[tag] = after
    raiseEvent("urtellikUL.state.game", tag, after, before)
    raiseEvent("urtellikUL.state.game."..tag, after, before)
  end
end

ns.multiCaptorFn = function(...)
  local captors = {...}
  return function(tag, data)
    for _,cap in ipairs(captors) do
      cap(tag, data)
    end
  end
end

-- For debugging
function ns.printCaptor(...)
  display({...})
end

ns.accumCaptor = function(tag, data)
  local before = sg[tag]
  local after = before and table.deepcopy(before) or {}
  table.insert(after, ns.parseScalar(data))
  sg[tag] = after
  raiseEvent("urtellikUL.state.game", tag, after, before)
  raiseEvent("urtellikUL.state.game."..tag, after, before)
end

ns.clearCaptor = function(targetTag)
  return function()
    local before = sg[targetTag]
    local after = nil
    sg[targetTag] = after
    raiseEvent("urtellikUL.state.game", targetTag, after, before)
    raiseEvent("urtellikUL.state.game."..targetTag, after, before)
  end
end

ns.parseString = function(data)
  if data == "" then
    return nil
  else
    return data
  end
end

ns.curMaxCaptor = ns.parserCaptorFn(ns.parseCurMax)
ns.stringListCaptor = ns.parserCaptorFn(ns.listParserFn(ns.parseString))
ns.scalarCaptor = ns.parserCaptorFn(ns.parseScalar)
ns.tableCaptor = ns.parserCaptorFn(ns.parseTable)
ns.stringCaptor = ns.parserCaptorFn(ns.parseString)
ns.numCaptor = ns.parserCaptorFn(tonumber)
ns.timerCaptor = function(tag, data)
  local before = sg[tag]
  local after = {cur=tonumber(data)}
  if after.cur < 0 then
    after.cur = 0
  end
  if before == nil
    or (before.cur or 0) <= 0
    or after.cur > (before.max or 0) then
    after.max = after.cur
  else
    after.max = before.max
  end
  sg[tag] = after
  raiseEvent("urtellikUL.state.game", tag, after, before)
  raiseEvent("urtellikUL.state.game."..tag, after, before)
end

sg.limb = sg.limb or {}

ns.dataTagCaptors = {
  vitality = ns.curMaxCaptor,
  essence = ns.curMaxCaptor,
  stamina = ns.curMaxCaptor,
  willpower = ns.curMaxCaptor,

  experience = ns.numCaptor,

  pretitle = ns.stringCaptor,
  posttitle = ns.stringCaptor,
  truename = ns.stringCaptor,
  race = ns.stringCaptor,
  subrace = ns.stringCaptor,
  gender = ns.stringCaptor,
  age = ns.numCaptor,
  profession = ns.stringCaptor,
  specialization = ns.stringCaptor,
  deity = ns.stringCaptor,
  patronmoon = ns.stringCaptor,
  dominanthand = ns.stringCaptor,
  position = ns.stringCaptor,
  stance = ns.stringCaptor,
  righthand = ns.stringCaptor,
  lefthand = ns.stringCaptor,
  level = ns.numCaptor,
  experiencetolevel = ns.numCaptor,
  skillpoints = ns.numCaptor,
  arcana = ns.numCaptor,
  language = ns.stringCaptor,
  spells = ns.stringListCaptor,

  exit = ns.accumCaptor,
  room = ns.multiCaptorFn(ns.stringCaptor, ns.clearCaptor("exit")),
  
  fame = ns.curMaxCaptor,
  lessons = ns.curMaxCaptor,
  languages = ns.stringListCaptor,
  martialarts = ns.stringListCaptor,
  martialart = ns.parserCaptorFn(
    function(data)
      local arr = data:split":"
      local cur = arr[1]
      table.remove(arr, 1)
      return {cur=cur, moves=arr}
    end
  ),
  limb = function(tag, data)
    local beforeWhole = sg[tag]
    local part, status, wounds, bleeding = unpack(data:split":")
    local beforePart = beforeWhole[part]
    local afterPart = {status=status, wounds=wounds, bleeding=bleeding}
    sg[tag][part] = afterPart
    local afterWhole = sg[tag]
    raiseEvent("urtellikUL.state.game", tag, afterWhole, beforeWhole)
    raiseEvent("urtellikUL.state.game."..tag, afterWhole, beforeWhole)
    raiseEvent("urtellikUL.state.game."..tag.."."..part, afterPart, beforePart)
  end,
  settings = ns.tableCaptor,
  name = ns.parserCaptorFn(
    function(data)
      local first, last = unpack(data:split":")
      return {first=first, last=last}
    end
  ),
  ht = ns.timerCaptor,
  pt = ns.timerCaptor,
  rt = ns.timerCaptor,
  st = ns.timerCaptor,
  ut = ns.timerCaptor
}
setmetatable(
  ns.dataTagCaptors,
  {
    __index = function(_table, key)
      log:warn("Using default parser for tag "..key)
      return ns.scalarCaptor
    end
  }
)

function ns.handledataTag(_event, tag, data)
  ns.dataTagCaptors[tag](tag, data)
end

registerNamedEventHandler(
  "urtellikUL",
  "dataTag.handledataTag",
  "urtellikUL.dataTag",
  ns.handledataTag
)
