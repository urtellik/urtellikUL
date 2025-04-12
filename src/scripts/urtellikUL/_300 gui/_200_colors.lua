local ut = urtellikUL.util
local Color = urtellikUL.gui.Color
local ns = ut.ns("urtellikUL.gui.colors")

ns.fgBrt = 128
ns.bgBrt = 10
ns.midBrt = 90

ns.bg = Color:new("black"):setBrightness(ns.bgBrt)

local desat = 20
ns.vitality = {raw = Color:new(255, desat, desat)}
ns.essence = {raw = Color:new(desat, desat, 255)}
ns.endurance = {raw = Color:new(255, 255, desat)}
ns.willpower = {raw = Color:new(255, desat, 255)}

ns.rt = {raw = Color:new(255, 255, desat)}
ns.st = {raw = Color:new(255, 128, desat)}
ns.ut = {raw = Color:new(255, desat, desat)}
ns.pt = {raw = Color:new(desat, 255, 255)}
ns.ht = {raw = Color:new(desat, 255, desat)}

ns.neutral = {raw = Color:new(0,0,0)}

for _,v in pairs(ns) do
  if type(v) == "table" and v.raw then
    v.fg = v.raw:setBrightness(ns.fgBrt)
    v.bg = v.raw:setBrightness(ns.bgBrt)
    v.mid = v.raw:setBrightness(ns.midBrt)
  end
end
