SleepResults = {}

function SleepResults.draw()
    print("sleep results go here", 16, 16, 6)
    print("press "..Button_display_take_action.." to continue", 16, 24, 6)
end

function SleepResults.update()
    if my_btnp(Button_take_action) then
        CoroutineRunner_StartScriptWithFade(function()
            Modes_return_to_previous_mode()
        end)
    end
end