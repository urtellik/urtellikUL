urtellikUL = urtellikUL or {}

local loginator = require("urtellikUL.mdk.loginator")
local log = loginator:new({
  name = "urtellikUL.dataCapture.dataTag",
  level = "info"
})
log:info("UULC version @VERSION@")
