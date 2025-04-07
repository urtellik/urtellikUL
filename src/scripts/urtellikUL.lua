urtellikUL = urtellikUL or {}

local loginator = require("urtellikUL.mdk.loginator")
local log = loginator:new({
  name = "urtellikUL",
  level = "info"
})
log:info("UULC version @VERSION@")
