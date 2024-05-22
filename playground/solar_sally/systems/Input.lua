-- On mobile, x is on the left and o is on the right.
-- On a pc, x is x and o is z, so x is on the right and o is on the left.

--[[const]] Button_select_action = ❎
--[[const]] Button_take_action = 🅾️

local Input_AllInputDisabled = false

function my_btn(...)
    if(Input_AllInputDisabled) return false
    return btn(...)
end

function my_btnp(...)
    if(Input_AllInputDisabled) return false
    return btnp(...)
end

function disableInputFor(fn)
    Input_AllInputDisabled = true
    fn()
    Input_AllInputDisabled = false
end
