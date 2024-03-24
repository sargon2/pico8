
-- todo
-- add total electricity generated
-- add energy storage
-- add day/night cycle
-- add panel inventory
-- add money to buy panels
-- add store to buy panels from
-- add trees
-- add houses?

char = {
    x=0,
    y=0,
    frame=1,
    speed=6,
    anim_speed=8,
    anim_frames={1,2},
    flip_x=false,
    -- selected square
    sel_x_p=0, -- "precise" (sub-integer)
    sel_y_p=0,
    sel_x=0,
    sel_y=0,
    is_moving = false,
    is_placing = false,
    is_removing = false,
    sel_sprite = "no_action",
    place_mode = "place_panel",
}

sprites = {
    transformer_left = 18,
    transformer_right = 19,
    selection_box = 32,
    place_panel = 33,
    pick_up = 34,
    no_action = 35,
    place_wire = 36,
    rock = 48,
    wire_left = 49,
    wire_right = 50,
    wire_up = 51,
    wire_down = 52,
}

-- TODO this probably shouldn't live here
function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
 end


-- These are a 2d array of booleans to make random access easier.
-- [x] = {[y]=true}
-- TODO should I combine these into a single structure?
panel_locations = table_with_default_val_inserted({})
wire_locations = table_with_default_val_inserted({})
transformer_left_locations = {
    [2] = {[2]=true}
}
transformer_right_locations = {
    [3] = {[2]=true}
}

last_t=0

