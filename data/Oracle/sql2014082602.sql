Delete from LeftMenuInfo where id=15
/
call LMConfig_U_ByInfoInsert (2,1,12) 
/
call LMInfo_Insert(15,16393,'/images_face/ecologyFace_2/LeftMenuIcon/SearchWorkflow.png','/workflow/search/WFSearch.jsp?fromleftmenu=1',2,1,12,3)
/
Delete from LeftMenuInfo where id=101
/
call LMConfig_U_ByInfoInsert (2,1,23)
/
call LMInfo_Insert(101,16758,'/images_face/ecologyFace_2/LeftMenuIcon/WorkflowWatch.png','/system/systemmonitor/workflow/WorkflowMonitor.jsp?fromleftmenu=1',2,1,23,3)
/
Delete from LeftMenuInfo where id=604
/
call LMConfig_U_ByInfoInsert (2,1,13)
/
call LMInfo_Insert(604,26382,'/images_face/ecologyFace_2/LeftMenuIcon/CRM_1.png','/workflow/request/WorkflowMultiPrintTree.jsp?fromleftmenu=1',2,1,13,3)
/

Delete from LeftMenuInfo where id=639
/
call LMConfig_U_ByInfoInsert (2,1,26)
/
call LMInfo_Insert(639,22231,'/images_face/ecologyFace_2/LeftMenuIcon/workflowtodoc.png','/system/systemmonitor/workflow/WorkflowToDoc.jsp',2,1,26,3 )
/

Delete from LeftMenuInfo where id=91
/

Delete from LeftMenuInfo where id=13
/
call LMConfig_U_ByInfoInsert (2,1,1)
/
call LMInfo_Insert(13,1207,'/images_face/ecologyFace_2/LeftMenuIcon/RequestView.png','/workflow/request/RequestView.jsp',2,1,1,3 )
/

Delete from LeftMenuInfo where id=12
/
call LMConfig_U_ByInfoInsert (2,1,2)
/
call LMInfo_Insert(12,16392,'/images_face/ecologyFace_2/LeftMenuIcon/RequestType.png','/workflow/request/RequestType.jsp',2,1,2,3 )
/

Delete from LeftMenuInfo where id=90
/
call LMConfig_U_ByInfoInsert (2,1,3)
/
call LMInfo_Insert(90,17991,'/images_face/ecologyFace_2/LeftMenuIcon/RequestHandled.png','/workflow/request/requesthandled.jsp',2,1,3,3 )
/

Delete from LeftMenuInfo where id=235
/
call LMConfig_U_ByInfoInsert (2,1,4)
/
call LMInfo_Insert(235,21218,'/images_face/ecologyFace_2/LeftMenuIcon/CRM_33.png','/workflow/search/RequestSupervise.jsp',2,1,4,3 )
/

Delete from LeftMenuInfo where id=14
/
call LMConfig_U_ByInfoInsert (2,1,5)
/
call LMInfo_Insert(14,1210,'/images_face/ecologyFace_2/LeftMenuIcon/MyRequestView.png','/workflow/request/MyRequestView.jsp',2,1,5,3 )
/

Delete from LeftMenuInfo where id=86
/
call LMConfig_U_ByInfoInsert (2,1,6)
/
call LMInfo_Insert(86,17723,'/images_face/ecologyFace_2/LeftMenuIcon/AgentStatistic.png','/workflow/request/wfAgentStatistic.jsp',2,1,6,3 )
/

Delete from LeftMenuInfo where id=15
/
call LMConfig_U_ByInfoInsert (2,1,7)
/
call LMInfo_Insert(15,16393,'/images_face/ecologyFace_2/LeftMenuIcon/SearchWorkflow.png','/workflow/search/WFSearch.jsp',2,1,7,3 )
/

Delete from LeftMenuInfo where id=15
/
call LMConfig_U_ByInfoInsert (2,1,7)
/
call LMInfo_Insert(15,16393,'/images_face/ecologyFace_2/LeftMenuIcon/SearchWorkflow.png','/workflow/search/WFSearch.jsp?fromleftmenu=1',2,1,7,3 )
/

Delete from MainMenuInfo where id=1311
/
call MMConfig_U_ByInfoInsert (4,28)
/
call MMInfo_Insert (1311,33660,'反向维护','/workflow/transfer/permissionSearchResult.jsp','mainFrame',4,1,28,0,'',0,'',0,'','',0,'','',3)
/

Delete from MainMenuInfo where id=1303
/
call MMConfig_U_ByInfoInsert (4,39)
/
call MMInfo_Insert (1303,32481,'规则管理','/workflow/ruleDesign/ruleListTab.jsp','mainFrame',4,1,39,0,'',0,'',0,'','',0,'','',3)
/
