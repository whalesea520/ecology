ALTER TABLE Workflow_Agent ADD  isSet char(1) NULL
/
ALTER TABLE Workflow_Agent ADD  isPending char(1) NULL
/

update workflow_agent set isSet='0' 
/
update workflow_agent set isPending='0'
/