LuaQ &   @files/api_src/api/sys_upgrade_ex.lua                 A@    ΐ@@  A@ @   A @   Aΐ @   A  @   A@ @ ΐ  C @C  $    $@  ΐ         module    oraybox.api.sys_upgrade_ex    package    seeall    require    oraybox.errorcode    oraybox.restarttype    oraybox.util    oraybox.log 	   luci.sys    restart    oraybox    restarttype    reboot    done    index        
   L     
I   A  A  @ΐΒ     A ZB    AB  @ A  @ΐ @   @ A  @ΐΒ A  @ A  @ΐB    @ [B   AB  @ A  @ΐ @ @ Α CACΐ Cΐ ΕΑ ΖΔAΔDΐ ΕΑ ΖΔΑΔ  Eΐ ΕΑ ΖΔAΕ ΕΑ ΖΔΕ      p  		#δΈθ½½ 
		#md5 check
		md5=$(echo #md5# | tr '[a-z]' '[A-Z]')

		if [ -f /tmp/#file_name# ]; then
			file_md5=$(md5sum /tmp/#file_name# | cut -d " " -f1 | tr '[a-z]' '[A-Z]')
			[ "$file_md5" = "$md5" ] && {
				sysupgrade /tmp/#file_name#
				if [ $? -ne 0 ]; then
					exit 3
				fi
				exit 0
			}
		fi
		rm -f /tmp/#file_name#
		wget #use_https# #url# -q -O /tmp/#file_name#
		if [ $? -ne 0 ]; then
			exit 1
		fi

		if [ "$md5" != "" ]; then
			dl_file_md5=$(md5sum /tmp/#file_name# | cut -d " " -f1 | tr '[a-z]' '[A-Z]')
			if [ "$md5" != "$dl_file_md5" ]; then
				exit 2
			fi
		fi

		#εηΊ§
		if [ "#upgrade_type#" == "sysupgrade" ]; then
			{
				sleep 5 && sysupgrade /tmp/#file_name#
			} &
			exit 0

		elif [ "#upgrade_type#" == "mtd" ]; then 
			mtd write /tmp/#file_name# firmware -r
			if [ $? -ne 0 ]; then
				exit 4
			fi
		else
			exit 5
		fi

		exit 0
	    string    gsub    #use_https#    --no-check-certificate        #url#    #file_name#    oraybox_firmware.bin    #md5#    #upgrade_type#    luci    sys    call 	       oraybox 
   errorcode    success 	   	   download 	      md5    args     I   8   :   :   :   :   :   :   :   :   :   :   :   :   ;   ;   ;   ;   ;   ;   ;   <   <   <   <   <   <   <   =   =   =   =   =   =   =   =   =   =   =   >   >   >   >   >   >   >   A   A   A   A   A   B   B   C   C   C   C   D   D   E   E   E   E   F   F   G   G   G   G   I   I   I   K   L         url     H   
   file_name     H      md5     H      upgrade_type     H   
   use_https     H      cmd    H      code 2   H           N   P        J@  @  Ζ@ Α@ FA AA ΖA  I ^          code    done    url 
   file_name    md5    upgrade_type 
   use_https        O   O   O   O   O   O   O   O   O   O   P         args     
                                                                                  L   
   P   N   P           