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
        func_name="unnamed function"
    end

    local success, err = pcall(func)
    
    if success
    then
        self:conditional_broadcast(vars.debug_mode and vars.verbose, func_name.." ran successfully")
        return err --err is the value returned by func, if it ran successfully
    else
        self:conditional_broadcast(vars.debug_mode, func_name.." failed to run: "..err)
        return false
    end
end
function functions:get_root_path()
    return storage.FPCM
end  --resolve rootpath via method in case of changes
function functions:array_contains_value(array, target_value) --check array for a target value
    for _, value in ipairs(array)
    do
        if value==target_value then return true end
    end
    return false
end
function functions:conditional_broadcast(cond, msg) --print to game and debug if condition is met
    if cond then 
        self:print_to_console(msg)
        self:print_to_debug(msg)
    end
end


--some methods for operating with tables !!
functions.tables={}
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




globals.functions=functions
globals.vars=vars
globals.compatible_entities=compatible
return globals