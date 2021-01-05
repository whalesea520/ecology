alter table HRM_CompensationTargetSet add showOrder decimal(15,2) null
GO
update HRM_CompensationTargetSet set showOrder=id
GO