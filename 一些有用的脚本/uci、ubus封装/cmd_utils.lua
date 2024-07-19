local function execute(cmd)
    local r, err = io.popen(cmd)
    if not r then
        return nil, err
    end

    local data = r:read("*all")
    r:close()

    return data
end

return {
    execute = execute
}