local ut = urtellikUL.util
local ns, log = ut.ns("urtellikUL.dataCapture.derived")
local sg = ut.safeGetInit("urtellikUL.state.game")

local aggWounds = function(limbs)
  local woundedLimbs = {}
  local woundCount = 0
  local bleedingLimbs = {}
  for limb,data in pairs(limbs or {}) do
    if data.wounds > 0 then
      table.insert(woundedLimbs, limb)
      woundCount = woundCount + data.wounds
    end
    if data.bleeding ~= "nothing" then
      table.insert(bleedingLimbs, limb)
    end
  end
  table.sort(woundedLimbs)
  table.sort(bleedingLimbs)
  return {
    woundedLimbs = woundedLimbs,
    woundCount = woundCount,
    bleedingLimbs = bleedingLimbs
  }
end

local eqArray = function(a, b)
  if (not a and b) or (b and not a) then
    return flase
  end
  if #a ~= #b then
    return false
  end
  for i,v in ipairs(a) do
    if v ~= b[i] then
      return false
    end
  end
  return true
end

registerNamedEventHandler(
  "urtellikUL",
  "dataCapture.derived.wounds",
  "urtellikUL.state.game.limb",
  function(_, data)
    local old = {
      woundedLimbs = sg.woundedLimbs,
      woundCount = sg.woundCount,
      bleedingLimbs = sg.bleedingLimbs
    }
    local new = aggWounds(data)
    sg.woundedLimbs = new.woundedLimbs
    sg.woundCount = new.woundCount
    sg.bleedingLimbs = new.bleedingLimbs
    if not eqArray(old.woundedLimbs, new.woundedLimbs) then
      raiseEvent(
        "urtellikUL.state.game.woundedLimbs",
        new.woundedLimbs, old.woundedLimbs
      )
    end
    if old.woundCount ~= new.woundCount then
      raiseEvent(
        "urtellikUL.state.game.woundCount",
        new.woundCount, old.woundCount
      )
    end
    if not eqArray(old.bleedingLimbs, new.bleedingLimbs) then
      raiseEvent(
        "urtellikUL.state.game.bleedingLimbs",
        new.bleedingLimbs, old.bleedingLimbs
      )
    end
  end
)
