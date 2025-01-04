local gv=require("global").vars --global vars
local gf=require("global").functions --global properties
local linking_combinator=require("models.linker")



local fpcm_table={}
function fpcm_table:new()
    local obj={
        linker = {}
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end
function fpcm_table:drop_linkers()
    self.linker={}
end
function fpcm_table:drop_linker(unit_number)
    if self.linker[unit_number] then self.linker[unit_number]=nil end
end
function fpcm_table:find_linkers()
    for _, entity in pairs(gf:find_entities_by_type("linking-combinator"))
    do
        self:insert_linker(linking_combinator:new(entity))
    end
end
function fpcm_table:drop_invalid_linkers()
    for unit_number, linker in pairs(self.linker) do
        if not linker:verify_self() then
            self:drop_linker(unit_number)
        end
    end
end
function fpcm_table:update_linkers()
    self:drop_invalid_linkers()
    self:find_linkers()
    for _, linker in pairs(self.linker) do
        linker:update_networks()
    end
end
function fpcm_table:insert_linker(linker_object)
    if self.linker[linker_object.unit_number] then
        gf:conditional_broadcast(gv.debug_mode and gv.verbose, "linker could not be inserted into table: already exists")
    else
        self.linker[linker_object.unit_number]=linker_object
    end
end

return fpcm_table