---@diagnostic disable: undefined-global
---@
local item_sprites = {"inserter", "transport-belt", "stone-furnace", "assembling-machine-3", "logistic-chest-storage", "sulfur", "utility-science-pack", "laser-turret"}

script.on_event(defines.events.on_player_created, function(event)
    local player = game.players[event.player_index]
    local button_flow = mod_gui.get_button_flow(player)
    
    if not button_flow["example_button"] then
        button_flow.add{
            type = "button",
            name = "example_button",
            caption = "Klick mich!",
            style = mod_gui.button_style
        }
    end
end)

script.on_event(defines.events.on_gui_click, function(event)
    if event.element.name == "example_button" then
        game.players[event.player_index].print("Hallo, Factorio-Welt!")
    end
end)

--[[
script.on_event(defines.events.on_player_created, function(event)
    local player = game.get_player(event.player_index)
    storage.players[player.index] = { controls_active = true }
    local screen_element = player.gui.screen
    local main_frame = screen_element.add{type="frame", name="test_main_frame", caption={"test.hello_world"}}

    main_frame.style.size={400,200}
    main_frame.auto_center=true

    local content_frame = main_frame.add{type="frame", name="content_frame", direction="vertical", style="test_content_frame"}
    local controls_flow = content_frame.add{type="flow", name="controls_flow", direction="horizontal", style="test_controls_flow"}

    controls_flow.add{type="button", name="test_controls_toggle", caption={"test.deactivate"}}
    controls_flow.add{type="slider", name="test_controls_slider", value=0, minimum_value=0, maximum_value=#item_sprites, style="notched_slider"}
    controls_flow.add{type="textfield", name="test_controls_textfield", text="0", numeric=true, allow_decimal=false, allow_negative=false, style="test_controls_textfield"}
end)
]]

script.on_init(function()
    storage.players = {}
end)

script.on_event(defines.events.on_gui_click, function(event)
    if event.element.name=="test_controls_toggle"then
        local player_global=storage.players[event.player_index]
        player_global.controls_active=not player_global.controls_active

        local control_toggle=event.element
        control_toggle.caption=(player_global.controls_active) and {"test.deactivate"} or {"test.activate"}

        local player = game.get_player(event.player_index)
        local controls_flow = player.gui.screen.test_main_frame.content_frame.controls_flow
        controls_flow.test_controls_slider.enabled = player_global.controls_active
        controls_flow.test_controls_textfield.enabled = player_global.controls_active
    end
end)

script.on_event(defines.events.on_gui_value_changed, function(event)
    if event.element.name == "test_controls_slider" then
        local player = game.get_player(event.player_index)
        local player_global = storage.players[player.index]

        local new_button_count = event.element.slider_value
        player_global.button_count = new_button_count

        local controls_flow = player.gui.screen.test_main_frame.content_frame.controls_flow
        controls_flow.test_controls_textfield.text = tostring(new_button_count)
    end
end)

script.on_event(defines.events.on_gui_text_changed, function(event)
    if event.element.name == "test_controls_textfield" then
        local player = game.get_player(event.player_index)
        local player_global = storage.players[player.index]

        local new_button_count = tonumber(event.element.text) or 0
        local capped_button_count = math.min(new_button_count, #item_sprites)
        player_global.button_count = capped_button_count

        local controls_flow = player.gui.screen.test_main_frame.content_frame.controls_flow
        controls_flow.test_controls_slider.slider_value = capped_button_count
        controls_flow.test_controls_textfield.text = tostring(capped_button_count)
    end
end)