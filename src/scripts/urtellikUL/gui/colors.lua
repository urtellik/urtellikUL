local uul = urtellikUL
local ut = uul.util
local ns = ut.ns(uul, "gui.colors")
local Color = uul.gui.Color

ns.fgBrt = 128
ns.bgBrt = 10
ns.midBrt = 100

ns.bg = Color:new("black"):setBrightness(ns.bgBrt)

local desat = 20
ns.vitality = {raw = Color:new(255, desat, desat)}
ns.essence = {raw = Color:new(desat, desat, 255)}
ns.endurance = {raw = Color:new(255, 255, desat)}
ns.willpower = {raw = Color:new(255, desat, 255)}

ns.rt = {raw = Color:new"yellow"}
ns.st = {raw = Color:new"orange"}
ns.ut = {raw = Color:new"red"}
ns.pt = {raw = Color:new"cyan"}
ns.ht = {raw = Color:new"green"}

for _,v in pairs(ns) do
  if type(v) == "table" and v.raw then
    v.fg = v.raw:setBrightness(ns.fgBrt)
    v.bg = v.raw:setBrightness(ns.bgBrt)
    v.mid = v.raw:setBrightness(ns.midBrt)
  end
end