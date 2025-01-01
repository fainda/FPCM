local entity_1 = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])

entity_1.name = "test1-combinator"
entity_1.input_connection_points = {
    {
        shadow =
        {
            red = { 0.328125, 0.703125 },
            green = { 0.859375, 0.703125 }
        },
        wire =
        {
            red = { -0.28125, 0.34375 },
            green = { 0.25, 0.34375 }
        }
    }
}

local entity_2 = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
entity_2.name = "test2-combinator"
entity_2.input_connection_points = {
    {
        shadow =
        {
            red = { 0.328125, 0.703125 },
            green = { 0.859375, 0.703125 }
        },
        wire =
        {
            red = { -0.28125, 0.34375 },
            green = { 0.25, 0.34375 }
        }
    }
}

data:extend{entity_1, entity_2}