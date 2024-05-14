--[[const]] SFX_id_footsteps = 0

function start_sfx_loop(sfx_id, frame_count)
    if(not Settings_60fps) frame_count /= 2
    local coroutine = CoroutineRunner_StartScript(function ()
        while true do
            sfx(sfx_id)
            for _=1,frame_count do
                yield()
            end
        end
    end)
    return coroutine
end
