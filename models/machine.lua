local gv=require("global").vars --global vars
local gf=require("global").functions --global properties

local machine={}
function machine:new(machine_entity)
    local obj={ -- make it Local?
        type = machine_entity.type,
        name = machine_entity.name,
        unit_number = machine_entity.unit_number,
        position = machine_entity.position,
        status = gf:status_int_to_str(machine_entity.status),
        signals={}--SIGNALS GO HERE
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end
function machine:update_status()
    local entity = game.get_entity_by_unit_number(self.unit_number)
    if entity and entity.status then self.status=gf:status_int_to_str(entity.status) end
end

return machine