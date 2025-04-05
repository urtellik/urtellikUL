local ut = urtellikUL.impl.util
local ns = ut.ns("urtellikUL.gui.styles")

local gss = Geyser.StyleSheet

ns.background = Geyser.StyleSheet:new([[
  background-color: rgb(13,13,13);
]])

ns.spaced = Geyser.StyleSheet:new([[
  margin: 2%;
  padding: 2%;
]])

ns.bordered = Geyser.StyleSheet:new([[
  background-color: rgba(0,0,0,0);
  border-style: solid;
  border-color: rgb(100,100,100);
  border-width: 1px;
  border-radius: 3px;
]], ns.spaced)

ns.vitFront = Geyser.StyleSheet:new([[
  background-color: rgb(225,0,0);
]], ns.bordered)
ns.vitBack = Geyser.StyleSheet:new([[
  background-color: rgb(50,0,0);
]], ns.bordered)

ns.essFront = Geyser.StyleSheet:new([[
  background-color: rgb(93,93,255);
]], ns.bordered)
ns.essBack = Geyser.StyleSheet:new([[
  background-color: rgb(23,23,50);
]], ns.bordered)

ns.wilFront = Geyser.StyleSheet:new([[
  background-color: rgb(202,0,253);
]], ns.bordered)
ns.wilBack = Geyser.StyleSheet:new([[
  background-color: rgb(40,0,50);
]], ns.bordered)

ns.edrFront = Geyser.StyleSheet:new([[
  background-color: rgb(148,148,0);
]], ns.bordered)
ns.edrBack = Geyser.StyleSheet:new([[
  background-color: rgb(29,29,0);
]], ns.bordered)

ns.gaugeText = Geyser.StyleSheet:new([[
  color: white;
  background-color: rgba(0,0,0,0);
  margin: 0;
]], ns.spaced)

for k,v in pairs(ns) do
  if v.getCSS then
    ns[k] = v:getCSS()
  end
end