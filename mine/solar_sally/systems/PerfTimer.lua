PerfTimer = {
    last_cpu = 0
}

function PerfTimer.reset()
    PerfTimer.last_cpu = 0
end

function PerfTimer.get_and_advance()
    local cpu = stat(1)
    local elapsed = cpu - PerfTimer.last_cpu
    PerfTimer.last_cpu = cpu
    return elapsed
end