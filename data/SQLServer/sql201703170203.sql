CREATE TABLE mode_reminddata_error(
	id int IDENTITY(1,1) ,
	remindjobid int ,
	modeid int ,
	billid int ,
	subbillid int ,
	createdate varchar(20) ,
	createtime varchar(20) ,
	remindway int,
	remindwaydesc varchar(50),
	msg varchar(4000),
	lastdate varchar(20) ,
	lasttime varchar(20) 
)
GO