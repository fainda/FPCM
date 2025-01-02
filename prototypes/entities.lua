--input combinator
local input_combinator = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
input_combinator.name = "input-combinator"
input_combinator.flags = {"placeable-neutral", "player-creation", "get-by-unit-number"}
input_combinator.minable.result = "input-combinator"
--coloring of the entity
input_combinator.sprites.north.layers[1].tint = { r = 0, g = 1, b = 0, a = 1 } -- green
input_combinator.sprites.east.layers[1].tint = { r = 0, g = 1, b = 0, a = 1 } -- green
input_combinator.sprites.south.layers[1].tint = { r = 0, g = 1, b = 0, a = 1 } -- green
input_combinator.sprites.west.layers[1].tint = { r = 0, g = 1, b = 0, a = 1 } -- green


--output combinator
local output_combinator = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
output_combinator.name = "output-combinator"
output_combinator.flags = {"placeable-neutral", "player-creation", "get-by-unit-number"}
output_combinator.minable.result = "output-combinator"
output_combinator.sprites.north.layers[1].tint = { r = 1, g = 0, b = 0, a = 1 } -- red
output_combinator.sprites.east.layers[1].tint = { r = 1, g = 0, b = 0, a = 1 } -- red
output_combinator.sprites.south.layers[1].tint = { r = 1, g = 0, b = 0, a = 1 } -- red
output_combinator.sprites.west.layers[1].tint = { r = 1, g = 0, b = 0, a = 1 } -- red


data:extend{input_combinator, output_combinator}