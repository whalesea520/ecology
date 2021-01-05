 CREATE OR REPLACE PROCEDURE workflow_SelectItemSelectByid 
 (id_1 varchar2, isbill_1 varchar2, flag out integer, msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor) 
 AS begin open thecursor for select * from workflow_SelectItem where fieldid = id_1 
 and isbill = isbill_1 order by listorder,id; end;
/
