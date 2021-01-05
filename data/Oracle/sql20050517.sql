ALTER TABLE workflow_addinoperate
ADD type integer NULL
/


UPDATE workflow_addinoperate
SET type=0
/
