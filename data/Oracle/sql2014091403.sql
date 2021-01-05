delete WorkPlanShareDetail  where not EXISTS(select 1 from workplan w where WorkPlanShareDetail.workid=w.id)
/
drop index WorkPlanShareDetail_ID
/
drop index IX_WorkPlanShareDetail
/
drop index WorkPlanShareDetail_udx
/
alter table WorkPlanShareDetail add shareType char(1) DEFAULT '1' not null 
/
alter table WorkPlanShareDetail add objId int
/
alter table WorkPlanShareDetail add roleLevel int
/
alter table WorkPlanShareDetail add securityLevel int
/
alter table WorkPlanShareDetail add securityLevelMax int
/
create index WorkPlanShareDetail_UserID on WorkPlanShareDetail(userid ASC, usertype ASC,shareType ASC)
/
create index WorkPlanShareDetail_ObjID on WorkPlanShareDetail(objId ASC, usertype ASC,shareType ASC,securityLevel ASC,securityLevelMax ASC)
/
create index WorkPlanShareDetail_WorkID on WorkPlanShareDetail(workid ASC)
/

