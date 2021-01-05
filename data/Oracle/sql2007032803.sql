ALTER TABLE SMS_Message
 modify(message varchar2(4000))
/


create or replace PROCEDURE SMS_Message_Insert
	(
	 id_1 	integer,
	 message_2 	varchar2,
	 recievenumber_3 	varchar2,
	 sendnumber_4 	varchar2,
	 messagestatus_5 	char,
	 requestid_6 	integer,
	 userid_7 	integer,
	 usertype_8 	char,
	 messagetype_9 	char,
	 finishtime_10 	char,
     smsyear_11   char,
     smsmonth_12  char,
     smsday_13    char,
     isdelete_14   char,
     touserid_15   integer,
     tousertype_16 char,
     flag	out		integer	, 
     msg	out		varchar2,
     thecursor IN OUT cursor_define.weavercursor
     )

AS
begin
INSERT INTO SMS_Message 
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
	( id_1,
	 message_2,
	 recievenumber_3,
	 sendnumber_4,
	 messagestatus_5,
	 requestid_6,
	 userid_7,
	 usertype_8,
	 messagetype_9,
	 finishtime_10,
     smsyear_11,
     smsmonth_12,
     smsday_13,
     isdelete_14,
     touserid_15,
     tousertype_16);
end;
/
