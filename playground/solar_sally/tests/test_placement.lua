placement_tests = {}

function init_inventory(num_panels, num_transformers, num_wire, num_fence)
    if(num_panels == nil) num_panels = 0
    if(num_transformers == nil) num_transformers = 0
    if(num_wire == nil) num_wire = 0
    if(num_fence == nil) num_fence = 0

    -- Clear inventory (only needed for testing, where we re-init)
    Inventory_items = {}
    Inventory_order = {}
    Inventory_formatters = {}
    Inventory_icons = {}

    Settings_start_panels = num_panels
    Settings_start_transformers = num_transformers
    Settings_start_wire = num_wire
    Settings_start_fence = num_fence

    Inventory.on_load()
end

function placement_tests.test_empty_inventory_rotate()
    
    init_inventory()
    Placement.on_load()

    assert.equals(Placement_get_place_ent_id(), Entities_None)
    Placement_rotate_with_inventory_check()
    assert.equals(Placement_get_place_ent_id(), nil)
    Placement_rotate_with_inventory_check()
    assert.equals(Placement_get_place_ent_id(), Entities_None)
    Placement_rotate_with_inventory_check()
    assert.equals(Placement_get_place_ent_id(), nil)
end

function placement_tests.test_rotate_empty_skip_off()
    
    init_inventory()
    Placement.on_load()

    assert.equals(Placement_get_place_ent_id(), Entities_None)
    Placement_rotate_with_inventory_check(true)
    assert.equals(Placement_get_place_ent_id(), nil)
    Placement_rotate_with_inventory_check(true)
    assert.equals(Placement_get_place_ent_id(), nil)
    Placement_rotate_with_inventory_check(true)
    assert.equals(Placement_get_place_ent_id(), nil)
end

function placement_tests.test_basic_rotate()

    init_inventory(1, 1, 1, 1)
    Placement.on_load()

    assert.equals(Placement_get_place_ent_id(), Entities_None)
    Placement_rotate_with_inventory_check()
    assert.equals(Placement_get_place_ent_id(), Entities_Panels)
    Placement_rotate_with_inventory_check()
    assert.equals(Placement_get_place_ent_id(), Entities_Wire)
    Placement_rotate_with_inventory_check()
    assert.equals(Placement_get_place_ent_id(), Entities_Transformers_left)
    Placement_rotate_with_inventory_check()
    assert.equals(Placement_get_place_ent_id(), Entities_Fence)
    Placement_rotate_with_inventory_check()
    assert.equals(Placement_get_place_ent_id(), Entities_None)
    Placement_rotate_with_inventory_check()
    assert.equals(Placement_get_place_ent_id(), Entities_Panels)
end

function placement_tests.test_rotate_skip_off()

    init_inventory(1, 1, 1, 1)
    Placement.on_load()

    assert.equals(Placement_get_place_ent_id(), Entities_None)
    Placement_rotate_with_inventory_check(true)
    assert.equals(Placement_get_place_ent_id(), Entities_Panels)
    Placement_rotate_with_inventory_check(true)
    assert.equals(Placement_get_place_ent_id(), Entities_Wire)
    Placement_rotate_with_inventory_check(true)
    assert.equals(Placement_get_place_ent_id(), Entities_Transformers_left)
    Placement_rotate_with_inventory_check(true)
    assert.equals(Placement_get_place_ent_id(), Entities_Fence)
    Placement_rotate_with_inventory_check(true)
    assert.equals(Placement_get_place_ent_id(), Entities_Panels)
    Placement_rotate_with_inventory_check(true)
    assert.equals(Placement_get_place_ent_id(), Entities_Wire)
    Placement_rotate_with_inventory_check(true)
end

runTests("placement tests", placement_tests)
