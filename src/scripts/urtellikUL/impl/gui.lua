local ut = urtellikUL.impl.util
local ns = ut.ns("urtellikUL.impl.gui")

function ns.createRight(autoLoad)
  ns.right = Adjustable.Container:new2({
    name = "right",
    titleText = "",
    y = "0%",
    height = "100%",
    x = "-20%",
    width = "20%",
    autoLoad = autoLoad
  })
  ns.right:attachToBorder("right")
  ns.right:addConnectMenu()
end
if not ns.right then
  ns.createRight()
end

function ns.createTop(autoLoad)
  ns.top = Adjustable.Container:new2({
    name = "top",
    titleText = "",
    y="0%",
    height = "10%",
    autoLoad = autoLoad
  })
  ns.top:attachToBorder("top")
  ns.top:connectToBorder("left")
  ns.top:connectToBorder("right")
  ns.top:addConnectMenu()
end
if not ns.top then
  ns.createTop()
end

function ns.createBottom(autoLoad)
  ns.bottom = Adjustable.Container:new2({
    name = "bottom",
    titleText = "",
    height = "20%",
    y = "-20%",
    autoLoad = autoLoad
  })
  ns.bottom:attachToBorder("bottom")
  ns.bottom:connectToBorder("left")
  ns.bottom:connectToBorder("right")
  ns.bottom:addConnectMenu()
end
if not ns.bottom then
  ns.createBottom()
end