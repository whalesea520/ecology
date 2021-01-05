CREATE or REPLACE PROCEDURE bill_CptAdjustDetail_Select 
	(cptadjustid1 	integer,	 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * from  bill_CptAdjustDetail 
WHERE 
	( cptadjustid	 = cptadjustid1) order by id;
	end;
/
