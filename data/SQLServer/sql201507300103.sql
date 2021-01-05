CREATE TABLE workflow_requestexception(
	keyid int IDENTITY(1,1) NOT NULL,
	requestid  int NULL,
	nodeid  int NULL,
	destnodeid  int NULL,
	exceptiontype  char(1) NULL,
	signtype  char(1) NULL,
	flowoperator  varchar(500) NULL
) 
GO

create index workflow_exception_index on workflow_requestexception(requestid)
GO