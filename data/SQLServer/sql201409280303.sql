update meeting set repeatType=0 where repeatType is null
go

Delete from MainMenuInfo where id=1412
GO
EXECUTE MMInfo_Insert 1412,32592,'年度会议统计表','/meeting/report/MeetingForTypeRpt.jsp','mainFrame',208,2,3,0,'',0,'',0,'','',0,'','',9
GO
EXECUTE MMConfig_U_ByInfoInsert 208,3
GO
