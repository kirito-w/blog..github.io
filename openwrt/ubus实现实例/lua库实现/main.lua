#!/usr/bin/env lua

local unistd = require("posix.unistd")
unistd.chdir(... or "/usr/share/sysupgrade")  -- 修改工作目录 保证require搜索路径
local uloop = require("uloop")
local ubus = require("ubus")
local js = require("cjson.safe")
local signal = require("posix.signal")
local log = require("lib.libsyslog")
local system = require("script.system")

local conn  -- ubus连接对象


uloop.init()

-- 连接ubus 失败退出
conn = ubus.connect()
if not conn then
    log.error("Failed to connect to ubusd")
    return
end

local function reply(req, status, data)
    if status then
        conn:reply(req, {status = 0, data = data})
    else
        conn:reply(req, {status = -1, error = data})
    end
end

-- 响应的结果 成功{"status": 0, "data":xxx } 失败 {"error":xxx }
conn:add({
    ["sysupgrade"] = {
        system_upgrade = {
            function (req, msg)
                local data, err = system.system_upgrade(msg)
                if data then
                    if type(data) == "string" then
                        reply(req, true, data)
                    else
                        reply(req, true, "ok")
                    end
                else
                    reply(req, false, err)
                end
            end, {keep = ubus.INT32, filepath = ubus.STRING, md5 = ubus.STRING, check_file = ubus.INT32}
        },

        system_fota_upgrade = {
            function (req, msg)
                local data, err = system.system_fota_upgrade(msg)
                if data then
                    if type(data) == "string" then
                        reply(req, true, data)
                    else
                        reply(req, true, "begin check fota")
                    end
                else
                    reply(req, false, err)
                end
                local def_req = conn:defer_request(req)  -- 推迟响应
                local wait_timer
                wait_timer = uloop.timer(function ()  -- 使用定时器轮询结果 同时让出cpu以保证ril_client_tcp_ev被调度
                    local is_wait, response = system.system_get_fota_upgrade_status()
                    if is_wait then  -- 继续等待结果或超时
                        wait_timer:set(1000)
                    else  -- 获取到结果或超时返回
                        conn:reply(def_req, response)
                        conn:complete_deferred_request(def_req, 0)
                        wait_timer:cancel()
                    end
                end, 100)
            end, {file_type = ubus.INT32, size = ubus.INT32, url = ubus.STRING, md5 = ubus.STRING}
        },

        system_diff_upgrade = {
            function (req, msg)
                local data, err = system.system_diff_upgrade(msg)
                if data then
                    if type(data) == "string" then
                        reply(req, true, data)
                    else
                        reply(req, true, "ok")
                    end
                else
                    reply(req, false, err)
                end
            end, {file_type = ubus.INT32, url = ubus.STRING, md5 = ubus.STRING}
        },
    },
})

-- 开启uloop循环
uloop.run()

