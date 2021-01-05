alter table hrm_att_proc_set add ishalfday int 
GO
alter table hrmLeaveTypeColor add isCalWorkDay int default 1
GO
alter table hrmLeaveTypeColor add relateweekday int
GO
CREATE TABLE [hrmscheduleapplication](
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[unit] [int] NULL,
	[type] [tinyint] NULL
) 
GO