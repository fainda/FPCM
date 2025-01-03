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