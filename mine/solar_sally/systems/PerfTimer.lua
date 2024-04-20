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
    -- TODO sort by times desc
    printh("")
    for name, time in pairs(PerfTimer.times) do
        printh(tostr(name)..": "..tostr(time*100).."%")
    end
end