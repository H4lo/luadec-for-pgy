module("oraybox.api.mwan_get", package.seeall)

local errcode = require("oraybox.errorcode")
local uci = require("luci.model.uci").cursor()


local function info()
	local info = {}

	uci:foreach("network", "interface", function(s)
		if string.find(s[".name"], "wan") 
				and not string.match(s[".name"], "wan.*6") 
			then
			info[s[".name"]] = 0
		end
	end)
	
	local list = uci:get_list("mwan3", "balanced", "use_member")
	if list then
		for i=1,#list do
			local rex = "_m1"
			local iface = string.sub(list[i], 1, string.find(list[i], rex) - 1)
			if iface then
				info[iface] = tonumber(uci:get("mwan3", list[i], "weight"))
			end
		end
	end
	
	info["code"] = errcode.success
	return info 
end


function index(args)
	local info = info()

	return info
end