function draw_char(char,x,y)
    local f=char.anim_frames[
        1+(flr(char.frame) % #char.anim_frames)
    ]
    spr(f,x,y,1,1,char.flip_x)
end

function draw_selection(char)
    draw_spr(sprites["selection_box"],char.sel_x,char.sel_y)
    draw_spr(sprites[char.sel_sprite],char.sel_x,char.sel_y-1)
end

-- TODO move this elsewhere
RockComponent = ECSComponent:new()
RockComponent.component_type = "RockComponent"
RockComponent.__index = RockComponent

function RockComponent:new(entity_id, data)
    local o = {}
    setmetatable(o, self)

    o.entity_id = entity_id

    -- Rock contains a nested Location
    ecs:associate_component(entity_id, LocationComponent, data)

    return o
end

function _init()
    srand(12345) -- it isn't a procedural game, we want to be able to tune the experience, so we need rands to be consistent
    distribute_rocks()
end

function distribute_rocks()
    for i=0,1000 do
        x = flr(rnd(100))
        y = flr(rnd(100))
        rock_ent_id = ecs:create_entity()
        ecs:associate_component(rock_ent_id, RockComponent, {x = x, y = y})
    end
end

function draw_simple(tbl, spritenum)
    for x,ys in pairs(tbl) do
        for y,t in pairs(ys) do
            draw_spr(spritenum,x,y)
        end
    end
end

function draw_rocks()
    -- TODO this method is very slow and is taking up 40% of our entire frame budget
    for c in all(ecs:get_all_components_with_type(RockComponent)) do
        -- Get the rock's location component
        l = ecs:get_component(c.entity_id, LocationComponent)
        draw_spr(sprites["rock"], l.x, l.y)
    end 
end

function draw_transformers()
    draw_simple(transformer_left_locations, sprites["transformer_left"])
    draw_simple(transformer_right_locations, sprites["transformer_right"])
end

function draw_wire_tile(x, y)
    local left = thing_at(x-1,y, "wire")
    local right = thing_at(x+1,y, "wire")
    local up = thing_at(x,y-1, "wire")
    local down = thing_at(x,y+1, "wire")

    -- straight has a couple of special cases (0 or 1 connections)
    if not up and not down then
        draw_spr(sprites["wire_left"], x, y)
        draw_spr(sprites["wire_right"], x, y)
        return
    end
    if not left and not right then
        draw_spr(sprites["wire_up"], x, y)
        draw_spr(sprites["wire_down"], x, y)
        return
    end

    -- the other cases are all straightforward.  The order here matters for wire overlap.
    if up then
        draw_spr(sprites["wire_up"], x, y)
    end
    if left then
        draw_spr(sprites["wire_left"], x, y)
    end
    if right then
        draw_spr(sprites["wire_right"], x, y)
    end
    if down then
        draw_spr(sprites["wire_down"], x, y)
    end
end

function draw_wire()
    for x,ys in pairs(wire_locations) do
        for y,t in pairs(ys) do
            draw_wire_tile(x,y)
        end
    end
end

function _draw()
    cls()
    map(0,0,64-(char.x*8),64-(char.y*8))
    draw_rocks()
    draw_panels()
    draw_wire()
    draw_transformers()
    draw_char(char, 64, 64)
    draw_selection(char)
end

function draw_spr(s,x,y)
    local changed_transparency = false
    if fget(s, 0) then
        -- flag 0 means "use purple as transparent"
        palt(0b0010000000000000) -- purple
        changed_transparency = true
    end
    spr(
        s,
        (8+x-char.x)*8,
        (8+y-char.y)*8
    )
    if changed_transparency then
        palt()
    end
end

function iter_thing_types(key)
    -- TODO finish converting these to components
    thing_types = {
        wire = {wire_locations},
        panel = {panel_locations},
        rock = {},
        placeable = {"panel", "wire"},
        walking_obstruction = {"panel", "rock"},
        anything = {"panel", "wire", "rock"},
    }

    local stack = {key}
    return function()
        while #stack > 0 do
            local next = deli(stack)
            if type(next) == "string" then
                for i = 1, #thing_types[next] do
                    add(stack, thing_types[next][i]) -- Push items to be processed onto the stack
                end
            else
                return next -- Yield value
            end
        end
    end
end

-- for each entity that has the "location" component,
-- for each entity that has both the "location" component and the "placeable" component/attribute
-- for each placeable entity
-- should a single panel be an entity or should "panels" collectively be an entity?
-- - seems more flexible for a single panel to be an entity
-- get_entities_with_component("placeable")
-- a component can just be a boolean attribute
-- recursive component groups -> archetypes like "placeable"
-- a component can be a set of other components
-- id = create_entity(...)
-- associate_component_with_entity(id, component)
-- entity.associate_component(component) vs. component.associate_entity(id)
-- does a component just have a list of entity ids associated with it? that'd make iterating them easy
-- create_panel() would be just like.. create an entity id, associate panel components with it, like sprite.add_entity(panel_id, sprites["panel"])
-- so associating component with entity should validate all the data needed for the component is provided
-- recursive components shouldn't have a list of ids though... and a components' child components' ids could be duplicates
-- - the list could be built on the fly.. is that fast enough? is that better than storing and maintaining a list of ids on the recursive component?
-- adding a recursive component to an entity would need to take data for all the children of the recursive component, which means the method signature would change if the child components changed
-- - this may be why archetypes are a different type than components in unity
-- - it could just take a variable-size list of structs
-- if I add "placeable" to one entity, then directly add "panel" and "wire" to another entity, then request the list of "placeable", it should NOT include the panel/wire entity.
-- - An example of this would be a new item which is both a panel and a wire, but is not placeable.
-- - This means recursive entities MUST store their own list of entities.
-- - I'm off in the weeds here.  This kind of problem would get solved via implementation.
-- - if something is "placeable" that doesn't ever mean it's both panel and wire.
-- "get all placeable items" -> get all wire, get all panels, (deduplicate?), return
-- "is there a placeable thing at x/y?" -> "is there a wire at x/y?" followed by "is there a panel at x/y?"
-- - should this be "get all things at x/y", "are any of them panel or wire?"?
-- - "get all things at x/y" and "get all wire" should both be valid ways to get lists of entity ids
-- - "get all things at x/y" looks like "get all entities with a location component", "foreach query the location component for its x/y"
-- - "get all wire" looks like "get all entities with a wire component", "get the location component for each & query its x/y"
-- - so we definitely need "given an entity id, get its location component"
-- - - "get_component(entity_id, component_type)" -- in c# this would be generic
-- - - maybe "location_component_manager.get_component(entity_id)"
-- do we need "get all components associated with this entity id"?
-- - maybe not
--
-- get_component(entity_id, component_type)
-- get_all_entities(component) -- including compound components, which might mean deduplicating or storing redundant data
-- get_all_components(entity_id) -- may not be needed
--
-- then thing_at could be implemented as:
-- function thing_at(x, y, thing_type)
--     for ent in get_all_entities(thing_type) do
--         l = get_component(ent, location)
--           if l.x == x and l.y == y then
--               return true
--           end
--     end
--     return false
-- end
--
-- OR
--
-- function thing_at(x, y, thing_type)
--     for ent in get_all_entities(location) do
--         if ent.x == x and ent.y == y and get_component(ent, thing_type) then
--             return true
--         end
--     end
--     return false
-- end
--
-- maybe the first one is faster because the number of wires is smaller than the number of things with a location? not sure
--
-- associate_component(entity_id, component_type, data)
-- id = create_entity()

function thing_at(x, y, thing_type)
    for tbl in iter_thing_types(thing_type) do
        if tbl[x][y] then
            return true
        end
    end
    return false
end

function draw_panels()
    local overlays=table_with_default_val_inserted({})
    for x,ys in pairs(panel_locations) do
        for y,t in pairs(ys) do
            -- draw overlays
            -- careful about leg length
            if thing_at(x+1, y+1, "panel") then
                -- short legs override long
                if not overlays[x][y] then
                    if thing_at(x, y+1, "panel") then
                        overlays[x][y]=2
                    else
                        overlays[x][y]=1
                    end
                end
            end
            if thing_at(x+1, y-1, "panel") then
                overlays[x][y-1]=2
            end
            draw_spr(17,x,y)
        end
    end
    for x,row in pairs(overlays) do
        for y,v in pairs(row) do
            draw_spr(21,x,y)
            draw_spr(38,x+1,y+1)
            draw_spr(22,x+1,y)
            if v==1 then
                draw_spr(37,x,y+1) -- long leg
            else
                draw_spr(53,x,y+1) -- short leg
            end
        end
    end
end

function bound(val, min, max)
    if val < min then
        return min
    elseif val > max then
        return max
    end
    return val
end

function handle_frame_timing()
    -- Handle physics advancement timing
    ft=t()
    elapsed=ft-last_t
    last_t=ft
    max_skip_fps=15
    max_elapsed=1/max_skip_fps
    if elapsed>max_elapsed then
        -- make sure we don't skip physics too far if the game hiccups
        elapsed=max_elapsed
    end
    return elapsed
end

function _update60()
    elapsed = handle_frame_timing()
    handle_player_movement(elapsed)
    handle_selection_and_placement()
end

function handle_player_movement(elapsed)

    -- Check for player movement
    local x=0
    local y=0
    local is_moving = false
    if btn(⬅️) then
        char.flip_x=true
        char.anim_frames={1,2}
        x=-1
        is_moving = true
    end
    if btn(➡️) then
        char.anim_frames={1,2}
        char.flip_x=false
        x=1
        is_moving = true
    end
    if btn(⬆️) then
        char.anim_frames={3,4}
        y=-1
        is_moving = true
        if btn(⬅️) or btn(➡️) then
            char.anim_frames={9,10}
        end
    end
    if btn(⬇️) then
        char.anim_frames={7,8}
        y=1
        is_moving = true
        if btn(⬅️) or btn(➡️) then
            char.anim_frames={5,6}
        end
    end

    -- Calculate if it's the first movement frame or not
    is_first_movement_frame = false
    if is_moving and not char.is_moving then
        is_first_movement_frame = true
    end
    char.is_moving = is_moving

    -- Process player movement

    max_sel_range=2
    sel_speed = 12

    -- Is it the first movement frame?
    if is_first_movement_frame then
        -- If it's the first movement frame, we want to kickstart the movement, but not too far so we don't jump twice.
        -- This is so a single-frame tap will always move the selection box, for responsiveness.
        x=x/2
        y=y/2
    else
        -- Then for subsequent frames, we normalize the movement speed to the frame rate.
        x, y = normalize(x, y, sel_speed*elapsed) -- TODO vector type instead of tuple?
    end
    char.sel_x_p += x
    char.sel_y_p += y

    -- If we're at the max selection range, move the character
    char_x = 0
    char_y = 0
    if char.sel_x_p > char.x + max_sel_range + .5 then
        char_x = 1
        char.sel_x_p = char.x + max_sel_range + .5
    elseif char.sel_x_p < char.x - max_sel_range + .5 then
        char_x = -1
        char.sel_x_p = char.x - max_sel_range + .5
    end
    if char.sel_y_p > char.y + max_sel_range + .5 then
        char_y = 1
        char.sel_y_p = char.y + max_sel_range + .5
    elseif char.sel_y_p < char.y - max_sel_range + .5 then
        char_y = -1
        char.sel_y_p = char.y - max_sel_range + .5
    end
    char_x, char_y = normalize(char_x, char_y, char.speed*elapsed)
    char.sel_x = flr(char.sel_x_p)
    char.sel_y = flr(char.sel_y_p)
    -- The player can't walk through panels
    if not thing_at(
        flr(char.x+char_x+.6),
        flr(char.y+1),
        "walking_obstruction"
    ) then
        char.x += char_x
    end
    if not thing_at(
        flr(char.x+.6),
        flr(char.y+char_y+1),
        "walking_obstruction"
    ) then
        char.y += char_y
    end
    -- Animate walking
    if char_x!=0 or char_y!=0 then
        char.frame += char.anim_speed*elapsed
    else
        char.frame = 0.99 -- TODO ?? why is this .99?
    end
end

function set_place_mode()
    if btnp(🅾️) then
        if char.place_mode == "place_panel" then
            char.place_mode = "place_wire"
        else
            char.place_mode = "place_panel"
        end
    end
end

function handle_selection_and_placement()
    set_place_mode()

    -- choose a selection sprite

    -- truth table for which icon to draw:
    -- is_removing is_placing panel_at - result
    -- T T T - error
    -- T T F - error

    -- T F T - remove
    -- T F F - remove
    -- F F T - remove

    -- F T T - place
    -- F T F - place
    -- F F F - place

    char.sel_sprite = "pick_up"
    if char.is_placing then
        char.sel_sprite = char.place_mode
    end
    if not char.is_removing and not thing_at(char.sel_x, char.sel_y, "placeable") then
        char.sel_sprite = char.place_mode
    end

    if thing_at(char.sel_x, char.sel_y, "rock") then
        char.sel_sprite = "no_action"
    else
        handle_item_removal_and_placement()
    end
end

function handle_item_removal_and_placement()
    if btn(❎) then
        local tbl = panel_locations
        if char.place_mode == "place_wire" then
            tbl = wire_locations
        end
        if not char.is_placing and not char.is_removing then
            -- first press frame, determine if we're placing or removing and which table we're modifying
            if thing_at(char.sel_x, char.sel_y, "panel") then
                char.is_removing = true
                char.place_mode = "place_panel"
                tbl = panel_locations
            elseif thing_at(char.sel_x, char.sel_y, "wire") then
                char.is_removing = true
                char.place_mode = "place_wire"
                tbl = wire_locations
            else
                char.is_placing = true
            end
        end
        if char.is_placing then
            if not thing_at(char.sel_x, char.sel_y, "anything") then
                tbl[char.sel_x][char.sel_y] = true
            end
        elseif char.is_removing then
            if not thing_at(char.sel_x, char.sel_y, "rock") then
                tbl[char.sel_x][char.sel_y] = nil
            end
        end
    else
        char.is_placing = false
        char.is_removing = false
    end
end