alter table HrmPerformancePlanModul add immediatetouch integer default 0
/
alter table HrmPerformancePlanCheck add workplanid varchar2(100)
/
update HrmPerformancePlanModul set immediatetouch=0
/