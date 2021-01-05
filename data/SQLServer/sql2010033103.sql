alter table workflow_flownode add isnullnotfeedback char(1)
GO
alter table workflow_base add isrejectremind char(1)
GO
alter table workflow_base add ischangrejectnode char(1)
GO
insert into SysPoppupInfo values (14,'/system/sysRemindWfLink.jsp?flag=rejectWf','24449','y','24449')
GO
