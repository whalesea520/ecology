CREATE or REPLACE PROCEDURE bill_CptApplyDetail_Select 
	(cptapplyid1 	integer,	 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for
SELECT * from  bill_CptApplyDetail 
WHERE 
	( cptapplyid	 = cptapplyid1) order by id;
end;
/
