require("scripts.update")
require("scripts.commands")
local load_handler=require("models.load_handler"):new()

local gv=require("global").vars --global vars
local gf=require("global").functions --global properties

if gv.debug_mode and script.active_mods["gvv"] then require("__gvv__.gvv")() end



--call handlers on certain events
script.on_init(load_handler:execute_once())
script.on_configuration_changed(load_handler:execute_once()) --better safe than sorry
script.on_load(load_handler:execute_once()) --same thing


