delete WorkPlanShareDetail  where not EXISTS(select 1 from workplan w where WorkPlanShareDetail.workid=w.id)
go
drop index WorkPlanShareDetail_ID on WorkPlanShareDetail 
GO
drop index IX_WorkPlanShareDetail on WorkPlanShareDetail 
GO
drop index WorkPlanShareDetail_udx on WorkPlanShareDetail 
go
alter table WorkPlanShareDetail add shareType char(1) not null DEFAULT '1'
GO
alter table WorkPlanShareDetail add objId int
go
alter table WorkPlanShareDetail add roleLevel int
GO
alter table WorkPlanShareDetail add securityLevel int
GO
alter table WorkPlanShareDetail add securityLevelMax int
GO
create index WorkPlanShareDetail_UserID on WorkPlanShareDetail(userid ASC, usertype ASC,shareType ASC)
GO
create index WorkPlanShareDetail_ObjID on WorkPlanShareDetail(objId ASC, usertype ASC,shareType ASC,securityLevel ASC,securityLevelMax ASC)
go
create index WorkPlanShareDetail_WorkID on WorkPlanShareDetail(workid ASC)
go

