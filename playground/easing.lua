-- Easing functions cheat sheet: https://www.lexaloffle.com/bbs/?tid=40577

function lerp(a,b,t)
    return a+(b-a)*t
end

function easeinquadoutelastic(t)
    if t<.5 then
        return t*t*2
    else
        t-=.5
        return 1-2^(-10*2*t)*cos(2*2*t)/2
    end
end

function animate_movement(setter, begin, ending, num_frames, easer)
    CoroutineRunner_StartScript(function ()
        for frame_num=1, num_frames do
            setter(lerp(begin, ending, easer(frame_num/num_frames)))
            yield()
        end
        -- Make sure we end accurately if the easer doesn't
        setter(ending)
    end)
end

function elastic_around_zero(t)
    -- start at zero, take a bounce that fades, end at zero
    --[[const]] local num_shakes = 10
    --[[const]] local shake_magnitude = 10
    --[[const]] local shake_falloff = 50
    return shake_magnitude*2^(-shake_falloff*t)*sin(num_shakes * t)
end

function shake_screen()
    --[[const]] local num_frames = 50
    CoroutineRunner_StartScript(function ()
        for frame_num=1, num_frames do
            local t = frame_num / num_frames
            local eased_t = elastic_around_zero(t)
            local x_factor = rnd(6)-3
            camera(eased_t/x_factor, eased_t)
            yield()
        end
    end)
end