create or replace trigger TGR_PRJUPDATEDEPARTMENT after update on HrmResource for each row 
begin
   update prj_projectinfo t
     set t.department = :new.departmentid
   where t.manager = :new.id;    
   update cptcapital t
     set t.departmentid = :new.departmentid
   where t.resourceid = :new.id;  
end;
/