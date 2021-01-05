alter table workflow_nodelink add tempcol varchar2(4000)
/
update workflow_nodelink set tempcol = condition
/
alter table workflow_nodelink drop column condition
/
alter table workflow_nodelink add condition clob DEFAULT empty_clob()
/
update workflow_nodelink set condition = tempcol
/

update workflow_nodelink set tempcol = conditioncn
/
alter table workflow_nodelink drop column conditioncn
/
alter table workflow_nodelink add conditioncn clob DEFAULT empty_clob()
/
update workflow_nodelink set conditioncn = tempcol
/
alter table workflow_nodelink drop column tempcol
/
