local resolveType = require("resolveType")

script.on_load(function()
    commands.add_command("fpcm_scan", "Scans all machines on the same circuit network as a given entity_number",
        function(event)
            local player = game.get_player(event.player_index)
            if not player then return end

            local entity_number = tonumber(event.parameter)
            if not entity_number then
                player.print("Invalid entity number.")
                return
            end

            -- Ensure storage.FPCM and the entity_number table are initialized
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

            local pos = entity_data.position    -- READ: Get position of the Process Controller
            local surface = entity_data.surface -- READ: Get surface of the Process Controller
            if not pos or not surface then
                player.print("Position or surface not stored for entity number: " .. entity_number)
                return
            end

            local entity = game.get_entity_by_unit_number(entity_number)
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
            -- write to storage
            storage.FPCM[entity_number] = entity_data
            -- Debugging
            player.print("Connected machines [font=default-bold][color=red](Red):\n" ..
                serpent.line(entity_data.machinesRED) .. "[/color][/font]")
            player.print("Connected machines [font=default-bold][color=green](Green):\n" ..
                serpent.line(entity_data.machinesGREEN) .. "[/color][/font]")
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

        local pos = storage.FPCM[entity_number].position    -- READ: get the position of the Process Controller
        local surface = storage.FPCM[entity_number].surface -- READ: get the surface of the Process Controller
        local entity = game.get_entity_by_unit_number(entity_number)
        if not entity then
            player.print("Entity not found.")
            return
        end

        -- Check through all machinesGREEN and look for a match of the type with the types in resolveType.lua
        for _, machine in pairs(storage.FPCM[entity_number].machinesGREEN) do
            local found_entity = surface.find_entity(machine.name, machine.position)
            if found_entity then
                local resolved_properties = resolveType[found_entity.type]
                if resolved_properties then
                    machine.properties = {}
                    for _, property in pairs(resolved_properties) do
                        if found_entity.valid and found_entity[property] ~= nil then
                            machine.properties[property] = found_entity[property]
                            player.print(property .. ": " .. tostring(found_entity[property]))
                        else
                            machine.properties[property] = "[property not available]"
                            player.print(property .. ": [property not available]")
                        end
                    end
                    -- Update the storage with the new properties
                    storage.FPCM[entity_number].machinesGREEN[_] = machine
                else
                    player.print("No resolved properties found for entity type: " .. found_entity.type)
                end
            else
                player.print("Entity not found at position: " .. serpent.line(machine.position))
            end
        end
    end)
    commands.add_command("unit_number_finder", "finds an entity by its unit number", function(event)
        local player = game.get_player(event.player_index)
        if not player then return end
        local entity_number = tonumber(event.parameter)
        if not entity_number then
            player.print("Invalid entity number.")
            return
        end
        local entity = game.get_entity_by_unit_number(entity_number)
        if not entity then
            player.print("Entity not found.")
            return
        end
        player.print("Entity found: " .. entity.name .. " at [gps=" .. entity.position.x .. ", " .. entity.position.y .. "," .. entity.surface.name .. "]")
    end)
end)
