local ut = urtellikUL.util
local brd = urtellikUL.gui.borders
local st = urtellikUL.gui.styles
local cmp = urtellikUL.gui.components
local ns, log = ut.ns("urtellikUL.gui.left")

ns.timers = Geyser.VBox:new({
  name = "urtellikUL.timers",
  x = "0%", y = "75%",
  width = "100%",
  height = "25%",
}, brd.left)

for _,lc in ipairs({"rt","st","ut","pt","ht"}) do
  local uc = string.upper(lc)
  
  ns[lc.."Gauge"] = Geyser.Gauge:new({
    name = "urtellikUL.timers."..lc..".gauge",
    orientation="goofy",
  }, ns.timers)
  local gauge = ns[lc.."Gauge"]
  gauge:setStyleSheet(
    st[lc.."TimerFrontCss"],
    st[lc.."TimerBackCss"],
    st.gaugeTextCss
  )
  gauge.text:setFontSize(st.fontSize)
  gauge.text:setFormat("r")
  ns[lc.."Update"] = function(new)
    local new = new or {cur=0, max=0}
    local cur = new.cur >= 0 and new.cur or 0
    local max = new.cur == 0 and 1 or new.max or 1
    gauge:setValue(cur, max, uc..": "..cur)
  end
  local update = ns[lc.."Update"]
  update(ut.safeGet("urtellikUL.state.game."..lc))
  registerNamedEventHandler(
    "urtellikUL",
    "gui.timers."..lc,
    "urtellikUL.state.game."..lc,
    function(_, new)
      update(new)
    end
  )
end

ns.healthBox =
  cmp.bordered(Geyser.VBox:new({
    name = "urtellikUL.healthBox",
    x = "0%", y = "35%",
    width = "100%",
    height = "40%",
  }), brd.left)

-- ns.limbs = Geyser.VBox:new({
--   name = "urtellikUL.limbs",
-- }, ns.healthBox)
-- ns.limbs:setStyleSheet(st.spacedCss)

registerNamedEventHandler(
  "urtellikUL",
  "gui.limbs",
  "urtellikUL.state.game.woundedLimbs",
  function(_, val)
    -- ns.limbs:echo("")
  end
)

for k,v in pairs(ns.limbs or {}) do
  ut.hideAllIn(v)
end
ns.limbs = {}
for k,v in spairs(urtellikUL.state.game.limb) do
  ns.limbs[k] = ns.limbs[k] or {}
  ut.hideAllIn(ns.limbs[k])
  local l = ns.limbs[k]
  l.row = Geyser.HBox:new({
    name = "urtellikUL.limbRow."..k,
  }, ns.healthBox)
  l.name = Geyser.Label:new({
    name = "urtellikUL.limbName."..k,
    message = k
  }, l.row)
  l.name:setStyleSheet(st.spacedLRCss)
  l.status = Geyser.Label:new({
    name = "urtellikUL.limbStatus."..k,
    message = v.status
  }, l.row)
  l.status:setStyleSheet(st.spacedLRCss)
  l.bleeding = Geyser.Label:new({
    name = "urtellikUL.limbBleeding."..k,
    message = v.bleeding
  }, l.row)
  l.bleeding:setStyleSheet(st.spacedLRCss)
  l.wounds = Geyser.Label:new({
    name = "urtellikUL.limbWounds."..k,
    message = v.wounds
  }, l.row)
  l.wounds:setStyleSheet(st.spacedLRCss)
end

function ns.update(limb, data)
  local l = ns.limbs[limb]
  l.status:echo(data.status)
  l.bleeding:echo(data.bleeding)
  l.wounds:echo(data.wounds)
end

registerNamedEventHandler(
  "urtellikUL",
  "gui.left.limbTable",
  "urtellikUL.state.game.limb",
  function(_, _afterWhole, _beforeWhole, limb, data)
    ns.update(limb, data)
  end
)
