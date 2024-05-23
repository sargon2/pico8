TitleScreen = {}

function TitleScreen.draw()
    print("title screen not done yet", 16, 16, 6)
    print("press "..Button_display_take_action.." to continue", 16, 24, 6)
end

function TitleScreen.update()
    if my_btnp(Button_take_action) then
        CoroutineRunner_StartScriptWithFade(function()
            Modes_switch_mode(Mode_TitleScreenInterlude)
        end)
    end
end