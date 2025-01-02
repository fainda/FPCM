---@diagnostic disable: param-type-mismatch
--get global vars
local global_vars=require("global.vars")
local root_path = global_vars["root_path"]


--########## INPUT COMBINATOR START ##########
--init input combinator object
local input_combinator = {}
--constructor method
function input_combinator:new(combinator_entity)
    local obj = {
        unit_number = combinator_entity.unit_number,
        name = "Input combinator "..combinator_entity.unit_number, -- this will be displayed in the GUI
        surface = combinator_entity.surface,
        position = combinator_entity.position,
        output_network = nil, --old name: signal_red
        input_network = nil, --old name: signal_green
        machines = {} --create machine array
    }
    if combinator_entity.get_control_behavior() ~=nil then
        obj.output_network=combinator_entity.get_control_behavior().get_circuit_network(1).network_id
        obj.input_network=combinator_entity.get_control_behavior().get_circuit_network(2).network_id
    end
    setmetatable(obj, self)
    self.__index = self
    return obj
end
function input_combinator:get_machines()
    -- SCAN LOGIC HERE
end
function input_combinator:drop_machines()
    self.machines={}
end
function input_combinator:update_name(name)
    self.name=name
end
function input_combinator:update_networks()
    self.output_network = game.get_entity_by_unit_number(self.unit_number).get_control_behavior().get_circuit_network(1) --old name: signal_red
    self.input_network = game.get_entity_by_unit_number(self.unit_number).get_control_behavior().get_circuit_network(2) --old name: signal_green
end
--this following function may not be necessary, as unit numbers are not reused and these properties are therefore static
function input_combinator:verify_self()
    if
    self.surface == game.get_entity_by_unit_number(self.unit_number).surface
    and self.position == game.get_entity_by_unit_number(self.unit_number).position
    then return true
    else return false
    end
end
--########## INPUT COMBINATOR END ##########


--########## OUTPUT COMBINATOR START ##########
--init input combinator object
local output_combinator = {}
--constructor method
function output_combinator:new(combinator_entity)
    local obj = {
        unit_number = combinator_entity.unit_number,
        name = "output combinator "..combinator_entity.unit_number, -- this will be displayed in the GUI
        surface = combinator_entity.surface,
        position = combinator_entity.position,
        output_network = combinator_entity.get_control_behavior().get_circuit_network(1).network_id, --old name: signal_red
        input_network = combinator_entity.get_control_behavior().get_circuit_network(2).network_id, --old name: signal_green
        machines = {} --create machine array
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end
function output_combinator:get_machines()
    -- SCAN LOGIC HERE
end
function output_combinator:drop_machines()
    self.machines={}
end
function output_combinator:update_name(name)
    self.name=name
end
function output_combinator:update_networks()
    self.output_network = game.get_entity_by_unit_number(self.unit_number).get_control_behavior().get_circuit_network(1) --old name: signal_red
    self.input_network = game.get_entity_by_unit_number(self.unit_number).get_control_behavior().get_circuit_network(2) --old name: signal_green
end
--this following function may not be necessary, as unit numbers are not reused and these properties are therefore static
function output_combinator:verify_self()
    if
    self.surface == game.get_entity_by_unit_number(self.unit_number).surface
    and self.position == game.get_entity_by_unit_number(self.unit_number).position
    then return true
    else return false
    end
end
--########## OUTPUT COMBINATOR END ##########


--create an event every second
script.on_nth_tick(60, function(event) handler(event) end)
--call everything inside every event
function handler(event)
    try_and_catch(update_combinators, "update combinators")
end

function update_combinators()
    for _, surface in pairs(game.surfaces) do
        --surface loop starts here
        for _, entity in pairs(surface.find_entities_filtered { name = "input-combinator" }) do
            if entity.get_control_behavior() then
                if root_path["sensors"][entity.unit_number] ~= nil --PATH DEFINITION
                then
                    try_and_catch(root_path["sensors"][entity.unit_number]:verify_self(), "verify sensors")
                    try_and_catch(root_path["sensors"][entity.unit_number]:update_networks(), "update sensor networks")
                else
                    root_path["sensors"][entity.unit_number]= try_and_catch(input_combinator:new(entity))
                end
            end
        end
        --[[
        for _, entity in pairs(surface.find_entities_filtered { name = "output-combinator" }) do
            if entity.get_control_behavior() then
                if root_path["actors"][entity.unit_number] ~= nil --PATH DEFINITION
                then
                    root_path["actors"][entity.unit_number]:verify_self()
                    root_path["actors"][entity.unit_number]:update_networks()
                else
                    root_path["actors"][entity.unit_number]=output_combinator:new(entity)
                end
            end
        end
        ]]--
        --surface loop ends here
    end
end