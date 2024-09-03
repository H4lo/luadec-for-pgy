module("oraybox.api.interface_track_get", package.seeall)

local errcode = require("oraybox.errorcode")
local uci = require("luci.model.uci").cursor()


local function info(interface)
	local info = {}

	uci:foreach("mwan3", "interface", function(s)
		local iface = {}
		if not interface then
			if string.find(s[".name"], "wan") then
				iface.track_ip = s.track_ip 
				iface.reliability = s.reliability
				iface.count = s.count
				iface.timeout = s.timeout
				iface.failure_latency = s.failure_latency
				iface.recovery_latency = s.recovery_latency 
				iface.failure_loss = s.failure_loss
				iface.recovery_loss = s.recovery_loss
				iface.interval = s.interval
				iface.down = s.down
				iface.up = s.up
				info[s['.name']] = iface
			end
		else
			if s['.name'] == interface then
				info.track_ip = s.track_ip 
				info.reliability = s.reliability
				info.count = s.count
				info.timeout = s.timeout
				info.failure_latency = s.failure_latency
				info.recovery_latency = s.recovery_latency 
				info.failure_loss = s.failure_loss
				info.recovery_loss = s.recovery_loss
				info.interval = s.interval
				info.down = s.down
				info.up = s.up
			end
		end
	end)
	
	info["code"] = errcode.success
	return info 
end


function index(args)
	local info = info(args.interface)

	return info
end
