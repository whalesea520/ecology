alter table workflow_groupdetail add conditioncn2 clob
/
update workflow_groupdetail set conditioncn2=cast(conditioncn as varchar(4000)) where conditioncn is not null
/
alter table workflow_groupdetail rename column conditioncn to conditioncn0
/
alter table workflow_groupdetail rename column conditioncn2 to conditioncn
/