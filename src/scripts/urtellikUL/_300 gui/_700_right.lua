local ut = urtellikUL.util
local brd = urtellikUL.gui.borders
local st = urtellikUL.gui.styles
local ns = ut.ns("urtellikUL.gui.right")

ns.chatBox = Geyser.Label:new({
  name = "urtellikUL.chatBox",
  x = "0%", y = "0%",
  width = "100%",
  height = "50%",
}, brd.right)
ns.chatBox:setStyleSheet(st.textBoxCss)

local size = (100-st.defaultMargin*2).."%"
local pos = st.defaultMargin.."%"

ns.chat = Geyser.MiniConsole:new({
  name = "urtellikUL.chat",
  x = pos, y = pos,
  width = size, height = size,
  autoWrap = true,
  scrollBar = true,
}, ns.chatBox)
local r,g,b = getBgColor()
-- I have NO idea why these are sometimes nil
ns.chat:setColor(r or 0, g or 0, b or 0)
ns.chat:setFontSize(getFontSize())

local buf = "urtellikUL.oocChannelMessage"
registerNamedEventHandler(
  "urtellikUL",
  "urtellikUL.chatMessage",
  "urtellikUL.oocChannelMessage",
  function()
    selectCurrentLine(buf)
    copy(buf)
    ns.chat:appendBuffer()
  end
)

local mw, mh = getMainWindowSize()

ns.compass = {}

ns.compass.back = Geyser.Label:new({
  name = "urtellikUL.compass.back",
  x = 0,
  y = "75%",
  width = "25%",
  height = "25%",
},brd.right)

ns.compass.back:setStyleSheet(st.borderedCss)

ns.compass.box = Geyser.HBox:new({
  name = "urtellikUL.compass.box",
  x = pos, y = pos,
  width = size, height = size,
}, ns.compass.back)

ns.compass.col1 = Geyser.VBox:new({
  name = "urtellikUL.compass.col1",
  h_policy = Geyser.Fixed,
},ns.compass.box)
ns.compass.col2 = Geyser.VBox:new({
  name = "urtellikUL.compass.col2",
  h_policy = Geyser.Fixed,
},ns.compass.box)
ns.compass.col3 = Geyser.VBox:new({
  name = "urtellikUL.compass.col3",
  h_policy = Geyser.Fixed,
},ns.compass.box)
ns.compass.col4 = Geyser.VBox:new({
  name = "urtellikUL.compass.col4",
  h_policy = Geyser.Fixed,
},ns.compass.box)

function ns.compass.click(name)
  send(name)
end

ns.compass.dirs = {}
local mkdir = function(name, parent)
  ns.compass.dirs[name] = {}
  local dir = ns.compass.dirs[name]
  dir.label = Geyser.Label:new({
    name = "urtellikUL.compass."..name,
  }, parent)
  
  dir.inactive = Geyser.StyleSheet:new(f[[
    border-image: url("{getMudletHomeDir()}/urtellikUL/compass/{name}.png");
    margin: {st.defaultMargin*1.5}%;
  ]], st.spaced):getCSS()

  dir.active = Geyser.StyleSheet:new(f[[
    border-image: url("{getMudletHomeDir()}/urtellikUL/compass/{name}-active.png");
    margin: {st.defaultMargin*1.5}%;
  ]], st.spaced):getCSS()
  
  dir.label:setStyleSheet(dir.inactive)
  dir.label:setClickCallback(ns.compass.click, name)
end

mkdir("northwest", ns.compass.col1)
mkdir("west", ns.compass.col1)
mkdir("southwest", ns.compass.col1)

mkdir("north", ns.compass.col2)
mkdir("out", ns.compass.col2)
mkdir("south", ns.compass.col2)

mkdir("northeast", ns.compass.col3)
mkdir("east", ns.compass.col3)
mkdir("southeast", ns.compass.col3)

ns.compass.spacer1 = Geyser.Label:new({
  name = "urtellikUL.compass.spacer1",
  v_stretch_factor = 1/3
}, ns.compass.col4)
ns.compass.spacer1:setStyleSheet(st.spacedCss)
mkdir("up", ns.compass.col4)
ns.compass.spacer2 = Geyser.Label:new({
  name = "urtellikUL.compass.spacer2",
  v_stretch_factor = 1/3
}, ns.compass.col4)
ns.compass.spacer2:setStyleSheet(st.spacedCss)
mkdir("down", ns.compass.col4)
ns.compass.spacer3 = Geyser.Label:new({
  name = "urtellikUL.compass.spacer3",
  v_stretch_factor = 1/3
}, ns.compass.col4)
ns.compass.spacer3:setStyleSheet(st.spacedCss)

function ns.compass.setActive(dirs)
  for _,dir in pairs(ns.compass.dirs) do
    dir.label:setStyleSheet(dir.inactive)
  end
  for _,v in ipairs(dirs or {}) do
    local dir = ns.compass.dirs[v]
    if dir then
      dir.label:setStyleSheet(dir.active)
    end
  end
end

registerNamedEventHandler(
  "urtellikUL",
  "gui.right.highlightExits",
  "urtellikUL.state.game.exit",
  function(_event, exits)
    ns.compass.setActive(exits)
  end
)

ns.compass.setActive(ut.safeGet("urtellikUL.state.game.exit"))

function ns.compass.resize()
  local arrowHeight = ns.compass.dirs.north.label:get_height()
  for _,col in ipairs({ns.compass.col1, ns.compass.col2, ns.compass.col3, ns.compass.col4}) do
    col:resize(arrowHeight, nil)
  end
  local backHeight = ns.compass.back:get_height()
  ns.compass.back:resize(
    backHeight*4/3,
    nil
  )
end

registerNamedEventHandler(
  "urtellikUL",
  "gui.right.compassResize",
  "urtellikUL.gui.mainWindowResize",
  function(_event, dims)
    ns.compass.resize()
  end
)

ns.compass.resize()
