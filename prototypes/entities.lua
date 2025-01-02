local input_combinator = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])


--input combinator
input_combinator.name = "input-combinator"
input_combinator.flags = {"placeable-neutral", "player-creation", "get-by-unit-number"}


--output combinator
local output_combinator = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
output_combinator.name = "output-combinator"
output_combinator.flags = {"placeable-neutral", "player-creation", "get-by-unit-number"}


data:extend{input_combinator, output_combinator}