local ut = urtellikUL.impl.util
local ns = ut.ns("urtellikUL.impl.dataElement")
local sg = ut.ns("urtellikUL.state.game")

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
  return {cur=ns.parseScalar(cur), max=ns.parseScalar(max)}
end

function ns.parseList(data)
  local arr = data:split":"
  for i, v in ipairs(arr) do
    arr[i] = ns.parseScalar(v)
  end
  return arr
end

function ns.parseTable(data)
  local result = {}
  for _, row in pairs(data:split"|") do
    local k, v = unpack(row:split":")
    result[k] = ns.parseScalar(v)
  end
  return result
end

function ns.parserCaptor(parser)
  return function(tag, data)
    local before = sg[tag]
    local after = parser(data)
    sg[tag] = after
    raiseEvent("urtellikUL.state.game", tag, after, before)
    raiseEvent("urtellikUL.state.game."..tag, after, before)
  end
end

ns.curMaxCaptor = ns.parserCaptor(ns.parseCurMax)
ns.listCaptor = ns.parserCaptor(ns.parseList)
ns.scalarCaptor = ns.parserCaptor(ns.parseScalar)
ns.tableCaptor = ns.parserCaptor(ns.parseTable)
ns.timerCaptor = function(tag, data)
  local before = sg[tag]
  local after = {cur=ns.parseScalar(data)}
  if before == nil
    or (before.cur or 0) == 0
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

ns.dataElementCaptors = {
  essence = ns.curMaxCaptor,
  fame = ns.curMaxCaptor,
  lessons = ns.curMaxCaptor,
  stamina = ns.curMaxCaptor,
  vitality = ns.curMaxCaptor,
  willpower = ns.curMaxCaptor,
  languages = ns.listCaptor,
  martialarts = ns.listCaptor,
  martialart = ns.parserCaptor(
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
  name = ns.parserCaptor(
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
  ns.dataElementCaptors,
  {
    __index = function(_table, key)
      return ns.scalarCaptor
    end
  }
)

function ns.handleDataElement(_event, tag, data)
  ns.dataElementCaptors[tag](tag, data)
end

registerNamedEventHandler(
  "urtellikUL",
  "dataElement.handleDataElement",
  "urtellikUL.dataElement",
  ns.handleDataElement
)
