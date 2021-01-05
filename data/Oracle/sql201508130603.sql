CREATE OR REPLACE TRIGGER tgr_PrjUpdateDepartment
after update
on HrmResource
for each row
  begin
     update prj_projectinfo t set t.department = :new.departmentid where t.manager = :new.id;
  end;
  /