CREATE OR REPLACE PROCEDURE Prj_Task_UpdateParent 
(parentid_1	integer,	 flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) 
AS  finish_1 number; 
begin  select to_number(sum(workday*finish)/sum(workday)) INTO finish_1 from Prj_TaskProcess where parentid=parentid_1;
if finish_1 > 100 then finish_1 := 100; end if; 
UPDATE Prj_TaskProcess  SET  finish = finish_1 WHERE ( id = parentid_1); end;
/