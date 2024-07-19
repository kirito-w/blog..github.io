local uci         = require("uci")
local cmd_utils   = require("iot.pkg.util.cmd.cmd_utils")
local table_utils = require("iot.pkg.util.table.table_utils")
local execute     = cmd_utils.execute

local function build_cursor(path)
    return uci.cursor(path and path or nil)
end

local function get(param, cursor)
    if not cursor then
        cursor = build_cursor()
    end
    return cursor:get(param.config, param.section, param.option)
end

local function get_all(param, cursor)
    if not cursor then
        cursor = build_cursor()
    end
    if param.section and param.section ~= "" then
        return cursor:get_all(param.config, param.section)
    end
    return cursor:get_all(param.config)
end


local function get_all_by_type(param, cursor)
    if not cursor then
        cursor = build_cursor()
    end
    local data = {}

    if param.config then
        cursor:foreach(param.config, param.type, function(s)
            if param.type and s[".type"] == param.type then
                data[s[".name"]] = s
            end
        end)
    end

    return data
end

local function set(param, cursor)
    if not (param.config and param.section and param.values) then
        return false
    end

    if not cursor then
        cursor = build_cursor()
    end

    local config = param.config
    local section = param.section
    for option, value in pairs(param.values) do
        if option and value then
            if type(value) == "table" and table_utils.table_is_empty(value) then
                cursor:delete(config, section, option)
            else
                cursor:set(config, section, option, value)
            end
        end
    end

    if param.commit == false then
        return true
    end

    local ok = cursor:commit(param.config)
    if not ok then
        cursor:revert(param.config)
    end

    return ok
end

local function set_list(param)
    if not (param.config and param.section and param.values) then
        return false
    end

    local config = param.config
    local section = param.section
    for option, value in pairs(param.values) do
        if type(value) == "table" then
            local delete_cmd  = string.format("uci -q delete %s.%s.%s", config, section, option)
            local _, err = execute(delete_cmd)
            if err then
                return false, string.format("uci set failed, err: %s, cmd: %s", err, delete_cmd)
            end
            for _, v in ipairs(value) do
                if v ~= "" then
                    local cmd = string.format("uci add_list %s.%s.%s=\"%s\"", config, section, option, v)
                    local _, err = execute(cmd)
                    if err then
                        return false, string.format("uci set failed, err: %s, cmd: %s", err, cmd)
                    end
                end
            end
        else
            local cmd = string.format("uci set %s.%s.%s=\"%s\"", config, section, option, value)
            local _, err = execute(cmd)
            if err then
                return false, string.format("uci set failed, err: %s, cmd: %s", err, cmd)
            end
        end
    end

    local _, err = execute(string.format("uci commit %s", config))
    if err  then
        execute(string.format("uci revert %s", config))
        return false
    end

    return true
end

local function add(param, cursor)
    if not (param.config and param.type and param.name) then
        return false
    end

    if not cursor then
        cursor = build_cursor()
    end
    cursor:set(param.config, param.name, param.type)

    if param.section and param.values then
        for option, value in pairs(param.values) do
            if option and value then
                cursor:set(param.config, param.section, option, value)
            end
        end
    end

    if param.commit == false then
        return true
    end

    local ok = cursor:commit(param.config)
    if not ok then
        cursor:revert(param.config)
    end

    return ok
end

local function delete(param, cursor)
    if not (param.config and param.section) then
        return false
    end

    if not cursor then
        cursor = build_cursor()
    end

    local config = param.config
    local section = param.section
    if param.values then
        for _, option in pairs(param.values) do
            cursor:delete(config, section, option)
        end
    else
        cursor:delete(config, section)
    end

    if param.commit == false then
        return true
    end

    local ok = cursor:commit(param.config)
    if not ok then
        cursor:revert(param.config)
    end

    return ok
end

local function uci_patchs(args, cursor)
    if not (type(args) == "table") then
        return false
    end
    if not cursor then
        cursor = build_cursor()
    end
    local config
    local handle_map = {
        add = add,
        set = set,
        delete = delete
    }

    for _, p in ipairs(args) do
        if not (p.config and p.section) then
            return false
        end
        config = p.config
        p.commit = false
        local func = handle_map[p.op]
        local ok = func(p, cursor)
        if not ok then
            return false
        end
    end

    local ok = cursor:commit(config)
    if not ok then
        cursor:revert(config)
    end

    return ok
end

---chatgpt写的
-- 定义一个函数来创建 UCI section
local function add_section(param, cursor)
    -- 创建 UCI 实例
    if not cursor then
        cursor = build_cursor()
    end

    -- 检查指定的 section 是否已存在
    if not cursor:get(param.config, param.name) then
        -- 如果 section 不存在，创建一个新的 section
        local new_section = cursor:set(param.config, param.name, param.type)
        -- 检查新的 section 是否成功创建
        if not new_section then
            return false
        end
    end

    if param.commit == false then
        return true
    end

    local ok = cursor:commit(param.config)
    if not ok then
        cursor:revert(param.config)
    end

    return true
end

-- 某一个list中再添加一个新的参数
-- 每次调用同一组list只能添加一个新参数
local function add_list_safe(param)
    if not (param.config and param.section and param.values) then
        return false
    end
    local config = param.config
    local seciton = param.section
    for option, value in pairs(param.values) do
        local cmd = string.format("uci del_list %s.%s.%s=\"%s\"", config, seciton, option, value)
        local _, err = execute(cmd)
        if err then
            err = nil
            return false, string.format("uci del_list failed, err: %s, cmd: %s", err, cmd)
        end
        local cmd = string.format("uci add_list %s.%s.%s=\"%s\"", config, seciton, option, value)
        _, err = execute(cmd)
        if err then
            return false, string.format("uci add_list failed, err: %s, cmd: %s", err, cmd)
        end
    end
    return true
end

return {
    add = add,
    get = get,
    set = set,
    delete = delete,
    uci_patchs = uci_patchs,
    set_list = set_list,
    get_all = get_all,
    get_all_by_type = get_all_by_type,
    add_section = add_section,
    add_list_safe = add_list_safe,
    build_cursor = build_cursor
}