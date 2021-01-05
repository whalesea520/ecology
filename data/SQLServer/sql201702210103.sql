alter table mode_remindjob add sqlwherejson varchar(2000)
GO

CREATE TABLE mode_reminddata_all(
	id int IDENTITY(1,1) ,
	remindjobid int ,
	modeid int ,
	billid int ,
	subbillid int ,
	lastdate varchar(20) ,
	lasttime varchar(20) ,
	isRemindSMS int ,
	isRemindEmail int ,
	isRemindWorkflow int ,
	isRemindWeChat int ,
	isRemindEmobile int 
)
GO