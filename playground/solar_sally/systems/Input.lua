--[[const]] Button_select_action = 🅾️
--[[const]] Button_take_action = ❎

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
