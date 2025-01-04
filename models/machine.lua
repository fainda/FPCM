local gv=require("global").vars --global vars
local gf=require("global").functions --global properties
local valid_properties=require("scripts.resolve_type")

local machine={}
function machine:new(machine_entity)
    local obj={
        type = machine_entity.type,
        name = machine_entity.name .. " " .. machine_entity.unit_number,
        unit_number = machine_entity.unit_number,
        position = machine_entity.position,
        status = gf:status_int_to_str(machine_entity.status),
        signals={}
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end
function machine:update_status()
    local entity = game.get_entity_by_unit_number(self.unit_number)
    if entity and entity.status then self.status=gf:status_int_to_str(entity.status) end
end
function machine:update_signals()
    local properties = valid_properties:find(self.type)
    local entity=game.get_entity_by_unit_number(self.unit_number)
    self.signals={}
    if entity then
        for _, property in ipairs(properties) do
            if entity[property] ~= nil then
                self.signals[property] = entity[property]
            end
        end
    end
end

return machine