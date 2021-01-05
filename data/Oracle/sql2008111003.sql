alter table workflow_SubwfSet add triggerType char(1) null
/
update workflow_SubwfSet set triggerType='1'
/
alter table workflow_SubwfSet add TriggerOperation char(1) null
/
update workflow_SubwfSet set TriggerOperation=''
/

alter table Workflow_TriDiffWfDiffField add triggerType char(1) null
/
update Workflow_TriDiffWfDiffField set triggerType='1'
/
alter table Workflow_TriDiffWfDiffField add TriggerOperation char(1) null
/
update Workflow_TriDiffWfDiffField set TriggerOperation=''
/

CREATE TABLE Workflow_TriSubwfButtonName ( 
    id integer  NOT NULL ,
    workflowId integer NULL,
    nodeId integer NULL,
    subwfSetTableName varchar2(30) NULL,
    subwfSetId integer NULL,
    triSubwfName7 varchar2(50) NULL,
    triSubwfName8 varchar2(50) NULL
)  
/

create sequence Wf_TriSubwfButtonName_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger Wf_TriSubwfButtonName_Tri
before insert on Workflow_TriSubwfButtonName
for each row
begin
select Wf_TriSubwfButtonName_id.nextval into :new.id from dual;
end;
/
