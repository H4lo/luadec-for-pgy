LuaQ )   @files/api_src/api/timing_reboot_set.lua           2      A@    À@@  A@ @   A @   AÀ @   A  @  ÀB  C @ 
 A À Á  A A Á Á "@@ 
  A À Á  A "@ @ $   d@  ¤         äÀ     $               module    oraybox.api.timing_reboot_set    package    seeall    require    oraybox.errorcode    oraybox.restarttype    oraybox.util 	   luci.sys    restart    oraybox    restarttype    none    month_huge 	   	   	   	   	   	
   	      month_tiny 	   	   		   	      index                   E   @  \ À  @    a  @þE   À  \ À  @   a  @þA@ ^          pairs    month_huge 	      month_tiny 	   	                                                                                     mon           (for generator)    
      (for state)    
      (for control)    
      _          v          (for generator)          (for state)          (for control)          _          v                         
      @@ @ AÀ  @   @A A           luci    sys    exec    crontab /etc/crontabs/root    oraybox 
   errorcode    success     
                                              "   P    h   W @          WÀ @ À  Á     À X@@ @  À E FAÁFÁ^ Z   À X@À @ @À E FAÁFÁ^ WÀÀX Â@ ÀÀ E FAÁFÁ^ W@ WÀX B D  \ À E FAÁFÁ^ W@@X@@@  À E FAÁFÁ^ @@    B  A  EÁ FÃFAÃ \A EÁ FÃFAÃÁ \A EÁ FÃFAÃ À B @   À C @C À Ä \A D ] ^        	       * 	      oraybox 
   errorcode    args 	;   	   	   	      luci    sys    exec     rm /etc/last_timing_reboot_time 7   sed -i '/\/etc\/timing_reboot.sh/d' /etc/crontabs/root    echo '            .    /etc/timing_reboot.sh' >> /etc/crontabs/root     h   $   $   $   $   %   (   (   )   ,   ,   ,   ,   -   0   0   0   0   0   0   0   0   0   0   1   1   1   1   1   1   1   1   1   1   3   3   4   4   4   4   5   5   5   5   9   9   9   9   :   :   :   :   :   :   :   ;   ;   ;   ;   ?   ?   @   @   @   @   A   A   A   A   C   C   D   F   F   G   K   K   K   K   K   L   L   L   L   L   M   M   M   M   M   M   M   M   M   M   M   M   M   M   M   M   O   O   O   P         hour     g      minute     g      day     g      month     g      week     g         month_length    apply_crontab     R   V           @@ @ AÀ  @    @@ @ A  @                 luci    sys    exec     rm /etc/last_timing_reboot_time 7   sed -i '/\/etc\/timing_reboot.sh/d' /etc/crontabs/root        S   S   S   S   S   T   T   T   T   T   U   U   U   V             apply_crontab     X   b    	#   E   F@À FÀ À@  A   Å@ A Ü A FÁA  EA B \ A ÆAB  ÅA B Ü   @  @À@ ÀB    @  @  @           oraybox 
   errorcode    args    enabled    1 	   tonumber    hour    minute    day    month    week    0    code     #   Y   Y   Y   [   [   [   \   \   \   \   \   \   \   \   \   \   \   \   \   \   \   \   \   \   \   ]   ]   ]   ^   ^   ^   a   a   a   b         args     "   	   ret_code    "         advenced_enabled 	   disabled 2                                                                  	   	   	   	   	   	   	   	   	   	   
   
   
   
   
   
   
          P   P   P   V   V   b   b   b   X   b         month_length '   1      apply_crontab (   1      advenced_enabled +   1   	   disabled -   1       