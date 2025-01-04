local globals = {}



local vars = {}
vars.mod_name = "FPCM"
vars.debug_mode = true
vars.verbose = true




local functions = {}
function functions:print_to_console(msg) --mhm
    if game then game.print(msg) end
end

function functions:print_to_debug(msg) --ya
    log(msg)
end

function functions:try_and_catch(func, func_name) --best and worst thing yet
    if not func_name then
        func_name = "unnamed function"
    end

    local success, err = pcall(func)

    if success
    then
        self:conditional_broadcast(vars.debug_mode and vars.verbose, func_name .. " ran successfully")
        return err --err is the value returned by func, if it ran successfully
    else
        self:conditional_broadcast(vars.debug_mode, func_name .. " failed to run: " .. err)
        return false
    end
end

function functions:get_root_path()
    return storage[vars.mod_name]
end                                                          --resolve rootpath via method in case of changes

function functions:array_contains_value(array, target_value) --check array for a target value
    for _, value in ipairs(array)
    do
        if value == target_value then return true end
    end
    return false
end

function functions:conditional_broadcast(cond, msg) --print to game and debug if condition is met
    if cond then
        self:print_to_console(msg)
        self:print_to_debug(msg)
    end
end

function functions:find_entities_by_type(name)
    local entities = {}
    for _, surface in pairs(game.surfaces) do
        for _, entity in pairs(surface.find_entities_filtered { name = name }) do
            if entity.get_control_behavior() then
                table.insert(entities, entity)
            end
        end
    end
    return entities
end

function functions:highlight_entity(entity, color, text) -- entity = LuaEntity, color = 1 or 2, text = boolean|string
    local role
    if type(entity) == "number" then
        entity = game.get_entity_by_unit_number(entity)
    end
    if color == 1 then
        color = { r = 1, g = 0, b = 0 }
        role = "actor"
    elseif color == 2 then
        color = { r = 0, g = 1, b = 0 }
        role = "sensor"
    end
    local surface = entity.surface
    local bounding_box = entity.bounding_box
    local duration = 60 * 10 -- 10 seconds

    -- Outer glow layer 1
    rendering.draw_rectangle({
        color = { r = color.r, g = color.g, b = color.b, a = 0.2 },
        filled = false,
        surface = surface,
        left_top = { x = bounding_box.left_top.x - 0.2, y = bounding_box.left_top.y - 0.2 },
        right_bottom = { x = bounding_box.right_bottom.x + 0.2, y = bounding_box.right_bottom.y + 0.2 },
        time_to_live = duration
    })

    -- Outer glow layer 2
    rendering.draw_rectangle({
        color = { r = color.r, g = color.g, b = color.b, a = 0.1 },
        filled = false,
        surface = surface,
        left_top = { x = bounding_box.left_top.x - 0.4, y = bounding_box.left_top.y - 0.4 },
        right_bottom = { x = bounding_box.right_bottom.x + 0.4, y = bounding_box.right_bottom.y + 0.4 },
        time_to_live = duration
    })
    if type(text) == "boolean" and text == true then
        rendering.draw_text({
            text = { "", { "hologram-text." .. role } },
            surface = surface,
            target = entity,
            alignment = "center",
            color = { r = 1, g = 1, b = 1 }, -- if you want your text to be colored, use "[color=red/green]Your awesome string[/color] (same works with [font])"
            scale = 0.75,
            time_to_live = duration,
            use_rich_text = true
        })
    end

    if type(text) == "string" then
        rendering.draw_text({
            text = text,
            surface = surface,
            target = entity,
            alignment = "center",
            color = { r = 1, g = 1, b = 1 }, -- if you want your text to be colored, use "[color=red/green]Your awesome string[/color] (same works with [font])"
            scale = 0.75,
            time_to_live = duration,
            use_rich_text = true
        })
    end
end

function functions:draw_to_highlight(pos_a, pos_b, surface, color)
    color = color or { r = 1, g = 1, b = 0, a = 0.5 } -- given or yellow
    if pos_a.x == pos_b.x or pos_a.y == pos_b.y then -- a.x == b.x or a.y == b.y means they are on the same axis, so we can draw a straight line and save precious UPS
        rendering.draw_line({
            color = color or { r = 1, g = 1, b = 0, a = 0.5 },
            width = 2,
            gap_length = 0,
            dash_length = 0,
            from = pos_a,
            to = pos_b,
            surface = surface,
            time_to_live = 60 * 10
        })
    else
        local x = { pos_b.x, pos_a.y } -- this is the point where the line will change direction, it is the intersection between the b.x and a.y

        rendering.draw_line({          --line from linker
            color = color,
            width = 2,
            gap_length = 0,
            dash_length = 0,
            from = pos_a,
            to = x,
            surface = surface,
            time_to_live = 60 * 10
        })

        rendering.draw_circle({        --circle at intersection
            color = color,
            radius = 0.1,
            filled = true,
            target = x,
            surface = surface,
            time_to_live = 60 * 10
        })

        rendering.draw_line({ --line to machine
            color = color,
            width = 2,
            gap_length = 0,
            dash_length = 0,
            from = x,
            to = pos_b,
            surface = surface,
            time_to_live = 60 * 10
        })
    end
end

function functions:status_int_to_str(status_number)
    for name, numb in pairs(defines.entity_status) do
        if numb == status_number then
            return name
        end
    end
    return "custom_status"
end

--some methods for operating with tables !!
functions.tables = {}
function functions.tables:find(f, l) -- find element v of l satisfying f(v)
    for _, v in ipairs(l) do
        if f(v) then
            return v
        end
    end
    return nil
end

function functions.tables:remove_duplicates(t)
    local seen = {}
    local result = {}
    for _, value in ipairs(t) do
        if not seen[value] then
            seen[value] = true
            table.insert(result, value)
        end
    end
    return result
end

function functions.tables:union(t1, t2)
    local result = {}
    for _, v in ipairs(t1) do
        table.insert(result, v)
    end
    for _, v in ipairs(t2) do
        table.insert(result, v)
    end
    return self:remove_duplicates(result)
end

function functions.tables:difference(t1, t2)
    local result = {}
    local in_t2 = {}
    for _, v in ipairs(t2) do
        in_t2[v] = true
    end
    for _, v in ipairs(t1) do
        if not in_t2[v] then
            table.insert(result, v)
        end
    end
    for _, v in ipairs(t2) do
        if not in_t2[v] and not self:find(t1, v) then
            table.insert(result, v)
        end
    end
    return self:remove_duplicates(result)
end

function functions.tables:intersection(t1, t2)
    local result = {}
    local in_t2 = {}
    for _, v in ipairs(t2) do
        in_t2[v] = true
    end
    for _, v in ipairs(t1) do
        if in_t2[v] then
            table.insert(result, v)
        end
    end
    return self:remove_duplicates(result)
end

local compatible = {}
compatible.sensors = {
    "reactor",
    "assembling-machine",
    "centrifuge",
    "mining-drill",
    "accumulator",
    "transport-belt",
    "inserter",
    "logistic-container"
}
compatible.actors = {
    "assembling-machine",
    "pump",
    "centrifuge",
    "inserter",
    "mining-drill",
    "offsore-pump",
    "transport-belt",
}
compatible.all = functions.tables:union(compatible.actors, compatible.sensors)
compatible.common = functions.tables:intersection(compatible.actors, compatible.sensors)




globals.functions = functions
globals.vars = vars
globals.compatible_entities = compatible
return globals
