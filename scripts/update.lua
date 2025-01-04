---@diagnostic disable: param-type-mismatch
--get global vars
local gv=require("global").vars --global vars
local gf=require("global").functions --global properties



--[[function update_combinators()
    for _, surface in pairs(game.surfaces) do
        --surface loop starts here
        for _, entity in pairs(surface.find_entities_filtered { name = "linking-combinator" }) do
            if entity.get_control_behavior() then
                if gf:get_root_path()["linker"][entity.unit_number]
                then --update logic
                    if not gf:get_root_path()["linker"][entity.unit_number]:verify_self() then gf:get_root_path()["linker"][entity.unit_number]:deconstruct() end
                    gf:get_root_path()["linker"][entity.unit_number]:update_networks()
                else --create logic
                    gf:get_root_path()["linker"][entity.unit_number] = {}
                    gf:get_root_path()["linker"][entity.unit_number] = linking_combinator:new(entity)
                end
            end
        end
        --surface loop ends here
    end
end]]--



--create an event every second (4s for debugging)
local frequency = gv.debug_mode and 240 or 60
script.on_nth_tick(frequency, function(event) handler(event) end)
--call everything inside every event
function handler(event)
    storage[gv.mod_name]:update_linkers()
end

