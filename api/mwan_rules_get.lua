module("oraybox.api.mwan_rules_get", package.seeall)
require("oraybox.errorcode")
require("oraybox.util")
require("oraybox.uci_wrapper")

local uci = oraybox.uci_wrapper.get_uci_cursor()
local function info()
	local code = oraybox.errorcode.success
	
	local rules = {}
	local policy = {}
	uci:foreach("mwan3", "policy", function(s)
		policy[#policy + 1] = s['.name']
	end)

	uci:foreach("mwan3", "rule", function(s)
		local rule = {}
		rule.name = s[".name"]
		rule.fake_name = s.fake_name
		rule.dest_ip = s.dest_ip
		rule.dest_port = s.dest_port
		rule.src_ip = s.src_ip
		rule.src_port = s.src_port
		rule.proto = s.proto
		rule.use_policy = s.use_policy
		rules[#rules + 1] = rule
	end)
		
	return code, policy, rules
end


function index(args)
	local code, policy, rules = info()
        return {
		code = code,
		policy = policy,
		rules = rules,
	}
end
