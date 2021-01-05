CREATE TABLE workflow_penetrateLog(
   id integer  primary key, 
	requestid integer,
	workflowid integer,
	nodeid integer,
	logtype varchar(1),
	operatedate varchar(10) ,
	operatetime varchar(8),
	operator integer ,
	remark varchar2(4000) ,
	clientip varchar(15) ,
	operatortype integer ,
	destnodeid integer ,
	receivedPersons varchar2(4000),
	showorder integer ,
	agentorbyagentid integer,
	agenttype varchar(1),
	LOGID integer ,
	annexdocids varchar(2000),
	requestLogId integer ,
	operatorDept integer,
	signdocids varchar(500),
	signworkflowids varchar(500),
	isMobile varchar(1),
	HandWrittenSign integer,
	SpeechAttachment integer
)
/
create sequence workflowpenetratelog_Id start with 1 increment by 1 nomaxvalue nocycle
/
