alter table hrmgroupmembers alter column dsporder decimal(18,1)
GO
alter table hrmuserdefine add hasgroup char(1)
GO
update hrmuserdefine set hasgroup = '1'
GO
alter table hrmsearchmould add groupid varchar(1000)
GO
