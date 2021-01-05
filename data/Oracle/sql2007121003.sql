alter table workflow_requestlog ADD (REMARKs LONG)
/
update workflow_requestlog set REMARKs=REMARK
/

alter table workflow_requestlog RENAME COLUMN REMARK TO REMARK1 
/
alter table workflow_requestlog RENAME COLUMN REMARKs TO REMARK 
/