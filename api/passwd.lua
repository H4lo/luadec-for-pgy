LuaQ    @files/api_src/api/passwd.lua           "      A@  ��  ��@@�  A@ @   A� @   A� @   A  @   A@ @ �  C @C � � �C �C �� d       G  d@  G@  �       module    oraybox.api.passwd    package    seeall    require    oraybox.errorcode    oraybox.uci_wrapper    oraybox.restarttype    oraybox.privilege 	   luci.sys    restart    oraybox    restarttype    none    uci_wrapper    get_uci_cursor    modify    index           5    �   �   �@�ƀ� Z   ���   @�W�� � �W�@@ ��� � �E  FA�F��^    @ � A ��EA F��F��F��A �� \��ZA   �EA F��F��F��A � \��Z   �EA F��F��F���A � \��Z  @�E  FA����@�E  FA�� �@�E  FA�F���  \� @���E  FA�F���  � \��� �D  K��A   A� \��Z  @ ������  �A@��B�  ��AB �  �  ܁��A  � ��  �A��A��  ��AB �  �� � ܁ �A  � ��  �A��A��  ���AB ܁��A  � ��  �A��A� ����  �EB A  �B � �A �  ��EB �A���� �� �       oraybox 
   errorcode    args        admin    luci    sys    user    checkpasswd    oray 
   setpasswd    success    wrong_passwd 
   privilege    get_user_pwd    modify_user_pwd    get    system    initialization    0    set    uci 	      commit 	    	   password     �                                                                                                                                                                              #   #   #   #   #   #   #   $   $   $   $   $   $   $   )   )   )   )   )   )   *   *   *   *   +   +   +   ,   ,   ,   ,   ,   ,   ,   ,   ,   ,   ,   -   -   -   -   -   -   -   -   -   -   -   -   .   .   .   .   .   .   .   .   .   0   0   1   1   1   1   1   1   1   2   2   2   2   4   4   4   5         user     �      old_pwd     �      new_pwd     �      change_code    �   
   init_code    �      init M   �   
   init_code T   t         uci     7   =     
   �   � � A@ F�@ �� 
�  	���	� �  �       modify    old_pwd    new_pwd    code 
   init_code     
   8   8   8   8   8   9   :   ;   <   =         args     	      user     	      code    	   
   init_code    	       "                                                                           
   
   
   
   5   5      =   7   =         uci    !       