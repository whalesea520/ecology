CREATE or REPLACE PROCEDURE CRM_Contract_Select
	(crmId_1 integer ,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
begin
 open thecursor for
SELECT * FROM CRM_Contract  where crmId = crmId_1 order by id asc;
end;
/