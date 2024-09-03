module("oraybox.api.vpn_reboot_set", package.seeall)
require("oraybox.errorcode")
require("oraybox.restarttype")
require("oraybox.util")
require("luci.sys")
local cjson = require("cjson")
local cron_command = "'oraybox_api\ name=orayboxvpn\ _api=restart_service'"

restart = oraybox.restarttype.none

month_huge = {1, 3, 5, 7, 8, 10, 12}
month_tiny = {4, 6, 9, 11}

local function month_length(mon)
	for _, v in pairs(month_huge) do
		if v == mon then
			return 31
		end
	end

	for _, v in pairs(month_tiny) do
		if v == mon then
			return 30
		end
	end

	return 28
end


local function apply_crontab()
	os.execute("crontab /etc/crontabs/root")
	return oraybox.errorcode.success
end

local function advenced_enabled(hour, minute, day, month, raw_week)

	if nil == day or 0 == day then
		day = "*"
	end

	if nil == raw_week then
		raw_week = "*"
	end

	if nil == month or 0 == month then
		month = "*"
	end

	if not hour or hour < 0 or hour > 23 then return oraybox.errorcode.args end
	if not minute or minute < 0 or minute > 59 then return oraybox.errorcode.args end

	if month ~= "*" then
		if month < 1 or month > 12 then
			return oraybox.errorcode.args
		end
	end

	if day ~= "*" and month ~= "*" then
		if day < 1 or day > month_length(month) then
			return oraybox.errorcode.args
		end
	end

    local function format_array_week(tb_week)
        local tmp_weeks ={
            [0] = false,
            [1] = false,
            [2] = false,
            [3] = false,
            [4] = false,
            [5] = false,
            [6] = false,
        }
        local str = ""
        local count = 0
        for _, raw_elem in ipairs(tb_week) do
            if raw_elem == "*" then
                return "*"
            end
            local elem = tonumber(raw_elem)
            if elem == nil or elem < 0 or elem > 6 then
                return nil 
            end
            if not tmp_weeks[elem] then
                count = count + 1
                tmp_weeks[elem] = true
            end
        end
        for idx = 0,6 do
            if tmp_weeks[idx] then
                str = str .. tostring(idx)
                count = count - 1
                if count > 0 then
                    str = str .. ","
                end
            end
        end
        return str
    end

    local str_week = ""

    if raw_week == "*" then
        str_week = raw_week
    else
        local jarray_week = cjson.decode(raw_week)
        if not jarray_week then
            return oraybox.errorcode.args
        end
        str_week = format_array_week(jarray_week)
        if not str_week then
            return oraybox.errorcode.args
        end
    end

	--os.execute("rm -f /etc/last_vpn_reboot_time")
    -- 删除原有的crontab
	os.execute("sed -i /" .. cron_command .. "/d /etc/crontabs/root")

    -- 添加新的crontab
    local cron_cursor = minute .. " " .. hour .. "  " .. day .. " " .. month .. " " .. str_week
	os.execute("echo '" .. cron_cursor .. " " .. cron_command .. "' >> /etc/crontabs/root")

	return apply_crontab()
end

local function disabled()
	--luci.sys.exec("rm /etc/last_vpn_reboot_time")
	os.execute("sed -i /" .. cron_command .. "/d /etc/crontabs/root")
	return apply_crontab()
end

function index(args)
	local ret_code = oraybox.errorcode.args

	if args.enabled == "1" then
		ret_code = advenced_enabled(tonumber(args.hour), tonumber(args.minute), tonumber(args.day), tonumber(args.month), args.week)
	elseif args.enabled == "0" then
		ret_code = disabled()
	end
	
	return {code = ret_code}
end
