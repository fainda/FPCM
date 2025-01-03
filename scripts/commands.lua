local gv=require("global").vars --global vars
local gf=require("global").functions --global properties



function add_commands()

    commands.add_command("fpcm_scan_network", "Scans all connected machines on a given network",
    function (event)
        local linker = gf:get_root_path()["linker"][tonumber(event.parameter)]
        if not linker then
            gf:print_to_console("Invalid entity number.")
        return
        end
        -- Ensure FPCM and the unit_number table are initialized
        if not linker then gf:print_to_console("no entry found") end
        
        linker:drop_machines()
        linker:find_machines()
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
            --woahh
        end)

    commands.add_command("fpcm_storage", "Prints the storage",
        function(event)
            local player = game.get_player(event.player_index)
            if not player then return end

            player.print(serpent.block(storage.FPCM)) -- READ: get the storage.FPCM table in all its glory
        end)

    commands.add_command("fpcm_get_wire_connector_ids", "find all wire connector ids (JSON input)",
        function(event)
            local params =helpers.json_to_table(event.parameter) 
            local player = game.get_player(event.player_index)

            if not player or not params or not params.id or not params.unit then return end

            local entity = game.get_entity_by_unit_number(params.unit)
            if entity then player.print(serpent.block(entity.get_circuit_network(params.id))) else player.print("no entity with \"unit_number:\" "..params.unit.." found") end
            --player.print(serpent.block(storage.FPCM)) -- READ: get the storage.FPCM table in all its glory
        end)

end
