
CoroutineRunner = {}

local CoroutineRunner_Scripts = {}

function CoroutineRunner_StartScript(s)
    local c = cocreate(s)
    add(CoroutineRunner_Scripts, c)
    return c
end

function CoroutineRunner_StartScriptWithFade(s)
    CoroutineRunner_StartScript(function ()
        fade_out()
        s()
        fade_in()
    end)
end

function CoroutineRunner.update()
    local s = {}
    for f in all(CoroutineRunner_Scripts) do
        if f and costatus(f) != 'dead' then
            local succeeded, err = coresume(f)
            if(not succeeded) then
                printh(err)
                printh(trace(f))
            end
            add(s, f)
        end
    end
    CoroutineRunner_Scripts = s -- remove finished scripts
end

function CoroutineRunner_Cancel(c)
    if(c == nil) return
    del(CoroutineRunner_Scripts, c)
end

function yield_for_seconds(s) -- supports partial seconds
    local fps = 30
    if(Settings_60fps) fps = 60
    local total_frames = s * fps
    for _=1,total_frames do
        yield()
    end
end

function fade_out()
    disableInput()
    for f=1,24 do
        fade(f)
        yield()
    end
end

function fade_in()
    for f=24,1,-1 do
        fade(f)
        yield()
    end
    enableInput()
end

