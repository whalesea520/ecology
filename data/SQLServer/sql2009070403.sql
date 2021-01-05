alter table HrmPerformancePlanModul add immediatetouch [int] default 0
GO
alter table HrmPerformancePlanCheck add workplanid varchar(100)
GO
update HrmPerformancePlanModul set immediatetouch=0
GO
