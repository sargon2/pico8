TitleScreen = {}

function TitleScreen.on_enable()
    -- Decompress to the screen
    rle1(title_image, 0, 0)
    -- Copy the screen to working memory
    memcpy(0x8000, 0x6000, 0x2000)
end

function TitleScreen.draw()
    -- Copy working memory back to the screen to redraw it after the main loop's cls()
    memcpy(0x6000, 0x8000, 0x2000)

    -- Superimpose text
    --[[const]] local text_u = 120
    --[[const]] local text_r = 31
    print_outlined("press ", text_r, text_u, 7)
    print_outlined(Button_display_take_action, text_r+23, text_u, 8)
    print_outlined("to start", text_r+34, text_u, 7)
end

-- from https://www.lexaloffle.com/bbs/?tid=45020
function print_outlined(s,...)
    for i in all(split'\-f\f0,\-h\f0,\|f\f0,\|h\f0') do
    ?i..s,...
    end
    ?s,...
end

function TitleScreen.update()
    if my_btnp(Button_take_action) then
        CoroutineRunner_StartScript(function()
            fade_out()
            Modes_switch_mode(Mode_TitleScreenInterlude)
            SmoothLocations_set_or_update_location(Entities_Character, 7, 7)
            fade_in()
        end)
    end
end

-- https://www.lexaloffle.com/bbs/?tid=38829

--1.basic version (74 tokens)
--specify string name and 
--screen x&y coords for top
--left corner of image. tr is
--the transparency color (this
--saves cpu and allows drawing
--over other graphics like a
--sprite, no transparency if
--left blank).

function rle1(s,x0,y,tr)
    local x,mw=x0,x0+ord(s,2)-96
    for i=5,#s,2do
        local col,len=ord(s,i)-96,ord(s,i+1)-96
        if(col!=tr) line(x,y,x+len-1,y,col)
        x+=len if(x>mw) x=x0 y+=1
    end
end
