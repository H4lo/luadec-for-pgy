module("oraybox.api.mwan_rules_set", package.seeall)
require("oraybox.errorcode")
require("oraybox.uci_wrapper")
require("oraybox.util")
require("luci.json")
local ifm = require("oraybox.utils.iface_manager")

local uci = oraybox.uci_wrapper.get_uci_cursor()

local function check_rules_safety(rules)
	if type(rules) ~= "table" then
		return false
	end

	--检测参数
	for i = 1, #rules do
		local rule = rules[i]
		if not rule or not rule.name or rule.name == "" then
			return false 
		end
	end
	return true
end

local function check_policy(policy)
	local ret = false
	uci:foreach("mwan3", "policy", function(s)
		if s['.name'] == policy then
			ret = true
		end
	end)
	return ret
end

--设置所有规则
local function add_rules(rules)
	--添加规则
	for i = 1, #rules do
		local rule = rules[i]
		if rule then
			if check_policy(rule.use_policy) ~= true then return oraybox.errorcode.args end
			if not rule.sticky then rule.sticky = '0' end

			local name = rule.name
			rule.name = nil

			if not uci:section("mwan3", "rule", name, rule) then return oraybox.errorcode.uci end
		end
	end

	uci:commit("mwan3")
	luci.sys.exec("(sleep 3 && /etc/init.d/mwan3 restart) & 2>&1 >/dev/null")

	return oraybox.errorcode.success
end

--设置所有规则
local function set_rules(rules)
	uci:delete_all("mwan3", "rule", function(s) 
		return true
	end)
	
	--添加规则
	for i = 1, #rules do
		local rule = rules[i]
		if rule then
			if check_policy(rule.use_policy) ~= true then return oraybox.errorcode.args end
			if not rule.sticky then rule.sticky = '0' end

			local name = rule.name
			rule.name = nil

			if not uci:section("mwan3", "rule", name, rule) then return oraybox.errorcode.uci end
		end
	end

	uci:commit("mwan3")
	luci.sys.call("(sleep 3 && /etc/init.d/mwan3 restart) & 2>/dev/null")
	return oraybox.errorcode.success
end

--删除规则
local function del_rules(rules)
	uci:delete_all("mwan3", "rule", function(s) 
		for i = 1, #rules do
			if rules[i].name == s.name then
				return true
			end
		end
	end)

	uci:commit("mwan3")
	luci.sys.exec("{ sleep 3 && /etc/init.d/mwan3 restart } & 2>&1 >/dev/null")
	return oraybox.errorcode.success
end

-- 设置或者删除ispip出口规则
local function set_ispip_rules(rules)
	local inst_rule = ifm.get("mwan3", rules.name)
	if not inst_rule then
		inst_rule = ifm.add("mwan3", "rule")
		:set_key(rules.name)
	end	
	local ret = inst_rule
		:set_option("sticky", '0')
		:set_option("ipset", rules.ipset)
		:set_option("dest_port", rules.dest_port)
		:set_option("src_ip", rules.src_ip)
		:set_option("src_port", rules.src_port)
		:set_option("proto", rules.proto)
		:set_option("use_policy", rules.use_policy)
		:save()
		:commit()

	return ret 
		and oraybox.errorcode.success
		or oraybox.errorcode.uci
end

function index(args)
	local rules = luci.json.decode(args.rules)
	--检测参数
	if check_rules_safety(rules) ~= true then
		return { code = oraybox.errorcode.args }
	end

	--增加规则
	if not args.op then
		code = set_rules(rules)
	elseif args.op == '1' then
		code = add_rules(rules)
	elseif args.op == '2' then
		code = del_rules(rules)
	elseif args.op == '3' then
		code = set_ispip_rules(rules)
	end

	return {
		code = code
	}
end                               
