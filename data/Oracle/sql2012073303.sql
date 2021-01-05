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