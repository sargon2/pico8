Cows = {
    name = "Cows",
    cow_ent_ids = {},
    vector_x = {}, -- vector_x[ent_id] = x
    vector_y = {}, -- vector_y[ent_id] = y
    flip_x = {}, -- flip_x[ent_id] = true -- TODO should this be an attribute?
    looking = {}, -- looking[ent_id] = true, whether or not the cow is looking at the player
    is_cow = {}, -- is_cow[ent_id] = true -- to speed up updating. TODO should it be an attribute?
}

function Cows.init()

    for _=1,5000 do
        local ent_id = Entities_create_entity()
        add(Cows.cow_ent_ids, ent_id)
        Attr_DrawFn[ent_id] = Cows.draw_cow

        local x = flr(rnd(1000))-500
        local y = flr(rnd(1000))-500
        SmoothLocations_set_or_update_location(ent_id, x, y)
        Cows.vector_x[ent_id] = 0
        Cows.vector_y[ent_id] = 0
        Cows.flip_x[ent_id] = rnd() > .5
        Cows.looking[ent_id] = false
        Cows.is_cow[ent_id] = true
    end
end

function Cows.draw_cow(x, y, ent_id)
    local sprite = Sprite_id_cow_side
    if Cows.looking[ent_id] then
        sprite = Sprite_id_cow_looking
    end
    Sprites_draw_spr(sprite, x, y, 1, 1, Cows.flip_x[ent_id])
end

function Cows.update(elapsed)
    -- TODO move constants here to settings

    -- TODO this bounding is duplicated with world.draw()
    local char_x, char_y = SmoothLocations_get_location(Entities_Character)

    local xmin, xmax, ymin, ymax = flr(char_x - 10), flr(char_x + 8), flr(char_y - 9), flr(char_y + 9) -- TODO increase bounding box size for cows? so they move slightly off-screen

    local smooth_ents = SmoothLocations_get_all_visible(xmin, xmax, ymin, ymax)

    for ent_tuple in all(smooth_ents) do
        local ent_id = ent_tuple[1] -- TODO all we're using is ent_id, can we use a faster getter that only returns those?
        -- Is it a cow?
        if Cows.is_cow[ent_id] then
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
            SmoothLocations_move_by_if_not_obstructed(ent_id, Cows.vector_x[ent_id], Cows.vector_y[ent_id], Settings_cow_speed*elapsed)
        end
    end
end