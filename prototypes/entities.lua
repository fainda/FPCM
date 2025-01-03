--linking combinator
local linking_combinator = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
linking_combinator.name = "linking-combinator"
linking_combinator.flags = {"placeable-neutral", "player-creation", "get-by-unit-number"}
linking_combinator.minable.result = "linking-combinator"
--coloring of the entity
linking_combinator.sprites.north.layers[1].tint = { r = 0, g = 1, b = 0, a = 1 } -- green
linking_combinator.sprites.east.layers[1].tint = { r = 0, g = 1, b = 0, a = 1 } -- green
linking_combinator.sprites.south.layers[1].tint = { r = 0, g = 1, b = 0, a = 1 } -- green
linking_combinator.sprites.west.layers[1].tint = { r = 0, g = 1, b = 0, a = 1 } -- green

data:extend{linking_combinator}