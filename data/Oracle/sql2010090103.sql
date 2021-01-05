CREATE or REPLACE PROCEDURE bill_monthinfodetail_SByType 
 (
	infoid1		integer,
	type1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as
begin
open thecursor for

	select * from bill_monthinfodetail where infoid=infoid1 and type=type1 order by id;
end;
/
