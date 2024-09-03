module("oraybox.api.vpn_reboot_get", package.seeall)
require("oraybox.errorcode")
require("oraybox.restarttype")
require("oraybox.util")
require("luci.sys")
local cron_command = "oraybox_api\ name\=orayboxvpn\ _api\=restart_service"

restart = oraybox.restarttype.none

local function get()
	local code = oraybox.errorcode.success
	local enabled = "0"
	local hour = nil
	local minute = nil
	local day = nil
	local week = nil
	local month = nil
	local crontab_line = luci.sys.exec("grep '" .. cron_command .. "' /etc/crontabs/root")
	if crontab_line == "" or not crontab_line then
		enabled = 0
	else
		local time_array = oraybox.util.string_split(crontab_line, " ", true)
		if #time_array >= 5 then
			minute = time_array[1]
			hour = time_array[2]
			day = time_array[3]
			month = time_array[4]
			week = time_array[5]
			enabled = "1"
		else
			enabled = "0"
		end
	end

	if "*" == day then
		day = "0"
	end

	if "*" == month then
		month = "0"
	end

	if "*" == week then
		week = "[1,2,3,4,5,6,0]"
    elseif week then 
        week = "[" .. week .. "]"
	end

	return code, enabled, hour, minute, day, month, week
end

function index(args)
	local ret_code, enabled, hour, minute, day, month, week = get()

	return {
		code = ret_code,
		enabled = enabled,
		hour = hour,
		minute = minute,
		day = day,
		month = month,
		week = week
	}
end
