alter table workflowactionset rename column interfaceid to interfaceid_tmp
/
alter table workflowactionset add interfaceid varchar2(2000)
/
update workflowactionset set interfaceid=trim(interfaceid_tmp)
/
alter table workflowactionset drop column interfaceid_tmp
/
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
/

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
/
update workflow_addinoperate set type=3 where type=2
/
alter table workflowactionset add isused int
/
drop view workflowactionview
/
create view workflowactionview
as
	select d.interfaceid as id, d.actionname, d.actionorder, d.nodeid, d.workflowId, d.nodelinkid, d.ispreoperator, 0 as actiontype,isused
	from workflowactionset d where d.interfacetype=1
	union
	select d.interfaceid as id, d.actionname, d.actionorder, d.nodeid, d.workflowId, d.nodelinkid, d.ispreoperator, 1 as actiontype,isused
	from workflowactionset d where d.interfacetype=2
	union    
	select d.interfaceid as id, d.actionname, d.actionorder, d.nodeid, d.workflowId, d.nodelinkid, d.ispreoperator, 3 as actiontype,isused
	from workflowactionset d where d.interfacetype=3
	union
	select to_char(s.id) as id, s.actionname, s.actionorder, s.nodeid, s.workflowId, s.nodelinkid, s.ispreoperator, 2 as actiontype,1 as isused
	from sapactionset s
/
