module("oraybox.api.dmz_get_ex",package.seeall)
require("oraybox.errorcode")
require("oraybox.util")
require("oraybox.restarttype")
require("oraybox.uci_wrapper")

restart = oraybox.restarttype.none

local uci = oraybox.uci_wrapper.get_uci_cursor()

local function info_ex(interface)
	local result = {
		code = oraybox.errorcode.success,
	}

	uci:foreach("firewall", "redirect", function(r)
		 if r.proto == "all" then -- means it's dmz section
			if not interface then
				local dmz = {}
				dmz.ip = r.dest_ip
				dmz.enable = (r.enable == 'true' and true or false)
				result[r.src] = dmz
			else
				if interface == r.src then
					result["ip"] = r.dest_ip
					result["enable"] = true
					if r.enable then -- 新版本因为是根据enable 字段来的 老版本由于设置dmz时  不写入enable字段 所以为了兼容以前的逻辑 先设置为true 然后再根据是否有enable字段来判断
						result["enable"] = (r.enable == 'true' and true or false)
					end
				end
			end

		end
	end)

    -- 处理oray_vnc虚拟接口的dmz配置
    local include_dmz = uci:get_all("firewall", "dmz_oray_vnc")
    if include_dmz  and not interface then
        local dmz_item = {}
        dmz_item.ip = include_dmz.dest_ip
        dmz_item.enable = (include_dmz.enable == 'true' and true or false)
        result["oray_vnc"] = dmz_item
    end
    if include_dmz and interface == "oray_vnc" then
        result["ip"] = include_dmz.dest_ip
        result["enable"] = (include_dmz.enable == 'true' and true or false)
    end

	return result
end

function index(args)
	return info_ex(args.interface)
end
