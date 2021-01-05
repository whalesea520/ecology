alter table workflowactionset alter column interfaceid varchar(2000)
GO
insert into workflowactionset
  (actionname,
   workflowid,
   nodeid,
   nodelinkid,
   ispreoperator,
   actionorder,
   interfaceid,
   interfacetype,
   typename)
select customervalue,workflowid,objid,0,ispreadd,0,customervalue,3,'' 
from workflow_addinoperate where type=2 and isnode=1
GO

insert into workflowactionset
  (actionname,
   workflowid,
   nodeid,
   nodelinkid,
   ispreoperator,
   actionorder,
   interfaceid,
   interfacetype,
   typename)
select customervalue,workflowid,0,objid,ispreadd,0,customervalue,3,'' 
from workflow_addinoperate where type=2 and isnode=0
GO
update workflow_addinoperate set type=3 where type=2
GO
alter table workflowactionset add isused int
GO
drop view workflowactionview
GO
create view workflowactionview
as
	select cast(d.interfaceid as varchar(2000)) as id, d.actionname, d.actionorder, d.nodeid, d.workflowId, d.nodelinkid, d.ispreoperator, 0 as actiontype,isused
	from workflowactionset d where d.interfacetype=1
	union
	select cast(d.interfaceid as varchar(2000)) as id, d.actionname, d.actionorder, d.nodeid, d.workflowId, d.nodelinkid, d.ispreoperator, 1 as actiontype,isused
	from workflowactionset d where d.interfacetype=2
	union    
	select cast(d.interfaceid as varchar(2000)) as id, d.actionname, d.actionorder, d.nodeid, d.workflowId, d.nodelinkid, d.ispreoperator, 3 as actiontype,isused
	from workflowactionset d where d.interfacetype=3
	union
	select cast(s.id as varchar(2000)) as id, s.actionname, s.actionorder, s.nodeid, s.workflowId, s.nodelinkid, s.ispreoperator, 2 as actiontype,1 as isused
	from sapactionset s
go
