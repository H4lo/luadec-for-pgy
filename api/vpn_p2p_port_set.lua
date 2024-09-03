module("oraybox.api.vpn_p2p_port_set", package.seeall)
require("oraybox.errorcode")
require("oraybox.util")
require("oraybox.uci_wrapper")

local uci = oraybox.uci_wrapper.get_uci_cursor()

function p2p_port_set(p2p_port)
	-- 为空则为随即端口
	if not p2p_port or p2p_port == "" then
		uci:delete("orayboxvpn", "base", "p2p_local_port")
		if not uci:commit("orayboxvpn") then return oraybox.errorcode.uci end
		oraybox.util.restart_orayboxvpn()
		return oraybox.errorcode.success
	end

	-- 端口范围检测
	local port_num = tonumber(p2p_port)
	if not port_num or port_num < 15111 or port_num > 16000 then
		return oraybox.errorcode.args
	end

	-- 端口是否使用中
	local result = luci.sys.exec("netstat -tunlp | grep ':" .. port_num .. " '")
	if result and result ~= '' then
		return oraybox.errorcode.in_use
	end
		
	if not uci:set("orayboxvpn", "base", "p2p_local_port", port_num) then return oraybox.errorcode.uci end
	if not uci:commit("orayboxvpn") then return oraybox.errorcode.uci end
	oraybox.util.restart_orayboxvpn()

	return oraybox.errorcode.success
end

function index(args)
        return {code = p2p_port_set(args.p2p_port)}
end                                                 

