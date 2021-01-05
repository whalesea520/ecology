alter table workflow_agent add  iseditstartdate varchar(100)
GO
alter table workflow_agent add  iseditstarttime varchar(100)
GO
alter table workflow_agent add  iseditenddate varchar(100)
GO
alter table workflow_agent add  iseditendtime  varchar(100)
GO
update workflow_agent set isProxyDeal='1' where agenttype='1' 
GO
update  workflow_agent set beginDate='1900-01-01',iseditstartdate='1'  where (beginDate='' or isnull(beginDate,'')='')
GO
update  workflow_agent set beginTime='00:00' ,iseditstarttime='1' where (beginTime='' or isnull(beginTime,'')='')
GO
update  workflow_agent set endDate='2099-12-31',iseditenddate='1'  where (endDate='' or isnull(endDate,'')='')
GO
update  workflow_agent set endTime='23:59',iseditendtime='1'  where (endTime='' or isnull(endTime,'')='')
GO
insert into workflow_agentConditionSet
  (agentid,
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
   agentbatch
   )
  select agentId,
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
GO