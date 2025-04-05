local uul = urtellikUL
local ut = uul.util
local ns = ut.ns(uul, "gui.styles")

local gss = Geyser.StyleSheet

ns.background = gss:new([[
  background-color: rgb(13,13,13);
]])

ns.spaced = gss:new([[
  margin: 2%;
  padding: 2%;
]])

ns.bordered = gss:new([[
  background-color: rgba(0,0,0,0);
  border-style: solid;
  border-color: rgb(100,100,100);
  border-width: 1px;
  border-radius: 3px;
]], ns.spaced)

ns.borderedTight = gss:new([[
  padding: 0px;
]], ns.bordered)

ns.vitFront = gss:new([[
  background-color: rgb(225,0,0);
]], ns.bordered)
ns.vitBack = gss:new([[
  background-color: rgb(50,0,0);
]], ns.bordered)

ns.essFront = gss:new([[
  background-color: rgb(93,93,255);
]], ns.bordered)
ns.essBack = gss:new([[
  background-color: rgb(23,23,50);
]], ns.bordered)

ns.wilFront = gss:new([[
  background-color: rgb(202,0,253);
]], ns.bordered)
ns.wilBack = gss:new([[
  background-color: rgb(40,0,50);
]], ns.bordered)

ns.edrFront = gss:new([[
  background-color: rgb(148,148,0);
]], ns.bordered)
ns.edrBack = gss:new([[
  background-color: rgb(29,29,0);
]], ns.bordered)

ns.gaugeText = gss:new([[
  color: white;
  background-color: rgba(0,0,0,0);
  margin: 0;
]], ns.spaced)

ns.rtTimerFront = gss:new([[
  background-color: rgb(148,148,0);
]], ns.bordered)
ns.rtTimerBack = gss:new([[
  background-color: rgba(0,0,0,0);
]], ns.bordered)

ns.stTimerFront = gss:new([[
  background-color: rgb(184,92,0);
]], ns.bordered)
ns.stTimerBack = gss:new([[
  background-color: rgba(0,0,0,0);
]], ns.bordered)

ns.utTimerFront = gss:new([[
  background-color: rgb(225,0,0);
]], ns.bordered)
ns.utTimerBack = gss:new([[
  background-color: rgba(0,0,0,0);
]], ns.bordered)

ns.ptTimerFront = gss:new([[
  background-color: rgb(0,147,147);
]], ns.bordered)
ns.ptTimerBack = gss:new([[
  background-color: rgba(0,0,0,0);
]], ns.bordered)

ns.htTimerFront = gss:new([[
  background-color: rgb(0,161,0);
]], ns.bordered)
ns.htTimerBack = gss:new([[
  background-color: rgba(0,0,0,0);
]], ns.bordered)

for k,v in pairs(ns) do
  if v.getCSS then
    ns[k] = v:getCSS()
  end
end