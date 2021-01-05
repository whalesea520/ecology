
alter table workflow_flownode add viewtypeall char(1)
/
alter table workflow_flownode add viewdescall char(1)
/
alter table workflow_flownode add showtype char(1)
/
alter table workflow_flownode add vtapprove char(1)
/
alter table workflow_flownode add vtrealize char(1)
/
alter table workflow_flownode add vtforward char(1)
/
alter table workflow_flownode add vtpostil char(1)
/
alter table workflow_flownode add vtrecipient char(1)
/
alter table workflow_flownode add vtreject char(1)
/
alter table workflow_flownode add vtsuperintend char(1)
/
alter table workflow_flownode add vtover char(1)
/
alter table workflow_flownode add vdcomments char(1)
/
alter table workflow_flownode add vddeptname char(1)
/
alter table workflow_flownode add vdoperator char(1)
/
alter table workflow_flownode add vddate char(1)
/
alter table workflow_flownode add vdtime char(1)
/
alter table workflow_flownode add stnull char(1)
/
update workflow_flownode set viewtypeall='1',viewdescall='1',showtype='0',stnull='0'
/