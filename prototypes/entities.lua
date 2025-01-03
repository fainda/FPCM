--linking combinator
local linking_combinator = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
linking_combinator.name = "linking-combinator"
linking_combinator.flags = {"placeable-neutral", "player-creation", "get-by-unit-number"}
linking_combinator.minable.result = "linking-combinator"
linking_combinator.icon = "__FPCM__/graphics/icons/items/linking_combinator.png"
linking_combinator.icon_size = 64
linking_combinator.icon_mipmaps = 4
--coloring of the entity
linking_combinator.sprites.north.layers[1].tint = { r = 0, g = 1, b = 0, a = 1 } -- green
linking_combinator.sprites.east.layers[1].tint = { r = 0, g = 1, b = 0, a = 1 } -- green
linking_combinator.sprites.south.layers[1].tint = { r = 0, g = 1, b = 0, a = 1 } -- green
linking_combinator.sprites.west.layers[1].tint = { r = 0, g = 1, b = 0, a = 1 } -- green

local logic_controller = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
logic_controller.name = "logic-controller"
logic_controller.flags = {"placeable-neutral", "player-creation", "get-by-unit-number"}
logic_controller.minable.result = "logic-controller"
logic_controller.icon = "__FPCM__/graphics/icons/items/logic_controller.png"
logic_controller.icon_size = 128
logic_controller.icon_mipmaps = 4
--coloring of the entity
logic_controller.sprites.north.layers[1].tint = { r = 1, g = 1, b = 0, a = 1 } -- yellow
logic_controller.sprites.east.layers[1].tint = { r = 1, g = 1, b = 0, a = 1 } -- yellow
logic_controller.sprites.south.layers[1].tint = { r = 1, g = 1, b = 0, a = 1 } -- yellow
logic_controller.sprites.west.layers[1].tint = { r = 1, g = 1, b = 0, a = 1 } -- yellow

data:extend{linking_combinator, logic_controller}