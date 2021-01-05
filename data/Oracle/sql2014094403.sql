alter table WorkPlanShare add type char(1)
/
drop index WorkPlanShareDetail_UserID
/
drop index WorkPlanShareDetail_ObjID
/
drop index WorkPlanShareDetail_WorkID 
/
alter table WorkPlanShareDetail rename to WorkPlanShareDetail_old
/
CREATE table WorkPlanShareDetail as select * from WorkPlanShareDetail_old where 1=2
/
create index WorkPlanShareDetail_UserID on WorkPlanShareDetail(userid ASC, usertype ASC,shareType ASC)
/
create index WorkPlanShareDetail_ObjID on WorkPlanShareDetail(objId ASC, usertype ASC,shareType ASC,securityLevel ASC,securityLevelMax ASC)
/
create index WorkPlanShareDetail_WorkID on WorkPlanShareDetail(workid ASC)
/
update WorkPlanUpdate set hasUpdated=2
/