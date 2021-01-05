alter table workflow_agent add isProxyDeal varchar2(20)
/
CREATE TABLE workflow_agentConditionSet(
   id      varchar2(500)  not null,
   agentid   varchar(250) NULL,
   bagentuid   varchar(350) NULL,
   agentuid   varchar(350) NULL,
   conditionss   varchar(4000)  NULL,
   conditioncn   varchar(4000)  NULL,
   conditionkeyid   varchar(4000) NULL,
   beginDate   varchar(450) NULL,
   beginTime   varchar(450) NULL,
   endDate   varchar(450) NULL,
   endTime   varchar(450) NULL,
   workflowid   varchar(4000) NULL,
   Recoverstate   varchar(4000) NULL,
   isCreateAgenter   varchar(450) NULL,
   agenttype   varchar(450) NULL,
   isProxyDeal   varchar(450) NULL,
   isPendThing   varchar(450) NULL,
   operatorid   varchar(450) NULL,
   operatordate   varchar(450) NULL,
   operatortime   varchar(450) NULL,
   isSet   varchar(450) NULL,
   backDate   varchar(450) NULL,
   backTime   varchar(450) NULL,
   agentconditionid   varchar(400) NULL,
   agentbatch   varchar(550) NULL
   )
/