local uul = urtellikUL
local ut = uul.util
local ns = ut.ns(uul, "gui.borders")
local st = uul.gui.styles

local numToPct = function(num)
  return string.format("%f%%", 100*num)
end

ns.measures = {}

for k, v in pairs(st.borderSizes) do
  ns.measures[k] = v
  ns.measures[k.."Pct"] = numToPct(v)
  ns.measures[k.."InvPct"] = numToPct(1-v)
end

ns.measures.midH = 1-ns.measures.left-ns.measures.right
ns.measures.midHPct = numToPct(ns.measures.midH)
ns.measures.midV = 1-ns.measures.top-ns.measures.bottom
ns.measures.midVPct = numToPct(ns.measures.midV)

function ns.raiseMainWindowResize(dims)
  local lastDims = ns.lastDims or {}
  if dims.w ~= lastDims.w or dims.h ~= lastDims.h then
    raiseEvent("urtellikUL.gui.mainWindowResize", dims, lastDims)
    ns.lastDims = dims
  end
end
registerNamedEventHandler(
  "urtellikUL",
  "gui.borders.raiseMainWindowResize",
  "sysWindowResizeEvent",
  function(_event)
    local w, h = getMainWindowSize()
    ns.raiseMainWindowResize({w=w, h=h})
  end
)

function ns.resizeBorders(dims)
  local w, h = dims.w, dims.h
  local top = h * ns.measures.top + st.extraBorderPx
  local right = w * ns.measures.right + st.extraBorderPx
  local bottom = h * ns.measures.bottom + st.extraBorderPx
  local left = w * ns.measures.left + st.extraBorderPx
  local sizes = getBorderSizes()
  if sizes.top ~= top
    or sizes.right ~= right
    or sizes.bottom ~= bottom
    or sizes.left ~= left
  then
    setBorderSizes(top, right, bottom, left)
  end
end

registerNamedEventHandler(
  "urtellikUL",
  "gui.borders.resizeBorders",
  "urtellikUL.gui.mainWindowResize",
  function(_event, dims)
    ns.resizeBorders(dims)
  end
)

local w, h = getMainWindowSize()
ns.resizeBorders({w=w, h=h})

ns.left = ut.mvWins(
  ns.left,
  Geyser.Label:new({
    name = "urtellikUL.left",
    x = 0, y = 0,
    width = ns.measures.leftPct,
    height = "100%"
  }))
ns.left:setStyleSheet(st.background)

ns.right = ut.mvWins(
  ns.right,
    Geyser.Label:new({
    name = "urtellikUL.right",
    x = "-"..ns.measures.rightPct, y = 0,
    width = ns.measures.rightPct,
    height = "100%",
  }))
ns.right:setStyleSheet(st.background)

-- ns.top = ut.mvWins(
  -- ns.top,
  -- Geyser.Label:new({
    -- name = "urtellikUL.top",
    -- x = ns.measures.leftPct, y = 0,
    -- width = ns.measures.midHPct,
    -- height = ns.measures.topPct,
  -- }))
-- ns.top:setStyleSheet(st.background)

ns.bottom = ut.mvWins(
  ns.bottom,
  Geyser.Label:new({
    name = "urtellikUL.bottom",
    x = ns.measures.leftPct, y = ns.measures.bottomInvPct,
    width = ns.measures.midHPct,
    height = ns.measures.bottomPct,
  }))
ns.bottom:setStyleSheet(st.background)