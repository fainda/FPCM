local gv=require("global").vars --global vars
local gf=require("global").functions --global properties

local properties = {}

properties.always_include = {
    "name",
    "type",
    "position",
    "status",
    "force",
}

properties.always_exclude = {
    -- :3
}

properties["assembling-machine"] = {
    "crafting_progress",
    "energy",
    "fluidbox",
    "crafting_speed",
    "electric_buffer_size",
    "active",
    "status",
    "speed_bonus",
    "productivity_bonus",
    "consumption_bonus",
    "health"
}

properties["reactor"] = {
    -- "energy",
    -- "temperature",
    -- "active",
    -- "status",
    -- "burner",
    -- "health"
    "read_fuel",
    "read_temperature",
}

properties["pump"] = {
    "fluidbox.fluidbox[1]", --input
    "fluidbox.fluidbox[2]", --output
    "fluid_usage_per_tick",
    "energy",
    "energy_usage",
    "active",
    "status",
    "direction",
    "neighbours",
    "health"
}

function properties:find(name) --will return all valid properties of an entity with set name
    local result
    if properties[name] then
        result = gf.tables:union(properties.always_include, properties[name])
    else result = properties.always_include
    end
    return result
end

return properties