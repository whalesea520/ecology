CREATE TABLE Workflow_Initialization
	(
	ID              NUMBER,
	WFID            INTEGER,
	ORDERID		INTEGER
	)
/
    create sequence Workflow_Initialization_seq minvalue 1 maxvalue 99999999
    increment by 1
    start with 1
/
create or replace trigger Workflow_Initialization_tri
 before insert on Workflow_Initialization
 for each row      
 begin      
     select Workflow_Initialization_seq.nextval into :new.id from DUAL;
 END;
/