-- Easing functions cheat sheet: https://www.lexaloffle.com/bbs/?tid=40577

function lerp(a,b,t)
    return a+(b-a)*t
end

function easeinoutelastic(t)
    if t<.5 then
        return 2^(10*2*t-10)*cos(2*2*t-2)/2
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
    end)
end
