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
ns.chatBox:setStyleSheet(st.textBox)

-- For some reason it isn't respecting padding. Manually set size.
local borderedSheet = Geyser.StyleSheet:new(st.bordered)
local padding = borderedSheet:get("padding")
local paddingNum = tonumber(utf8.remove(padding, -1))
local size = (100-paddingNum*2).."%"

ns.chat = Geyser.MiniConsole:new({
  name = "urtellikUL.chat",
  x = padding, y = padding,
  width = size, height = size,
  autoWrap = true,
  scrollBar = true,
}, ns.chatBox)
local r,g,b = getBgColor()
ns.chat:setColor(r,g,b)

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