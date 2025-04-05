local ut = urtellikUL.impl.util
local ns = ut.ns("urtellikUL.gui.left")
local gui = ut.ns("urtellikUL.gui")
local brd = ut.ns("urtellikUL.gui.borders")
local st = ut.ns("urtellikUL.gui.styles")

ns.boxCSS = Geyser.StyleSheet:new("", gui.borderedCSS)

-- ns.box1 = Geyser.Label:new({
  -- name = "urtellikUL.box1",
  -- x = 0, y = 0,
  -- width = "100%",
  -- height = "50%",
-- },brd.right)
-- ns.box1:setStyleSheet(ns.boxCSS:getCSS())
-- ns.box1:echo("<center>ns.box1")
-- 
-- ns.box2 = Geyser.Label:new({
  -- name = "urtellikUL.box2",
  -- x = 0, y = "50%",
  -- width = "50%",
  -- height = "50%",
-- },brd.right)
-- ns.box2:setStyleSheet(ns.boxCSS:getCSS())
-- ns.box2:echo("<center>ns.box2")
-- 
-- ns.box3 = Geyser.Label:new({
  -- name = "urtellikUL.box3",
  -- x = "50%", y = "50%",
  -- width = "50%",
  -- height = "50%",
-- },brd.right)
-- ns.box3:setStyleSheet(ns.boxCSS:getCSS())
-- ns.box3:echo("<center>ns.box3")

ns.box4 = ut.mvWins(
  ns.box4,
    Geyser.Label:new({
    name = "urtellikUL.box4",
    x = "0%", y = "0%",
    width = "100%",
    height = "25%",
  },brd.left))
ns.box4:setStyleSheet(ns.boxCSS:getCSS())
ns.box4:echo("<center>ns.box4")

ns.box5 = Geyser.Label:new({
  name = "urtellikUL.box5",
  x = "0%", y = "25%",
  width = "50%",
  height = "50%",
},brd.left)
ns.box5:setStyleSheet(ns.boxCSS:getCSS())
ns.box5:echo("<center>ns.box5")

ns.box6 = Geyser.Label:new({
  name = "urtellikUL.box6",
  x = "50%", y = "25%",
  width = "50%",
  height = "50%",
},brd.left)
ns.box6:setStyleSheet(ns.boxCSS:getCSS())
ns.box6:echo("<center>ns.box6")

ns.timers = Geyser.HBox:new({
  name = "urtellikUL.timers",
  x = "0%", y = "75%",
  width = "100%",
  height = "25%",
}, brd.left)

for _,lc in ipairs({"rt","st","ut","pt","ht"}) do
  local uc = string.upper(lc)
  
  ns[lc.."Col"] = ut.mvWins(
    ns[lc.."Col"],
    Geyser.VBox:new({
      name = "urtellikUL.timers."..lc..".col",
    }, ns.timers))
  local col = ns[lc.."Col"]
  
  ns[lc.."Gauge"] = Geyser.Gauge:new({
    name = "urtellikUL.timers."..lc..".gauge",
    v_policy=Geyser.Fixed,
    orientation="vertical",
    height="80%"
  }, col)
  local gauge = ns[lc.."Gauge"]
  gauge:setStyleSheet(
    st[lc.."TimerFront"],
    st[lc.."TimerBack"]
  )
  ns[lc.."Label"] = Geyser.Label:new({
    name="urtellikUL.timers."..lc..".label",
    v_policy=Geyser.Fixed,
    height="20%",
  }, col)
  local label = ns[lc.."Label"]
  label:setStyleSheet(st.borderedTight)
  label:setFormat("c")
  ns[lc.."Update"] = function(new)
    local new = new or {}
    local cur = new.cur or 0
    local max = new.cur == 0 and 1 or new.max or 1
    gauge:setValue(cur, max)
    label:echo(uc..": "..cur)
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