LuaQ    @files/api_src/api/reset.lua                 A@    Ā@@  A@ @   A @   AĀ @   A  @  ĀB  C @ $   @         module    oraybox.api.reset    package    seeall    require    oraybox.errorcode    oraybox.restarttype    oraybox.util 	   luci.sys    restart    oraybox    restarttype    reboot    index        	           E   F@Ā FĀ Ā   A@AÁ  WĀA    @@F B@  @    
      oraybox 
   errorcode    success    luci    sys    call H   (/sbin/oraybox_sn -f >/dev/null && firstboot -y && sleep 3 && reboot) & 	       unknown    code        
   
   
                                                   args        	   ret_code                                                                                	              