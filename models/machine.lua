local gv=require("global").vars --global vars
local gf=require("global").functions --global properties
local compatible_entities = require("global").compatible_entities

local machine={}
function machine:new(machine_entity)
    for name, numb in pairs(defines.entity_status) do
        if numb == machine_entity.status then
            local status = name
            break
        end
    end
    obj={ -- make it Local?
        type = machine_entity.type,
        name = machine_entity.name,
        unit_number = machine_entity.unit_number,
        position = machine_entity.position,
        status = status,
        signals={}--SIGNALS GO HERE
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

return machine