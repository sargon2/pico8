Input_AllInputDisabled = false

function my_btn(...)
    if(Input_AllInputDisabled) return false
    return btn(...)
end

function my_btnp(...)
    if(Input_AllInputDisabled) return false
    return btnp(...)
end