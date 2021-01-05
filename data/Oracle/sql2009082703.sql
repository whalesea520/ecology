alter table workflow_flownode add toexcel char(1)
/
update workflow_flownode set toexcel='1'
/
