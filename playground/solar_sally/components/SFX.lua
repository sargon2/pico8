--[[const]] SFX_id_footsteps = 0

local sfx_loops = {} -- sfx_loops[loop_id] = coroutine
local next_loop_id = 1

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
    local loop_id = next_loop_id
    next_loop_id += 1
    sfx_loops[loop_id] = coroutine
    return loop_id
end

function stop_sfx_loop(loop_id)
    if(loop_id == nil) return
    CoroutineRunner_Cancel(sfx_loops[loop_id])
    sfx_loops[loop_id] = nil
end
