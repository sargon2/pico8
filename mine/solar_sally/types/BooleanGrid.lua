
BooleanGrid = {}

function BooleanGrid:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.values = table_with_default_table_inserted()

    return o
end

function BooleanGrid:set(x, y)
    self.values[x][y] = true
end

function BooleanGrid:unset(x, y)
    del(self.values[x][y])
end

function BooleanGrid:is_set(x, y)
    return self.values[x][y]
end