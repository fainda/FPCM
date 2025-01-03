local gv=require("global").vars --global vars
local gf=require("global").functions --global properties

function add_commands()

    commands.add_command("fpcm_scan_network", "Scans all connected machines on a given network", function (event)
        local entity_number = tonumber(event.parameter)
        if not entity_number then
            gf:print_to_console("Invalid entity number.")
            return
        end

        -- Ensure FPCM and the entity_number table are initialized
        if not gf:get_root_path()["linker"][entity_number] then gf:print_to_console("no entry found") end
        
        gf:get_root_path()["linker"][entity_number]:find_machines()


        --Scan surface for machines
        --[[for _, machine in pairs(game.get_surface(linker.surface).find_entities_filtered({force = linker.force})) do
            if machine.valid and machine.get_control_behavior() then
                if
                machine.get_control_behavior().get_circuit_network(1)
                and machine.get_control_behavior().get_circuit_network(1).network_id == linker.networks.output
                and gf:array_contains_value(compatible_entities.actors, machine.type)
                then
                    -- run when machine is in the same network (red) as linker
                    linker.machines.actor[machine.unit_number]=machine_object:new(machine)
                end
                if
                machine.get_control_behavior().get_circuit_network(2)
                and machine.get_control_behavior().get_circuit_network(2).network_id == linker.networks.input
                and gf:array_contains_value(compatible_entities.sensors, machine.type)
                then
                    -- run when machine is in the same network (red) as linker
                    linker.machines.sensor[machine.unit_number]=machine_object:new(machine)
                end
            end
        end]]--
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
