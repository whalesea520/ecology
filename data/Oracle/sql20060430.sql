CREATE or REPLACE PROCEDURE DocDetail_SelectCountByOwner 
	(id_1 	integer, 
	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
open thecursor for
	select count(*) from DocDetail where ownerid = id_1 and  maincategory!=0  and subcategory!=0 and seccategory!=0; 
end;
/