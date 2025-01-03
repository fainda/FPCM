local gv=require("global").vars --global vars
local gf=require("global").functions --global properties
local compatible_entities = require("global").compatible_entities
local machine_object=require("models.machine")
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
        networks = {input=nil, output=nil},
        machines = {}, --create machine array
        force = combinator_entity.force
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end
function linking_combinator:deconstruct()
    gf:get_root_path()["linker"][self.unit_number] = nil
    gf:conditional_broadcast(gv.debug_mode and gv.verbose, "deconstructed linker")
end
function linking_combinator:find_machines()
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
                gf:highlight_entity(machine, 1, true)
            end
            if
            machine.get_control_behavior().get_circuit_network(2)
            and machine.get_control_behavior().get_circuit_network(2).network_id == self.networks.input
            and gf:array_contains_value(compatible_entities.sensors, machine.type)
            then
                -- run when machine is in the same network (green) as self and is compatible
                self.machines.sensor = self.machines.sensor or {}
                self.machines.sensor[machine.unit_number]=machine_object:new(machine)
                gf:highlight_entity(machine, 2, true)
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
    local entity_surface, entity_position_x, entity_position_y, own_surface, own_position_x, own_position_y
    if entity then
        entity_surface=entity.surface.name
        entity_position_x=entity.position.x
        entity_position_y=entity.position.y
        own_surface=self.surface
        own_position_x=self.position.x
        own_position_y=self.position.y
    else
        gf:conditional_broadcast(gv.debug_mode and gv.verbose, "entity does not exist")
        return false
    end

    if entity_surface == own_surface and entity_position_x==own_position_x and entity_position_y==own_position_y then
        gf:conditional_broadcast(gv.debug_mode and gv.verbose, "linker verified")
        return true
    else
        gf:conditional_broadcast(gv.debug_mode and gv.verbose, "linker invalid")
        return false
    end
end

return linking_combinator