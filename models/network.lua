local gv=require("global").vars --global vars
local gf=require("global").functions --global properties
local compatible_entities = require("global").compatible_entities
local machine_object=require("models.machine")


local network={}
function network:new(circuit_network)
    local type
    if circuit_network.wire_type == 2 then type = "output" elseif circuit_network.wire_type == 3 then type = "input" end --determine type via
    local obj={
        id = circuit_network.network_id,
        type = type, -- "output" or "input"
        machines = {},
        machine_type = nil,
        valid = true
        --signals = circuit_network.signals()
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end
function network:update(linker) --old: find_machines()
    self.machines={}--clear array everytime it is called
    self.valid=true --standardly valid
    self.machine_type=nil --standardly empty
    local connector_id
    local machine_role
    if self.type == "output" then connector_id=1 machine_role="actors"
    elseif self.type == "input" then connector_id=2 machine_role="sensors"
    else return {}
    end
    for _, machine in pairs(game.get_surface(linker.surface).find_entities_filtered({force = linker.force})) do
        if
        machine.valid and machine.get_control_behavior()
        and machine.get_control_behavior().get_circuit_network(connector_id)
        and machine.get_control_behavior().get_circuit_network(connector_id).network_id == self.id
        and gf:array_contains_value(compatible_entities[machine_role], machine.type)
        then
            -- run when machine is in the same network as self and is compatible
            self.machines[machine.unit_number]=machine_object:new(machine)
            if self.machine_type == nil then self.machine_type=machine.type
            elseif self.machine_type ~= machine.type then self.valid=false                    
            end
        end
    end
end
function network:update_signals()
    for unit_number,_ in pairs(self.machines) do
        self.machines[unit_number]:update_signals()
    end
end


return network