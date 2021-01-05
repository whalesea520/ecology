create table smsvoting(
	id int IDENTITY (1, 1) NOT NULL,
	creater int null,
	createdate varchar(10) null,
	createtime varchar(10) null,
	subject varchar(100) null,
	senddate varchar(10) null,
	sendtime varchar(10) null,
	enddate varchar(10) null,
	endtime varchar(10) null,
	isseeresult int null,
	status int null,
	remark varchar(2000) null,
	smscontent varchar(500) null,
	portno varchar(50) null,
	hrmids varchar(2000) null,
	votingcount int null,
	vaildvotingcount int null
)
GO
create table smsvotingdetail(
	id int IDENTITY (1, 1) NOT NULL,
	smsvotingid int null,
	regcontent varchar(10) null,
	remark varchar(500) null,
	count int null
)
GO
create table smsvotinghrm(
	id int IDENTITY (1, 1) NOT NULL,
	smsvotingid int null,
	smsvotingdetailid int null,
	userid int null,
	receivesms varchar(500) null,
	receivedate varchar(10) null,
	receivetime varchar(10) null,
	status int null
)
GO
