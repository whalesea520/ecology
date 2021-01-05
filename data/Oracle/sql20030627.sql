CREATE or REPLACE PROCEDURE MeetingShareDetail_Insert 
	(meetingid_1 integer ,
	 userid_1 integer ,
	 usertype_1 integer ,
	 sharelevel_1 integer ,
     flag	out integer, 
     msg   out	varchar2, 
thecursor IN OUT cursor_define.weavercursor )
AS 
count_1 integer;
begin

select  count(userid) INTO count_1 from Meeting_ShareDetail where meetingid=meetingid_1 and userid=userid_1 and usertype=usertype_1;
if count_1=0 then
		INSERT INTO Meeting_ShareDetail 
		 (meetingid,
		 userid,
		 usertype,
		 sharelevel) 
		VALUES 
		(meetingid_1,
		 userid_1,
		 usertype_1,
		 sharelevel_1);
	   
else 
		update Meeting_ShareDetail 
		set sharelevel=sharelevel_1 where meetingid=meetingid_1 and userid=userid_1 and usertype=usertype_1 and sharelevel>sharelevel_1 ; 
     end if;
end;
/