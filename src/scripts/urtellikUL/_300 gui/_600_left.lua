local ut = urtellikUL.util
local brd = urtellikUL.gui.borders
local st = urtellikUL.gui.styles
local ns = ut.ns("urtellikUL.gui.left")

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
