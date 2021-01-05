update systemmodule set modulereleased=1 where id=8
/

call LMConfig_U_ByInfoInsert (2,1,9)
/
call LMInfo_Insert (224,20829,'/images_face/ecologyFace_2/LeftMenuIcon/DOC_23.gif','/datacenter/report/OutReportPortal.jsp',2,1,9,8)
/
call LMConfig_U_ByInfoInsert (2,1,10)
/
call LMInfo_Insert (225,16520,'/images_face/ecologyFace_2/LeftMenuIcon/DOC_85.gif','/datacenter/maintenance/reportstatus/ReportStatus.jsp',2,1,10,8 )
/
call MMConfig_U_ByInfoInsert (9,1)
/
call MMInfo_Insert (643,16516,'','/datacenter/maintenance/inputreport/InputReport.jsp','mainFrame',9,1,1,0,'DataCenter:Maintenance',0,'DataCenter:Maintenance',0,'','',0,'','',8)
/
call MMConfig_U_ByInfoInsert (9,2)
/
call MMInfo_Insert (644,16517,'','/datacenter/maintenance/condition/OutReportCondition.jsp','mainFrame',9,1,2,0,'DataCenter:Maintenance',0,'DataCenter:Maintenance',0,'','',0,'','',8)
/
call MMConfig_U_ByInfoInsert (9,4)
/
call MMInfo_Insert (646,16518,'','/datacenter/maintenance/outreport/OutReport.jsp','mainFrame',9,1,4,0,'DataCenter:Maintenance',0,'DataCenter:Maintenance',0,'','',0,'','',8)
/
call MMConfig_U_ByInfoInsert (9,3)
/
call MMInfo_Insert (645,16890,'','/datacenter/maintenance/statitem/ReportStatItem.jsp','mainFrame',9,1,3,0,'DataCenter:Maintenance',0,'DataCenter:Maintenance',0,'','',0,'','',8)
/
call MMConfig_U_ByInfoInsert (9,5)
/
call MMInfo_Insert (647,17496,'','/datacenter/design/index.htm','mainFrame',9,1,5,0,'DataCenter:Maintenance',0,'DataCenter:Maintenance',0,'','',0,'','',8)
/
