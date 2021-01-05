CREATE or REPLACE PROCEDURE Prj_TaskProcess_UpdateParent 
 (parentid_1	integer,	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor ) 
	AS 

 begindate_1 varchar2(30); 
 enddate_1 varchar2(30);
 workday_1 number;
 finish_1 number;
begin

select  min(begindate), max(enddate), sum(workday) , to_number(sum(workday*finish)/sum(workday)) 
INTO begindate_1, enddate_1, workday_1,finish_1 
 from Prj_TaskProcess where parentid=parentid_1;
if finish_1 > 100 
	then
		finish_1 := 100;
	end if;
UPDATE Prj_TaskProcess  SET   begindate = begindate_1, enddate = enddate_1, workday = workday_1, finish = finish_1
WHERE ( id = parentid_1);
end;
/