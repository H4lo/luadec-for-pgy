module("oraybox.api.vpn_set", package.seeall)
require("oraybox.errorcode")
require("oraybox.restarttype")
require("oraybox.util")
require("oraybox.uci_wrapper")

restart = oraybox.restarttype.none

local uci = oraybox.uci_wrapper.get_uci_cursor()

function set(encrypt, udpproxy, no_conflict_route, mlink)
	--参数检验
	if encrypt ~= "1" and encrypt ~= "0" then
		return oraybox.errorcode.args
	end

	if udpproxy == nil then
		udpproxy = "0"
	elseif udpproxy ~= "1" and udpproxy ~= "0" then
		return oraybox.errorcode.args
	end

	if mlink == nil then
		mlink = "1"
	elseif mlink ~= "1" and mlink ~= "0" then
		return oraybox.errorcode.args
	end

	if not uci:set("orayboxvpn", "secure", "encrypt", encrypt) then return oraybox.errorcode.uci end
	if not uci:set("orayboxvpn", "base", "udpproxy", udpproxy) then return oraybox.errorcode.uci end
	if not uci:set("orayboxvpn", "base", "mlink", mlink) then return oraybox.errorcode.uci end

	--是否需要防172冲突的路由
	if no_conflict_route == "1" or no_conflict_route == "0" then
		if not uci:set("orayboxvpn", "base", "no_conflict_route", no_conflict_route) then return oraybox.errorcode.uci end
	end

	if not uci:commit("orayboxvpn") then return oraybox.errorcode.uci end

	oraybox.util.restart_orayboxvpn()

	return oraybox.errorcode.success
end

function index(args)
        return {code = set(args.encrypt, args.udpproxy, args.no_conflict_route)}
end                                                 

