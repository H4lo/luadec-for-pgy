LuaQ '   @files/api_src/api/package_upgrade.lua                 A@    ΐ@@  A@ @   A @   Aΐ @   A  @   A@ @ ΐ  C @C  $   d@      G         module    oraybox.api.package_upgrade    package    seeall    require    oraybox.errorcode    oraybox.restarttype    oraybox.util    oraybox.log 	   luci.sys    restart    oraybox    restarttype    none    index        
   >     	^     @   @@@ @ ΐ Α  AAA   @  @@@ ΐ ΐ Α  AAA  EA  FΑΑ Α Ϊ    B B      \  EA  FΑΑ Α    \  EA  FΑΑ ΑΑ   \  EA  FΑΑ Α    @ B     \  EA FΓFΑΓ \  Δΐ Α  AFAD Δΐ Α  AFΑD Εΐ Α  AFAE Εΐ Α  AFΑE Α  AFAA^         type    string        oraybox 
   errorcode    args   		#δΈθ½½ 
		mkdir -p /tmp/package_upgrade/dl
		rm -f /tmp/package_upgrade/dl/#file_name#
		wget #use_https# #url# -q -O /tmp/package_upgrade/dl/#file_name#
		[ $? -ne 0 ] && exit 1

		#md5 check
		md5=$(echo #md5# | tr '[a-z]' '[A-Z]')
		if [ "$md5" != "" ]; then
			dl_file_md5=$(md5sum /tmp/package_upgrade/dl/#file_name# | cut -d " " -f1 | tr '[a-z]' '[A-Z]')
			if [ "$md5" != "$dl_file_md5" ]; then
				exit 2
			fi
		fi

		#εηΊ§
		touch /tmp/no_oray_daemon
		opkg install /tmp/package_upgrade/dl/#file_name# > /dev/null 2>&1
		if [ $? -ne 0 ]; then
			rm /tmp/package_upgrade/dl/#file_name# > /dev/null 2>&1
			rm /tmp/no_oray_daemon > /dev/null 2>&1
			exit 3
		fi
		rm /tmp/package_upgrade/dl/#file_name# > /dev/null 2>&1
		rm /tmp/no_oray_daemon > /dev/null 2>&1

		exit 0
	    gsub    #use_https#    --no-check-certificate    #url#    #file_name#    #md5#    luci    sys    call 	       success 	   	   download 	      md5 	   
   no_target     ^                                                                     *   ,   ,   ,   ,   ,   ,   ,   ,   ,   ,   ,   ,   -   -   -   -   -   -   -   .   .   .   .   .   .   .   /   /   /   /   /   /   /   /   /   /   /   1   1   1   1   1   2   2   3   3   3   3   4   4   5   5   5   5   6   6   7   7   7   7   8   8   9   9   9   9   ;   ;   ;   =   >         url     ]   
   file_name     ]      md5     ]   
   use_https     ]      cmd    ]      code A   ]           @   C       D   @@ Ζ@ Α@ FA \G   J@     I ^          code    url 
   file_name    md5 
   use_https        A   A   A   A   A   A   A   B   B   B   B   C         args              done                                                                            >   C   C   @   C         done           