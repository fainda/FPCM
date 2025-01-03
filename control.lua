require("scripts.combinator")
require("scripts.commands")
local gv=require("global").vars --global vars
local gf=require("global").functions --global properties
if script.active_mods["gvv"] then require("__gvv__.gvv")() end

local mod_gui = require("mod-gui")


-- define tables
local function load_handler()
    storage = storage or {}
    storage.FPCM = storage.FPCM or {}
    storage.FPCM.linker = storage.FPCM.linker or {}
    gf:print_to_debug("load handler called")
end
script.on_init(function ()
    add_commands()
    load_handler()
end)

script.on_configuration_changed(load_handler()) --better safe than sorry
script.on_load(load_handler())


-- Create the button when the player joins the game
script.on_event(defines.events.on_player_created, function(event)
    local player = game.get_player(event.player_index)
    local button_flow = mod_gui.get_button_flow(player)

    if not button_flow["fpcm_open_window_button"] then
        button_flow.add{
            type = "button",
            name = "fpcm_open_window_button",
            caption = "FPCM",
            tooltip = "Open FPC-Panel."
        }
    end
end)

-- Handle button clicks
script.on_event(defines.events.on_gui_click, function(event)
    local player = game.get_player(event.player_index)
    local element = event.element

    if not (element and element.valid) then return end

    -- Handle button click to open window
    if element.name == "fpcm_open_window_button" then
        open_example_window(player)
    end

    -- Handle close button in the window
    if element.name == "fpcm_close_window_button" then
        local screen = player.gui.screen
        if screen["example_window"] and screen["example_window"].valid then
            screen["example_window"].destroy() -- Close the window
        end
    end
end)

-- Function to open the window
function open_example_window(player)
    local screen = player.gui.screen

    -- Check if the window is already open
    if screen["example_window"] then
        screen["example_window"].destroy()
        return
    end

    -- Create the window
    local frame = screen.add{
        type = "frame",
        name = "example_window",
        caption = "",
        direction = "vertical"
    }
    frame.auto_center = true
    


    -- Add a custom title bar
    local titlebar = frame.add{
        type = "flow",
        name = "titlebar_flow",
        direction = "horizontal",
    }

    -- Title label
    titlebar.add{
        type = "label",
        caption = "Example Window",
        style = "frame_title",
        ignored_by_interaction = true
    }

    -- Drag handle (optional, for draggable windows)
    local drag_space = titlebar.add{
        type = "empty-widget",
        style = "draggable_space",
        ignored_by_interaction = true
    }
    drag_space.style.horizontally_stretchable = true
    drag_space.style.height = 36  

    -- Close button
    titlebar.add{
        type = "sprite-button",
        name = "fpcm_close_window_button",
        sprite = "utility/close",
        hovered_sprite = "utility/close_black",
        clicked_sprite = "utility/close_black",
        style = "frame_action_button",
        tooltip = "Close"
    }



    -- Add flows
    local flow_1 = frame.add{
        type="flow",
        name="fpcm_flow_1",
        direction="horizontal"
    }
    local flow_2 = frame.add{
        type="flow",
        name="fpcm_flow_2",
        direction="horizontal"
    }
    local flow_2_1 = flow_2.add{
        type="flow",
        name="fpcm_flow_2_1",
        direction="vertical"
    }
    local flow_2_2 = flow_2.add{
        type="flow",
        name="fpcm_flow_2_2",
        direction="vertical"
    }



    -- Add content to the window
    flow_1.add{
        type = "label",
        caption = "Factorio Process Control Panel."
    }
    
    -- Add a select button
    flow_2_1.add{
        type = "button",
        name = "fpcm_select_button",
        caption = "SELECT"
    }

    -- Add a start button
    flow_2_1.add{
        type = "button",
        name = "fpcm_start_button",
        caption = "start"
    }

    -- Add a stop button
    flow_2_1.add{
        type = "button",
        name = "fpcm_stop_button",
        caption = "stop"
    }
    
    -- Add a close button
    flow_2_1.add{
        type = "button",
        name = "fpcm_close_window_button",
        caption = "Close"
    }

    -- Add a close button
    flow_2_2.add{
        type = "label",
        caption = "fracked entities"
    }

    flow_2_2.add{
        type = "label",
        caption = "[testlabel]"
    }
end



--DRAG LOGIC?

-- local drag_data = {}

-- script.on_event(defines.events.on_gui_click, function(event)
--     -- Close the window when the close button is clicked
--     if event.element.name == "fpcm_close_window_button" then
--         event.element.closest("frame").destroy()
--     end
-- end)

-- script.on_event(defines.events.on_gui_dragged, function(event)
--     -- Check if the dragged element is the draggable space
--     if event.element.name == "drag_space" then
--         local frame = event.element.closest("frame")
--         if not frame then return end

--         -- Update the window position
--         if not drag_data[frame.name] then
--             drag_data[frame.name] = {initial_x = frame.position.x, initial_y = frame.position.y, start_x = event.mouse_position.x, start_y = event.mouse_position.y}
--         end

--         -- Calculate the new position
--         local delta_x = event.mouse_position.x - drag_data[frame.name].start_x
--         local delta_y = event.mouse_position.y - drag_data[frame.name].start_y
--         frame.position = {x = drag_data[frame.name].initial_x + delta_x, y = drag_data[frame.name].initial_y + delta_y}
--     end
-- end)

-- script.on_event(defines.events.on_gui_mouse_up, function(event)
--     -- Reset the dragging data when the mouse is released
--     if event.element.name == "drag_space" then
--         local frame = event.element.closest("frame")
--         if frame then
--             drag_data[frame.name] = nil
--         end
--     end
-- end)