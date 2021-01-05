CREATE TABLE MeetingSet	(id   INT IDENTITY NOT NULL,timeRangeStart int	, timeRangeEnd int	)
GO	
insert into MeetingSet(timeRangeStart,timeRangeEnd)values(0,23)	
GO
Delete from MainMenuInfo where id=1306
GO
EXECUTE MMConfig_U_ByInfoInsert 502,3
GO
EXECUTE MMInfo_Insert 1306,31811,'”¶”√≈‰÷√','/meeting/Maint/MeetingSetTab.jsp','mainFrame',502,2,3,0,'',0,'',0,'','',0,'','',9
GO