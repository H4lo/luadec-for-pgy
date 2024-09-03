module("oraybox.api.vpn_visitors_set", package.seeall)
require("oraybox.errorcode")
require("oraybox.restarttype")
require("oraybox.util")
require("oraybox.uci_wrapper")

restart = oraybox.restarttype.none
local uci = oraybox.uci_wrapper.get_uci_cursor()

--基础设置
local function base_setup(switch, action)
	assert(switch)
	assert(action)

	if switch ~= "1" then switch = "0" end
	if action ~= "refuse" then action = "accept" end

	if uci:get("orayboxvpn", "visitors", "switch") == nil then
		local section = uci:section("orayboxvpn", "visitors", "visitors")
		if not section then return oraybox.errorcode.uci end
	end

	if not uci:set("orayboxvpn", "visitors", "switch", switch) then return oraybox.errorcode.uci end
	if not uci:set("orayboxvpn", "visitors", "action", action) then return oraybox.errorcode.uci end

	return oraybox.errorcode.success
end

--添加一个访问名单
local function add(name, ip, mac)
	--检测参数
	if not name or not ip or not mac then
		return oraybox.errorcode.args
	end

	--是否已经存在这个名单
	local is_exist = false
	uci:foreach("orayboxvpn", "visitor", function(s)
		if s.ip == ip then
			is_exist  = true
		end
	end)
	if is_exist then
		return oraybox.errorcode.target_repeat
	end

	--添加节点
	local section_name = uci:add("orayboxvpn", "visitor")
	if not section_name then return oraybox.errorcode.uci end
	
	--配置参数提交
	if not uci:set("orayboxvpn", section_name, "name", name) then return oraybox.errorcode.uci  end
	if not uci:set("orayboxvpn", section_name, "ip", ip) then return oraybox.errorcode.uci  end
	if not uci:set("orayboxvpn", section_name, "mac", mac) then return oraybox.errorcode.uci  end
	if not uci:commit("orayboxvpn") then return oraybox.errorcode.uci end

	return oraybox.errorcode.success
end

--删除一个访问名单
local function del(name, ip, mac)
	local delete_cnt = 0
	uci:delete_all("orayboxvpn", "visitor", function(s)
		if s.mac == mac and s.ip == ip then
			delete_cnt = delete_cnt + 1
			return true
		end
		return false
	end)

	if delete_cnt == 0 then
		return oraybox.errorcode.no_target;
	end

	if not uci:commit("orayboxvpn") then return oraybox.errorcode.uci end
	return oraybox.errorcode.success
end

--编辑一个访问名单
local function edit(name, ip, mac)
	local ret_code = del(name, ip, mac)
	if ret_code ~= oraybox.errorcode.success then
		return ret_code
	end

	return add(name, ip, mac)
end


function index(args)
	local ret_code = oraybox.errorcode.args

	--基本设置
	if args.switch ~= nil and args.action ~= nil then
		ret_code = base_setup(args.switch, args.action)
		if ret_code ~= oraybox.errorcode.success then
			return ret_code
		end
	end


	--名单设置
	if args.op == "1" then
		ret_code = add(args.name, args.ip, args.mac)
	elseif args.op == "2" then
		ret_code = edit(args.name, args.ip, args.mac)
	elseif args.op == "3" then
		ret_code = del(args.name, args.ip, args.mac)
	end

	--如果出错了，则恢复uci并返回
	if ret_code ~= oraybox.errorcode.success then
		uci:unload("orayboxvpn")
		return {code = ret_code}
	end

	--如果成功则提交uci
	if not uci:commit("orayboxvpn") then return {code = oraybox.errorcode.uci} end

	--实现iptables
	if args.switch == "0" then
		luci.sys.exec("lua /usr/lib/lua/oraybox/tools/orayvnc_vpn_visitors_exit.lua")
	else
		luci.sys.exec("lua /usr/lib/lua/oraybox/tools/orayvnc_vpn_visitors_init.lua")
	end

	return {code = oraybox.errorcode.success}
end
