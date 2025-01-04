local gv=require("global").vars --global vars
local gf=require("global").functions --global properties

local properties = {}

properties.always_include = { -- TODO: (Very Big) look up all properties of all entity types we are interested in
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
    "health",
}

properties["reactor"] = {
    "energy",
    "temperature",
    "active",
    "status",
    "burner",
    "health"
}

properties["accumulator"] = {
    "energy", -- stored energy in form of Joules
    "prototype.electric_energy_source_prototype.buffer_capacity", -- maximum energy storage in Joules
}

properties["transport-belt"] = {
    "direction",
    "energy",
    "belt_speed",
    "get_control_behavior()"
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