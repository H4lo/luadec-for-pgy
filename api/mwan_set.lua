module("oraybox.api.mwan_set", package.seeall)

local errcode = require("oraybox.errorcode")
local uci = require("luci.model.uci").cursor()
local json = require("luci.json")

local section = {
	enabled = 0,
	track_ip = {"119.29.29.29", "223.5.5.5"},
	family = "ipv4",
	reliability = 1,
	count = 1,
	timeout = 2,
	size = 12,
	failure_latency = 1000,
	recovery_latency = 500,
	failure_loss = 70,
	recovery_loss = 50,
	interval = 5,
	down = 3,
	up = 8,
	check_quality = 1,
}

local function multiwan_set(rules)
	local iface, percent
	if not uci:delete("mwan3", "balanced") then return errcode.uci end
	uci:delete_all("mwan3", "interface", function(s)
		return uci:get("network", s['.name']) ~= "interface" and true or false
	end)
	uci:delete_all("mwan3", "policy", function(s)
		return true
	end)	
	uci:delete_all("mwan3", "member", function(s)
		return true
	end)

	for iface,percent in pairs(rules) do
		if uci:get("network", iface) ~= "interface" then
			return errcode.args
		end
		
		if uci:get("mwan3", iface) ~= "interface" then
			if not uci:section("mwan3", "interface", iface, section) then return errcode.uci end
		end

		local enabled = 0
		if percent ~= 0 then enabled = 1 end
		
		local member = iface .. "_m1"
		if not uci:section("mwan3", "member", member, {}) then return errcode.uci end
		if not uci:set("mwan3", member, "interface", iface) then return errcode.uci end
		if not uci:set("mwan3", member, "metric", 10) then return errcode.uci end
		if not uci:set("mwan3", member, "weight", percent) then return errcode.uci end

		local policy_only = iface .. "_only"
		if not uci:section("mwan3", "policy", policy_only, {}) then return errcode.uci end
		if not uci:set_list("mwan3", policy_only, "use_member", member) then return errcode.uci end
		
		if not uci:section("mwan3", "policy", "balanced", {}) then return errcode.uci end
		if not uci:add_list("mwan3", "balanced", "use_member", member) then return errcode.uci end
		if not uci:set("mwan3", iface, "enabled", enabled) then return errcode.uci end
	end
	if not uci:commit("mwan3") then return errcode.uci end
	luci.sys.call("(sleep 3 && /etc/init.d/mwan3 restart) & 2>/dev/null")
	return errcode.success
end

function index(args)
	local code = errcode.args

	local rules = luci.json.decode(args.rules)
	if not rules then
		return {
			code = code,
		} 
	end

	code = multiwan_set(rules)

	return {
		code = code,
	}
end

