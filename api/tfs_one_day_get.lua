LuaQ '   @files/api_src/api/tfs_one_day_get.lua           +      A@    À@@  A@ @   A @   AÀ @   A  @   A@ @ À  C @C  $   d@      ¤  äÀ  $          dA     ¤      äÁ       Ç         module    oraybox.api.tfs_one_day_get    package    seeall    require    oraybox.errorcode    oraybox.restarttype    oraybox.util 	   luci.sys    io    restart    oraybox    restarttype    none    index                   E      Á@  À ]  ^        	   tonumber    .0                                   num                   @    [   J      @@Á     AÁ  Õ@    ÀË AÜ @Á  À ÁAB@A T @@üJ  CICIBI CI@ùË DÜ@   ^  Ô  @ÄÊ    ÁDA  É É@ÄÉ@Ä CIÀ Á    AEA À ÂAB@B FÂE @  Å ÆÂÄ Ü ÂÄ  CÜ ÂÄ  BÜ ÂÔ ÌÃI Ì Ã!A  @ø^          io    popen )   cat /tmp/tfs_one_day_record | grep -F '      '    read     oraybox    util    string_split      	      time 	      send_bytes 	      recv_bytes    close 	       os    date 	   %H:%M:%S    lines    /proc/tf_stats 	       [                                                                                                            !   !   !   #   '   '   '   (   )   )   )   )   )   *   +   ,   ,   ,   0   1   1   1   1   1   2   2   2   2   2   2   3   4   4   5   6   6   6   6   6   7   7   7   7   8   8   8   8   9   9   9   :   <   1   <   ?   @         src_ip     Z      origin_data    Z      f    Z      line    "      arr    "      od    "      od +   5      i 6   Z      (for generator) :   Y      (for state) :   Y      (for control) :   Y      line ;   W      tbl A   W      ip B   W      od E   V         oray_tonumber     C   T     7      Æ @ Á    A@ FÁ FÀ@ Á FA@ 	AA@ FÁ FÁÀ  Á FA@ 	AA FÁ FAÁ@ Á FA 	AA FÁ FÁ @Á FA 	A@
  I Á FA@ 	AÁ FA@ 	AÁ FA 	AÁ FA 	A          ip    send_bytes    send_start 	   send_end    recv_bytes    recv_start 	   recv_end     7   D   E   F   F   F   G   G   G   G   G   G   G   G   H   H   H   H   H   H   H   H   I   I   I   I   I   I   I   I   J   J   J   J   J   J   J   J   J   L   L   M   M   M   N   N   N   O   O   O   P   P   P   S   S   T         val     6      datas     6      flag    6      ip    6           V   a     
   J      À     Ê  ÉAÂ@FABÉAFÂABÉ BIÀ¡   ü^    	      pairs    ip    send_bytes 	   send_end    send_start    recv_bytes 	   recv_end    recv_start 	          W   Y   Y   Y   Y   Z   [   \   \   \   \   ]   ]   ]   ]   ^   ^   ^   Y   ^   `   a         origin_data           datas          (for generator)          (for state)          (for control)          k          v          data               d   |     2   
   E   F@À   \ Z   @ÀÀ   A  Å@ ÆÁÆÀÁ  A Ü @ü
  FÁÂ	AFAÃ	AD  ÁÃ\ 	AD  AÂ\ 	AD  À  \AÀ÷@Ä @   À    Å@ ÆÄÆÀÄ  Þ         io    popen    cat /tmp/tfs_one_day_record    read     oraybox    util    string_split      	      time 	      ip 	      send_bytes 	      recv_bytes    close 
   errorcode    success     2   e   f   f   f   f   g   g   i   i   j   j   j   l   l   l   l   l   l   m   m   m   n   o   o   p   p   q   q   q   q   r   r   r   r   s   s   s   s   t   v   v   y   y   y   {   {   {   {   {   |         origin_data    1      f    1      line 	   &      arr    &      od    &      datas ,   1         oray_tonumber    append_val_to_table    calculate_total_flow            !   J      Ô   A      ÆA BÀ FÀAD  ÂÀ\   ÆÂ@ MAD  Á\   ÆA MAT LBÀI@ù^       	   	      time    send_bytes    recv_bytes     !                                                                                                      	      origin_data            format_data           (for index)          (for limit)          (for step)          i          fd          od          prev_od 	            oray_tonumber        ª    0   J         À    Ä    Ü 
  	 	ÁI ÀÀ   AÁ@    ÁABÀB ÆBWÀÂÀ  @ D  \   ÂBÔ ÌÀI¡@   ú  C@CÀ           ip    traffic 	      io    lines    /proc/tf_stats    oraybox    util    string_split      	      239.255.255.250 
   errorcode    success     0                                                                                                            ¡   ¢   £   ¤   ¤   ¤      ¥   ©   ©   ©   ©   ©   ª         src_ip     /      datas    /      origin_data          format_data 	         data 
         (for generator)    *      (for state)    *      (for control)    *      line    (      tbl    (      src_ip    (      origin_data    (      format_data "   (      data #   (         get_original_data    format_origin_data     ¬   µ       Æ @ @À Ä   ÜÀ   @  Ä  @ ÜÀ   @ Ê  É@É Þ          total_only    1    src_ip    code    datas        ®   ®   ®   ¯   ¯   ¯   ¯   ¯   ±   ±   ±   ±   ±   ´   ´   ´   ´   µ         args           code           datas              get_total_info    info +                                                                              @   @   T   a   |   |   |   |         ª   ª   ª   µ   µ   µ   ¬   µ         oray_tonumber    *      get_original_data    *      append_val_to_table    *      calculate_total_flow    *      get_total_info !   *      format_origin_data #   *      info &   *       