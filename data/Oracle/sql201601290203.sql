alter table exp_workflowXML add xmltext_bak clob
/
update  exp_workflowXML set xmlteXt_bak = xmltext
/
alter table exp_workflowXML drop column xmltext
/
alter table exp_workflowXML rename column xmltext_bak to xmltext
/