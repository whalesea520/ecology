alter table workflow_base add isshared char(1)
GO
CREATE TABLE Workflow_SharedScope
	(
	wfid             INT,
	requestid	INT,
	permissiontype  INT,
	seclevel        INT,
	departmentid    INT,
	deptlevel       INT,
	subcompanyid    INT,
	sublevel        INT,
	userid          INT,
	describ         VARCHAR (1000),
	seclevelMax     INT,
	deptlevelMax    INT,
	sublevelMax     INT,
	id              INT IDENTITY NOT NULL,
	roleid          INT,
	rolelevel       INT,
	roleseclevel    INT,
	roleseclevelMax INT,
	iscanread      INT,
	operator	VARCHAR (10),
	currentnodeid	INT
	)
GO