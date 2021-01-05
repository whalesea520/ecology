ALTER TABLE SMS_Message
ALTER COLUMN message varchar(4000)
GO


alter PROCEDURE SMS_Message_Insert
	(@id_1 	int,
	 @message_2 	varchar(4000),
	 @recievenumber_3 	varchar(15),
	 @sendnumber_4 	varchar(15),
	 @messagestatus_5 	char(1),
	 @requestid_6 	int,
	 @userid_7 	int,
	 @usertype_8 	char(1),
	 @messagetype_9 	char(1),
	 @finishtime_10 	char(19),
     @smsyear_11   char(4),
     @smsmonth_12  char(2),
     @smsday_13    char(2),
     @isdelete_14   char(1),
     @touserid_15   int,
     @tousertype_16 char(1),
     @flag			int	output, 
	 @msg			varchar(80) output)

AS INSERT INTO SMS_Message 
	 ( id,
	 message,
	 recievenumber,
	 sendnumber,
	 messagestatus,
	 requestid,
	 userid,
	 usertype,
	 messagetype,
	 finishtime,
     smsyear,
     smsmonth,
     smsday,
     isdelete,
     touserid,
     tousertype) 
 
VALUES 
	( @id_1,
	 @message_2,
	 @recievenumber_3,
	 @sendnumber_4,
	 @messagestatus_5,
	 @requestid_6,
	 @userid_7,
	 @usertype_8,
	 @messagetype_9,
	 @finishtime_10,
     @smsyear_11,
     @smsmonth_12,
     @smsday_13,
     @isdelete_14,
     @touserid_15,
     @tousertype_16)
GO
