
BooleanGrid = {}

function BooleanGrid:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.values = {}

    return o
end

function BooleanGrid:set(x, y)
    if(not self.values[x]) self.values[x] = {}
    self.values[x][y] = true
end

function BooleanGrid:unset(x, y)
    if(not self.values[x]) return
    self.values[x][y] = nil
    if(not next(self.values[x])) self.values[x] = nil
end

function BooleanGrid:is_set(x, y)
    if(not self.values[x]) return false
    return self.values[x][y]
end