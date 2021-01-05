
/* 删除权限 */
ALTER PROCEDURE Doc_DirAcl_Delete(@mainid_1 int, @flag int output, @msg varchar(80) output)  AS

declare @dirid_1 int, @dirtype_1 int, @operationcode_1 int, @departmentid_1 int, @subcompanyid_1 int, @roleid_1 int, @rolelevel_1 int, @seclevel_1 int, @permissiontype_1 int, @usertype_1 int, @mainuserid_1 int
declare permission_cursor cursor for
select dirid, dirtype, seclevel, departmentid, subcompanyid, roleid, rolelevel, usertype, permissiontype, operationcode, userid from DirAccessControlList where mainid = @mainid_1

open permission_cursor
fetch next from permission_cursor
into @dirid_1, @dirtype_1, @seclevel_1, @departmentid_1, @subcompanyid_1, @roleid_1, @rolelevel_1, @usertype_1, @permissiontype_1, @operationcode_1, @mainuserid_1

close permission_cursor
deallocate permission_cursor

if @@fetch_status = 0 begin
  declare @userid_1 int
  declare @count int
  
  if @permissiontype_1 = 1 begin
    declare users_cursor cursor for
    select distinct id from HrmResource where departmentid = @departmentid_1 and seclevel >= @seclevel_1
    open users_cursor
    fetch next from users_cursor
    into @userid_1
    
    while @@fetch_status = 0
    begin
      execute Doc_DirAccessPermission_Delete @dirid_1,@dirtype_1,@userid_1,0,@operationcode_1
      fetch next from users_cursor
      into @userid_1
    end
    close users_cursor
    deallocate users_cursor
  end
  else if @permissiontype_1 = 2 begin
    declare users_cursor cursor for
    select distinct HrmResource.id from HrmResource, HrmRoleMembers where roleid = @roleid_1 and rolelevel >= @rolelevel_1 and HrmResource.id = HrmRoleMembers.resourceid and seclevel >= @seclevel_1 union select distinct HrmResourceManager.id from HrmResourceManager, HrmRoleMembers where roleid = @roleid_1 and rolelevel >= @rolelevel_1 and HrmResourceManager.id = HrmRoleMembers.resourceid and seclevel >= @seclevel_1
    open users_cursor
    fetch next from users_cursor
    into @userid_1
    
    while @@fetch_status = 0
    begin
      execute Doc_DirAccessPermission_Delete @dirid_1,@dirtype_1,@userid_1,0,@operationcode_1
      fetch next from users_cursor
      into @userid_1
    end
    close users_cursor
    deallocate users_cursor
  end
  else if @permissiontype_1 = 3 begin
    declare users_cursor cursor for
    select distinct id from HrmResource where seclevel >= @seclevel_1 union select distinct id from HrmResourceManager where seclevel >= @seclevel_1
    open users_cursor
    fetch next from users_cursor
    into @userid_1
    
    while @@fetch_status = 0
    begin
      execute Doc_DirAccessPermission_Delete @dirid_1,@dirtype_1,@userid_1,0,@operationcode_1
      fetch next from users_cursor
      into @userid_1
    end
    close users_cursor
    deallocate users_cursor
  end
  else if @permissiontype_1 = 4 begin
    if @usertype_1 = 0 begin
      declare users_cursor cursor for
      select distinct id from HrmResource where seclevel >= @seclevel_1 union select distinct id from HrmResourceManager where seclevel >= @seclevel_1
      open users_cursor
      fetch next from users_cursor
      into @userid_1
      
      while @@fetch_status = 0
      begin
        execute Doc_DirAccessPermission_Delete @dirid_1,@dirtype_1,@userid_1,@usertype_1,@operationcode_1
        fetch next from users_cursor
        into @userid_1
      end      
      close users_cursor
      deallocate users_cursor
    end
  end
  else if @permissiontype_1 = 5 begin
    execute Doc_DirAccessPermission_Delete @dirid_1,@dirtype_1,@mainuserid_1,0,@operationcode_1
  end
  else if @permissiontype_1 = 6 begin
    declare users_cursor cursor for
    select distinct id from HrmResource where subcompanyid1 = @subcompanyid_1 and seclevel >= @seclevel_1
    open users_cursor
    fetch next from users_cursor
    into @userid_1
    
    while @@fetch_status = 0
    begin
      execute Doc_DirAccessPermission_Delete @dirid_1,@dirtype_1,@userid_1,0,@operationcode_1
      fetch next from users_cursor
      into @userid_1
    end
    close users_cursor
    deallocate users_cursor
  end
  
  delete from DirAccessControlList where mainid = @mainid_1
