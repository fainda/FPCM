functions ={}

function print_to_console(msg)
    game.print(msg)
end

function try_and_catch(func, func_name)
    if not func_name then
        func_name="unset"
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

return functions