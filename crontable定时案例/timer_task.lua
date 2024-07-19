-- local js = require("cjson.safe")
local myerr = require("myerr")
-- local wlan = require("op.wlan")
local ioutil = require("ioutil")
local logging = require("logging")
local file_info = require("file_info")

local log = logging.default()
local TIMER_TASK_PATH = "/etc/config/ttask.json" --以此文件为准，每次添加任务时，都先情况，然后添加所有此文件中的任务，重启crontab
local CRONTAB_ROOT = "/etc/crontabs/root"
local TG_CLOSE_CMD = "lua /usr/share/netmgr/apps/2g_set_no.lua"
local TG_OPEN_CMD = "lua /usr/share/netmgr/apps/2g_set_yes.lua"
local FG_CLOSE_CMD = "lua /usr/share/netmgr/apps/5g_set_no.lua"
local FG_OPEN_CMD = "lua /usr/share/netmgr/apps/5g_set_yes.lua"
local CLOSE_ALL = "lua /usr/share/netmgr/apps/close_allwifi.lua"
local OPEN_ALL = "lua /usr/share/netmgr/apps/open_allwifi.lua"
local REBOOT = "ANDLINK_REBOOT"

local MAX_POINT = 32
local Opt_add, Opt_del = 0, 1

local function cron_effect(cmd_arr)
	table.insert(cmd_arr, string.format("/etc/init.d/cron restart", CRONTAB_ROOT))
	return true
end

-- params {"weekday":"1-7", "time":"19:30","enable":"yes"}
local function enable_cron(cmd_arr, timer_str)
	if not (timer_str) then
		return nil, myerr.INVALID_PARAMS
	end
	for i, v in ipairs(timer_str) do
		table.insert(cmd_arr, string.format("echo '%s' >> '%s'\n", timer_str[i], CRONTAB_ROOT))
	end

	return true
end

local function disable_cron(cmd_arr, timer_str)
	if not (timer_str) then
		return nil, myerr.INVALID_PARAMS
	end

	local format_timer_str = timer_str:gsub("*", "\\*"):gsub("/", "\\/")
	table.insert(cmd_arr, string.format("sed -i /'%s'/d %s", format_timer_str, CRONTAB_ROOT))

	return true
end

local function Calculation_time(data)
	if type(data) ~= "number" then
		return "*", "*"
	end

	if data <= 60 then
		return 0, 0
	end
	if data >= 86340 then
		return 23, 59
	end

	log:info("data: [%s]", data)
	local hour = data >= 3600 and tostring(data / 3600):match("%d+") or "0"
	local min = tostring((data - (3600 * hour)) / 60)

	log:info("hour:[%s], min:[%s]", hour, min)
	return hour, min:match("%d+")
end

local function byte2bin(n)
	local t = {}
	for i = 7, 0, -1 do
		t[#t + 1] = math.floor(n / 2 ^ i)
		n = n % 2 ^ i
	end
	return table.concat(t)
end

local function Calculation_time_week(data)
	if type(data) ~= "number" then
		return "*"
	end

	local num = byte2bin(data)

	local b = ""
	local count = 7
	for work in num:gmatch("%d") do
		if work == "1" then
			b = b .. count .. ","
		end
		count = count > 1 and count - 1 or 7
	end

	return string.sub(b, 1, -2)
end

-- {"TaskId":"0","Operation":"Add","TimeOffset":20,"Index":5,"Enable":1,"Week":7,"TimeOffset2":46,"Action":"ToSetHealthMode"}
local function set_crontable(cmd_arr, map)
	if map.enable == 0 then
		return
	end

	local timer_str = {}
	local hour, min = Calculation_time(map.timeOffset)
	local week, day, month = "*", "*", "*"

	if map.week == 0 then
		local now = os.date("*t", os.time())
		if now.year == map.year and now.month == map.month and now.day == map.day then
			day = map.day
			month = map.month
		else
			return true
		end
	else
		week = Calculation_time_week(map.week)
	end

	if map.action == 2 then
		local op_hour, op_min = Calculation_time(map.timeOffset2)
		local tomorr, today = week, day
		if map.timeOffset2 < map.timeOffset then
			tomorr = Calculation_time_week(map.week * 2)
			today = map.week == 0 and today + 1 or day
		end
		log:info("h:%s m:%s W:%s H:%s M:%s", hour, min, week, op_hour, op_min)

        -- 本地的index和移动的index 4和5对应是反的; 如果index是0,就关闭/打开所有的WiFi通道
		if map.index <= 4 then
            if map.index == 4 then
                map.index = 5
            end
            if map.index == 0 then
                table.insert(timer_str,
				    string.format("%s %s %s %s %s %s", min, hour, day, month, week, CLOSE_ALL))
			    table.insert(timer_str, string.format("%s %s %s %s %s %s", op_min, op_hour, today, month, tomorr,
				    OPEN_ALL))
            else
                table.insert(timer_str,
				    string.format("%s %s %s %s %s %s %s", min, hour, day, month, week, TG_CLOSE_CMD, map.index))
			    table.insert(timer_str, string.format("%s %s %s %s %s %s %s", op_min, op_hour, today, month, tomorr,
				    TG_OPEN_CMD, map.index))
            end
		end
		if map.index > 4 then
			local num = map.index - 4
            if map.index == 8 then
                num = 5
            end
			table.insert(timer_str,
				string.format("%s %s %s %s %s %s %s", op_min, op_hour, today, month, tomorr, FG_CLOSE_CMD, num))
			table.insert(timer_str,
				string.format("%s %s %s %s %s %s %s", min, hour, day, month, week, FG_OPEN_CMD, num))
		end
	end

	if map.action == 1 then
		table.insert(timer_str, string.format("%s %s %s %s %s %s", min, hour, day, month, week, REBOOT))
	end

	enable_cron(cmd_arr, timer_str)
	return true
end

local function tack_reload()

	local cmd_arr = {}
	local cmd_map = {"2g_set_no.lua", "2g_set_yes.lua", "5g_set_no.lua", "5g_set_yes.lua","ANDLINK_REBOOT","close_allwifi.lua","open_allwifi.lua"}
	for i, v in ipairs(cmd_map) do
		disable_cron(cmd_arr, cmd_map[i])
	end

	local task_list = file_info.load_parse_file(TIMER_TASK_PATH)
	if task_list and next(task_list) then
		for i, v in ipairs(task_list) do
			set_crontable(cmd_arr, task_list[i])
		end
	end

	cron_effect(cmd_arr)
	local cmd = table.concat(cmd_arr, "\n")
	local s, e = ioutil.popen(cmd)
	if e then
		log:error("Run cmd[%s] error: %s", cmd, e)
		return nil, myerr.INVALID_PARAMS
	end

	return true
end

return {
	tack_reload = tack_reload
}
