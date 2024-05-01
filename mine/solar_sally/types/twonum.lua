twonum = {}
-- Supports storing numbers in the range 0 - 327679999.9999847412109375 inclusive.

function twonum:construct(val)
    self.small_val = val
    self.big_val = 0
    self:_carry()
end

function twonum:_carry()
    while self.small_val >= 10000 do
        self.big_val += 1
        self.small_val -= 10000
    end
    while self.small_val < 0 do
        self.big_val -= 1
        self.small_val += 10000
    end
end

function twonum:tostr()
    local ret = ""
    if self.big_val != 0 then
        ret ..= tostr(self.big_val)
        -- pad to four digits pre-decimal
        if(self.small_val < 10) then ret ..= "000"
        elseif(self.small_val < 100) then ret ..= "00"
        elseif(self.small_val < 1000) then ret ..= "0" end
    end
    ret ..= full_tostr(self.small_val)
    return ret
end

-- Supports adding negative numbers.
function twonum:add(n)
    while n > 20000 do -- Avoid overflow. 9999 + 20k < 32k
        self:add(20000)
        n -= 20000
    end
    self.small_val += n
    self:_carry()
end