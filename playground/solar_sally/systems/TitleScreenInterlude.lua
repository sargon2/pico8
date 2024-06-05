TitleScreenInterlude = {}

function TitleScreenInterlude.draw()
    --[[const]] local top = 27
    --[[const]] local left = 26
    --[[const]] local left_indented = 36
    --[[const]] local left_sig = 38
    print("a PIECE OF SKY", left, top, 6)
    print("bROKE OFF AND FELL", left, top+8, 6)
    print("tHROUGH THE CRACK", left, top+16, 6)
    print("IN THE CEILING", left_indented, top+24, 6)
    print("rIGHT INTO MY SOUP,", left, top+32, 6)
    print("kerplop!", left, top+40, 6)
    print("- sHEL sILVERSTEIN", left_sig, top+54, 6)

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