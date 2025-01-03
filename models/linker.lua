local gv=require("global").vars --global vars
local gf=require("global").functions --global properties
local compatible_entities = require("global").compatible_entities
local machine_object=require("scripts.machine")

--init combinator object
local linking_combinator = {}
--constructor method
function linking_combinator:new(combinator_entity)
    local obj = {
        unit_number = combinator_entity.unit_number,
        name = "linking combinator "..combinator_entity.unit_number, -- this will be displayed in the GUI
        surface = combinator_entity.surface.name,
        position = combinator_entity.position,
        networks = {input=nil, output=nil},
        machines = {}, --create machine array
        force = combinator_entity.force
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end
function linking_combinator:find_machines()
    for _, machine in pairs(game.get_surface(self.surface).find_entities_filtered({force = self.force})) do
        if machine.valid and machine.get_control_behavior() then
            if
            machine.get_control_behavior().get_circuit_network(1)
            and machine.get_control_behavior().get_circuit_network(1).network_id == self.networks.output
            and gf:array_contains_value(compatible_entities.actors, machine.type)
            then
                -- run when machine is in the same network (red) as self
                self.machines.actor[machine.unit_number]=machine_object:new(machine)
            end
            if
            machine.get_control_behavior().get_circuit_network(2)
            and machine.get_control_behavior().get_circuit_network(2).network_id == self.networks.input
            and gf:array_contains_value(compatible_entities.sensors, machine.type)
            then
                -- run when machine is in the same network (red) as self
                self.machines.sensor[machine.unit_number]=machine_object:new(machine)
            end
        end
    end
end
function linking_combinator:drop_machines()
    self.machines={}
end
function linking_combinator:update_name(name)
    self.name=name
end
function linking_combinator:update_networks()
    local entity = game.get_entity_by_unit_number(self.unit_number)
    if entity and entity.get_control_behavior() then
        local output_network = entity.get_control_behavior().get_circuit_network(1)
        local input_network = entity.get_control_behavior().get_circuit_network(2)
        self.networks.output = output_network and output_network.network_id or nil --old name: signal_red
        self.networks.input = input_network and input_network.network_id or nil --old name: signal_green
    end
end
--this following function may not be necessary, as unit numbers are not reused and these properties are therefore static
function linking_combinator:verify_self()
    local entity = game.get_entity_by_unit_number(self.unit_number)
    if entity and self.surface == entity.surface.name and self.position == entity.position then
        return true
    else
        return false
    end
end

return linking_combinator