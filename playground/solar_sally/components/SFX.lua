--[[const]] SFX_id_footsteps = 0
--[[const]] SFX_id_activate_actions = 1
--[[const]] SFX_id_deactivate_actions = 2
--[[const]] SFX_id_rotate_action = 3
--[[const]] SFX_id_move_action = 4

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
