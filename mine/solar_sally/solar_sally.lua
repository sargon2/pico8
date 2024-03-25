
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
    Sprites.draw_spr("selection_box",char.sel_x,char.sel_y)
    Sprites.draw_spr(char.sel_sprite,char.sel_x,char.sel_y-1)
end


function _init()
    srand(12345)
    Rocks.create_rocks()
    Panels.init()
    Wire.init()
end

-- TODO this shouldn't live here
function getOnlyElement(tbl)
    assert(#tbl == 1) -- getOnlyElement requires 1 element in the table
    for x in all(tbl) do
        return x
    end
end

function draw_simple(tbl, spritenum)
    for x,ys in pairs(tbl) do
        for y,t in pairs(ys) do
            Sprites.draw_spr(spritenum,x,y)
        end
    end
end

function draw_transformers()
    draw_simple(transformer_left_locations, "transformer_left")
    draw_simple(transformer_right_locations, "transformer_right")
end


function _draw()
    cls()
    map(0,0,64-(char.x*8),64-(char.y*8))

    Drawable.draw_all(char.x, char.y)

    draw_transformers() -- TODO componentize

    draw_char(char, 64, 64)
    draw_selection(char)
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
    if not WalkingObstructions.obstructed(flr(char.x+char_x+.6), flr(char.y+1)) then
        char.x += char_x
    end
    if not WalkingObstructions.obstructed(flr(char.x+.6), flr(char.y+char_y+1)) then
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

function determine_sprite_from_action(action)
    local sprites_from_action = {
        no_action = "no_action",
        pick_up_panel = "pick_up",
        pick_up_wire = "pick_up",
        place_panel = "place_panel",
        place_wire = "place_wire",
    }
    return sprites_from_action[action]
end

function handle_selection_and_placement()
    set_place_mode()

    -- Determine what we have selected
    local entity_at_sel = Locations.entity_at(char.sel_x, char.sel_y) -- may be nil

    local selected_type = ObjectTypes.type_of(entity_at_sel)

    -- 1. determine action -- no action, pick up panel, pick up wire, place panel, place wire
    action = determine_action(selected_type)

    -- 2. determine sprite from action
    -- TODO when we're removing, we shouldn't get the "x" selection icon unless we're hovering over a non-removable item
    -- TODO same for placing, we shouldn't get the "x" directly after placing something
    char.sel_sprite = determine_sprite_from_action(action)

    -- 3. take action if button pressed, and set placement/removal state
    if btn(❎) then
        -- TODO convert this to a table of lambda functions?
        if action == "no_action" then
            -- pass
        elseif action == "pick_up_panel" then
            char.is_removing = true
            char.place_mode = "place_panel"
            Locations.remove_entity_at(char.sel_x, char.sel_y)
        elseif action == "pick_up_wire" then
            char.is_removing = true
            char.place_mode = "place_wire"
            Locations.remove_entity_at(char.sel_x, char.sel_y)
        elseif action == "place_panel" then
            char.is_placing = true
            char.place_mode = "place_panel"
            Panels.place_panel_at(char.sel_x, char.sel_y)
        elseif action == "place_wire" then
            char.is_placing = true
            char.place_mode = "place_wire"
            Wire.place_wire_at(char.sel_x, char.sel_y)
        else
            assert(false) -- unknown action
        end
    else
        char.is_placing = false
        char.is_removing = false
    end
end

function determine_action(selected_type)
    local action

    -- If we're placing, then we place on empty, and everything else is no_action.
    -- If we're removing, then we remove panels/wire, and everything else is no_action.
    -- If we're not placing or removing, action depends on entity.
    -- This is fizzbuzz.

    if char.is_placing then
        if selected_type == nil then
            action = char.place_mode
        else
            action = "no_action"
        end
    elseif char.is_removing then
        if char.place_mode == "place_panel" then
            if selected_type == "panel" then
                action = "pick_up_panel"
            else
                action = "no_action"
            end
        elseif char.place_mode == "place_wire" then
            if selected_type == "wire" then
                action = "pick_up_wire"
            else
                action = "no_action"
            end
        else
            assert(false) -- Unknown place mode
        end
    else
        -- we're not currently placing or removing
        -- TODO lookup table?
        if selected_type == "rock" then
            action = "no_action"
        elseif selected_type == "panel" then
            action = "pick_up_panel"
        elseif selected_type == "wire" then
            action = "pick_up_wire"
        else
            -- If nothing's there, we're in place mode, and we use the user's selected mode.
            action = char.place_mode
        end
    end

    return action
end
