LuaQ    @files/api_src/api/dns_set.lua           (      A@  ��  ��@@�  A@ @   A� @   A� @   A  @ � �B  C @ � @C �C �� B � �     � �@         �� �         �  ��    � �@  �       module    oraybox.api.dns_set    package    seeall    require    oraybox.errorcode    oraybox.restarttype    oraybox.util    oraybox.uci_wrapper    restart    oraybox    restarttype    reload_network    uci_wrapper    get_uci_cursor    set    reset    index                  D   Z    �E   F@� F�� �   \@ E   F�� F � ^   �       oraybox    util    restart_network 
   errorcode    success                                                     restart_or_reload              restart_network        ,    x       �Z   ��W@   ��   �@�ƀ�   ܀   ��   �@�ƀ� � ܀ @ ��@    ���  �@�	��     Z   ��W@�  �A� �� U��ZA    �AA �@�  �A� ��  B J� ��bB� � A  � �  �B�B   C� ��A  ��  �B�B @��   A @� �@�  A@�@@�� �    �C�� �  @�� A  � �  �B�B   �C�� � B A� � A  � �  �B�B   C�� ��A  � �  �B�B � � W�@  �A  � �  �   �   ƀ�����   �       oraybox    util    string_trim    lan    6,        , 	   set_list    dhcp    dhcp_option 
   errorcode    uci    commit         set    network    dns    peerdns    0    args     x                                                                                                                                                                                                             !   !   !   !   !   !   "   "   "   "   "   "   "   "   "   "   "   "   "   #   #   #   #   #   #   #   #   #   #   #   #   #   $   $   $   $   $   $   $   $   $   $   &   &   &   &   &   &   &   *   *   *   *   ,         dns     w      backup_dns     w   
   interface     w      dns_string $   =      dns_string B   l         uci    restart_dns     .   :    4   @    �    @  �D   K@� ��    A�  \@�D   K � ��  \��Z@  ��E@ F�� F�� ^  @�D   K@� �     AA \@�D   K@� �     A� \@�D   K � �  \��Z@  � �E@ F�� F�� ^  D � W @   ��@  � � ]  ^    �       lan    delete    dhcp    dhcp_option    commit    oraybox 
   errorcode    uci    network    dns    peerdns     4   /   /   /   0   0   1   1   1   1   1   1   2   2   2   2   2   2   2   2   2   2   2   5   5   5   5   5   5   6   6   6   6   6   6   7   7   7   7   7   7   7   7   7   7   9   9   9   9   9   9   9   :      
   interface     3         uci    restart_dns     <   K    )   E   �@@ \� W��  �E   ��@ \� �� @ �B   H   F A Z   � �F A @�   �	�A�F�A Z   ��F�A W �  �J@  �� ��A �B FA �� I���^  @�J@  �  � A �� I���^   �    	   tonumber    no_restart_network 	      not_restart_net 
   interface    wan_4    wan    dns        code    set    backup_dns    reset     )   =   =   =   =   =   =   =   =   =   =   >   >   B   B   B   B   B   B   C   F   F   F   F   F   F   G   G   G   G   G   G   G   G   G   I   I   I   I   I   I   K         args     (         restart_network (                                                                  	   	   	   	   
         ,   ,   ,      :   :   :   .   K   K   <   K         uci    '      restart_network    '      restart_dns    '       