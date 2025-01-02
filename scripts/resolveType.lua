local properties = {}

properties.general = {
    "name",
    "type",
    "position",
    "status",
    "force",
}

properties.assembling = {
    "crafting_progress",
    "energy",
    "energy_usage",
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

properties.reactor = {
    "energy",
    "energy_buffer",
    "temperature",
    "heat_buffer",
    "active",
    "status",
    "burner",
    "neighbours",
    "health"
}

properties.pump = {
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

