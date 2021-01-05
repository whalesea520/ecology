alter table meeting_type add subcompanyid int
GO
update meeting_type set subcompanyid=(select top 1 dftsubcomid from SystemSet)
GO

alter table meetingroom add subcompanyid int
GO
update meetingroom set subcompanyid=(select top 1 dftsubcomid from SystemSet)
GO

ALTER PROCEDURE MeetingRoom_Update
 (@id_1 	int  ,
 @name_1 varchar (100) ,
 @roomdesc_1 varchar (100) ,
 @hrmid_1 int ,
 @subcompanyid_1 int,
 @flag	int 	output,
 @msg	varchar (80)	output)
 AS

 Update MeetingRoom  set  name=@name_1, roomdesc=@roomdesc_1, hrmid=@hrmid_1,subcompanyid=@subcompanyid_1  where id= @id_1

GO

ALTER PROCEDURE MeetingRoom_Insert
	(@name_1 varchar (100) ,
	 @roomdesc_1 varchar (100) ,
	 @hrmid_1 int ,
     @subcompanyid int,
	 @flag	int 	output,
	 @msg	varchar (80)	output)
AS

INSERT INTO MeetingRoom
		 (name ,
		 roomdesc ,
		 hrmid,subcompanyid )
		VALUES
		(@name_1,
		 @roomdesc_1,
		 @hrmid_1,
         @subcompanyid)

GO

ALTER PROCEDURE Meeting_Type_Update
 (@id int , @name varchar (255), @approver int , @desc_n varchar (255),@subcompanyid int, @flag integer output, @msg varchar(80) output  )  AS
update Meeting_Type   set name =@name, approver =@approver, desc_n =@desc_n,subcompanyid=@subcompanyid
where id=@id
set @flag = 1 set @msg = 'OK!'

GO

ALTER PROCEDURE Meeting_Type_Insert
 (@name varchar (255), @approver int, @desc_n varchar (255),@subcompanyid int, @flag integer output, @msg varchar(80) output  )  AS
INSERT INTO Meeting_Type ( name , approver , desc_n ,subcompanyid)  VALUES ( @name, @approver, @desc_n,@subcompanyid )
set @flag = 1 set @msg = 'OK!'

GO

update SystemRights set detachable=1 where id in(350,200)
go
