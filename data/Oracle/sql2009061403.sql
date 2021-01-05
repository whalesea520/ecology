INSERT INTO SequenceIndex(currentid,indexdesc) values (1, 'docchangeid')
/
CREATE TABLE DocChangeSetting (
	autoSend varchar(1) NULL ,
	autoSendTime int NULL ,
	autoReceive varchar(1) NULL,
	autoReceiveTime int NULL,
	serverURL varchar(250) NULL,
    serverPort int NULL,
	serverUser varchar(50) NULL,
	serverPwd varchar(100) NULL,
	changeMode varchar(1) NULL
)
/
insert into DocChangeSetting values('0',0,'0',0,'',21,'','','0')
/
CREATE TABLE DocChangeWorkflow (
	id int NOT NULL ,
	createdate varchar(10) NULL ,
	createtime varchar(10) NULL ,
	workflowid int NULL,
	creator int NULL
)
/
CREATE TABLE DocChangeWfField (
	workflowid int NULL ,
	version int NULL ,
	fieldid int NULL ,
	isChange varchar(1) NULL ,
	isCompany varchar(1) NULL ,
	creator int NULL
)
/
CREATE TABLE DocChangeSend (
	id int NOT NULL ,
	senddate varchar(10) NULL ,
	sendtime varchar(10) NULL ,
	requestid int NULL,
	sender int NULL
)
/
CREATE TABLE DocChangeSendDetail (
	id int NOT NULL,
	type varchar(1) NULL,
	receiver int NULL,
	receivedate varchar(10) NULL,
	receivetime varchar(10) NULL,
	requestid int NULL,
	detail varchar(1000) NULL,
	status varchar(1) NULL
)
/
CREATE TABLE DocChangeReceive (
	id int NOT NULL ,
	type varchar(1) NULL,
	imagefileid int NULL,
	sn int NULL,
	title varchar(1000) NULL,
	companyid int NULL,
	version int NULL,
	senddate varchar(10) NULL ,
	sendtime varchar(10) NULL ,
	receivedate varchar(10) NULL ,
	receivetime varchar(10) NULL ,
	executedate varchar(10) NULL ,
	executetime varchar(10) NULL ,
	receiver int NULL,
	docid int NULL,
	fileids varchar(1000) NULL,
	isCreateWf varchar(1) NULL,
	status int NULL
)
/
CREATE TABLE DocChangeReceiveWf (
	id int NOT NULL ,
	receiveid int NULL,
	requestid int NULL,
	createdate varchar(10) NULL,
	createtime varchar(10) NULL,
	creator int NULL
)
/
alter table DocReceiveUnit add companyType varchar(1)
/
alter table DocReceiveUnit add isMain varchar(1)
/
alter table DocReceiveUnit add changeDir varchar(100)
/
UPDATE DocReceiveUnit set companyType='0',isMain='0'
/