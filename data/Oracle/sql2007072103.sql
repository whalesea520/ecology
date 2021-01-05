CREATE TABLE workflow_codeSeq (
	id integer  NOT NULL ,
	departmentId integer NULL ,
	yearId integer NULL ,
	sequenceId integer NULL 
)
/
create sequence workflow_codeSeq_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_codeSeq_Trigger
before insert on workflow_codeSeq
for each row
begin
select workflow_codeSeq_id.nextval into :new.id from dual;
end;
/

alter table workflow_code add isBill char(1) null
/
alter table workflow_codeDetail add isBill char(1) null
/

update  workflow_code set isBill=
(select b.isBill from workflow_base b  
  where b.id=workflow_code.flowId
)
/

update  workflow_codeDetail set isBill=
(select b.isBill from workflow_code b  
  where b.formId=workflow_codeDetail.mainId
)
/

alter table workflow_nodelink add isBulidCode char(1) null
/
update workflow_nodelink set isBulidCode='0'
/
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
/