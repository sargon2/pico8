Map = {}

function Map.init()
    Drawable.add_aggregate_draw_fn(ZValues["Map"], Map.drawMap)
end

function Map.drawMap()
    map(0,0,64-(Character.x*8),64-(Character.y*8))
end