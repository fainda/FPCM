local gv=require("global").vars --global vars
local gf=require("global").functions --global properties
local compatible_entities = require("global").compatible_entities

local load_handler={}

function load_handler:new()
    obj = {
        has_executed=false
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function load_handler:execute()
    storage = storage or {}
    storage.FPCM = storage.FPCM or {}
    storage.FPCM.linker = storage.FPCM.linker or {}
    gf:conditional_broadcast(gv.debug_mode and gv.verbose, "load handler called")
    add_commands()
    self.has_executed=true
end

function load_handler:execute_once()
    if not self.has_executed then
        self:execute()
    end
end

return load_handler