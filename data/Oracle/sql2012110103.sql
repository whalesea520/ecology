alter table HRM_CompensationTargetSet add showOrder number(15,2) null
/
update HRM_CompensationTargetSet set showOrder=id
/