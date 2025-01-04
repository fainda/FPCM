local gv=require("global").vars --global vars
local gf=require("global").functions --global properties
local network_object=require("models.network")

--init combinator object
local linking_combinator = {}
--constructor method
function linking_combinator:new(combinator_entity)
    local obj = {
        unit_number = combinator_entity.unit_number,
        name = "linking combinator "..combinator_entity.unit_number, -- this will be displayed in the GUI
        surface = combinator_entity.surface.name,
        position = combinator_entity.position,
        networks = {},
        force = combinator_entity.force
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end
function linking_combinator:drop_machines()
    self.machines={}
end
function linking_combinator:set_name(name)
    self.name=name
end
function linking_combinator:update_networks()
    self.networks={}--clear tables before update
    local entity = game.get_entity_by_unit_number(self.unit_number)
    if entity and entity.get_control_behavior() then
        local output_network = entity.get_control_behavior().get_circuit_network(1) --this can be shortened
        local input_network = entity.get_control_behavior().get_circuit_network(2)
        if output_network then
            self.networks[output_network.network_id] = network_object:new(output_network)
            self.networks[output_network.network_id]:update(self)
            self.networks[output_network.network_id]:update_signals()
        end
        if input_network then
            self.networks[input_network.network_id] = network_object:new(input_network)
            self.networks[input_network.network_id]:update(self)
            self.networks[input_network.network_id]:update_signals()
        end
        
    end
end
function linking_combinator:verify_self()
    if game.get_entity_by_unit_number(self.unit_number) then return true else return false end
end

return linking_combinator