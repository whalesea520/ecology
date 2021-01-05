create or replace trigger wf_agentConditionSet_Trigger
before insert on workflow_agentConditionSet
for each row
begin
select WORKFLOW_AGENTCONDITIONSET_SEQ.nextval into :new.id from dual;
end;
/