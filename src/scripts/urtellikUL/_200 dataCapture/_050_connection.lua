local ut = urtellikUL.util
local ns, log = ut.ns("urtellikUL.dataCapture.dataTag")
local sg = ut.safeGetInit("urtellikUL.state.game")

registerNamedEventHandler(
  "urtellikUL",
  "clearGameState",
  "sysDisconnectionEvent",
  function()
    local old = sg.limb
    sg.limb = {}
    raiseEvent("urtellikUL.state.game.limb", {}, old)
  end
)
