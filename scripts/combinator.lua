---@diagnostic disable: param-type-mismatch
--get global vars
local gv=require("global").vars --global vars
local gf=require("global").functions --global properties
local compatible_entities = require("global").compatible_entities
local machine_object=require("scripts.machine")
local linking_combinator=require("models.linker")


--create an event every second (4s for debugging)
local frequency = gv.debug_mode and 240 or 60
script.on_nth_tick(frequency, function(event) handler(event) end)
--call everything inside every event
function handler(event)
    gf:try_and_catch(update_combinators, "update combinators")
end

function update_combinators()
    for _, surface in pairs(game.surfaces) do
        --surface loop starts here
        for _, entity in pairs(surface.find_entities_filtered { name = "linking-combinator" }) do
            if entity.get_control_behavior() then
                if gf:get_root_path()["linker"][entity.unit_number]
                then --update logic
                    gf:get_root_path()["linker"][entity.unit_number]:verify_self()
                    gf:get_root_path()["linker"][entity.unit_number]:update_networks()
                else --create logic
                    gf:get_root_path()["linker"][entity.unit_number] = {}
                    gf:get_root_path()["linker"][entity.unit_number] = linking_combinator:new(entity)
                end
            end
        end
        --surface loop ends here
    end
end