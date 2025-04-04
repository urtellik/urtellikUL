local uul = urtellikUL
local ut = uul.util
local gui = uul.gui
local ns = ut.ns(gui, "left")
local brd = gui.borders
local st = gui.styles

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
    st[lc.."TimerFront"],
    st[lc.."TimerBack"],
    st.gaugeText
  )
  gauge.text:setFontSize(st.fontSize)
  gauge.text:setFormat("r")
  ns[lc.."Update"] = function(new)
    local new = new or {}
    local cur = new.cur or 0
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