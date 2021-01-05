CREATE TABLE workflow_codeSeq(
	id int identity (1, 1) NOT NULL ,
	departmentId integer NULL ,
	yearId integer NULL ,
	sequenceId integer NULL 
)
GO

alter table workflow_code add isBill char(1) null
GO
alter table workflow_codeDetail add isBill char(1) null
GO

update  workflow_code set isBill=
(select b.isBill from workflow_base b  
  where b.id=workflow_code.flowId
)
GO

update  workflow_codeDetail set isBill=
(select b.isBill from workflow_code b  
  where b.formId=workflow_codeDetail.mainId
)
GO

alter table workflow_nodelink add isBulidCode char(1) null
GO
update workflow_nodelink set isBulidCode='0'
GO
update  workflow_nodelink  set isBulidCode='1'
where exists(
select 1 from workflow_flownode b
where b.workflowId=workflow_nodelink.workflowId
  and b.nodeId=workflow_nodelink.nodeId
  and b.nodeType='0'
)
and exists(
select 1
from workflow_code b,workflow_base c
where b.formId=c.formId
  and b.isBill=c.isBill
  and c.id=workflow_nodelink.workflowId
  and b.isUse='1'
)
GO