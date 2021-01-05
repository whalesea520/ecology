CREATE TABLE SysPoppupRemindInfoNew(
	userid int NULL,
	ifPup int NULL,
	usertype char(1)  NULL,
	type int  NULL,
	requestid int NULL,
	remindDate char(10)  NULL,
	counts int NULL
) 
/

create index remindindex on syspoppupremindinfonew 
(userid,usertype)
/

create index remindindextype on syspoppupremindinfonew 
(type)

/