 CREATE or REPLACE PROCEDURE Meeting_Decision_SelectAll 
 ( meetingid_1 integer,  	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
	AS
begin
open thecursor for
SELECT * FROM Meeting_Decision where meetingid = meetingid_1 order by id; 
end;
/