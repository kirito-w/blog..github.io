local ubus  = require("ubus")
local cjson = require('cjson.safe')

local function call(param)
    local conn = ubus.connect()
    if not conn then
        return nil, "connect ubus failed"
    end
    local resp = conn:call(param.object, param.method, param.param or {})
    conn:close()
    if not resp then
        return nil, string.format("no resp for ubus call, object: %s, method: %s, param: %s", param.object, param.method, cjson.encode(param.param) or "")
    end

    return resp
end

return {
    call = call
}