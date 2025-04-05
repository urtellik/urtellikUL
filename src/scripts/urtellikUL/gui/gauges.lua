local ut = urtellikUL.impl.util
local ns = ut.ns("urtellikUL.gui.gauges")
local bdrs = ut.ns("urtellikUL.gui.borders")
local st = ut.ns("urtellikUL.gui.styles")

ns.footer = ut.mvWins(
  ns.footer,
  Geyser.HBox:new({
    name = "urtellikUL.gauges",
    x = 0, y = 0,
    width = "100%",
    height = "100%",
  }, bdrs.bottom))

ns.leftColumn = Geyser.VBox:new({
  name = "urtellikUL.gauges.leftColumn",
}, ns.footer)

ns.rightColumn = Geyser.VBox:new({
  name = "urtellikUL.gauges.rightColumn",
}, ns.footer)

ns.vitality = Geyser.Gauge:new({
  name = "urtellikUL.gauges.vitality.gauge",
  height = "100%",
  width = "100%",
  x=0, y=0,
}, ns.leftColumn)
ns.vitality:setStyleSheet(
  st.vitFront,
  st.vitBack,
  st.gaugeText
)
-- ns.vitality.front:setStyleSheet(ns.vitFront:getCSS())
function ns.updateVitality(val)
  local val = val or {}
  local cur, max = val.cur, val.max
  ns.vitality:setValue(
    cur or 0,
    max or 1,
    "Vitality: "..(cur or "?").."/"..(max or "?")
  )
end
ns.updateVitality(ut.safeGet("urtellikUL.state.game.vitality"))
registerNamedEventHandler(
  "urtellikUL",
  "gui.gauges.vitality",
  "urtellikUL.state.game.vitality",
  function(_event, vit)
    ns.updateVitality(vit)
  end
)

ns.essence = Geyser.Gauge:new({
  name = "urtellikUL.gauges.essence.gauge",
  height = "100%",
  width = "100%",
  x=0, y=0,
}, ns.leftColumn)
ns.essence:setStyleSheet(
  st.essFront,
  st.essBack,
  st.gaugeText
)
function ns.updateEssence(val)
  local val = val or {}
  local cur, max = val.cur, val.max
  ns.essence:setValue(
    cur or 0,
    max or 1,
    "Essence: "..(cur or "?").."/"..(max or "?")
  )
end
ns.updateEssence(ut.safeGet("urtellikUL.state.game.essence"))
registerNamedEventHandler(
  "urtellikUL",
  "gui.gauges.essence",
  "urtellikUL.state.game.essence",
  function(_event, vit)
    ns.updateEssence(vit)
  end
)

ns.endurance = Geyser.Gauge:new({
  name = "urtellikUL.gauges.endurance.gauge",
  height = "100%",
  width = "100%",
  x=0, y=0,
},ns.rightColumn)
ns.endurance:setStyleSheet(
  st.edrFront,
  st.edrBack,
  st.gaugeText
)
function ns.updateEndurance(val)
  local val = val or {}
  local cur, max = val.cur, val.max
  ns.endurance:setValue(
    cur or 0,
    max or 1,
    "Endurance: "..(cur or "?").."/"..(max or "?")
  )
end
ns.updateEndurance(ut.safeGet("urtellikUL.state.game.endurance"))
registerNamedEventHandler(
  "urtellikUL",
  "gui.gauges.endurance",
  "urtellikUL.state.game.endurance",
  function(_event, vit)
    ns.updateEndurance(vit)
  end
)

ns.willpower = Geyser.Gauge:new({
  name = "urtellikUL.gauges.willpower.gauge",
  height = "100%",
  width = "100%",
  x=0, y=0,
},ns.rightColumn)
ns.willpower:setStyleSheet(
  st.wilFront,
  st.wilBack,
  st.gaugeText
)
function ns.updateWillpower(val)
  local val = val or {}
  local cur, max = val.cur, val.max
  ns.willpower:setValue(
    cur or 0,
    max or 1,
    "Willpower: "..(cur or "?").."/"..(max or "?")
  )
end
ns.updateWillpower(ut.safeGet("urtellikUL.state.game.willpower"))
registerNamedEventHandler(
  "urtellikUL",
  "gui.gauges.willpower",
  "urtellikUL.state.game.willpower",
  function(_event, vit)
    ns.updateWillpower(vit)
  end
)