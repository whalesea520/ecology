CREATE or REPLACE procedure updatenewdepdefault 
as
tempid integer;
begin
    for c in(select id from HrmDepartment where id not in (select objid from HrmPerformanceCheckFlow where objtype=2))
    loop
		tempid := c.id;
        insert into HrmPerformanceCheckFlow (objId,objType) values (tempid,2);
        insert into HrmPerformanceCheckFlow (objId,objType) values (tempid,3);
    end loop;
    
    for c2  in(select id from HrmSubCompany where id not in (select objid from HrmPerformanceCheckFlow where objtype=1))
    loop
        tempid := c2.id;
		insert into HrmPerformanceCheckFlow (objId,objType) values (tempid,1);
    end loop;
end;
/

call updatenewdepdefault ()
/
drop procedure updatenewdepdefault
/

CREATE TRIGGER Tri_I_DeptKPICheckFlow after INSERT  ON HrmDepartment
for each row
Declare 
deptid 	integer;
countdelete   	integer;
countinsert   	integer;

begin
    countdelete :=:old.id;
    countinsert :=:new.id;

IF (countinsert>0 AND countdelete=0)
then

	deptid := :new.id;
	INSERT INTO HrmPerformanceCheckFlow (objId,objType) VALUES (deptid,'2');
	INSERT INTO HrmPerformanceCheckFlow (objId,objType) VALUES (deptid,'3');
END if;
end;
/

CREATE TRIGGER Tri_I_SubComKPICheckFlow after insert ON HrmSubCompany
for each row

Declare 
subcompid 	integer;
countdelete   	integer;
countinsert   	integer;

begin
  
	countdelete :=:old.id;
    countinsert :=:new.id;

IF (countinsert>0 AND countdelete=0)
then
	subcompid :=:new.id;
	INSERT INTO HrmPerformanceCheckFlow (objId,objType) VALUES (subcompid,'1');
END if;
end;
/
