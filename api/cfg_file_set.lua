LuaQ     @files/api_src/cfg_file_set.lua           #      A@    À@@  A@ @   A @   AÀ @   A  @  ÀB  C @ $   d@  ¤      äÀ      $   dA          GA         module    oraybox.api.cfg_file_set    package    seeall    require    oraybox.errorcode    oraybox.restarttype    oraybox.util 	   luci.sys    restart    oraybox    restarttype    none    index        	           E      \ @À ÀE@  FÀ    \ @@E@  F Á    Á@ \Á  B  GÀ @ B   GÀ EÀ ^          type    string    len 	       find !   [ :<>?'"=+~!@#$%^&*(){}%[%]%%\|]     ret        
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
                                 name                               @@ @ EÀ  F Á F@Á  \ WÀÁ     @@ B    	      oraybox 
   errorcode    success    luci    sys    call -   /etc/backup_config.sh manual 2>&1 >/dev/null 	       unknown                                                           code          result                  7    ;      @@@   ÀZ   @WÀ@ ÀWÀÀ @Ä      Ü Ú    Ä     Ü Ú@  À Å   Æ@ÀÆ ÁÞ  Á@  ÁA@ À   À   ÁA@A À  À   ÁA@ ÁÁ  À   ACC@ WÀC E  FAÀ Ä          oraybox 
   errorcode    success        args   		mv /etc/backup/#old# /etc/backup/#new# 2>/dev/null
		rm /www/oraybox/#old# 2>/dev/null
		ln -s /etc/backup/#new# /www/oraybox/#new# 2>/dev/null
		sed -i 's/#old#/#new#/g' #file# 2>/dev/null
		sed -i '/#new#/s/ done.*//' #file# 2>/dev/null
		grep '#new# .* upload' #file# >/dev/null && return 0
		grep '#new# .* update' #file# >/dev/null || \
		sed -i '/#new#/s/$/ update #old#/' #file# 2>/dev/null
		return 0
	    string    gsub    #old#    #new#    #file#    /etc/backup/backup.list    luci    sys    call 	       unknown     ;                                                                                  -   .   .   .   .   .   .   .   /   /   /   /   /   /   /   0   0   0   0   0   0   0   1   1   1   1   1   3   3   4   4   4   6   7         old     :      new     :      code    :      cmd    :      result 4   :         check_file_name     9   K    $   E   F@À FÀ    WÀ@     À    @  À    @@ A  @ Å ÆÀÁ  A   Ü  Å@ ÆÂÆÀÂ  Ü W Ã   A@F@C^          oraybox 
   errorcode    success        args    		rm /etc/backup/#name# 2>/dev/null 
		rm /www/oraybox/#name# 2>/dev/null
		sed -i '/#name#/d' /etc/backup/backup.list 2>/dev/null
	    string    gsub    #name#    luci    sys    call 	       unknown     $   :   :   :   ;   ;   ;   ;   ;   ;   ;   ;   ;   <   <   <   <   C   D   D   D   D   D   D   D   E   E   E   E   E   G   G   H   H   H   J   K         name     #      code    #      cmd    #      result    #         check_file_name     M   W       E      \ W@À À E  FÀÀ F Á ^  A@    Á@ `À F   ÀA _þE  FÀÀ FÁ ^          type    table    oraybox 
   errorcode    args 	      success        N   N   N   N   N   O   O   O   O   R   R   R   R   S   T   T   T   R   V   V   V   V   W         names           (for index)          (for limit)          (for step)          i          name             config_delete_one     Y   i    "   E   F@À FÀ À@  AÀ     @  ÀÀ@ @A@  ÆA ÁA @  À@  BÀ  Å@ ÆÂÆÀÂC Ü    @  @  @          oraybox 
   errorcode    args    op    1    2    old    new    3    luci    json    decode    configs    code     "   Z   Z   Z   [   [   [   \   \   \   \   ^   ^   ^   _   _   _   _   _   _   a   a   a   b   b   b   b   b   b   b   b   f   g   h   i         args     !   	   ret_code    !         config_backup    config_modify    config_delete #                                                                        7   7   K   K   W   W   i   i   i   i   Y   i         check_file_name    "      config_backup    "      config_modify    "      config_delete_one    "      config_delete    "       