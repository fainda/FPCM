local gv = require("global").vars
local gf = require("global").functions

local hologram = {}

--- Highlights a sensor entity with a green box and triangles going outwards
--- @param entity LuaEntity|unit_number
function hologram:highlight_sensor(entity)
    if type(entity) == "number" then
        entity = game.get_entity_by_unit_number(entity)
    end

    local color = gv.green
    local surface = entity.surface
    local bounding_box = entity.bounding_box

    local rectangle_pos = { -- 0.5 larger than the bounding box
        left_top = { x = bounding_box.left_top.x - 0.5, y = bounding_box.left_top.y - 0.5 },
        right_bottom = { x = bounding_box.right_bottom.x + 0.5, y = bounding_box.right_bottom.y + 0.5 }
    }

    local smaller_rectangle_pos = { -- 0.25 larger than the bounding box
        left_top = { x = bounding_box.left_top.x - 0.25, y = bounding_box.left_top.y - 0.25 },
        right_bottom = { x = bounding_box.right_bottom.x + 0.25, y = bounding_box.right_bottom.y + 0.25 }
    }

    -- Inner Box
    rendering.draw_rectangle({
        color = { r = color.r, g = color.g, b = color.b, a = 0.2 },
        width = 1,
        filled = false,
        surface = surface,
        left_top = smaller_rectangle_pos.left_top,
        right_bottom = smaller_rectangle_pos.right_bottom,
        time_to_live = gv.hologram_duration
    })

    -- Triangle from top left and top right to the north
    rendering.draw_polygon({
        color = { r = color.r, g = color.g, b = color.b, a = 0.2 },
        filled = true,
        surface = surface,
        vertices = {
            { x = rectangle_pos.left_top.x,                                      y = rectangle_pos.left_top.y },
            { x = rectangle_pos.right_bottom.x,                                  y = rectangle_pos.left_top.y },
            { x = (rectangle_pos.left_top.x + rectangle_pos.right_bottom.x) / 2, y = rectangle_pos.left_top.y - 1 }
        },
        time_to_live = gv.hologram_duration
    })

    -- Triangle from bottom left and bottom right to the south
    rendering.draw_polygon({
        color = { r = color.r, g = color.g, b = color.b, a = 0.2 },
        filled = true,
        surface = surface,
        vertices = {
            { x = rectangle_pos.left_top.x,                                      y = rectangle_pos.right_bottom.y },
            { x = rectangle_pos.right_bottom.x,                                  y = rectangle_pos.right_bottom.y },
            { x = (rectangle_pos.left_top.x + rectangle_pos.right_bottom.x) / 2, y = rectangle_pos.right_bottom.y + 1 }
        },
        time_to_live = gv.hologram_duration
    })

    -- Triangle from top left and bottom left to the west
    rendering.draw_polygon({
        color = { r = color.r, g = color.g, b = color.b, a = 0.2 },
        filled = true,
        surface = surface,
        vertices = {
            { x = rectangle_pos.left_top.x,     y = rectangle_pos.left_top.y },
            { x = rectangle_pos.left_top.x,     y = rectangle_pos.right_bottom.y },
            { x = rectangle_pos.left_top.x - 1, y = (rectangle_pos.left_top.y + rectangle_pos.right_bottom.y) / 2 }
        },
        time_to_live = gv.hologram_duration
    })

    -- Triangle from top right and bottom right to the east
    rendering.draw_polygon({
        color = { r = color.r, g = color.g, b = color.b, a = 0.2 },
        filled = true,
        surface = surface,
        vertices = {
            { x = rectangle_pos.right_bottom.x,     y = rectangle_pos.left_top.y },
            { x = rectangle_pos.right_bottom.x,     y = rectangle_pos.right_bottom.y },
            { x = rectangle_pos.right_bottom.x + 1, y = (rectangle_pos.left_top.y + rectangle_pos.right_bottom.y) / 2 }
        },
        time_to_live = gv.hologram_duration
    })
end

