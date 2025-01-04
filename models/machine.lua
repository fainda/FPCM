local gv = require("global").vars    --global vars
local gf = require("global").functions --global properties
local valid_properties = require("scripts.resolve_type")

local machine = {}
function machine:new(machine_entity)
    local obj = {
        type = machine_entity.type,
        name = machine_entity.name .. " " .. machine_entity.unit_number,
        unit_number = machine_entity.unit_number,
        position = machine_entity.position,
        status = gf:status_int_to_str(machine_entity.status),
        signals = {}
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function machine:update_status()
    local entity = game.get_entity_by_unit_number(self.unit_number)
    if entity and entity.status then self.status = gf:status_int_to_str(entity.status) end
end

function machine:update_signals()
    local properties = valid_properties:find(self.type)
    local entity = game.get_entity_by_unit_number(self.unit_number)
    self.signals = {}
    if entity then
        for _, property in ipairs(properties) do
            if not string.find(property, "%(%.*%)$") then -- "%(%.*%)$" is a regex pattern that matches a function call with or without arguments
                local prefix, actual_property = string.match(property, "^(.-)%.(.+)$")
                if prefix and actual_property then
                    local success, value = pcall(function() return entity[prefix][actual_property] end)
                    if success and value ~= nil then
                        self.signals[actual_property] = value
                    else
                        gf:print_to_console("Property " ..
                        actual_property .. " not found in " .. prefix .. " for " .. self.name)
                    end
                else
                    local success, value = pcall(function() return entity[property] end)
                    if success and value ~= nil then
                        self.signals[property] = value
                    else
                        gf:print_to_console("Property " .. property .. " not found for " .. self.name)
                    end
                end
            else -- property is a function
                local prefix, func = string.match(property, "^(.-)%.(.+)$")
                if not func then
                    func = property
                end
                local success, result = pcall(function()
                    local env = { entity = entity }
                    setmetatable(env, { __index = _G })
                    if prefix then
                        return load("return entity." .. prefix .. "." .. func, nil, "t", env)()
                    else
                        return load("return entity." .. func, nil, "t", env)()
                    end
                end)
                if success and result ~= nil then
                    self.signals[func] = result
                else
                    gf:print_to_console("Function " .. func .. " failed for " .. self.name)
                end
            end
        end
    end
end

return machine
