fadetoblack = {
    name = "fadetoblack",
}

-- TODO is any of this needed outside of the coroutine functions?
local fadetoblack_fade_state = 0 -- 0=no fade in progress, 1=fading out, -1=fading in
local fadetoblack_current_fade_level = 0

function fadetoblack_start_fade()
    fadetoblack_fade_state = 1
end

function fadetoblack_start_fade_in()
    fadetoblack_fade_state = -1
end

function fadetoblack.update()
    if fadetoblack_fade_state != 0 then
        fadetoblack_current_fade_level += fadetoblack_fade_state
        if fadetoblack_current_fade_level > 0 and fadetoblack_current_fade_level <= 24 then
            fade(fadetoblack_current_fade_level)
        else
            fadetoblack_fade_state = 0
        end
    end
end

-- Functions suitable for use as coroutines
function fadeAndDisableInputForCo(fn)
    CoroutineRunner_StartScript(function ()
        fadetoblack_fade_co()
        disableInputFor(fn)
        fadetoblack_fadein_co()
    end)
end

function fadetoblack_fade_co()
    local f = 0
    for f=1,24 do
        fade(f)
        yield()
    end
end

function fadetoblack_fadein_co()
    local f = 0
    for f=24,1,-1 do
        fade(f)
        yield()
    end
end

-- http://kometbomb.net/pico8/fadegen.html
-- 1. change settings on site (current settings: defaults except length 24)
-- 2. change bounds in fadetoblack.update() to match settings
-- 3. paste it in here
-- 4. transform to lower case
-- 5. format code

local fadetable = {
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1, 1, 1, 1, 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 0, 0, 0, 0, 0, 0, 0 },
    { 2, 2, 2, 2, 2, 130, 130, 130, 130, 130, 130, 130, 130, 128, 128, 128, 128, 128, 128, 0, 0, 0, 0 },
    { 3, 3, 3, 3, 3, 131, 131, 131, 131, 131, 129, 129, 129, 129, 129, 129, 129, 129, 0, 0, 0, 0, 0 },
    { 4, 4, 4, 4, 132, 132, 132, 132, 132, 132, 132, 132, 130, 130, 128, 128, 128, 128, 128, 128, 0, 0, 0 },
    { 5, 5, 5, 133, 133, 133, 133, 133, 133, 133, 130, 130, 128, 128, 128, 128, 128, 128, 128, 0, 0, 0, 0 },
    { 6, 6, 6, 134, 134, 13, 13, 13, 13, 13, 5, 5, 5, 5, 5, 133, 133, 130, 128, 128, 128, 128, 0 },
    { 7, 7, 6, 6, 6, 6, 6, 134, 134, 134, 134, 134, 141, 5, 5, 5, 133, 133, 130, 128, 128, 128, 0 },
    { 8, 8, 8, 136, 136, 136, 136, 136, 136, 136, 132, 132, 132, 132, 130, 130, 128, 128, 128, 128, 128, 0, 0 },
    { 9, 9, 9, 9, 9, 4, 4, 4, 4, 4, 132, 132, 132, 132, 132, 132, 128, 128, 128, 128, 128, 0, 0 },
    { 10, 10, 10, 138, 138, 138, 138, 138, 4, 4, 4, 4, 132, 132, 132, 132, 133, 128, 128, 128, 128, 128, 0 },
    { 11, 11, 139, 139, 139, 139, 139, 139, 3, 3, 3, 3, 3, 131, 129, 129, 129, 129, 128, 0, 0, 0, 0 },
    { 12, 12, 12, 12, 140, 140, 140, 140, 140, 140, 140, 131, 131, 131, 131, 1, 1, 129, 129, 129, 129, 0, 0 },
    { 13, 13, 13, 13, 141, 141, 141, 5, 5, 5, 133, 133, 133, 133, 130, 130, 129, 129, 128, 128, 128, 0, 0 },
    { 14, 14, 14, 14, 134, 134, 134, 141, 141, 141, 141, 2, 2, 2, 133, 133, 130, 130, 128, 128, 128, 128, 0 },
    { 15, 15, 143, 143, 134, 134, 134, 134, 134, 134, 134, 5, 5, 5, 5, 133, 133, 133, 130, 128, 128, 128, 0 }
}

function fade(i)
    for c = 0, 15 do
        if flr(i + 1) >= 24 then
            pal(c, 0)
        else
            pal(c, fadetable[c + 1][flr(i + 1)])
        end
    end
end