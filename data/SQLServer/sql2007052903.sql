CREATE TABLE SysPoppupRemindInfoNew(
	userid int NULL,
	ifPup int NULL,
	usertype char(1)  NULL,
	type int  NULL,
	requestid int NULL,
	remindDate char(10)  NULL,
	counts int NULL
) 
go

create index remindindex on syspoppupremindinfonew 
(userid,usertype)
go

create index remindindextype on syspoppupremindinfonew 
(type)

go