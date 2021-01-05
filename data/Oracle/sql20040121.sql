 CREATE or REPLACE PROCEDURE Meeting_Topic_SelectAll 
 ( meetingid1 integer,  	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Meeting_Topic where meetingid = meetingid1 Order By id; 
end;
/
UPDATE license set cversion = '2.62'
/