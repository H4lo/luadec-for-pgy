module("oraybox.api.vpn_p2p_port_get", package.seeall)
require("oraybox.errorcode")
require("oraybox.util")
require("oraybox.uci_wrapper")

local uci = oraybox.uci_wrapper.get_uci_cursor()

-- 获取p2p设置固定端口
function p2p_port_get()
	local port = uci:get("orayboxvpn", "base", "p2p_local_port")
	if not port then port = "" end
	return oraybox.errorcode.success, port
end

function index(args)
	local code, p2p_port = p2p_port_get()
        return {
		code = code,
		p2p_port = p2p_port
	}
end                                                 

