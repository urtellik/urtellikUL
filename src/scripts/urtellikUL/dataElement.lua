local uul = urtellikUL
local pkg = uul.pkg.dataElement

uul.state = uul.state or {}
uul.state.game = uul.state.game or {}
uul.state.game.limb = uul.state.game.limb or {}

function pkg.scalar(str)
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

function pkg.captureCurMax(tag, data)
  local cur, max = unpack(data:split":")
  uul.state.game[tag] = {cur=pkg.scalar(cur), max=pkg.scalar(max)}
end

function pkg.captureList(tag, data)
  local arr = data:split":"
  for i, v in ipairs(arr) do
    arr[i] = pkg.scalar(v)
  end
  uul.state.game[tag] = arr
end

function pkg.captureScalar(tag, data)
  uul.state.game[tag] = pkg.scalar(data)
end

function pkg.captureTable(tag, data)
  local result = {}
  for _, row in pairs(data:split"|") do
    local k, v = unpack(row:split":")
    result[k] = pkg.scalar(v)
  end
  uul.state.game[tag] = result
end

pkg.captors = pkg.captors or {}
setmetatable(
  pkg.captors,
  {
    __index = function(_table, _key)
      return pkg.captureScalar
    end
  }
)

pkg.captors.limb = function(tag, data)
  local part, status, wounds, bleeding = unpack(data:split":")
  uul.state.game[tag] = uul.state.game[tag] or {}
  uul.state.game[tag][part] = {status=status, wounds=wounds, bleeding=bleeding}
  raiseEvent("urtellikUL.dataElement."..tag.."."..part, uul.state.game[tag][part], data)
end

pkg.captors.essence = pkg.captureCurMax
pkg.captors.fame = pkg.captureCurMax
pkg.captors.lessons = pkg.captureCurMax
pkg.captors.stamina = pkg.captureCurMax
pkg.captors.vitality = pkg.captureCurMax
pkg.captors.willpower = pkg.captureCurMax

pkg.captors.languages = pkg.captureList
pkg.captors.martialarts = pkg.captureList

pkg.captors.martialart = function(tag, data)
  local arr = data:split":"
  local cur = arr[1]
  table.remove(arr, 1)
  uul.state.game[tag] = {cur=cur, moves=arr}
end

pkg.captors.settings = pkg.captureTable

pkg.captors.name = function(tag, data)
  local first, last = unpack(data:split":")
  uul.state.game[tag] = {first=first, last=last}
end

function pkg.handleDataElement(_event, tag, data)
  local captor = pkg.captors[tag]
  if captor then
    captor(tag, data)
  end
  raiseEvent("urtellikUL.dataElement."..tag, uul.state.game[tag], data)
end

registerNamedEventHandler(
  "urtellikUL",
  "handleDataElement",
  "urtellikUL.dataElement",
  pkg.handleDataElement
)
