CREATE or REPLACE PROCEDURE Prj_WorkType_SelectAll 
 (	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT * FROM Prj_WorkType  order by id asc  ;
end;
/