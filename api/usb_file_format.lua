LuaQ 0   @files/api_src/usb_file/api/usb_file_format.lua                 A@  ��  ��@@�  A@ @   A� @   A� @   A  @ � �B  C @ $   d@      G@  �       module    oraybox.api.usb_file_format    package    seeall    require 	   luci.sys    oraybox.util    oraybox.errorcode    oraybox.restarttype    restart    oraybox    restarttype    none    index        
   =     O   E   �   \� @� @ ��@ � �E�  F � F@� ^  E� F�� �  \� Z@  � ���  � A�@B�  �   ˀ� �  ���  �����  AB �� ܁ W��@	�  @�� �C ���C  � ��  ��B EB  F��� ��    \�  �EB  F��� � ��\�  �EB F��F��� \B E�  F�F�^ �@   ��@� �@ ��  � �ƀ��   �       type    string        oraybox 
   errorcode    args    io    popen    df -h | grep /tmp/storage 	   internal    lines    util    string_split         table 	   	   �  				#关闭samba
				/etc/init.d/samba stop 2>/dev/null
				
				#umount设备
				umount ##device## 2>/dev/null

				#格式化
				mkfs.exfat ##device## 2>/dev/null

				#重新桂载
				mount -o noatime,fmask=0,dmask=0 ##device## ##mount_point## 2>/dev/null
				[ $? -ne 0 ] && mount -o noatime,fmask=0,dmask=0 ##device## ##mount_point## 2>/dev/null

				#权限
				chmod 777 ##mount_point## 2>/dev/null

				#开启samba
				/etc/init.d/samba start 2>/dev/null
			    gsub    ##device##    ##mount_point##    luci    sys    exec    success    close    no_dev     O                                                                                                                                             0   2   2   2   2   2   2   2   3   3   3   3   3   3   3   5   5   5   5   5   7   7   7   7      8   :   :   <   <   <   <   =   	      device     N      f    N      partitions    N      (for generator)    H      (for state)    H      (for control)    H      line    F      disk_infos     F      cmd /   F           ?   A       J@  �   �@@ �� I� �^   �       code    device        @   @   @   @   @   @   A         args              format                                                                   =   A   A   ?   A         format           