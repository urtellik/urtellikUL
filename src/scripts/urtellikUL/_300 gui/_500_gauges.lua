local uul = urtellikUL
local gui = uul.gui
local ut = uul.util
local ns = ut.ns(gui, "gauges")
local bdr = gui.borders
local st = gui.styles

ns.footer = ut.mvWins(
  ns.footer,
  Geyser.HBox:new({
    name = "urtellikUL.gauges",
    x = 0, y = 0,
    width = "100%",
    height = "100%",
  }, bdr.bottom))

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
  st.vitFrontCss,
  st.vitBackCss,
  st.gaugeTextCss
)
ns.vitality.text:setFontSize(st.fontSize)
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
  function(_event, val)
    ns.updateVitality(val)
  end
)

ns.essence = Geyser.Gauge:new({
  name = "urtellikUL.gauges.essence.gauge",
  height = "100%",
  width = "100%",
  x=0, y=0,
}, ns.leftColumn)
ns.essence:setStyleSheet(
  st.essFrontCss,
  st.essBackCss,
  st.gaugeTextCss
)
ns.essence.text:setFontSize(st.fontSize)
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
  function(_event, val)
    ns.updateEssence(val)
  end
)

ns.stamina = Geyser.Gauge:new({
  name = "urtellikUL.gauges.stamina.gauge",
  height = "100%",
  width = "100%",
  x=0, y=0,
}, ns.rightColumn)
ns.stamina:setStyleSheet(
  st.edrFrontCss,
  st.edrBackCss,
  st.gaugeTextCss
)
ns.stamina.text:setFontSize(st.fontSize)
function ns.updateStamina(val)
  local val = val or {}
  local cur, max = val.cur, val.max
  ns.stamina:setValue(
    cur or 0,
    max or 1,
    "Stamina: "..(cur or "?").."/"..(max or "?")
  )
end
ns.updateStamina(ut.safeGet("urtellikUL.state.game.stamina"))
registerNamedEventHandler(
  "urtellikUL",
  "gui.gauges.stamina",
  "urtellikUL.state.game.stamina",
  function(_event, val)
    ns.updateStamina(val)
  end
)

ns.willpower = Geyser.Gauge:new({
  name = "urtellikUL.gauges.willpower.gauge",
  height = "100%",
  width = "100%",
  x=0, y=0,
},ns.rightColumn)
ns.willpower:setStyleSheet(
  st.wilFrontCss,
  st.wilBackCss,
  st.gaugeTextCss
)
ns.willpower.text:setFontSize(st.fontSize)
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
  function(_event, val)
    ns.updateWillpower(val)
  end
)
