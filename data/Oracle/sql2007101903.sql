 CREATE or REPLACE PROCEDURE CRM_ContacterTitle_SelectAll 
 (

flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
begin
 open thecursor for
 SELECT * FROM CRM_ContacterTitle order by id; 
end;
/
