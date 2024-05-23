TitleScreenInterlude = {}

function TitleScreenInterlude.draw()
    print("oNCE UPON A TIME,", 8, 16, 6)
    print("THERE LIVED A YOUNG WOMAN", 16, 24, 6)
    print("WITH A PROFOUND LOVE FOR", 16, 32, 6)
    print("THE WORLD.", 16, 40, 6)

    print("tHOUGH SHE WAS TOUCHED BY", 8, 56, 6)
    print("GRAVE MISFORTUNE,", 16, 64, 6)

    print("SHE COULD NOT FORGET", 8, 80, 6)
    print("HER LOVE.", 16, 88, 6)

    print("press "..Button_display_take_action.." to continue", 25, 118, 10)
end

function TitleScreenInterlude.update()
    if my_btnp(Button_take_action) then
        CoroutineRunner_StartScriptWithFade(function()
            Modes_switch_mode(Mode_SallysHouse)
            SmoothLocations_set_or_update_location(Entities_Character, 7, 7)
        end)
    end
end