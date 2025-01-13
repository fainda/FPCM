local gv=require("global").vars --global vars
local gf=require("global").functions --global properties
local compatible_entities = require("global").compatible_entities

local list = require("global").compatible_entities
local sensors = list.sensors
local actors = list.actors

for _, sensor_type in ipairs(sensors) do
    if data.raw[sensor_type] then
        for _, entity in pairs(data.raw[sensor_type]) do
            table.insert(entity.flags, "get-by-unit-number")
            gf:conditional_broadcast(gv.debug_mode and gv.verbose ,"Added flag to " .. entity.name)
        end
    else
        gf:conditional_broadcast(gv.debug_mode and gv.verbose, "No entities of type " .. sensor_type .. " found.")
    end
end

for _, actor_type in ipairs(actors) do
    if data.raw[actor_type] then
        for _, entity in pairs(data.raw[actor_type]) do
            table.insert(entity.flags, "get-by-unit-number")
            log("Added flag to " .. entity.name)
        end
    else
        log("No entities of type " .. actor_type .. " found.")
    end
end


-- make wire colors match the colorblind settings
data.raw["utility-sprites"].default.green_wire.filename = "__FPCM__/graphics/wire.png"
data.raw["utility-sprites"].default.green_wire.tint = settings.startup["fpcm_sensor"].value
data.raw["utility-sprites"].default.red_wire.filename = "__FPCM__/graphics/wire.png"
data.raw["utility-sprites"].default.red_wire.tint = settings.startup["fpcm_actor"].value



-- WORKS IN THEORY, but game uses already colored icons, tint just modifies that color (now way to change saturation)
-- -- icon when item is 'in hand'
data.raw["item"]["green-wire"].icons = {
    {
        icon = "__FPCM__/graphics/icons/new-green-wire-x56.png",
        icon_size = 56,
        icon_mipmaps = 2,
        tint = settings.startup["fpcm_sensor"].value
    }
}
data.raw["item"]["red-wire"].icons = {
    {
        icon = "__FPCM__/graphics/icons/new-red-wire-x56.png",
        icon_size = 56,
        icon_mipmaps = 2,
        tint = settings.startup["fpcm_actor"].value
    }
}

-- -- custom-input icons for rhs of main quick select bar at bottom of screen
data.raw["shortcut"]["give-green-wire"].icons = {
    {
        icon = "__FPCM__/graphics/icons/new-green-wire-x56.png",
        icon_size = 56,
        icon_mipmaps = 2,
        tint = settings.startup["fpcm_sensor"].value
    }
}
data.raw["shortcut"]["give-green-wire"].small_icons = {
    {
        icon = "__FPCM__/graphics/icons/new-green-wire-x24.png",
        icon_size = 24,
        icon_mipmaps = 2,
        tint = settings.startup["fpcm_sensor"].value
    }
}
data.raw["shortcut"]["give-red-wire"].icons = {
    {
        icon = "__FPCM__/graphics/icons/new-red-wire-x56.png",
        icon_size = 56,
        icon_mipmaps = 2,
        tint = settings.startup["fpcm_actor"].value
    }
}
data.raw["shortcut"]["give-red-wire"].small_icons = {
    {
        icon = "__FPCM__/graphics/icons/new-red-wire-x24.png",
        icon_size = 24,
        icon_mipmaps = 2,
        tint = settings.startup["fpcm_actor"].value
    }
}