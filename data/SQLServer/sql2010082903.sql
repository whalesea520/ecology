CREATE PROCEDURE createdocseclevel
AS
declare @resourceid_1 int, @departmentid_1 int, @subcompanyid_1 int, @seclevel_1 int
declare hrmresource_cursor cursor for
  select t.id,t.departmentid,t.subcompanyid1,t.seclevel FROM HrmResource t where t.seclevel = 0
  
open hrmresource_cursor
fetch next from hrmresource_cursor
into @resourceid_1, @departmentid_1, @subcompanyid_1, @seclevel_1

while @@fetch_status = 0

begin
  execute Doc_DirAcl_GUserP_BasicChange @resourceid_1,@departmentid_1,@subcompanyid_1,@seclevel_1
  fetch next from hrmresource_cursor
  into @resourceid_1, @departmentid_1, @subcompanyid_1, @seclevel_1
end

close hrmresource_cursor
deallocate hrmresource_cursor
GO

exec createdocseclevel 
go

drop PROCEDURE createdocseclevel
go
