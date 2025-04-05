local uul = urtellikUL
local ut = uul.util
local gui = uul.gui

gui.Color = {}
local Color = gui.Color

local rBrt, gBrt, bBrt = 0.299, 0.587, 0.114

function Color:__add(a)
  if Color.isColor(a) then
    return Color:new({
      r = self.r + a.r,
      b = self.b + a.b,
      g = self.g + a.g,
      a = self.a or a.a and (self.a or 255) + (a.a or 255)
    })
  elseif type(a) == "number" then
    return Color:new({
      r = self.r + a,
      b = self.b + a,
      g = self.g + a,
      a = self.a
    })
  else
    local a = Color:new(a)
    return self + a
  end
end

function Color:__sub(a)
  if Color.isColor(a) then
    return Color:new({
      r = self.r - a.r,
      b = self.b - a.b,
      g = self.g - a.g,
      a = self.a or a.a and (self.a or 255) - (a.a or 0)
    })
  elseif type(a) == "number" then
    return Color:new({
      r = self.r - a,
      b = self.b - a,
      g = self.g - a,
      a = self.a
    })
  else
    local a = Color:new(a)
    return self - a
  end
end

function Color:__mul(a)
  if Color.isColor(a) then
    return Color:new({
      r = self.r * a.r,
      b = self.b * a.b,
      g = self.g * a.g,
      a = self.a or a.a and (self.a or 255) * (a.a or 255)
    })
  elseif type(a) == "number" then
    return Color:new({
      r = self.r * a,
      b = self.b * a,
      g = self.g * a,
      a = self.a
    })
  else
    local a = Color:new(a)
    return self * a
  end
end

function Color.isColor(a)
  return type(a) == "table" and a.r and a.g and a.b
end  

function Color:new(r, g, b, a)
  local r, g, b, a = Geyser.Color.parse(r, g, b, a)
  local color = {r=r,g=g,b=b,a=a}
  setmetatable(color, self)
  self.__index = self
  return color
end

function Color:getPeak()
  return math.max(self.r, self.g, self.b)
end

-- https://alienryderflex.com/hsp.html
function Color:getBrightness()
  return math.sqrt(
    self.r^2 * rBrt
    + self.g^2 * gBrt
    + self.b^2 * bBrt
  )
end

function Color:inv()
  return Color:new(
    self.r == 0 and 255 or 1/self.r,
    self.g == 0 and 255 or 1/self.g,
    self.b == 0 and 255 or 1/self.b,
    self.a
  )
end

local findAdj1 = function(
  target,
  fix1, fix1Brt,
  fix2, fix2Brt,
  var, varBrt
)
  local subRad = 0
    - (fix1^2 * fix1Brt * varBrt)
    - (fix2^2 * fix2Brt * varBrt)
    + (target^2 * varBrt)
  return math.min(
    (math.sqrt(subRad) - (var*varBrt)) / varBrt,
    255-var)
end

local findAdj2 = function(
  target,
  fix, fixBrt,
  var1, var1Brt,
  var2, var2Brt
)
  local subRad = (2*var1*var1Brt + 2*var2*var2Brt)^2
    - 4 * (var1Brt+var2Brt)
      * (fix^2*fixBrt
        + var1^2*var1Brt
        + var2^2*var2Brt
        - target^2)
  local num = math.sqrt(subRad)
    - 2*var1*var1Brt
    - 2*var2*var2Brt
  return math.min(
    num / 2 / (var1Brt + var2Brt),
    255-var1,
    255-var2)
end

function Color:clamp()
  local res = Color:new(self)
  res.r = math.min(math.max(res.r, 0), 255)
  res.g = math.min(math.max(res.g, 0), 255)
  res.b = math.min(math.max(res.b, 0), 255)
  return res
end

function Color:setBrightness(brt)
  local brt = math.min(brt, 255)
  local curBr = self:getBrightness()
  local res = self * math.min(brt/curBr, 255/self:getPeak())
  if ut.round(res:getBrightness()) == ut.round(brt) then
    return res
  end
  for _ = 1,100 do
    curBr = res:getBrightness()
    if ut.round(curBr) == ut.round(brt) then
      return res
    end
    if tostring(curBr) == "nan" then
      return res
    end
    local rnd = {
      r = ut.round(res.r),
      g = ut.round(res.g),
      b = ut.round(res.b),
    }
    if rnd.r == 255 then
      if rnd.g == 255 then
        res.b = res.b + findAdj1(
          brt,
          res.r, rBrt,
          res.g, gBrt,
          res.b, bBrt)
      elseif rnd.b == 255 then
        res.g = res.g + findAdj1(
          brt,
          res.r, rBrt,
          res.b, bBrt,
          res.g, gBrt)
      else
        local adj = findAdj2(
          brt,
          res.r, rBrt,
          res.g, gBrt,
          res.b, bBrt)
        res.g = res.g + adj
        res.b = res.b + adj
      end
    elseif rnd.g == 255 then
      if rnd.b == 255 then
        res.r = res.r + findAdj1(
          brt,
          res.g, gBrt,
          res.b, bBrt,
          res.r, rBrt)
      else
        local adj = findAdj2(
          brt,
          res.g, gBrt,
          res.r, rBrt,
          res.b, bBrt)
        res.r = res.r + adj
        res.b = res.b + adj
      end
    elseif rnd.b == 255 then
      local adj = findAdj2(
        brt,
        res.b, bBrt,
        res.r, rBrt,
        res.g, gBrt)
      res.r = res.r + adj
      res.g = res.g + adj
    end
  end
  return res:clamp()
end