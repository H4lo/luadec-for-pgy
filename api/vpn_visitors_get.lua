module("oraybox.api.vpn_visitors_get", package.seeall)
require("oraybox.errorcode")
require("oraybox.restarttype")
require("oraybox.uci_wrapper")

restart = oraybox.restarttype.none
i_do_not_need_password = true;

local uci = oraybox.uci_wrapper.get_uci_cursor()

function info()
	local code = oraybox.errorcode.success

	--是否开启该功能
	local switch = uci:get("orayboxvpn", "visitors", "switch")--是否开启该功能
	if switch ~= "1" then switch = false else switch = true end

	--action代表所有添加进来的成员是接受还是拒绝
	--如果值为accept则代表不在表中的成员都是拒绝，在表中的成员都是接受
	--如果值为refuse则代表不在表中的成员都是接受，在表中的成员都是拒绝
	local action = uci:get("orayboxvpn", "visitors", "action")
	if action ~= "accept" then action = "refuse" end

	--如果开启了访问控制，则遍历所有访问控制项
	local visitors = {}
	uci:foreach("orayboxvpn", "visitor",
		function (s)
			local idx = #visitors + 1
			visitors[idx] = {}
			visitors[idx].name = s.name
			visitors[idx].ip = s.ip
	 		visitors[idx].mac = s.mac

			--名称是否存在使用别名，如果使用了别名，则要更正名称数据
			local f = io.popen("grep -i '" .. s.mac .. "' /etc/lan_device/device_alias.dat | awk '{$1=\"\"; sub(/^[ ]/,\"\"); print $0}'")
			if f then
				local dev_alias = string.gsub(f:read("*all"), "\n", "")
				f:close()
				if dev_alias and dev_alias ~= "" then
					visitors[idx].name = dev_alias
				end
			end
		end
	)

	return code, switch, action, visitors
end


function index(args)
	local code, switch, action, visitors = info()
        return {
		code = code,
		switch = switch,
		action = action,
		visitors = visitors,
	}
end                     
