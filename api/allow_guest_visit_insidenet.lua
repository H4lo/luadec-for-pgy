LuaQ /   @files/api_src/allow_guest_visit_insidenet.lua                 A@    Ą@@  A@ @   A @   AĄ @   A  @  ĄB  C @  @C C  d       GĄ d@  G          module (   oraybox.api.allow_guest_visit_insidenet    package    seeall    require    oraybox.errorcode    oraybox.restarttype    oraybox.uci_wrapper    oraybox.util    restart    oraybox    restarttype    reload_network    uci_wrapper    get_uci_cursor    allow_guest_visit_insidenet    index        
       8   D   K Ą Į@    AĮ    \@ D   K Į Į@  Į  AA  \@ D   K Į Į@  Į  AĮ  \@ D   K Į Į@  Į  AA  \@ C  ĄB @ A   WĄB   A@     AA  AĮ   Ą @    ĄCA  @  @DD@   ĄD E          section 	   firewall    rule    allow_guest_visit_insidenet    set    src 
   lan_guest    dest    lan    proto    all    0    ACCEPT    REJECT    target    commit    oraybox    util    restart_firewall 
   errorcode    success     8                                                                                                                                                                                 switch     7      rule    7         uci        "        E   @@ \ @  @           allow_guest_visit_insidenet    switch    code                    !   !   !   "         args           errcode                                                                                               
   "      "         uci           