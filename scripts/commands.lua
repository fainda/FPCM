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

            local pos = storage["FPCM"][entity_number].position -- READ: get the position of the Process Controller
            local surface = storage["FPCM"][entity_number].surface -- READ: get the surface of the Process Controller
            local entity = surface.find_entity("test1-combinator", pos)
            if not entity then
                player.print("Entity not found.")
                return
            end

            if entity.get_control_behavior() then
                if entity.get_control_behavior().get_circuit_network(1) then
                    if entity.get_control_behavior().get_circuit_network(1).network_id then
                        combinatorRED_networkID = entity.get_control_behavior().get_circuit_network(1).network_id
                    else
                        player.print("Entity is not connected to the red network.")
                        combinatorRED_networkID = 0
                    end
                else
                    player.print("Entity is not connected to a network.")
                    combinatorRED_networkID = 0
                end
            else
                player.print("Entity does not have control_behavior.")
                combinatorRED_networkID = 0
            end


            if entity.get_control_behavior() then
                if entity.get_control_behavior().get_circuit_network(2) then
                    if entity.get_control_behavior().get_circuit_network(2).network_id then
                        combinatorGREEN_networkID = entity.get_control_behavior().get_circuit_network(2).network_id
                    else
                        player.print("Entity is not connected to the green network.")
                        combinatorGREEN_networkID = 0
                    end
                else
                    player.print("Entity is not connected to a network.")
                    combinatorGREEN_networkID = 0
                end
            else
                player.print("Entity does not have control_behavior.")
                combinatorGREEN_networkID = 0
            end

            local machinesRED = {}
            local machinesGREEN = {}

            --get all entities on that surface and check if they are on the same network via network_id
            for _, entity in pairs(surface.find_entities_filtered({ force = player.force })) do
                if entity.get_control_behavior() then
                    local networkRED = entity.get_control_behavior().get_circuit_network(1)
                    local networkGREEN = entity.get_control_behavior().get_circuit_network(2)

                    if networkRED and networkRED.network_id == combinatorRED_networkID then
                        table.insert(machinesRED, "[entity=" .. entity.name .. "] -> [gps=" .. entity.position.x .. "," .. entity.position.y .. "]")
                        storage["FPCM"][entity_number].machinesRED = storage["FPCM"][entity_number].machinesRED or {} -- WRITE: create a new table if it doesn't exist
                        table.insert({
                            name = entity.name,
                            type = entity.type,
                            position = entity.position,
                            status = entity.status
                            -- add more here
                        }, storage["FPCM"][entity_number].machinesRED) -- WRITE: store the connected machines in the storage
                    else
                        storage["FPCM"][entity_number].machinesRED = "None" --WRITE: if no machines are connected, write "None" to the storage
                    end

                    if networkGREEN and networkGREEN.network_id == combinatorGREEN_networkID then
                        table.insert(machinesGREEN, "[entity=" .. entity.name .. "] -> [gps=" .. entity.position.x .. "," .. entity.position.y .. "]")
                        storage["FPCM"][entity_number].machinesGREEN = storage["FPCM"][entity_number].machinesGREEN or {} -- WRITE: create a new table if it doesn't exist
                        table.insert({
                            name = entity.name,
                            type = entity.type,
                            position = entity.position,
                            status = entity.status
                            -- add more here
                        }, storage["FPCM"][entity_number].machinesGREEN) -- WRITE: store the connected machines in the storage
                    else
                        storage["FPCM"][entity_number].machinesGREEN = "None" --WRITE: if no machines are connected, write "None" to the storage
                    end
                end
            end
            player.print("Connected machines [font=default-bold][color=red](Red)[/color][/font]: " .. serpent.block(machinesRED) .. "\n\n")
            player.print("Connected machines [font=default-bold][color=green](Green)[/color][/font]: " .. serpent.block(machinesGREEN))
        end)
end)
