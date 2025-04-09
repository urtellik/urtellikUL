-- Old name. Clean up if someone has an early build.
uninstallPackage("Urtellik UL")
urtellikUL = urtellikUL or {}
local ns = urtellikUL
local loginator = require("urtellikUL.mdk.loginator")
ns.baseLogger = loginator:new({
  name = "urtellikUL",
  level = "@VERSION@" == "DEV-BUILD" and "debug" or "info"
})
ns.baseLogger:info("UULC version @VERSION@")
ns.baseLogger:debug("Debug logging enabled")
