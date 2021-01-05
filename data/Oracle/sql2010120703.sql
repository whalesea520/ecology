CREATE or replace  PROCEDURE Prj_TaskProcess_Sum (
	prjid_1 	integer,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
AS
sumWorkday decimal(9);
sum_1 integer;
begin
	SELECT SUM(workday) into sum_1 FROM Prj_TaskProcess WHERE ( prjid = prjid_1 and parentid = '0' and isdelete<>'1');
	if sum_1>0 then
		SELECT SUM(workday) into sumWorkday FROM Prj_TaskProcess WHERE ( prjid = prjid_1 and parentid = '0' and isdelete<>'1');
	end if;
	
	IF sumWorkday<>0
	then
        open thecursor for
		SELECT sum(workday) as workday,
		min(begindate) as begindate, 
		max(enddate) as enddate, 
    min(actualBeginDate) as actualBeginDate,
    max(actualEndDate) as actualEndDate,             		
		sum(finish*workday)/sum(workday) as finish,
		sum(fixedcost) as fixedcost
		FROM Prj_TaskProcess
		WHERE ( prjid = prjid_1 and parentid = '0' and isdelete<>'1');
	ELSE
		open thecursor for
        SELECT sum(workday) as workday,
		min(begindate) as begindate, 
		max(enddate) as enddate, 
    min(actualBeginDate) as actualBeginDate,
    max(actualEndDate) as actualEndDate,                          		
		0 as finish,
		sum(fixedcost) as fixedcost
		FROM Prj_TaskProcess
		WHERE ( prjid = prjid_1 and parentid = '0' and isdelete<>'1');
	END if;
end;
/
