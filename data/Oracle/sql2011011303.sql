alter table workflow_flownode add vtintervenor char(1)
/
update workflow_flownode set vtintervenor='1' where viewtypeall='1'
/
