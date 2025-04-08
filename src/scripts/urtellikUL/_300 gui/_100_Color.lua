local ut = urtellikUL.util
local Color = ut.ns("urtellikUL.gui.Color")

function Color:new(r, g, b, a)
  local r, g, b, a = Geyser.Color.parse(r, g, b, a)
  local color = {r=r,g=g,b=b,a=a}
  setmetatable(color, self)
  self.__index = self
  return color
end

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

function Color:clamp()
  local res = Color:new(self)
  res.r = math.min(math.max(res.r, 0), 255)
  res.g = math.min(math.max(res.g, 0), 255)
  res.b = math.min(math.max(res.b, 0), 255)
  return res
end

function Color.rgbToHsl(rgb)
  local hsl = {h=0, s=0, l=0}
  local r, g, b = rgb.r/255, rgb.g/255, rgb.b/255
  local min, max = math.min(r, g, b), math.max(r, g, b)
  local delta = (max - min)
  hsl.l = (max + min) / 2
  if delta == 0 then
    return hsl
  end
  if hsl.l <= 0.5 then
    hsl.s = delta / (max + min)
  else
    hsl.s = delta / (2 - max - min)
  end
  local hue = 0
  if r == max then
    hue = (g-b) / 6 / delta
  elseif g == max then
    hue = 1/3 + (b-r) / 6 / delta
  else
    hue = 2/3 + (r-g) / 6 / delta
  end
  if hue < 0 then
    hue = hue + 1
  elseif hue > 1 then
    hue = hue - 1
  end
  hsl.h = hue * 360
  return hsl
end

local hueToRgb = function(v1, v2, hue)
  local hue = hue
  if hue < 0 then
    hue = hue + 1
  elseif hue > 1 then
    hue = hue - 1
  end
  if (6*hue) < 1 then
    return v1 + (v2-v1) * 6 * hue
  elseif (2*hue) < 1 then
    return v2
  elseif (3*hue) < 2 then
    return v1 + (v2-v1) * 6 * (2/3 - hue)
  else
    return v1
  end
end

function Color.hslToRgb(hsl)
  local rgb = Color:new({r=0,g=0,b=0})
  local h, s, l = hsl.h, hsl.s, hsl.l
  if s == 0 then
    rgb.r = l * 255
    rgb.g = rgb.r
    rgb.b = rgb.r
    return rgb
  end
  local hue = h / 360
  local v1,v2 = nil,nil
  if l < 0.5 then
    v2 = l * (1 + s)
  else
    v2 = (l + s) - l*s
  end
  v1 = 2 * l - v2
  rgb.r = 255 * hueToRgb(v1, v2, hue+1/3)
  rgb.g = 255 * hueToRgb(v1, v2, hue)
  rgb.b = 255 * hueToRgb(v1, v2, hue-1/3)
  return rgb
end

function Color:setBrightness(brt)
  local brt = math.min(brt, 255)
  local brtRnd = ut.round(brt)
  local curBr = self:getBrightness()
  local res = self
  if curBr > 0 then
    res = self * math.min(brt/curBr, 255/self:getPeak())
  end
  if ut.round(res:getBrightness()) == brtRnd then
    return res
  end
  local hsl = Color.rgbToHsl(res)
  local lo, mid, hi = 0, 0, nil
  while true do
    hsl.l = mid
    res = Color.hslToRgb(hsl)
    curBr = res:getBrightness()
    if ut.round(curBr) == brtRnd then
      return res
    elseif curBr < brt then
      if hi == nil then
        lo = 0
        mid = 1
        hi = 1
      elseif mid == 1 then
        break
      else
        lo = mid
        mid = (hi + lo) / 2
      end
    else --curBr > brt
      if mid == 0 then
        break
      else
        hi = mid
        mid = (hi + lo) / 2
      end
    end
  end
  return res
end

function Color:css()
  return "rgba("
    ..ut.round(self.r)..","
    ..ut.round(self.g)..","
    ..ut.round(self.b)..","
    ..ut.round(self.a)..")"
end
