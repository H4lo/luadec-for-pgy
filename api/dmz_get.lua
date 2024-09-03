module("oraybox.api.dmz_get",package.seeall)
require("oraybox.errorcode")
require("oraybox.util")
require("oraybox.restarttype")
require("oraybox.uci_wrapper")

restart = oraybox.restarttype.none

local uci = oraybox.uci_wrapper.get_uci_cursor()

local function info()
	local code = oraybox.errorcode.success
	local ip = ""
	local enable = false

	uci:foreach("firewall", "redirect", function(r)
		 if r.proto == "all" and r.src == "wan" then
			ip = r.dest_ip
			enable = true
		end
	end)

	--x6系统有两个wan口
	local ip2 = ""
	local enable2 = false
	if uci:get("network", "wan2") ~= nil then
		uci:foreach("firewall", "redirect", function(r)
			 if r.proto == "all" and r.src == "wan2" then
				ip2 = r.dest_ip
				enable2 = true
			end
		end)
	end
	return code, ip, enable, ip2, enable2
end

local function info_ex()
	local result = {
		code = oraybox.errorcode.success,
	}

	uci:foreach("firewall", "redirect", function(r)
		 if r.proto == "all" then
			local tag = string.gsub(r.src, "wan", "")
			result["ip" .. tag] = r.dest_ip
			result["enable" .. tag] = true
			if r.enable ~= nil then
				result["enable" .. tag] = (r.enable == 'true' and true or false)
			end
		end
	end)

    local include_dmz = uci:get_all("firewall", "dmz")
    if include_dmz then
        result["ip_oray_vnc"] = include_dmz.dest_ip
        result["enable_oray_vnc"] = (include_dmz.enable == 'true' and true or false)
    end

	return result
end

function index(args)
	return info_ex()
end
