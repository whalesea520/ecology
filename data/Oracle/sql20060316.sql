CREATE or replace PROCEDURE UpdateTaskParentIds
	(taskid_1 integer,
	taskid_2 integer)
AS 
	tmpParentId integer;
	tmpParentId2 integer;
	tmpParentHrmId integer;
	count_1 integer;
	count_2 integer;
BEGIN 
	SELECT count(parentid) into count_1 FROM Prj_TaskProcess WHERE id = taskid_2;
	if count_1>0 then
		SELECT  parentid into tmpParentId FROM Prj_TaskProcess WHERE id = taskid_2;
	end if;
	IF tmpParentId<>0
	then
		UPDATE Prj_TaskProcess SET parentids = concat(concat(parentids,to_char(tmpParentId)),',') WHERE id = taskid_1;
		SELECT count(hrmid) into count_1 FROM Prj_TaskProcess WHERE id= tmpParentId;
		if count_1>0 then
			SELECT  hrmid into tmpParentHrmId FROM Prj_TaskProcess WHERE id= tmpParentId;
		END IF;
		UPDATE Prj_TaskProcess SET parenthrmids= concat(concat(concat(concat(concat(parenthrmids,'|'),to_char(tmpParentId)),','),to_char(tmpParentHrmId)),'|') 
		WHERE id=taskid_1;
		SELECT count(parentid) into count_2 FROM Prj_TaskProcess WHERE id=tmpParentId;
		if count_2 >0 then
			SELECT parentid into tmpParentId2 FROM Prj_TaskProcess WHERE id=tmpParentId;
		END IF;
		IF tmpParentId<>0
		then 
			UpdateTaskParentIds (taskid_1,tmpParentId);
		end if;
	end if;
END;
/

DECLARE 
task_id integer;
task_parentid integer;
hrmid_1 integer;
count_1 integer;
begin
	FOR c in( 
		SELECT id,parentid,hrmid FROM Prj_TaskProcess)
	loop
		task_id :=c.id;
		task_parentid :=c.parentid;
		hrmid_1 :=c.hrmid;
		UPDATE Prj_TaskProcess SET parentids = concat(to_char(task_id),',') WHERE id=task_id;
		UPDATE Prj_TaskProcess SET parenthrmids= concat(concat(concat(concat('|',to_char(task_id)),','),to_char(hrmid_1)),'|') WHERE id=task_id;
		SELECT count(parentid) into count_1 FROM Prj_TaskProcess WHERE id=task_id;
		if count_1 >0 then
			SELECT parentid into task_parentid  FROM Prj_TaskProcess WHERE id=task_id;
		END IF;
		IF task_parentid<>0
		then
			UpdateTaskParentIds (task_id,task_id);
		END IF;
	END loop;
end;
/

DROP PROCEDURE UpdateTaskParentIds
/

CREATE or replace  PROCEDURE Prj_TaskProcess_UParentHrmIds(
	hrmid_1 integer,
	oldhrmid_2 integer,
	id_3 integer,
	flag out integer  , 
	msg out varchar2, 
	thecursor IN OUT cursor_define.weavercursor
	)
AS
currenthrmid varchar2(255);
currentoldhrmid varchar2(255);
begin
if hrmid_1<>oldhrmid_2 then
currenthrmid := concat(concat(concat(concat('|',to_char(id_3)), ','), to_char(hrmid_1)),'|');
currentoldhrmid := concat(concat(concat(concat('|' , to_char(id_3)), ','), to_char(oldhrmid_2)), '|');
UPDATE Prj_TaskProcess set parenthrmids = replace(parenthrmids,currentoldhrmid,currenthrmid) where (parenthrmids like concat(concat('%',currentoldhrmid),'%'));
end if;
end;
/

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
		sum(finish*workday)/sum(workday) as finish,
		sum(fixedcost) as fixedcost
		FROM Prj_TaskProcess
		WHERE ( prjid = prjid_1 and parentid = '0' and isdelete<>'1');
	ELSE
		open thecursor for
        SELECT sum(workday) as workday,
		min(begindate) as begindate, 
		max(enddate) as enddate, 
		0 as finish,
		sum(fixedcost) as fixedcost
		FROM Prj_TaskProcess
		WHERE ( prjid = prjid_1 and parentid = '0' and isdelete<>'1');
	END if;
end;
/
