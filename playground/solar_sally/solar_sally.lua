solar_sally_systems = {} -- ordered, index-based list
solar_sally_loaded_systems = {} -- which systems are loaded
solar_sally_running_systems = {} -- which systems are running

function system_is_running(s)
    return solar_sally_running_systems[s]
end

-- function _unload_system(s)
--     disable_system(s)
--     if(s.on_unload) s.on_unload()
--     del(solar_sally_systems, s)
--     solar_sally_loaded_systems[s] = nil
-- end

function _load_system(s)
    if(s.on_load) s.on_load()
    solar_sally_loaded_systems[s] = true
    if(not s.draw and not s.update) return -- If it doesn't have a draw or an update, there's no reason to keep it around
    add(solar_sally_systems, s)
end

function enable_system(s)
    if(not solar_sally_loaded_systems[s]) _load_system(s)
    if(s.on_enable) s.on_enable()
    solar_sally_running_systems[s] = true
    -- Move it to the end of the system order so the mode can control render order
    del(solar_sally_systems, s)
    add(solar_sally_systems, s)
end

function disable_system(s)
    if(s.on_disable) s.on_disable()
    solar_sally_running_systems[s] = nil
end

function _init()
    --srand(12345)

    enable_system(CoroutineRunner) -- Bootstrap so we can change mode; Modes will enable other systems
    enable_system(Modes)

    -- Transition to initial mode
    CoroutineRunner_StartScript(function ()
        fade_out()
        Modes_switch_mode(Mode_TitleScreen)
        fade_in()
    end)
end

function _draw()
    cls()

    for system in all(solar_sally_systems) do
        if system.draw and solar_sally_running_systems[system] then
            PerfTimer_time(get_var_name(system)..".draw()", function ()
                system.draw()
            end)
        end
    end
    PerfTimer_reportTimes()
end

function do_update()
    local elapsed = FrameTimer_calculate_elapsed()

    if Settings_debug_print_loaded_systems then
        local p = ""
        for system in all(solar_sally_systems) do
            p ..= get_var_name(system) .. ", "
        end
        printh_all("Loaded systems", p)
    end

    for system in all(solar_sally_systems) do
        if system.update and solar_sally_running_systems[system] then
            PerfTimer_time(get_var_name(system)..".update()", function ()
                system.update(elapsed)
            end)
        end
    end
end

-- The debug tree window scroll wheel doesn't work at 60 fps, so if that's enabled, drop to 30.
if Settings_60fps then
    function _update60()
        do_update()
    end
else
    function _update()
        do_update()
    end
end

function advance_time_days(d)
    PanelCalculator_add_panel_days(d)
    Trees_advanceTimeDays(d)
    Cows_advanceTimeDays(d)
end
