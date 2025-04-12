local ut = urtellikUL.util
local clr = urtellikUL.gui.colors
local ns, log = ut.ns("urtellikUL.gui.styles")

local gss = Geyser.StyleSheet

ns.fontSize = getFontSize() * 4/5

ns.extraBorderPx = 4

ns.borderSizes = {
  left = 0.2,
  top = 0,
  bottom = 0.1,
  right = 0.25,
}

ns.defaultMargin = 2

ns.root = gss:new(f[[
  background-color: rgba(0,0,0,0);
]])

ns.spaced = gss:new(f[[
  margin: {ns.defaultMargin}%;
  padding: {ns.defaultMargin}%;
]], ns.root)

ns.spacedLR = gss:new(f[[
  margin-left: {ns.defaultMargin}%;
  margin-right: {ns.defaultMargin}%;
  padding-left: {ns.defaultMargin}%;
  padding-right: {ns.defaultMargin}%;
]], ns.root)

ns.background = gss:new(f[[
  background-color: {clr.bg:css()};
]], ns.root)

ns.bordered = gss:new([[
  border-style: solid;
  border-color: rgb(100,100,100);
  border-width: 1px;
  border-radius: 3px;
]], ns.spaced)

ns.textBox = gss:new([[
  background-color: rgb(0,0,0);
]], ns.bordered)

ns.borderedTight = gss:new([[
  padding: 0px;
]], ns.bordered)

ns.vitFront = gss:new(f[[
  background-color: {clr.vitality.mid:css()};
]], ns.bordered)
ns.vitBack = gss:new(f[[
  background-color: {clr.vitality.bg:css()};
]], ns.bordered)

ns.essFront = gss:new(f[[
  background-color: {clr.essence.mid:css()};
]], ns.bordered)
ns.essBack = gss:new(f[[
  background-color: {clr.essence.bg:css()};
]], ns.bordered)

ns.wilFront = gss:new(f[[
  background-color: {clr.willpower.mid:css()};
]], ns.bordered)
ns.wilBack = gss:new(f[[
  background-color: {clr.willpower.bg:css()};
]], ns.bordered)

ns.edrFront = gss:new(f[[
  background-color: {clr.endurance.mid:css()};
]], ns.bordered)
ns.edrBack = gss:new(f[[
  background-color: {clr.endurance.bg:css()};
]], ns.bordered)

ns.gaugeText = gss:new([[
  color: white;
  background-color: rgba(0,0,0,0);
  margin: 0;
  padding-right: 8%;
  font-weight: 600;
]], ns.spaced)

ns.gaugeFront = gss:new(f[[
  background-color: {clr.neutral.mid:css()};
]], ns.bordered)
ns.gaugeBack = gss:new([[
  background-color: rgba(0,0,0,0);
]], ns.bordered)

ns.rtTimerFront = gss:new(f[[
  background-color: {clr.rt.mid:css()};
]], ns.bordered)
ns.rtTimerBack = gss:new([[
  background-color: rgba(0,0,0,0);
]], ns.bordered)

ns.stTimerFront = gss:new(f[[
  background-color: {clr.st.mid:css()};
]], ns.bordered)
ns.stTimerBack = gss:new([[
  background-color: rgba(0,0,0,0);
]], ns.bordered)

ns.utTimerFront = gss:new(f[[
  background-color: {clr.ut.mid:css()};
]], ns.bordered)
ns.utTimerBack = gss:new([[
  background-color: rgba(0,0,0,0);
]], ns.bordered)

ns.ptTimerFront = gss:new(f[[
  background-color: {clr.pt.mid:css()};
]], ns.bordered)
ns.ptTimerBack = gss:new([[
  background-color: rgba(0,0,0,0);
]], ns.bordered)

ns.htTimerFront = gss:new(f[[
  background-color: {clr.ht.mid:css()};
]], ns.bordered)
ns.htTimerBack = gss:new([[
  background-color: rgba(0,0,0,0);
]], ns.bordered)

ns.maimed = gss:new([[
  color: red;
]], ns.root)

ns.mutilated = gss:new([[
  color: black;
  background-color: red;
]])

for k,v in spairs(ns) do
  if type(v) == "table" and v.getCSS then
    log:debug("Generating CSS for "..k)
    ns[k.."Css"] = v:getCSS()
  else
    log:debug("Not generating CSS for "..k)
  end
end
