CREATE or replace PROCEDURE LgcAssetUnit_Select
(flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for select * from LgcAssetUnit order by id asc;
end;
/
