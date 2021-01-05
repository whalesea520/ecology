create trigger tgr_PrjUpdateDepartment
on HrmResource
    for update
as
    declare @olddepartmentid int, @newdepartmentid int,@hrmid int;
    select @olddepartmentid = departmentid,@hrmid = id from deleted;
        begin
    select @newdepartmentid = departmentid from inserted;
            update Prj_ProjectInfo set department = @newdepartmentid where manager = @hrmid;
        end
go