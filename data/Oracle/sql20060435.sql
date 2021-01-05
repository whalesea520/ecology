CREATE OR REPLACE PROCEDURE HrmScheduleDiff_Select_ByID
( id1 integer , flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS begin
open thecursor for select * from HrmScheduleDiff where id = id1;
end;
/
