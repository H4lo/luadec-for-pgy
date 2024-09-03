# luadec-for-pgy

针对蒲公英路由器（包括但不限于X1-3111型号）的加密lua代码的解密工具luadec（https://github.com/viruscamp/luadec）进行了改造（厂商修改了lua的加密方法），主要修改代码位置为lua-5.1/src/lundump.c代码：

luaU_header 函数：

```c
void luaU_header (char* h)
{
 int x=1;
 memcpy(h,LUA_SIGNATURE,sizeof(LUA_SIGNATURE)-1);
 h+=sizeof(LUA_SIGNATURE)-1;
 *h++=(char)LUAC_VERSION;
 *h++=(char)LUAC_FORMAT;
 *h++=(char)*(char*)&x;				/* endianness */
 *h++=(char)sizeof(int);
 *h++=(char)sizeof(size_t);
 *h++=(char)sizeof(Instruction);
 *h++=(char)sizeof(lua_Number);
- *h++=(char)(((lua_Number)0.5)==0);		/* is lua_Number integral? */
+ *h++=(char)4;
}

```


LoadConstants函数：
```c
static void LoadConstants(LoadState* S, Proto* f)
{
...
-   case LUA_TNUMBER:
+   case 9:   
	setnvalue(o,LoadNumber(S));
	break;


...
}
```


LoadNumber 函数：
```c
static lua_Number LoadNumber(LoadState* S)
{
- lua_Number x;
+ size_t x;
 LoadVar(S,x);
 return x;
}

```

反编译的效果：


```bash
y@y ~/iot/source_code/luadec-for-pgy$ ./luadec/luadec ./api/sn_get.lua                                130 ↵  ✹main
-- Decompiled using luadec 2.2 rev: 895d923 for Lua 5.1 from https://github.com/viruscamp/luadec
-- Command line: ./api/sn_get.lua

-- params : ...
-- function num : 0
module("oraybox.api.sn_get", package.seeall)
require("oraybox.errorcode")
require("oraybox.restarttype")
require("oraybox.util")
require("oraybox.privilege")
require("luci.sys")
restart = (oraybox.restarttype).none
i_do_not_need_password = true
local get = function()
  -- function num : 0_0
  local code = (oraybox.errorcode).success
  local sn = (string.gsub)(((luci.sys).exec)("/sbin/oraybox_sn -n"), "\n", "")
  local machine_type = ((oraybox.util).get_machine_type)()
  local machine_name = ((oraybox.util).get_machine_name)()
  if machine_name == (oraybox.util).MACHINE_X3PRO_1153 then
    machine_name = "OrayBox X3Pro-1153"
  else
    if machine_name == (oraybox.util).MACHINE_V5_1240 then
      machine_name = "OrayBox V1000"
    end
  end
  local machine_display = ((oraybox.util).get_machine_display_name)()
  do
    local multi_user = (table.getn)(((oraybox.privilege).get_user_list)()) > 0
    do return code, sn, machine_type, machine_name, machine_display, multi_user end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
end

index = function(args)
  -- function num : 0_1 , upvalues : get
  local code, sn, machine_type, machine_name, machine_display, multi_user = get()
  return {code = code, sn = sn, machine_type = machine_type, machine_name = machine_name, machine_display = machine_display, multi_user = multi_user and 1 or 0}
end
```

- lua加密代码的分析参考files目录下的pdf文章。

Credits
-------

Original by Hisham Muhammad (http://luadec.luaforge.net)

Ongoing port to Lua 5.1 by Zsolt Sz. Sztupak (https://github.com/sztupy/luadec51/)

The internals of Lua5.1 was learned from Kein-Hong Man's A No-Frills Introduction to Lua 5.1 VM Instructions
