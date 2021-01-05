alter table hrmLeaveTypeColor add ispaidleave int
GO
alter table HrmPSLPeriod add leavetype int 
GO
alter table HrmPSLBatchProcess add leavetype int 
GO
alter table hrmpslmanagement add leavetype int 
GO

update hrmLeaveTypeColor set ispaidleave=1 where field004=-12
GO
update HrmPSLPeriod set leavetype=-12 
GO
update HrmPSLBatchProcess set leavetype=-12 
GO
update hrmpslmanagement set leavetype=-12 
GO

