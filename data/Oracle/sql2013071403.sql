alter table workplan add resourceid_temp varchar2(4000)
/
update workplan set resourceid_temp=resourceid,resourceid=null
/
commit
/
alter table workplan modify resourceid varchar2(4000)
/
update workplan set resourceid=resourceid_temp,resourceid_temp=null
/
commit
/
alter table workplan drop column resourceid_temp
/
alter table workplan add principal_temp varchar2(4000)
/
update workplan set principal_temp=principal,principal=null
/
commit
/
alter table workplan modify principal varchar2(4000)
/
update workplan set principal=principal_temp,principal_temp=null
/
commit
/
alter table workplan drop column principal_temp
/
alter table HrmPerformancePlanModul add principal_temp varchar2(4000)
/
update HrmPerformancePlanModul set principal_temp=principal,principal=null
/
commit
/
alter table HrmPerformancePlanModul modify principal varchar2(4000)
/
update HrmPerformancePlanModul set principal=principal_temp,principal_temp=null
/
commit
/
alter table HrmPerformancePlanModul drop column principal_temp
/