alter TABLE workflow_requestlog add receivedpersonids clob
/
alter TABLE workflow_penetrateLog rename column receivedpersons to receivedpersons_temp
/
alter TABLE workflow_penetrateLog add receivedpersons clob
/
update workflow_penetrateLog set receivedpersons = receivedpersons_temp
/
alter TABLE workflow_requestbase rename column hrmids to hrmids_temp
/
alter TABLE workflow_requestbase add hrmids clob
/
update workflow_requestbase set hrmids = hrmids_temp
/