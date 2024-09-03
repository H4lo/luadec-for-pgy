module("oraybox.api.vpn_get", package.seeall)
require("oraybox.errorcode")
require("oraybox.restarttype")
require("oraybox.uci_wrapper")
local hlp = require("oraybox.utils.helper")
local cjson = require("cjson")
restart = oraybox.restarttype.none
i_do_not_need_password = true;

local uci = oraybox.uci_wrapper.get_uci_cursor()


function slice(tbl, first, last, step)
	local sliced = {}
	for i = first or 1 , last or #tbl, step or 1 do
		sliced[#sliced + 1] = tbl[i]
	end
	return sliced
end


function info(args)
	local code = oraybox.errorcode.success
	local vpn_info = {
		status = {},
		members_total = 0,
		code = code
	}

	--版本号
	local version = string.gsub(luci.sys.exec("/sbin/orayboxvpn -V"), "\n", "")
	vpn_info.version = version

	--加密是否
	local encrypt = uci:get("orayboxvpn", "secure", "encrypt")
	if encrypt == nil then encrypt = "0" end
	vpn_info.encrypt = encrypt

	--是否启用udpproxy
	local udpproxy = uci:get("orayboxvpn", "base", "udpproxy")
	if udpproxy == nil then udpproxy = "0" end
	vpn_info.udpproxy = udpproxy

	--是否启动智能链接
	local mlink = uci:get("orayboxvpn", "base", "mlink")
	if mlink == nil then mlink = "1" end --默认开启 
	vpn_info.mlink = mlink

	--是否需要防172冲突路由
	local no_conflict_route = uci:get("orayboxvpn", "base", "no_conflict_route")
	if no_conflict_route == nil then no_conflict_route = "0" end
	vpn_info.no_conflict_route = no_conflict_route

	local status = nil
	local f = io.open("/tmp/orayboxvpn_status", "r")

	if f == nil then return vpn_info end

	--vpn连接状态
	local file = io.open("/tmp/orayboxvpn_connect_status",'r')
	local connect_status = "disconnected"
	if file == nil then return vpn_info end
	connect_status = string.gsub(file:read("*all"), "\n", "")
	-- vpn 未链接直接返回
	if connect_status ~= "connected" then return vpn_info end
	vpn_info.connect_status = connect_status

	local members_total = 0

	local cjson = require("cjson")
	status = cjson.decode(f:read("*all"))

	if status == nil 
	   or status["connections"] == nil 
	   or #status["connections"] == 0
	   or status["connections"][1] == cjson.null
	   or status["connections"][1]["members"] == nil
	   or #status["connections"][1]["members"] == 0 
	then
		return vpn_info
	end

	local tb_all_members = status["connections"][1]["members"]

	local function get_speed(index,key)
		local value = tb_all_members[index][key]
		return value or 0
	end

	local function sum_speed(index,key_table)
		for k,v in pairs(key_table) do
			key_table[k] = key_table[k] + get_speed(index,k)
		end
		return key_table
	end

	local speed_total = {
		trans_send = 0,
		trans_send_speed = 0,
		trans_recv = 0,
		trans_recv_speed = 0,
		p2p_send = 0,
		p2p_send_speed = 0,
		p2p_recv = 0,
		p2p_recv_speed = 0
	}

	local tmp_members = {}

	-- 默认没有过滤器全部显示
	local func_filter = function(member, tmp) 
		if not member then
			return
		end
		tmp = table.insert(tmp, member) 
	end
	local tb_filter = nil
	if args.filter then
		--os.execute(string.format("logger -t filter=%s", tostring(args.filter)))
		tb_filter = cjson.decode(args.filter)
	end
	--hlp.log_debug("func_filter="..tostring(func_filter))

	-- 有过滤参数则过滤
	--hlp.tdump(tb_filter, "tb_filter")

	--hlp.log_debug(string.format("#tb_filter=%d",table.length(tb_filter)))

	if tb_filter and hlp.get_table_len(tb_filter) > 0 then
		func_filter = function(member, tmp)
			
			-- hlp.tdump(member, "member")

			if not member then
				return
			end

			--local is_matched = true
			
			--! 解析command结构 例如 ["match,sn,^P"] 匹配sn字段P开头的内容
			local function is_command_ok(cmd_array)
				if #cmd_array < 1 then return true end
				for _, command in pairs(cmd_array) do
					-- print(command)
					local comma1st_pos = string.find(command, ',')
					if not comma1st_pos then return true end
					local str_cmd = string.sub(command, 1, comma1st_pos - 1)
					local str_reminder = string.sub(command, comma1st_pos + 1, string.len(command))
					if str_cmd == "match" then --! match指令
						local comma2st_pos = string.find(str_reminder, ',')
						local field = string.sub(str_reminder, 1, comma2st_pos - 1)
						local pattern = string.sub(str_reminder, comma2st_pos + 1, string.len(str_reminder))
						return string.match(member[field], pattern)
					else
						return true
					
					end
				end
			end

			if tb_filter.command and not is_command_ok(tb_filter.command) then 
				return
			end


			if tb_filter.dev_type ~= nil and tonumber(tb_filter.dev_type) ~= tonumber(member.dev_type) then
				--is_matched = false
				return
			end

			if tb_filter.is_online ~= nil and tonumber(tb_filter.is_online) ~= tonumber(member.is_online) then
				--is_matched = false
				return
			end

			if tb_filter.search_key 
				and not (string.match(member.name, tb_filter.search_key) 
				         or string.match(member.lan_ip, tb_filter.search_key) 
				         or string.match(member.ip, tb_filter.search_key) )then
				--is_matched = false
				return
			end

			--if is_matched then
			tmp = table.insert(tmp, member) 
			--end
		end
		--hlp.log_debug("func_filter="..tostring(func_filter))
	end

	for i = 1 , #tb_all_members do
		speed_total = sum_speed(i,speed_total)
		func_filter(tb_all_members[i], tmp_members)
	end

	vpn_info["speed_total"] = speed_total

	members_total = #tmp_members
	vpn_info.members_total = members_total

    table.sort(tmp_members, function(a, b)
        if a.is_owner  ~= b.is_owner then
            return a.is_owner > b.is_owner
        elseif a.is_online  ~= b.is_online then
            return a.is_online > b.is_online
        elseif a.dev_type ~= b.dev_type then
            -- dev_type=0路由器  dev_type=1访问端
            return a.dev_type < b.dev_type
        end
    end)

	-- os.execute(string.format("logger -t %s", "length="..args.page_length.." choose="..args.page_choose))
	if args.page_length and args.page_choose then
		local page_members
		vpn_info.code , vpn_info.page_count, page_members = oraybox.util.table_paging(tmp_members, args.page_length, args.page_choose)
		--os.execute(string.format("logger -t %s", "'>>>>>>>>' origin paging_code="..paging_code.." paging_count="..paging_count))
		status["connections"][1]["members"] = page_members
	else
		status["connections"][1]["members"] = tmp_members
	end

	vpn_info.status = status
	--os.execute(string.format("logger -t %s", "'>>>>>>>>' code="..vpn_info.code.." page_count="..vpn_info.page_count))

	--[[
	if args.pages == nil and args.page_size == nil then
		vpn_info.status = status
	elseif ((args.pages-1) * args.page_size) < members_total then
		local members = slice(status["connections"][1]["members"], (args.pages -1) * args.page_size + 1, args.pages * args.page_size,1)
		status["connections"][1]["members"] = members
		vpn_info.status = status
	end
	--]]

	return vpn_info
end

function get_initiavite_list(sn)
	local curl = require("oraybox.curl_helper")
	local util = require("oraybox.util")

	local method = "GET"
	local proto = "http"
	local url = "pgy-api.oray.com"
	local route = "client/v2/initiative/data"

	local token = util.get_token("pgyapi-std.oray.net")
	local header_auth_key = "Authorization"
	local header_auth_value = "Bearer " .. token
	local header_type_key = "Content-Type"
	local header_type_value = "application/json"
	local data = string.format("{\"sn\":\"%s\",\"key\":\"%s\"}",sn,"sub_devices")

	curl_req_ctx = curl.curl_ctx_alloc()

	curl.set_method(curl_req_ctx,method)
	curl.set_protols(curl_req_ctx,proto)
	curl.set_url(curl_req_ctx,url)
	curl.set_route(curl_req_ctx,route)
	curl.add_header(curl_req_ctx,header_auth_key,header_auth_value)
	curl.add_header(curl_req_ctx,header_type_key,header_type_value)
	curl.set_data(curl_req_ctx,data)
	curl.set_timeout(curl_req_ctx,2)
	local _,rsp = curl.run(curl_req_ctx)

	return rsp
end

function index(args)
	if args.initiative ~= nil  and args.initiative == 1 and args.sn ~= nil  and args.sn ~= "" then
		return {
			code = oraybox.errorcode.success,
			data = get_initiavite_list(args.sn),
		}
	end

	local vpn_info = info(args)
        return {
		code = vpn_info.code,
		version = vpn_info.version,
		connect_status = vpn_info.connect_status,
		encrypt = vpn_info.encrypt,
		udpproxy = vpn_info.udpproxy,
		status = vpn_info.status,
		no_conflict_route = vpn_info.no_conflict_route,
		mlink = vpn_info.mlink,
		members_total = vpn_info.members_total,
		speed_total = vpn_info.speed_total,
		page_count = vpn_info.page_count,
	}
end                     

