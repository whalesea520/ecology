alter table workflow_nodebase add operators_TEMP Long
/
update workflow_nodebase t set t.operators_TEMP = t.OPERATORS
/
alter table workflow_nodebase rename column OPERATORS to OPERATORS_1
/
alter table workflow_nodebase rename column operators_TEMP to OPERATORS
/