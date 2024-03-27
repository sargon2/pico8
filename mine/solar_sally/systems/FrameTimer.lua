FrameTimer = {
    last_t=0,
}

function FrameTimer.calculate_elapsed()
    -- Handle physics advancement timing
    local ft=t()
    local elapsed=ft-FrameTimer.last_t
    FrameTimer.last_t=ft
    local max_skip_fps=15
    local max_elapsed=1/max_skip_fps
    if elapsed>max_elapsed then
        -- make sure we don't skip physics too far if the game hiccups
        elapsed=max_elapsed
    end
    return elapsed
end