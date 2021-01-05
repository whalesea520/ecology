create or replace PROCEDURE Meeting_Member2_SelectByType 
(
 meetingId_1 integer, 
 memberType_1 integer, 
 flag  out integer, 
 msg  out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 
AS 

begin
open thecursor for 
SELECT * FROM Meeting_Member2  WHERE meetingId = meetingId_1  AND memberType = memberType_1   ORDER BY id ASC;
 
end;
/
