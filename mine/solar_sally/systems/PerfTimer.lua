PerfTimer = {
    startTimes = {},
    times = {},
}

function PerfTimer.start(name)
    PerfTimer.startTimes[name] = stat(1)
end

function PerfTimer.stop(name)
    PerfTimer.times[name] = stat(1) - PerfTimer.startTimes[name]
end

function PerfTimer.reportTimes()
    -- Sort by times

    -- Quicksort requires an index-based array.
    local to_sort = {}
    for name, time in pairs(PerfTimer.times) do
        add(to_sort, {name, time})
    end

    quicksort(to_sort, function (a, b) return a[2] > b[2] end)

    -- Print results
    printh("")
    for item in all(to_sort) do
        printh(tostr(item[1])..": "..tostr(item[2]*100).."%")
    end
end