--- Highlights an actuator entity with a red box and triangles going inwards
--- @param entity LuaEntity|unit_number
function hologram:highlight_actuator(entity)
    if type(entity) == "number" then
        entity = game.get_entity_by_unit_number(entity)
    end

    local color = gv.red
    local surface = entity.surface
    local bounding_box = entity.bounding_box

    local rectangle_pos = { -- 1 larger than the bounding box
        left_top = { x = bounding_box.left_top.x - 1, y = bounding_box.left_top.y - 1 },
        right_bottom = { x = bounding_box.right_bottom.x + 1, y = bounding_box.right_bottom.y + 1 }
    }

    local larger_rectangle_pos = { -- 1.5 larger than the bounding box
        left_top = { x = bounding_box.left_top.x - 1.5, y = bounding_box.left_top.y - 1.5 },
        right_bottom = { x = bounding_box.right_bottom.x + 1.5, y = bounding_box.right_bottom.y + 1.5 }
    }

    -- Outer Box
    rendering.draw_rectangle({
        color = { r = color.r, g = color.g, b = color.b, a = 0.2 },
        width = 1,
        filled = false,
        surface = surface,
        left_top = larger_rectangle_pos.left_top,
        right_bottom = larger_rectangle_pos.right_bottom,
        time_to_live = gv.hologram_duration
    })

    -- Triangle from top left and top right to the south
    rendering.draw_polygon({
        color = { r = color.r, g = color.g, b = color.b, a = 0.2 },
        filled = true,
        surface = surface,
        vertices = {
            { x = rectangle_pos.left_top.x,                                      y = rectangle_pos.left_top.y },
            { x = rectangle_pos.right_bottom.x,                                  y = rectangle_pos.left_top.y },
            { x = (rectangle_pos.left_top.x + rectangle_pos.right_bottom.x) / 2, y = rectangle_pos.left_top.y + 1 }
        },
        time_to_live = gv.hologram_duration
    })

    -- Triangle from bottom left and bottom right to the north
    rendering.draw_polygon({
        color = { r = color.r, g = color.g, b = color.b, a = 0.2 },
        filled = true,
        surface = surface,
        vertices = {
            { x = rectangle_pos.left_top.x,                                      y = rectangle_pos.right_bottom.y },
            { x = rectangle_pos.right_bottom.x,                                  y = rectangle_pos.right_bottom.y },
            { x = (rectangle_pos.left_top.x + rectangle_pos.right_bottom.x) / 2, y = rectangle_pos.right_bottom.y - 1 }
        },
        time_to_live = gv.hologram_duration
    })

    -- now we draw a triangle from top left and bottom left to the east
    rendering.draw_polygon({
        color = { r = color.r, g = color.g, b = color.b, a = 0.2 },
        filled = true,
        surface = surface,
        vertices = {
            { x = rectangle_pos.left_top.x,     y = rectangle_pos.left_top.y },
            { x = rectangle_pos.left_top.x,     y = rectangle_pos.right_bottom.y },
            { x = rectangle_pos.left_top.x + 1, y = (rectangle_pos.left_top.y + rectangle_pos.right_bottom.y) / 2 }
        },
        time_to_live = gv.hologram_duration
    })

    -- now we draw a triangle from top right and bottom right to the west
    rendering.draw_polygon({
        color = { r = color.r, g = color.g, b = color.b, a = 0.2 },
        filled = true,
        surface = surface,
        vertices = {
            { x = rectangle_pos.right_bottom.x,     y = rectangle_pos.left_top.y },
            { x = rectangle_pos.right_bottom.x,     y = rectangle_pos.right_bottom.y },
            { x = rectangle_pos.right_bottom.x - 1, y = (rectangle_pos.left_top.y + rectangle_pos.right_bottom.y) / 2 }
        },
        time_to_live = gv.hologram_duration
    })
end

--- Draws a line from one entity to another, with a bend in the middle if they are not on the same axis
--- @param from LuaEnity|unit_number
--- @param to LuaEnity|unit_number
--- @param straight boolean
function hologram:draw_path(from, to, straight)
    if type(from) == "number" then
        from = game.get_entity_by_unit_number(from)
    end
    if type(to) == "number" then
        to = game.get_entity_by_unit_number(to)
    end

    local surface = from.surface
    local color = gv.highlight

    from = from.position
    to = to.position

    -- a.x == b.x or a.y == b.y or straight means they are on the same axis or a straight line is appreciated, so we can draw a straight line and save precious UPS
    if from.x == to.x or from.y == to.y or straight then
        rendering.draw_line({ -- from -> to
            color = color,
            width = 2,
            gap_length = 0,
            dash_length = 0,
            from = from,
            to = to,
            surface = surface,
            time_to_live = gv.hologram_duration
        })
    else
        -- how far away is the from entity from the intersection point
        local delta_X = math.abs(from.x - to.x)
        local delta_Y = math.abs(from.y - to.y)

        local x -- this is the intersection point

        if delta_X > delta_Y then
            x = { to.x, from.y }
        else
            x = { from.x, to.y }
        end

        rendering.draw_line({ -- from -> x
            color = color,
            width = 2,
            gap_length = 0,
            dash_length = 0,
            from = from,
            to = x,
            surface = surface,
            time_to_live = gv.hologram_duration
        })

        rendering.draw_circle({ -- x
            color = color,
            radius = 0.1,
            filled = true,
            target = x,
            surface = surface,
            time_to_live = gv.hologram_duration
        })

        rendering.draw_line({ -- x -> to
            color = color,
            width = 2,
            gap_length = 0,
            dash_length = 0,
            from = x,
            to = to,
            surface = surface,
            time_to_live = gv.hologram_duration
        })
    end
end

--- Displays a rich text message at a given entity
--- @param entity LuaEntity|unit_number
--- @param rich_text string
function hologram:rich_text_entity(entity, rich_text)
    if type(entity) == "number" then
        entity = game.get_entity_by_unit_number(entity)
    end

        rendering.draw_text({
            text = rich_text,
            surface = entity.surface,
            target = entity,
            alignment = "center",
            color = { r = 1, g = 1, b = 1 }, -- if you want your text to be colored, use "[color=red/green]Your awesome string[/color] (same works with [font])"
            scale = 0.75,
            time_to_live = gv.hologram_duration,
            use_rich_text = true
        })
end

return hologram
