CREATE OR REPLACE PROCEDURE Sales_CRM_CreditInfo_Select
(creditAmount  varchar2,
flag  out integer,
 msg out varchar2 ,
 thecursor OUT cursor_define.weavercursor)
IS
BEGIN
open thecursor for
 SELECT id
 FROM CRM_CreditInfo
 WHERE creditamount <= to_number(creditAmount)
	   AND highamount >= to_number(creditAmount);
END;
/