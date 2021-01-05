alter table workflow_groupdetail add tCONDITIONS text
GO
alter table workflow_groupdetail add tCONDITIONCN text
GO
update workflow_groupdetail set tCONDITIONS=CONDITIONS,tCONDITIONCN=CONDITIONCN
GO
alter table workflow_groupdetail drop column CONDITIONS 
GO
alter table workflow_groupdetail drop column CONDITIONCN 
GO
alter table workflow_groupdetail add CONDITIONS text
GO
alter table workflow_groupdetail add CONDITIONCN text
GO
update workflow_groupdetail set CONDITIONS=tCONDITIONS,CONDITIONCN=tCONDITIONCN
GO
alter table workflow_groupdetail drop column tCONDITIONS 
GO
alter table workflow_groupdetail drop column tCONDITIONCN 
GO
