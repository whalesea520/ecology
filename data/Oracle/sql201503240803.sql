alter table workflow_base add isshared char(1)
/
CREATE TABLE Workflow_SharedScope
	(
	ID              NUMBER,
	WFID            INTEGER,
	requestid	INTEGER,
	PERMISSIONTYPE  INTEGER,
	SECLEVEL        INTEGER,
	DEPARTMENTID    INTEGER,
	DEPTLEVEL       INTEGER,
	SUBCOMPANYID    INTEGER,
	SUBLEVEL        INTEGER,
	USERID          INTEGER,
	DESCRIB         VARCHAR2 (1000),
	SECLEVELMAX     NUMBER,
	DEPTLEVELMAX    NUMBER,
	SUBLEVELMAX     NUMBER,
	ROLEID          INTEGER,
	ROLELEVEL       INTEGER,
	ROLESECLEVEL    INTEGER,
	ROLESECLEVELMAX INTEGER,
	iscanread	INTEGER,
	operator	VARCHAR2 (10),
	currentnodeid	INTEGER
	)
/
    create sequence Workflow_SharedScope_seq minvalue 1 maxvalue 99999999
    increment by 1
    start with 1
/
create or replace trigger Workflow_SharedScope_tri
 before insert on Workflow_SharedScope
 for each row      
 begin      
     select Workflow_SharedScope_seq.nextval into :new.id from DUAL;
 END;
/