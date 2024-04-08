Cows = {
    cow_ent_ids = {},
    vector_x = {}, -- vector_x[ent_id] = x
    vector_y = {}, -- vector_y[ent_id] = y
    flip_x = {}, -- flip_x[ent_id] = true
    looking = {}, -- looking[ent_id] = true, whether or not the cow is looking at the player
}

function Cows.init()

    for i=1,100 do
        local ent_id = Entities.create_entity()
        add(Cows.cow_ent_ids, ent_id)
        DrawFns.add(ent_id, Cows.draw_cow)
        local x = flr(rnd(100))-50
        local y = flr(rnd(100))-50
        SmoothLocations.set_or_update_location(ent_id, x, y)
        Cows.vector_x[ent_id] = 0
        Cows.vector_y[ent_id] = 0
        Cows.flip_x[ent_id] = rnd() > .5
        Cows.looking[ent_id] = false
    end
end

function Cows.draw_cow(x, y, ent_id)
    -- TODO somehow when the player is moving the cow positions don't look quite right? like the player's movement is causing the cow to vibrate
    -- maybe we need to round the cow's location to the nearest pixel when drawing? a pixel is 1/8 of a tile
    local sprite = Sprite_ids["cow_side"]
    if Cows.looking[ent_id] then
        sprite = Sprite_ids["cow_looking"]
    end
    Sprites.draw_spr(sprite, x, y, 1, 1, Cows.flip_x[ent_id])
end

function Cows.update(elapsed)
    -- TODO move constants here to settings
    for ent_id in all(Cows.cow_ent_ids) do
        -- Sometimes cows look at the player, if they're not moving
        if rnd(100) < 1 and Cows.vector_x[ent_id] == 0 and Cows.vector_y[ent_id] == 0 then
            Cows.looking[ent_id] = true
        end
        -- Sometimes they stop looking at the player
        if rnd(100) < 1 then
            Cows.looking[ent_id] = false
        end
        -- Sometimes cows stop moving
        if rnd(100) < 1 then
            Cows.vector_x[ent_id] = 0
            Cows.vector_y[ent_id] = 0
        end
        -- Sometimes cows start moving
        if rnd(100) < 1 then
            -- Don't look at the player while moving
            Cows.looking[ent_id] = false
            -- TODO we're choosing the vectors on a square and then normalizing them, so it's not a really random direction
            local vx = rnd(2) - 1
            if vx > 0 then
                Cows.flip_x[ent_id] = true
            else
                Cows.flip_x[ent_id] = false
            end
            Cows.vector_x[ent_id] = vx
            Cows.vector_y[ent_id] = rnd(2) - 1
        end
        SmoothLocations.move_by_if_not_obstructed(ent_id, Cows.vector_x[ent_id], Cows.vector_y[ent_id], Settings.cow_speed*elapsed)
    end
end