PerfTimer = {
}

local PerfTimer_startTimes = {}
local PerfTimer_times = {}

function PerfTimer_start(name)
    if(Settings_debug_timing) PerfTimer_startTimes[name] = stat(1)
end

function PerfTimer_stop(name)
    if(Settings_debug_timing) PerfTimer_times[name] = stat(1) - PerfTimer_startTimes[name]
end

function PerfTimer_reportTimes()
    if(not Settings_debug_timing) return
    -- Sort by times

    -- Quicksort requires an index-based array.
    local to_sort = {}
    for name, time in pairs(PerfTimer_times) do
        add(to_sort, {name, time})
    end

    quicksort(to_sort, function (a, b) return a[2] > b[2] end)

    -- Print results
    printh("")
    for item in all(to_sort) do
        printh(tostr(item[1])..": "..tostr(item[2]*100).."%")
    end
end

function PerfTimer_time(name, fn)
    if(Settings_debug_timing) PerfTimer_start(name)
    fn()
    if(Settings_debug_timing) PerfTimer_stop(name)
end