end

if @@error<>0 begin 
    set @flag=1 
    set @msg='删除目录访问权限表成功' 
    return end 
else begin 
    set @flag=0 
    set @msg='删除目录访问权限表失败' 
    return 
end

GO

/* 以角色＋角色级别+安全级别的方式增加权限 */

ALTER PROCEDURE Doc_DirAcl_Insert_Type2(@dirid_1 int, @dirtype_1 int, @operationcode_1 int, @roleid_1 int, @rolelevel_1 int, @seclevel_1 int, @flag int output, @msg varchar(80) output)  AS

insert into DirAccessControlList(dirid, dirtype, roleid, rolelevel, seclevel, operationcode, permissiontype) values(@dirid_1, @dirtype_1, @roleid_1, @rolelevel_1, @seclevel_1, @operationcode_1, 2)

declare @userid_1 int
declare @count int
declare users_cursor cursor for
select distinct HrmResource.id from HrmResource, HrmRoleMembers 
where roleid = @roleid_1 and rolelevel >= @rolelevel_1 and HrmResource.id = HrmRoleMembers.resourceid and seclevel >= @seclevel_1
union
select distinct HrmResourceManager.id from HrmResourceManager, HrmRoleMembers 
where roleid = @roleid_1 and rolelevel >= @rolelevel_1 and HrmResourceManager.id = HrmRoleMembers.resourceid and seclevel >= @seclevel_1

open users_cursor
fetch next from users_cursor
into @userid_1
while @@fetch_status = 0
begin
  execute Doc_DirAccessPermission_Insert @dirid_1,@dirtype_1,@userid_1,0,@operationcode_1
  
  fetch next from users_cursor
  into @userid_1
end

close users_cursor
deallocate users_cursor

if @@error<>0 begin 
    set @flag=1 
    set @msg='插入目录访问权限主表成功' 
    return end 
else begin 
    set @flag=0 
    set @msg='插入目录访问权限主表失败' 
    return 
end

GO

/* 以所有人＋安全级别的方式增加权限 */
ALTER PROCEDURE Doc_DirAcl_Insert_Type3(@dirid_1 int, @dirtype_1 int, @operationcode_1 int, @seclevel_1 int, @flag int output, @msg varchar(80) output)  AS

insert into DirAccessControlList(dirid, dirtype, seclevel, operationcode, permissiontype) values(@dirid_1, @dirtype_1, @seclevel_1, @operationcode_1, 3)

declare @userid_1 int
declare @count int
declare users_cursor cursor for
select distinct id from HrmResource where seclevel >= @seclevel_1
union
select distinct id from HrmResourceManager where seclevel >= @seclevel_1

open users_cursor
fetch next from users_cursor
into @userid_1
while @@fetch_status = 0
begin
  execute Doc_DirAccessPermission_Insert @dirid_1,@dirtype_1,@userid_1,0,@operationcode_1
  
  fetch next from users_cursor
  into @userid_1
end

close users_cursor
deallocate users_cursor

if @@error<>0 begin 
    set @flag=1 
    set @msg='插入目录访问权限主表成功' 
    return end 
else begin 
    set @flag=0 
    set @msg='插入目录访问权限主表失败' 
    return 
end

GO

/* 以用户类型＋安全级别的方式增加权限 */
ALTER PROCEDURE Doc_DirAcl_Insert_Type4(@dirid_1 int, @dirtype_1 int, @operationcode_1 int, @usertype_1 int, @seclevel_1 int, @flag int output, @msg varchar(80) output)  AS

insert into DirAccessControlList(dirid, dirtype, usertype, seclevel, operationcode, permissiontype) values(@dirid_1, @dirtype_1, @usertype_1, @seclevel_1, @operationcode_1, 4)

if @usertype_1 = 0 begin
  declare @userid_1 int
  declare @count int
  declare users_cursor cursor for
  select distinct id from HrmResource where seclevel >= @seclevel_1
  union
  select distinct id from HrmResourceManager where seclevel >= @seclevel_1
  
  open users_cursor
  fetch next from users_cursor
  into @userid_1
  while @@fetch_status = 0
  begin
    execute Doc_DirAccessPermission_Insert @dirid_1,@dirtype_1,@userid_1,0,@operationcode_1
    
    fetch next from users_cursor
    into @userid_1
  end

  close users_cursor
  deallocate users_cursor
end

if @@error<>0 begin 
    set @flag=1 
    set @msg='插入目录访问权限主表成功' 
    return end 
else begin 
    set @flag=0 
    set @msg='插入目录访问权限主表失败' 
    return 
end

GO
