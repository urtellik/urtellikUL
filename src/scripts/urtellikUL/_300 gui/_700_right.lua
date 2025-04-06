local uul = urtellikUL
local ut = uul.util
local gui = uul.gui
local ns = ut.ns(gui, "right")
local brd = gui.borders
local st = gui.styles

local r,g,b = getBgColor()
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
ns.chat:setColor(r,g,b)
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

ns.compass = {
  dirs = {"northwest","north","northeast","west","out","east","southwest","south","southeast","up","down"},
  ratio = mw / mh
}

ns.compass.back = Geyser.Label:new({
  name = "compass.back",
  x = 0,
  y = "75%",
  width = "25%",
  height = "25%",
},brd.right)

-- ns.compass.back:setStyleSheet([[
--   background-color: QRadialGradient(cx:.3,cy:1,radius:1,stop:0 rgb(0,0,50),stop:.5 rgb(0,0,100),stop:1 rgb(0,0,255));
--   border-radius: ]]..tostring(ns.compass.back:get_width()/2-14)..[[px;
--   margin: 10px;
-- ]])
ns.compass.back:setStyleSheet(st.borderedCss)

ns.compass.box = Geyser.HBox:new({
  name = "compass.box",
  x = pos, y = pos,
  width = size, height = size,
}, ns.compass.back)

ns.compass.row1 = Geyser.VBox:new({
  name = "compass.row1",
},ns.compass.box)
ns.compass.row2 = Geyser.VBox:new({
  name = "compass.row2",
},ns.compass.box)
ns.compass.row3 = Geyser.VBox:new({
  name = "compass.row3",
},ns.compass.box)
ns.compass.row4 = Geyser.VBox:new({
  name = "compass.row4",
},ns.compass.box)

ns.compass.northwest = Geyser.Label:new({
  name = "compass.northwest",
},ns.compass.row1)

ns.compass.west = Geyser.Label:new({
  name = "compass.west",
},ns.compass.row1)

ns.compass.southwest = Geyser.Label:new({
  name = "compass.southwest",
},ns.compass.row1)

ns.compass.north = Geyser.Label:new({
  name = "compass.north",
},ns.compass.row2)
  
ns.compass.out = Geyser.Label:new({
  name = "compass.out",
},ns.compass.row2)

ns.compass.south = Geyser.Label:new({
  name = "compass.south",
},ns.compass.row2)

ns.compass.northeast = Geyser.Label:new({
  name = "compass.northeast",
},ns.compass.row3)

ns.compass.east = Geyser.Label:new({
  name = "compass.east",
},ns.compass.row3)

ns.compass.southeast = Geyser.Label:new({
  name = "compass.southeast",
},ns.compass.row3)

ns.compass.spacer1 = Geyser.Container:new({
  name = "compass.spacer1",
  v_stretch_factor = 1/3
}, ns.compass.row4)

ns.compass.up = Geyser.Label:new({
  name = "compass.up",
}, ns.compass.row4)

ns.compass.spacer2 = Geyser.Container:new({
  name = "compass.spacer2",
  v_stretch_factor = 1/3
}, ns.compass.row4)

ns.compass.down = Geyser.Label:new({
  name = "compass.down",
}, ns.compass.row4)

ns.compass.spacer3 = Geyser.Container:new({
  name = "compass.spacer3",
  v_stretch_factor = 1/3
}, ns.compass.row4)

function ns.compass.click(name)
  send(name)
end

local csses = {}

for k,v in pairs(ns.compass.dirs) do
  csses[v] = {}
  csses[v].inactive = Geyser.StyleSheet:new(f[[
    border-image: url("{getMudletHomeDir()}/Urtellik UL/compass/{v}.png");
    margin: {st.defaultMargin*1.5}%;
  ]], st.spaced):getCSS()
  csses[v].active = Geyser.StyleSheet:new(f[[
    border-image: url("{getMudletHomeDir()}/Urtellik UL/compass/{v}-active.png");
    margin: {st.defaultMargin*1.5}%;
  ]], st.spaced):getCSS()
  ns.compass[v]:setStyleSheet(csses[v].inactive)
  ns.compass[v]:setClickCallback(ns.compass.click,v)
end

function ns.compass.setStyle(name, style)
  ns.compass[name]:setStyleSheet(csses[name][style])
end

function ns.compass.setActive(dirs)
  for _,v in ipairs(ns.compass.dirs) do
    ns.compass.setStyle(v, "inactive")
  end
  for _,v in ipairs(dirs or {}) do
    if ns.compass[v] then
      ns.compass.setStyle(v, "active")
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
  ns.compass.back:resize(
    math.min(ns.compass.back:get_height()*4/3, brd.right:get_width()),
    ns.compass.back.height
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
