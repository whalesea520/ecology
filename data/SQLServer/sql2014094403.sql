alter table WorkPlanShare add type char(1)
go
drop index WorkPlanShareDetail_UserID on WorkPlanShareDetail 
GO
drop index WorkPlanShareDetail_ObjID on WorkPlanShareDetail 
GO
drop index WorkPlanShareDetail_WorkID on WorkPlanShareDetail 
go
EXEC sp_rename 'WorkPlanShareDetail', 'WorkPlanShareDetail_old'
go
SELECT * INTO WorkPlanShareDetail FROM WorkPlanShareDetail_old where 1=2
go
create index WorkPlanShareDetail_UserID on WorkPlanShareDetail(userid ASC, usertype ASC,shareType ASC)
GO
create index WorkPlanShareDetail_ObjID on WorkPlanShareDetail(objId ASC, usertype ASC,shareType ASC,securityLevel ASC,securityLevelMax ASC)
go
create index WorkPlanShareDetail_WorkID on WorkPlanShareDetail(workid ASC)
go
update WorkPlanUpdate set hasUpdated=2
go
