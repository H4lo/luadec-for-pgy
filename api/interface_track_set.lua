module("oraybox.api.interface_track_set", package.seeall)

local errcode = require("oraybox.errorcode")
local uci = require("luci.model.uci").cursor()
local json = require("luci.json")

local function multiwan_track_set(interface, track_ip, count, timeout, failure_loss, failure_latency, interval, reliability)
	if not interface or type(interface) ~= "string" then
		return errcode.args
	end
	if uci:get("network", interface) ~= "interface" then
		return errcode.args
	end
	
	if uci:get("mwan3", interface) ~= "interface" then
		return errcode.args
	end

	if track_ip then
		local ip_list = luci.json.decode(track_ip)
		if ip_list and not uci:set_list("mwan3", interface, "track_ip", ip_list) then return errcode.uci end
	end
	if count and tonumber(count) and not uci:set("mwan3", interface, "count", count) then return errcode.uci end
	if timeout and tonumber(timeout) and not uci:set("mwan3", interface, "timeout", timeout) then return errcode.uci end
	if failure_loss and tonumber(failure_loss) and not uci:set("mwan3", interface, "failure_loss", failure_loss) then return errcode.uci end
	if recovery_loss and tonumber(recovery_loss) and not uci:set("mwan3", interface, "recovery_loss", recovery_loss) then return errcode.uci end
	if failure_latency and tonumber(failure_latency) and not uci:set("mwan3", interface, "failure_latency", failure_latency) then return errcode.uci end
	if recovery_latency and tonumber(recovery_latency) and not uci:set("mwan3", interface, "recovery_latency", recovery_latency) then return errcode.uci end
	if interval and tonumber(interval) and not uci:set("mwan3", interface, "interval", interval) then return errcode.uci end
	if down and tonumber(down) and not uci:set("mwan3", interface, "down", down) then return errcode.uci end
	if up and tonumber(up) and not uci:set("mwan3", interface, "up", up) then return errcode.uci end
	if reliability and tonumber(reliability) and not uci:set("mwan3", interface, "reliability", reliability) then return errcode.uci end

	if not uci:commit("mwan3") then return errcode.uci end
	luci.sys.call("(sleep 3 && /etc/init.d/mwan3 restart) & 2>/dev/null")
	
	local track_only = uci:get("mwan3", "globals", "track_only")
	if track_only and track_only == "1" or track_only == 1 then
		luci.sys.call("(sleep 3 && ifup " .. interface .. ") & 2>/dev/null")
	end

	return errcode.success
end

function index(args)
	local code = errcode.args
	code = multiwan_track_set(args.interface, args.track_ip, args.count, args.timeout, args.failure_loss, args.failure_latency, args.interval, args.reliability)

	return {
		code = code,
	}
end

