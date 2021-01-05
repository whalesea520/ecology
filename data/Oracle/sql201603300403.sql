alter table workflow_RequestUserDefault add (selectedworkflow_a  clob)
/
 update workflow_RequestUserDefault set selectedworkflow_a = selectedworkflow
/
 alter table workflow_RequestUserDefault drop (selectedworkflow)
/
 alter table workflow_RequestUserDefault rename column selectedworkflow_a to selectedworkflow
/