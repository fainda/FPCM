local gv=require("global").vars --global vars
local gf=require("global").functions --global properties
local compatible_entities = require("global").compatible_entities

local machine_object={}
function machine_object:new(machine_entity)
    obj={
        type = machine_entity.type,
        name = machine_entity.name,
        unit_number = machine_entity.unit_number,
        position = machine_entity.position,
        status = machine_entity.status,
        signals={}--SIGNALS GO HERE
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function add_commands()

    commands.add_command("fpcm_scan", "Scans all machines on the same circuit network as a given entity_number", function(event)
        local player = game.get_player(event.player_index)
        if not player then return end
    
        local entity_number = tonumber(event.parameter)
        if not entity_number then
            player.print("Invalid entity number.")
            return
        end
    
        -- Efpcm_nsure storage.FPCM and the entity_number table are initialized  ?????????????
        storage.FPCM = storage.FPCM or {}
        storage.FPCM[entity_number] = storage.FPCM[entity_number] or {
            machinesRED = {},
            machinesGREEN = {},
            position = nil,
            surface = nil
        }
    
        local entity_data = storage.FPCM[entity_number]
        entity_data.machinesRED = entity_data.machinesRED or {}
        entity_data.machinesGREEN = entity_data.machinesGREEN or {}
    
        local pos = entity_data.position -- READ: Get position of the Process Controller
        local surface = entity_data.surface -- READ: Get surface of the Process Controller
        if not pos or not surface then
            player.print("Position or surface not stored for entity number: " .. entity_number)
            return
        end
    
        local entity = surface.find_entity("test1-combinator", pos)
        if not entity then
            player.print("Entity not found.")
            return
        end
    
        -- Retrieve network IDs
        local combinatorRED_networkID = entity.get_control_behavior() and
            entity.get_control_behavior().get_circuit_network(1) and
            entity.get_control_behavior().get_circuit_network(1).network_id or 0
    
        local combinatorGREEN_networkID = entity.get_control_behavior() and
            entity.get_control_behavior().get_circuit_network(2) and
            entity.get_control_behavior().get_circuit_network(2).network_id or 0
    
        -- Clear existing data
        entity_data.machinesRED = {}
        entity_data.machinesGREEN = {}
    
        -- Scan entities
        for _, machine in pairs(surface.find_entities_filtered({ force = player.force })) do
            if machine.get_control_behavior() then
                local networkRED = machine.get_control_behavior().get_circuit_network(1)
                local networkGREEN = machine.get_control_behavior().get_circuit_network(2)
    
                if networkRED and networkRED.network_id == combinatorRED_networkID then
                    table.insert(entity_data.machinesRED, {
                        name = machine.name,
                        type = machine.type,
                        position = machine.position,
                        status = machine.status
                    })
                end
    
                if networkGREEN and networkGREEN.network_id == combinatorGREEN_networkID then
                    table.insert(entity_data.machinesGREEN, {
                        name = machine.name,
                        type = machine.type,
                        position = machine.position,
                        status = machine.status
                    })
                end
            end
        end
    
        -- Debugging
        player.print("Connected machines [font=default-bold][color=red](Red)[/color][/font]:\n" ..
            serpent.block(entity_data.machinesRED))
        player.print("Connected machines [font=default-bold][color=green](Green)[/color][/font]:\n" ..
            serpent.block(entity_data.machinesGREEN))
    
        -- Final Debug Output
        player.print("Full storage state:\n" .. serpent.block(storage.FPCM))
        log(serpent.block(storage.FPCM))
    end)

    commands.add_command("fpcm_scan_network", "Scans all connected machines on a given network", function (event)
        local entity_number = tonumber(event.parameter)
        if not entity_number then
            gf:print_to_console("Invalid entity number.")
            return
        end

        -- Ensure FPCM and the entity_number table are initialized
        if not gf:get_root_path()["linker"][entity_number] then gf:print_to_console("no entry found") end
        
        local linker=gf:get_root_path()["linker"][entity_number]

        local input_network = linker.networks.input
        local output_network = linker.networks.output

        local sensor_machines = {}
        local actor_machines = {}

        local surface = game.get_surface(linker.surface)
        local force = linker.force

        --Scan surface for machines
        for _, machine in pairs(surface.find_entities_filtered({force = force})) do
            if machine.valid and machine.get_control_behavior() then
                if
                machine.get_control_behavior().get_circuit_network(1)
                and machine.get_control_behavior().get_circuit_network(1).network_id == output_network
                and gf:array_contains_value(compatible_entities.actors, machine.type)
                then
                    -- run when machine is in the same network (red) as linker
                    sensor_machines[machine.unit_number]=machine_object:new(machine)
                end
                if
                machine.get_control_behavior().get_circuit_network(2)
                and machine.get_control_behavior().get_circuit_network(2).network_id == input_network
                and gf:array_contains_value(compatible_entities.actors, machine.type)
                then
                    -- run when machine is in the same network (red) as linker
                    sensor_machines[machine.unit_number]=machine_object:new(machine)
                end
            end
        end
        gf:get_root_path()["linker"][entity_number].machines.sensor = sensor_machines
        gf:get_root_path()["linker"][entity_number].machines.actor = actor_machines
    end)

    commands.add_command("fpcm_clear", "Clears the storage",
        function(event)
            local player = game.get_player(event.player_index)
            if not player then return end

            storage.FPCM = nil -- WRITE: clear the storage
            player.print("Storage cleared.")
        end)

    commands.add_command("fpcm_storage", "Prints the storage",
        function(event)
            local player = game.get_player(event.player_index)
            if not player then return end

            player.print(serpent.block(storage.FPCM)) -- READ: get the storage.FPCM table in all its glory
        end)

    commands.add_command("fpcm_signal", "Prints all signals on the network", function(event)
        local player = game.get_player(event.player_index)
        if not player then return end

        local entity_number = tonumber(event.parameter)
        if not entity_number then
            player.print("Invalid entity number.")
            return
        end

        local pos = storage.FPCM[entity_number].position        -- READ: get the position of the Process Controller
        local surface = storage.FPCM[entity_number].surface     -- READ: get the surface of the Process Controller
        local entity = surface.find_entity("test1-combinator", pos)
        if not entity then
            player.print("Entity not found.")
            return
        end

        if storage.FPCM[entity_number].machinesRED then -- READ: get the machines connected to the red network
            for _, i in pairs(storage.FPCM[entity_number].machinesRED) do -- READ: iterate over the machines connected to the red network
                local entity = surface.find_entity(i.name, i.position)
                if entity and entity.get_control_behavior() then
                    local behavior = entity.get_control_behavior()
                    local circuit_output = behavior.get_circuit_network(1) and behavior.get_circuit_network(1).signals or
                    {}
                    if #circuit_output > 0 then
                        player.print("Circuit output for [entity=" ..
                        entity.name ..
                        "] -> [gps=" ..
                        entity.position.x .. "," .. entity.position.y .. "]: " .. serpent.block(circuit_output))
                    else
                        player.print("No Output for [entity=" ..
                        entity.name .. "] -> [gps=" .. entity.position.x .. "," .. entity.position.y .. "]")
                    end
                else
                    player.print("No Output for [entity=" ..
                    entity.name .. "] -> [gps=" .. entity.position.x .. "," .. entity.position.y .. "]")
                end
            end
        end

        if storage.FPCM[entity_number].machinesGREEN then -- READ: get the machines connected to the green network
            for _, i in pairs(storage.FPCM[entity_number].machinesGREEN) do -- READ: iterate over the machines connected to the green network
                local entity = surface.find_entity(i.name, i.position)
                if entity and entity.get_control_behavior() then
                    local behavior = entity.get_control_behavior()
                    local circuit_output = behavior.get_circuit_network(2) and behavior.get_circuit_network(2).signals or
                    {}
                    if #circuit_output > 0 then
                        player.print("Circuit output for [entity=" ..
                        entity.name ..
                        "] -> [gps=" ..
                        entity.position.x .. "," .. entity.position.y .. "]: " .. serpent.block(circuit_output))
                    else
                        player.print("No Output for [entity=" ..
                        entity.name .. "] -> [gps=" .. entity.position.x .. "," .. entity.position.y .. "]")
                    end
                else
                    player.print("No Output for [entity=" ..
                    entity.name .. "] -> [gps=" .. entity.position.x .. "," .. entity.position.y .. "]")
                end
            end
        end
    end)
end
