solar_sally_systems = {} -- ordered, index-based list
solar_sally_loaded_systems = {} -- cache for speed of system_is_loaded(); map of system to boolean

function system_is_loaded(s)
    return solar_sally_loaded_systems[s]
end

function unload_system(s)
    if(s.destroy) s.destroy()
    del(solar_sally_systems, s)
    solar_sally_loaded_systems[s] = nil
end

function load_system(s, idx)
    if(s.init) s.init()
    if(not s.draw and not s.update) return -- If it doesn't have a draw or an update, there's no reason to keep it around
    add(solar_sally_systems, s, idx)
    solar_sally_loaded_systems[s] = true
end

function _init()
    --srand(12345)

    -- The order here is important (think dep injection dependency graph)
    load_system(Rocks)
    load_system(Trees)
    load_system(Panels)
    load_system(Wire)
    load_system(GridWire)
    load_system(Transformers)
    load_system(Fence)
    load_system(Button)
    load_system(World)
    load_system(Cows)
    load_system(Inventory)
    load_system(Placement)
    load_system(Character)
    load_system(PanelCalculator)
    load_system(CoroutineRunner)
end

function _draw()
    cls()

    for system in all(solar_sally_systems) do
        if system.draw then
            PerfTimer_time(get_var_name(system)..".draw()", function ()
                system.draw()
            end)
        end
    end
    if(Settings_debug_window) db_window()
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
        if system.update then
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
