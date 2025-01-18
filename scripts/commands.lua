local gv = require("global").vars      --global vars
local gf = require("global").functions --global properties
local hologram = require("models.hologram")



function add_commands()
    commands.add_command("fpcm_scan_network", "Scans all connected machines on a given network",
        function(event)
            local linker = gf:get_root_path()["linker"][tonumber(event.parameter)]
            if not linker then
                gf:print_to_console("Invalid entity number.")
                return
            end
            -- Ensure FPCM and the unit_number table are initialized
            if not linker then gf:print_to_console("no entry found") end

            linker:drop_machines()
            linker:update()
        end)

    commands.add_command("fpcm_clear", "Clears the storage",
        function(event)
            local player = game.get_player(event.player_index)
            if not player then return end

            storage.FPCM = nil -- WRITE: clear the storage
            player.print("Storage cleared.")
        end)

    commands.add_command("fpcm_break", "breakpoint for debugging",
        function(event)
            if game then
                if true then
                    --woahh
                end
            end
        end)

    commands.add_command("fpcm_call_function", "call a specified function or method (has to be in scope of commands.lua)",
        function(event)
            local func = event.parameter
            if func then
                if pcall(func) then
                    gf:conditional_broadcast(gv.debug_mode, "function " .. func .. " called successfully")
                else
                    gf:conditional_broadcast(gv.debug_mode, "function " .. func .. " failed to run")
                end
            end
        end)

    commands.add_command("fpcm_storage", "Prints the storage",
        function(event)
            local player = game.get_player(event.player_index)
            if not player then return end

            player.print(serpent.block(storage.FPCM)) -- READ: get the storage.FPCM table in all its glory
        end)

    commands.add_command("fpcm_get_wire_connector_ids", "find all wire connector ids (JSON input)",
        function(event)
            local params = helpers.json_to_table(event.parameter)
            local player = game.get_player(event.player_index)

            if not player or not params or not params.id or not params.unit then return end

            local entity = game.get_entity_by_unit_number(params.unit)
            if entity then
                player.print(serpent.block(entity.get_circuit_network(params.id)))
            else
                player.print(
                    "no entity with \"unit_number:\" " .. params.unit .. " found")
            end
            --player.print(serpent.block(storage.FPCM)) -- READ: get the storage.FPCM table in all its glory
        end)

    commands.add_command("fpcm_highlight_by_number", "highlight an entity by unit number",
        function(event)
            local player = game.get_player(event.player_index)
            if not player then return end

            local entity = game.get_entity_by_unit_number(tonumber(event.parameter))
            if entity then
                gf:highlight_entity(entity, 1)
            else
                player.print("no entity with unit number " ..
                    event.parameter .. " found")
            end
        end)

    commands.add_command("fpcm_show", "Shows all entities connected to a given controller", function(event)
        local linker = gf:get_root_path()["linker"][tonumber(event.parameter)]
        if not linker then
            gf:print_to_console("Invalid entity number.")
            return
        end
        gf:highlight_entity(linker.unit_number, gv.highlight, linker.name)
        -- loop through all machines of this linker and highlight them
        for _, network in pairs(linker.networks) do
            if network.type == "output" then
                for _, machine in pairs(network.machines) do
                    gf:highlight_entity(machine.unit_number, 1, gv.rich_red .. machine.name .. "[/color]")
                    gf:draw_to_highlight(linker.position, machine.position, linker.surface)
                end
            else
                for _, machine in pairs(network.machines) do
                    gf:highlight_entity(machine.unit_number, 2, gv.rich_green .. machine.name .. "[/color]")
                    gf:draw_to_highlight(linker.position, machine.position, linker.surface)
                end
            end
        end
    end)

    commands.add_command("fpcm_change_name", "Change the name of a given entity", function(event)
        local params = helpers.json_to_table(event.parameter) -- input example: {"unit": 123, "name": "new name"}
        if not params or not params.unit or not params.name then return end

        -- we need to loop through all linkers and their machines and compare the unit number
        for _, linker in pairs(gf:get_root_path()["linker"]) do
            if linker.unit_number == params.unit then
                linker.name = params.name
                gf:print_to_console("Name changed to: " .. params.name)
                return
            end
            for _, network in pairs(linker.networks) do
                for _, machine in pairs(network.machines) do
                    if machine.unit_number == params.unit then
                        machine.name = params.name
                        gf:print_to_console("Name changed to: " .. params.name)
                        return
                    end
                end
            end
        end
        gf:print_to_console("No entity with unit number: " .. params.unit .. " found.")
    end)

    commands.add_command("fpcm_storage_to_json", "Converts the storage to JSON", function(event)
        -- export the storage.fpcm table to a json file and save it to scripts output
        local json = helpers.table_to_json(gf:get_root_path())
        helpers.write_file("storage_fpcm.json", json)

        gf:print_to_console("Storage saved to storage_fpcm.json")
    end)

    commands.add_command("fpcm_set_active", "Toggle a machine on or off", function(event)
        local params = helpers.json_to_table(event.parameter) -- input example: {"unit": 123, "active": false}
        -- check if params are ~= nil
        if not type(params) == "string" or not params.unit or params.active == nil then return end

        -- we need to loop through all linkers and their machines and compare the unit number
        for _, linker in pairs(gf:get_root_path()["linker"]) do
            for _, network in pairs(linker.networks) do
                for _, machine in pairs(network.machines) do
                    if machine.unit_number == params.unit then
                        machine:set_active(params.active)
                        return
                    end
                end
            end
        end
    end)

    commands.add_command("fpcm_test", "Test command", function(event)
        local params = tonumber(event.parameter)

        hologram:highlight_sensor(params)
    end)

    commands.add_command("fpcm_test2", "Test command", function(event)
        local params = tonumber(event.parameter)

        hologram:highlight_actuator(params)
    end)

    commands.add_command("fpcm_test3", "Test command", function(event)
        local params = helpers.json_to_table(event.parameter) -- input example: {"from": 123, "to": 456, "straight": false}
        if not params or not params.from or not params.to then return end

        hologram:draw_path(params.from, params.to, params.straight)
    end)
end
