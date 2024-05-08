
CoroutineRunner = {
    name = "CoroutineRunner",
}

local CoroutineRunner_Scripts = {}

function CoroutineRunner_StartScript(s)
    add(CoroutineRunner_Scripts, cocreate(s))
end

function CoroutineRunner.update()
    local s = {}
    for f in all(CoroutineRunner_Scripts) do
        if f and costatus(f) != 'dead' then
            local succeeded, err = coresume(f)
            if(not succeeded) printh(err)
            add(s, f)
        end
    end
    CoroutineRunner_Scripts = s -- remove finished scripts
end
