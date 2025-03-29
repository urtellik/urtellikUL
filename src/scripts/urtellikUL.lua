urtellikUL = urtellikUL or {}
urtellikUL.pkg = urtellikUL.pkg or {}
setmetatable(
  urtellikUL.pkg,
  {
    __index = function(table, key)
      table[key] = {}
      return table[key]
    end
  }
)
