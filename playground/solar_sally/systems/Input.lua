-- On mobile, x is on the left and o is on the right.
-- On a pc, x is x and o is z, so x is on the right and o is on the left.

-- We can't use the predefined button constants (❎, 🅾️) because shrinko8 doesn't recognize them for constants.
-- o is 4 and x is 5.
--[[const]] Button_select_action = 5
--[[const]] Button_take_action = 4

local Input_AllInputDisabled = false

function my_btn(...)
    if(Input_AllInputDisabled) return false
    return btn(...)
end

function my_btnp(...)
    if(Input_AllInputDisabled) return false
    return btnp(...)
end

function disableInput()
    Input_AllInputDisabled = true
end

function enableInput()
    Input_AllInputDisabled = false
end
