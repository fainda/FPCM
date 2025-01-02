script.on_nth_tick(60, function(event)
    inputEntity(event)
end)

function inputEntity(event)
    for _, surface in pairs(game.surfaces) do
        for _, entity in pairs(surface.find_entities_filtered { name = "test1-combinator" }) do
            if entity.get_control_behavior() then
                local signal_red = entity.get_control_behavior().get_circuit_network(1)
                local signal_green = entity.get_control_behavior().get_circuit_network(2)
                local machines_red = nil
                local machines_green = nil
                storage["FPCM"] = storage["FPCM"] or {} -- READ&WRITE: create a new table if it doesn't exist
                storage["FPCM"][entity.unit_number] = { red = signal_red, green = signal_green, position = entity.position, surface = entity.surface } -- READ&WRITE: store the Process Controller's network ID, and so on

                if signal_red ~= nil then
                    if signal_red.signals == nil then
                        -- game.print("Signal red is nil")
                    else
                        for _, signal in pairs(signal_red.signals) do
                            -- game.print("[font=default-bold][color=red]x".. signal.count .. "[/color][/font] [item=".. signal.signal.name .. "]")
                        end
                    end
                end
                if signal_green ~= nil then
                    if signal_green.signals == nil then
                        -- game.print("Signal green is nil")
                    else
                        for _, signal in pairs(signal_green.signals) do
                            -- game.print("[font=default-bold][color=green]x".. signal.count .. "[/color][/font] [item=".. signal.signal.name .. "]")
                        end
                    end
                end

                if machines_red ~= nil then
                    -- game.print("Connected machines (red):")
                    for _, machine in pairs(machines_red) do
                        -- game.print(machine.name .. " at position " .. serpent.line(machine.position))
                    end
                else
                    -- game.print("No machines connected with red wire.")
                end

                if machines_green ~= nil then
                    -- game.print("Connected machines (green):")
                    for _, machine in pairs(machines_green) do
                        -- game.print(machine.name .. " at position " .. serpent.line(machine.position))
                    end
                else
                    -- game.print("No machines connected with green wire.")
                end
            end
        end
    end
end