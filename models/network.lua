--[[
local gv=require("global").vars --global vars
local gf=require("global").functions --global properties
local compatible_entities = require("global").compatible_entities
local machine_object=require("models.machine")


local network={}
function network:new(circuit_network)
    obj={
        id = circuit_network.network_id,
        type = 
        machines = {}
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end
function network:find_machines()
    for _, machine in pairs(game.get_surface(self.surface).find_entities_filtered({force = self.force})) do
        if machine.valid and machine.get_control_behavior() then
            if
            machine.get_control_behavior().get_circuit_network(1)
            and machine.get_control_behavior().get_circuit_network(1).network_id == self.networks.output
            and gf:array_contains_value(compatible_entities.actors, machine.type)
            then
                -- run when machine is in the same network (red) as self and is compatible
                self.machines.actor = self.machines.actor or {}
                self.machines.actor[machine.unit_number]=machine_object:new(machine)
            end
            if
            machine.get_control_behavior().get_circuit_network(2)
            and machine.get_control_behavior().get_circuit_network(2).network_id == self.networks.input
            and gf:array_contains_value(compatible_entities.sensors, machine.type)
            then
                -- run when machine is in the same network (green) as self and is compatible
                self.machines.sensor = self.machines.sensor or {}
                self.machines.sensor[machine.unit_number]=machine_object:new(machine)
            end
        end
    end
end

return network
]]--