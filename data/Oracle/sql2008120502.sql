CALL MMConfig_U_ByInfoInsert ( 3,20 )
/
CALL MMInfo_Insert ( 722,21927,'计划任务设置','/worktask/base/WT_MainCategory.jsp','mainFrame',3,1,20,0,'',0,'',0,'','',0,'','',9 )
/

CALL LMConfig_U_ByInfoInsert (1,NULL,13 )
/
CALL LMInfo_Insert (263,16539,NULL,NULL,1,NULL,13,9 )
/

CALL LMConfig_U_ByInfoInsert (2,263,0 )
/
CALL LMInfo_Insert (264,22178,'','/worktask/request/WorktaskMain.jsp?rigthPage=RequestSubmitFrame',2,263,0,9  )
/

CALL LMConfig_U_ByInfoInsert (2,263,1 )
/
CALL LMInfo_Insert (265,22179,'','/worktask/request/WorktaskMain.jsp?rigthPage=RequestApproveFrame',2,263,1,9  )
/

CALL LMConfig_U_ByInfoInsert (2,263,2 )
/
CALL LMInfo_Insert (266,22180,'','/worktask/request/WorktaskMain.jsp?rigthPage=RequestExecuteFrame',2,263,2,9  )
/

CALL LMConfig_U_ByInfoInsert (2,263,3 )
/
CALL LMInfo_Insert (267,22181,'','/worktask/request/WorktaskMain.jsp?rigthPage=RequestCheckFrame',2,263,3,9  )
/

CALL LMConfig_U_ByInfoInsert (2,263,4 )
/
CALL LMInfo_Insert (268,22182,'','/worktask/request/WorktaskMain.jsp?rigthPage=RequestMonitorFrame',2,263,4,9  )
/

CALL LMConfig_U_ByInfoInsert (2,263,5 )
/
CALL LMInfo_Insert (269,22183,'','/worktask/request/WorktaskTemplate.jsp',2,263,5,9  )
/

