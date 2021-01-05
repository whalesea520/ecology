update meeting set repeatType=0 where repeatType is null
/

Delete from MainMenuInfo where id=1412
/
call MMInfo_Insert (1412,32592,'年度会议统计表','/meeting/report/MeetingForTypeRpt.jsp','mainFrame',208,2,3,0,'',0,'',0,'','',0,'','',9)
/
call MMConfig_U_ByInfoInsert (208,3)
/