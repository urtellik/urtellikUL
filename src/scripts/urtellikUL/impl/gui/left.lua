local ut = urtellikUL.impl.util
local ns = ut.ns("urtellikUL.impl.gui.left")
local gui = ut.ns("urtellikUL.impl.gui")

ns.timers = ns.timers or {}

function ns.createTimer(name, label, parent)
  ns.timers[name] = {}
  local t = ns.timers[name]
  t.box = Geyser.VBox:new({
    name="urtellikUL.timer."..name..".box",
  }, parent)
  t.gauge = Geyser.Gauge:new({
    name="urtellikUL.timer."..name..".gauge",
    v_policy=Geyser.Fixed,
    orientation="vertical",
    height="85%"
  }, t.box)
  -- ns.rtBar.front:setColor(55, 55, 55)
  t.gauge.back:setColor(0, 0, 0)

  t.label = Geyser.Label:new({
    name="urtellikUL.timer."..name..".label",
    v_policy=Geyser.Fixed,
    height="15%",
    message=label..": 0"
  }, t.box)
  t.label:setFormat("c")
  -- ns.rtLabel:setStyleSheet(gui.globalStyle:getCSS())
  -- ns.rtLabel:setColor(80, 80, 80)
  function t.update(new)
    local new = new or {}
    local cur = new.cur or 0
    local max = new.cur == 0 and 1 or new.max or 1
    t.gauge:setValue(cur, max)
    t.label:echo(label..": "..cur)
  end
  t.update(ut.safeGet("urtellikUL.state.game."..name))
  registerNamedEventHandler(
    "urtellikUL",
    "gui.timer."..name,
    "event.urtellikUL.state.game."..name,
    function(_, _, new)
      t.update(new)
    end
  )
end

function ns.createSpacer(name, size, parent)
  Geyser.Container:new({
    name=name,
    h_policy=Geyser.Fixed,
    v_policy=Geyser.Fixed,
    width=size,
    height=size,
  }, parent)
end

function ns.createPane(autoLoad)
  ns.pane = Adjustable.Container:new({
    name = "urtellikUL.left",
    titleText = "",
    x = "0%",
    y = "0%",
    height = "100%",
    width = "20%",
    color = "#300000",
    autoLoad = autoLoad
  })
  ns.pane:attachToBorder("left")
  ns.pane:addConnectMenu()
  
  ns.top = Geyser.Label:new({
    name = "urtellikUL.left.top",
    x = "0%",
    y = "0%",
    height = "25%",
    width = "100%",
    color = "#300000",
  }, ns.pane)
  ns.top:setColor(60, 0, 0)
  
  ns.mid = Geyser.Label:new({
    name = "urtellikUL.left.mid",
    x = "0%",
    y = "25%",
    height = "50%",
    width = "100%",
  }, ns.pane)
  ns.mid:setColor(0, 60, 0)
  
  ns.bot = Geyser.HBox:new({
    name = "urtellikUL.left.bot",
    x = "0%",
    y = "75%",
    height = "25%",
    width = "100%",
    color = "#000030"
  }, ns.pane)
  
  ns.createTimer("rt", "RT", ns.bot)
  ns.createSpacer("urtellikUL.left.bot.sp1", "1%", ns.bot)
  ns.createTimer("st", "ST", ns.bot)
  ns.createSpacer("urtellikUL.left.bot.sp2", "1%", ns.bot)
  ns.createTimer("ut", "UT", ns.bot)
  ns.createSpacer("urtellikUL.left.bot.sp3", "1%", ns.bot)
  ns.createTimer("ht", "HT", ns.bot)
  ns.createSpacer("urtellikUL.left.bot.sp4", "1%", ns.bot)
  ns.createTimer("pt", "PT", ns.bot)
end

ns.createPane()