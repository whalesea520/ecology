alter table workflow_agent add  iseditstartdate varchar(100)
/
alter table workflow_agent add  iseditstarttime varchar(100)  
/
alter table workflow_agent add  iseditenddate varchar(100)
/
alter table workflow_agent add  iseditendtime  varchar(100)
/
update workflow_agent set isProxyDeal='1' where agenttype='1' 
/
update  workflow_agent set beginDate='1900-01-01',iseditstartdate='1'   where  beginDate is   null
/
update  workflow_agent set beginTime='00:00',iseditstarttime='1'   where  beginTime is   null
/
update  workflow_agent set endDate='2099-12-31',iseditenddate='1'   where  endDate is   null
/
update  workflow_agent set endTime='23:59' ,iseditendtime='1' where  endTime is   null
/
create sequence WORKFLOW_AGENTCONDITIONSET_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20
/

insert into workflow_agentConditionSet
   (id,agentid,
    bagentuid,
    agentuid,
    beginDate,
    beginTime,
    endDate,
    endTime,
    workflowid,
    isCreateAgenter,
    agenttype,
    isPendThing,
    isProxyDeal,
    operatordate,
    operatorid,
    operatortime,
    agentbatch)
   select 
           WORKFLOW_AGENTCONDITIONSET_SEQ.NEXTVAL,
          agentId,
          beagenterId,
          agenterId,
          beginDate,
          beginTime,
          endDate,
          endTime,
          workflowId,
          isCreateAgenter,
          agenttype,
          isPending,
          '1',
          operatordate,
          operatorid,
          operatortime,
          0.00
     from workflow_agent
    where agentId not in (select agentId from workflow_agentConditionSet)
/