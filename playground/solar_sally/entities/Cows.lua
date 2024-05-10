Cows = {
    name = "Cows"
}

local Cows_cow_ent_ids = {}
local Cows_vector_x = {} -- vector_x[ent_id] = x
local Cows_vector_y = {} -- vector_y[ent_id] = y
local Cows_looking = {} -- looking[ent_id] = true, whether or not the cow is looking at the player
local Cows_is_cow = {} -- is_cow[ent_id] = true -- to speed up updating

function Cows.init()

    for _=1,5000 do
        local ent_id = Entities_create_entity()
        add(Cows_cow_ent_ids, ent_id)
        Attr_DrawFn[ent_id] = Cows_draw_cow

        local x = flr(rnd(1000))-500
        local y = flr(rnd(1000))-500
        SmoothLocations_set_or_update_location(ent_id, x, y)
        Cows_vector_x[ent_id] = 0
        Cows_vector_y[ent_id] = 0
        Attr_flip_x[ent_id] = rnd() > .5
        Cows_looking[ent_id] = false
        Cows_is_cow[ent_id] = true
    end
end

function Cows_draw_cow(x, y, ent_id)
    local sprite = Sprite_id_cow_side
    if Cows_looking[ent_id] then
        sprite = Sprite_id_cow_looking
    end
    Sprites_draw_spr(sprite, x, y, 1, 1, Attr_flip_x[ent_id])
end

function Cows.update(elapsed)
    local xmin, xmax, ymin, ymax = World_get_visible_ranges()
    local smooth_ents = SmoothLocations_get_all_visible(xmin, xmax, ymin, ymax)

    for ent_tuple in all(smooth_ents) do
        local ent_id = ent_tuple[1]
        -- Is it a cow?
        if Cows_is_cow[ent_id] then
            -- Sometimes cows look at the player, if they're not moving
            if rnd(Settings_cow_look_chance) < 1 and Cows_vector_x[ent_id] == 0 and Cows_vector_y[ent_id] == 0 then
                Cows_looking[ent_id] = true
            end
            -- Sometimes they stop looking at the player
            if rnd(Settings_cow_stop_looking_chance) < 1 then
                Cows_looking[ent_id] = false
            end
            -- Sometimes cows stop moving
            if rnd(Settings_cow_stop_moving_chance) < 1 then
                Cows_vector_x[ent_id] = 0
                Cows_vector_y[ent_id] = 0
            end
            -- Sometimes cows start moving
            if rnd(Settings_cow_start_moving_chance) < 1 then
                -- Don't look at the player while moving
                Cows_looking[ent_id] = false
                local vx = rnd(2) - 1
                Attr_flip_x[ent_id] = vx > 0
                Cows_vector_x[ent_id] = vx
                Cows_vector_y[ent_id] = rnd(2) - 1
            end
            SmoothLocations_move_by_if_not_obstructed(ent_id, Cows_vector_x[ent_id], Cows_vector_y[ent_id], Settings_cow_speed*elapsed)
        end
    end
end

function Cows_advanceTimeDays(d)
    for _=1,100 do -- Need to run it enough times to ensure the cow is moving at least once
        Cows.update(d)
    end
end