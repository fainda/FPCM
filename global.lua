local globals = {}



local functions = {}
function functions:print_to_console(msg)
    game.print(msg)
end
function functions:print_to_debug(msg)
    log(msg)
end
function functions:try_and_catch(func, func_name)
    if not func_name then
        func_name="unnamed function"
    end

    local success, err = pcall(func)
    
    if success
    then
        print_to_console(func_name.." ran successfully")
        return err --err is the value returned by func, if it ran successfully
    else
        print_to_console(func_name.." failed to run: "..err)
        return false
    end
end
function functions:get_root_path() return storage.FPCM end




local vars = {}
vars.mod_name = "FPCM"
vars.debug_mode = true


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



globals.functions=functions
globals.vars=vars
globals.compatible_entities=compatible
return globals