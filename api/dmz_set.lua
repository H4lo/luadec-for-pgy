module("oraybox.api.dmz_set",package.seeall)
require("oraybox.errorcode")
require("oraybox.restarttype")
require("oraybox.util")
require("oraybox.uci_wrapper")

restart = oraybox.restarttype.none

local uci = oraybox.uci_wrapper.get_uci_cursor()

local function restart_firewall()
	oraybox.util.restart_firewall()
	return oraybox.errorcode.success
end

function add(wan_name, dest_ip, enable)
    local section_name

	--检查参数
	if not dest_ip or not wan_name then
		return oraybox.errorcode.args;
	end

    -- wan_name为组网接口, 用include 配置
    if wan_name == "oray_vnc" then
        section_name = "dmz_oray_vnc"
        if not uci:get("firewall", section_name, "path") then
            if not uci:set("firewall", section_name, "include") then return oraybox.errorcode.uci end
        end
        if not uci:set("firewall", section_name, "path", "/etc/firewall.dmz") then return oraybox.errorcode.uci end
        if not uci:set("firewall", section_name, "enable", enable) then return oraybox.errorcode.uci end
        if not uci:set("firewall", section_name, "src", "oray_vnc") then return oraybox.errorcode.uci end
        if not uci:set("firewall", section_name, "proto", "all") then return oraybox.errorcode.uci end
        if not uci:set("firewall", section_name, "dest_ip", dest_ip) then return oraybox.errorcode.uci end
        if not uci:set("firewall", section_name, "reload", '1') then return oraybox.errorcode.uci end
    -- wan_name为原生接口, 用redirect配置
    else
        --添加节点
        section_name = uci:add("firewall", "redirect")
        if not section_name then return oraybox.errorcode.uci end
        --配置参数提交
        if not uci:set("firewall", section_name, "src", wan_name) then return oraybox.errorcode.uci  end
        if not uci:set("firewall", section_name, "proto", "all") then return oraybox.errorcode.uci  end
        if not uci:set("firewall", section_name, "dest_ip", dest_ip) then return oraybox.errorcode.uci  end
        if not uci:set("firewall", section_name, "enable", enable) then return oraybox.errorcode.uci  end
        if not uci:set("firewall", section_name, "enabled", enable == "false" and '0' or '1') then return oraybox.errorcode.uci  end
    end

    if not uci:commit("firewall") then return oraybox.errorcode.uci end

    return oraybox.errorcode.success
end

function edit(wan_name, enable, dest_ip)
    local section_name

	--检查参数
	if not wan_name then
		return oraybox.errorcode.args;
	end

    if wan_name == "oray_vnc" then
    -- wan_name为组网接口, 用include 配置
        section_name = "dmz_oray_vnc"
        if not uci:get("firewall", section_name, "path") then
            local ret_code = add(wan_name, dest_ip, enable)
            if ret_code ~= oraybox.errorcode.success then return ret_code end
        end
        if not uci:set("firewall", section_name, "enable", enable) then return oraybox.errorcode.uci end
        if dest_ip and not uci:set("firewall", section_name, "dest_ip", dest_ip) then return oraybox.errorcode.uci  end
        if not uci:commit("firewall") then return oraybox.errorcode.uci end
    else
    -- wan_name为原生接口, 用redirect配置
        local edit_count = 0
        uci:foreach("firewall", "redirect", function(sec)
            if sec.src == wan_name and sec.proto == "all"  then
                edit_count = edit_count + 1
                if not uci:set("firewall", sec[".name"], "enable", enable) then return oraybox.errorcode.uci end
                if not uci:set("firewall", sec[".name"], "enabled", (enable == "false") and '0' or '1') then return oraybox.errorcode.uci end
                if dest_ip and not uci:set("firewall", sec[".name"], "dest_ip", dest_ip) then return oraybox.errorcode.uci  end
            end
        end)
        if edit_count == 0 then
            local ret_code = add(wan_name, dest_ip, enable)
            if ret_code ~= oraybox.errorcode.success then return ret_code end
        end
    end
    if not uci:commit("firewall") then return oraybox.errorcode.uci end
    return restart_firewall()
end

function index(args)
	local code = oraybox.errorcode.args

	-- wan_name 参数检测
	if not args.wan_name then
		args.wan_name = "wan"
	end
    -- args.enabled 字段兼容
    if args.enabled then
        args.enable = (args.enabled == '0') and "false" or "true"
    end
    -- args.enable 默认字段
    if not args.enable then
        args.enable = "true"
    end

    return {
        code = edit(args.wan_name, args.enable, args.dest_ip)
    }
end
