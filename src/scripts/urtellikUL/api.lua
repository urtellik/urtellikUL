local ut = urtellikUL.impl.util
local ns = ut.ns("urtellikUL.api")
local gui = ut.ns("urtellikUL.impl.gui")

function ns.resetTop()
  gui.createTop(false)
  Adjustable.Container.saveAll()
end

function ns.resetBottom()
  gui.createBottom(false)
  Adjustable.Container.saveAll()
end

function ns.resetLeft()
  gui.left.createPane(false)
  gui.left.pane:show()
  Adjustable.Container.saveAll()
end

function ns.resetRight()
  gui.createRight(false)
  Adjustable.Container.saveAll()
end

function ns.resetGui()
  ns.resetLeft()
  ns.resetRight()
  ns.resetTop()
  ns.resetBottom()
end