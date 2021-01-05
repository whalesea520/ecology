ALTER TABLE Workflow_Agent ADD
isSet char(1) NULL
go	
ALTER TABLE Workflow_Agent ADD
isPending char(1) NULL
go	

update workflow_agent set isSet='0' , isPending='0'
go