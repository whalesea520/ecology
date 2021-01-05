
create table MeetingRoom_share 
	(id int , mid int,
	permissiontype int,seclevel int,
	departmentid int,deptlevel int,
	subcompanyid int,sublevel int,
	userid int,describ varchar(1000))
GO
ALTER PROCEDURE Meeting_Type_Insert
	(@name varchar (255), @approver int, @desc_n varchar (255), @subcompanyid int, @catalogpath varchar (255),
		 @flag integer output, @msg varchar(80) output) 
	 AS INSERT INTO Meeting_Type ( name , approver , desc_n ,subcompanyid,catalogpath) 
	 VALUES( @name, @approver, @desc_n , @subcompanyid , @catalogpath ) set @flag = 1 set @msg = 'OK!' 
GO

create table MeetingType_share 
	(id int, mtid int,
	permissiontype int,seclevel int,
	departmentid int,deptlevel int,
	subcompanyid int,sublevel int,
	userid int,describ varchar(1000))
GO
ALTER PROCEDURE MeetingRoom_Insert (@name_1 varchar (100) , @roomdesc_1 varchar (100) , @hrmid_1 int ,
	 @subcompanyid int,  @flag	int 	output, @msg	varchar (80)	output) 
	AS  INSERT INTO MeetingRoom (name , roomdesc , hrmid,subcompanyid ) VALUES (@name_1, 
	@roomdesc_1, @hrmid_1, @subcompanyid) 
GO