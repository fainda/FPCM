local gv=require("global").vars --global vars
local gf=require("global").functions --global properties



function add_commands()

    commands.add_command("fpcm_scan_network", "Scans all connected machines on a given network",
    function (event)
        local unit_number = tonumber(event.parameter)
        if not unit_number then
            gf:print_to_console("Invalid entity number.")
            return
        end
        local linker = gf:get_root_path()["linker"][unit_number]
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

end
