
if exists (select * from sysindexes where name = 'WorkPlan_resourceid') drop INDEX WorkPlan_resourceid ON workplan
GO
ALTER TABLE workplan ALTER COLUMN resourceid varchar(4000)
GO
if exists (select * from sysindexes where name = 'WorkPlan_principal') drop INDEX WorkPlan_principal ON workplan
GO
ALTER TABLE workplan ALTER COLUMN principal varchar(4000)
GO
if exists (select * from sysindexes where name = 'HrmPerformancePlanModul_principal')	drop INDEX HrmPerformancePlanModul_principal ON HrmPerformancePlanModul
GO
ALTER TABLE HrmPerformancePlanModul ALTER COLUMN principal varchar(4000)
GO