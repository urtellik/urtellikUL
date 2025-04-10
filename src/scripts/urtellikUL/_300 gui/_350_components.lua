local ut = urtellikUL.util
local st = urtellikUL.gui.styles
local ns = ut.ns("urtellikUL.gui.components")

function ns.bordered(elem, parent)
  local border = Geyser.Label:new({
    name = elem.name..".border",
    x = elem.x, y = elem.y,
    width = elem.width, height = elem.height,
  }, parent)
  elem:changeContainer(border)
  border:setStyleSheet(st.borderedCss)
  local size = (100-st.defaultMargin*2).."%"
  local pos = st.defaultMargin.."%"
  elem:set_constraints({
    x = pos, y = pos,
    width = size, height = size
  })
  return elem, border
end
