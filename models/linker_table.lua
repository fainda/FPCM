local gv=require("global").vars --global vars
local gf=require("global").functions --global properties
local compatible_entities = require("global").compatible_entities
local linking_combinator=require("models.linker")



local linker_table={}
function linker_table:new()
    obj={
        linker = {}
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end
function linker_table:drop_linkers()
    self.linker={}
end
function linker_table:find_linkers()
    local found_linkers
    for _, entity in pairs(gf:find_entities_by_type("linking-combinator"))
    do
        found_linkers.entity.unit_number={}
        found_linkers.entity.unit_number=linking_combinator:new(entity)
    end
    gf.tables:union(self.linker, found_linkers)
end

return linker_table