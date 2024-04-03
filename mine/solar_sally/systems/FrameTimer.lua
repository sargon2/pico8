FrameTimer = {
    last_t=0,
}

function FrameTimer.calculate_elapsed()
    -- Handle physics advancement timing

    -- t(), time(), and stat(7) seem to return the _intended_ time per frame, not the actual, regardless of if they're called from _draw or _update60.  It doesn't appear possible to get the actual frame time.

    -- local ft = time()
    -- local elapsed = ft - FrameTimer.last_t
    -- FrameTimer.last_t = ft

    -- local elapsed = 1 / stat(7)

    -- local max_skip_fps = 2
    -- local max_elapsed = 1 / max_skip_fps
    -- if elapsed > max_elapsed then
    --     -- make sure we don't skip physics too far if the game hiccups
    --     elapsed = max_elapsed
    -- end

    -- So, until that's fixed, we just return the intended time, and let the game slow down.
    local elapsed = 1 / 60

    return elapsed
end