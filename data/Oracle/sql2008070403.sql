CREATE TABLE Workflow_TriDiffWfDiffField ( 
    id integer NOT NULL ,
    mainWorkflowId integer NULL,
    triggerNodeId integer NULL,
    triggerTime char(1) NULL,
    fieldId integer NULL
)  
/

create sequence Wf_TriDiffWfDiffField_id
start with 1
increment by 1
nomaxvalue
nocycle
/


create or replace trigger Wf_TriDiffWfDiffField_Tri
before insert on Workflow_TriDiffWfDiffField
for each row
begin
select Wf_TriDiffWfDiffField_id.nextval into :new.id from dual;
end;
/


CREATE TABLE Workflow_TriDiffWfSubWf ( 
    id integer NOT NULL ,
    triDiffWfDiffFieldId integer NULL,
    subWorkflowId integer NULL,
    subwfCreatorType char(1) NULL,
    subwfCreatorFieldId integer NULL,
    isRead integer NULL
)  
/

create sequence Wf_TriDiffWfSubWf_id
start with 1
increment by 1
nomaxvalue
nocycle
/


create or replace trigger Wf_TriDiffWfSubWf_Tri
before insert on Workflow_TriDiffWfSubWf
for each row
begin
select Wf_TriDiffWfSubWf_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Workflow_TriDiffWfSubWfField ( 
    id integer NOT NULL ,
    triDiffWfSubWfId integer NULL,
    subWorkflowFieldId integer NULL,
    mainWorkflowFieldId integer NULL,
    isDetail integer NULL
)  
/

create sequence Wf_TriDiffWfSubWfField_id
start with 1
increment by 1
nomaxvalue
nocycle
/


create or replace trigger Wf_TriDiffWfSubWfField_Tri
before insert on Workflow_TriDiffWfSubWfField
for each row
begin
select Wf_TriDiffWfSubWfField_id.nextval into :new.id from dual;
end;
/

ALTER TABLE Workflow_base ADD  isTriDiffWorkflow char(1) null
/

ALTER TABLE Workflow_TriDiffWfSubWf ADD  fieldValue integer null
/

ALTER TABLE Workflow_TriDiffWfSubWfField ADD  isCreateDocAgain char(1) null
/

ALTER TABLE Workflow_TriDiffWfSubWfField ADD  ifSplitField char(1) null
/