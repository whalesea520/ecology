alter PROCEDURE Doc_DirAcl_CheckPermission(@dirid_1 int, @dirtype_1 int, @userid_1 int, @usertype_1 int, @seclevel_1 int, @operationcode_1 int, 
@departmentid_1 varchar(4000),@subcompanyid_1 varchar(4000), @roleid_1 varchar(4000),@flag int output, @msg varchar(4000) output)  AS
declare @count_1 int
declare @result int
set @result = 0
if @usertype_1 = 0 begin
    set @count_1 = (select count(sourceid) from DirAccessControlDetail  where  sourceid = @dirid_1 and  sourcetype=@dirtype_1 and  sharelevel=@operationcode_1 and ((type=1 and content in (select * from SplitStr(@departmentid_1,',')) and seclevel<=@seclevel_1) or (type=2 and  content in (select * from SplitStr(@roleid_1,',')) and seclevel<=@seclevel_1) or (type=3 and seclevel<=@seclevel_1) or (type=4 and content=@usertype_1 and seclevel<=@seclevel_1) or (type=5 and content=@userid_1) or (type=6 and content in (select * from SplitStr(@subcompanyid_1,',')) and seclevel<=@seclevel_1)))
end
else begin
    set @count_1 = (select count(mainid) from DirAccessControlList where dirid=@dirid_1 and dirtype=@dirtype_1 and operationcode=@operationcode_1 and ((permissiontype=3 and seclevel<=@seclevel_1) or (permissiontype=4 and usertype=@usertype_1 and seclevel<=@seclevel_1)))
end
print @count_1
if (not (@count_1 is null)) and (@count_1 > 0) begin
    set @result = 1
end
select @result result
if @@error<>0 begin 
    set @flag=1 
    set @msg='检查目录访问权限成功' 
    return end 
else begin 
    set @flag=-1 
    set @msg='检查目录访问权限失败' 
    return 
end
GO

alter PROCEDURE Doc_DirAcl_CheckPermissionEx(@dirid_1 int, @dirtype_1 int, @userid_1 int, @usertype_1 int, @seclevel_1 int, @operationcode_1 int,@departmentid_1 varchar(4000),@subcompanyid_1 varchar(4000), @roleid_1 varchar(4000),@flag int output, @msg varchar(4000) output) AS 
declare @result_1 int
declare @mainid_1 int
execute Doc_DirAcl_CheckPermissionEx1 @dirid_1, @dirtype_1, @userid_1, @usertype_1, @seclevel_1, @operationcode_1,@departmentid_1,@subcompanyid_1,@roleid_1, @result_1 output, 1, 1
if @result_1 <> 1 begin
    declare @fatherid_1 int, @fatherid1_1 int
    if @dirtype_1 = 1 begin
        select @fatherid_1=subcategoryid from DocSubCategory where id = @dirid_1
    end
    else if @dirtype_1 = 2 begin
        select @fatherid_1=subcategoryid from DocSecCategory where id = @dirid_1
        if @fatherid_1 is null set @fatherid_1 = -1
        if @fatherid_1 = 0 set @fatherid_1 = -1
    end
    else begin
        set @fatherid_1 = -1
    end 
    if @dirtype_1 = 1 begin
       select @mainid_1=maincategoryid from DocSubCategory where id = @dirid_1
       execute Doc_DirAcl_CheckPermissionEx1 @mainid_1, 0, @userid_1, @usertype_1, @seclevel_1, @operationcode_1,@departmentid_1,@subcompanyid_1,@roleid_1, @result_1 output, 1, 1
       if @result_1=1 begin
           set @fatherid_1 = -1
       end
    end
    else if @dirtype_1 = 2 and @fatherid_1 <> -1 begin
       select @mainid_1=maincategoryid from DocSubCategory where id = @fatherid_1
       execute Doc_DirAcl_CheckPermissionEx1 @mainid_1, 0, @userid_1, @usertype_1, @seclevel_1, @operationcode_1,@departmentid_1,@subcompanyid_1,@roleid_1, @result_1 output, 1, 1
       if @result_1=1 begin
           set @fatherid_1 = -1
       end
    end
    while @fatherid_1 <> -1 begin
        execute Doc_DirAcl_CheckPermissionEx1 @fatherid_1, 1, @userid_1, @usertype_1, @seclevel_1, @operationcode_1,@departmentid_1,@subcompanyid_1,@roleid_1, @result_1 output, 1, 1
        if @result_1 <> 1 begin
            select @fatherid1_1=subcategoryid from DocSubCategory where id = @fatherid_1
            set @fatherid_1 = @fatherid1_1
        end
        else begin
            set @fatherid_1 = -1
        end
    end
end
select @result_1 result
if @@error<>0 begin 
    set @flag=1 
    set @msg='检查目录访问权限成功' 
    return end 
else begin 
    set @flag=0 
    set @msg='检查目录访问权限失败' 
    return 
end
GO

alter PROCEDURE Doc_DirAcl_CheckPermissionEx1(@dirid_1 int, @dirtype_1 int, @userid_1 int, @usertype_1 int, @seclevel_1 int, @operationcode_1 int,
@departmentid_1 varchar(4000),@subcompanyid_1 varchar(4000), @roleid_1 varchar(4000), @haspermission_1 int output, @flag int output, @msg varchar(4000) output)  AS 
declare @count_1 int
declare @result int
set @result = 0
if @usertype_1 = 0 begin
    set @count_1 = (select count(sourceid) from DirAccessControlDetail  where  sourceid = @dirid_1 and  sourcetype=@dirtype_1 and  sharelevel=@operationcode_1 and ((type=1 and content in (select * from SplitStr(@departmentid_1,',')) and seclevel<=@seclevel_1) or (type=2 and content in (select * from SplitStr(@roleid_1,',')) and seclevel<=@seclevel_1) or (type=3 and seclevel<=@seclevel_1) or (type=4 and content=@usertype_1 and seclevel<=@seclevel_1) or (type=5 and content=@userid_1) or (type=6 and content in (select * from SplitStr(@subcompanyid_1,',')) and seclevel<=@seclevel_1)))
end
else begin
    set @count_1 = (select count(mainid) from DirAccessControlList where dirid=@dirid_1 and dirtype=@dirtype_1 and operationcode=@operationcode_1 and ((permissiontype=3 and seclevel<=@seclevel_1) or (permissiontype=4 and usertype=@usertype_1 and seclevel<=@seclevel_1)))
end
if (not (@count_1 is null)) and (@count_1 > 0) begin
    set @result = 1
end
set @haspermission_1 = @result
if @@error<>0 begin 
    set @flag=1 
    set @msg='检查目录访问权限成功' 
    return end 
else begin 
    set @flag=0 
    set @msg='检查目录访问权限失败' 
    return 
end
GO

alter PROCEDURE Doc_DirAcl_CheckPermissionEx2(@dirid_1 int, @dirtype_1 int, @userid_1 int, @usertype_1 int, @seclevel_1 int, @operationcode_1 int,@departmentid_1 varchar(4000),@subcompanyid_1 varchar(4000), @roleid_1 varchar(4000),@flag int output, @msg varchar(4000) output) AS 
declare @result_1 int
declare @mainid_1 int
execute Doc_DirAcl_CheckPermissionEx1 @dirid_1, @dirtype_1, @userid_1, @usertype_1, @seclevel_1, @operationcode_1,@departmentid_1,@subcompanyid_1,@roleid_1, @result_1 output, 1, 1
if @result_1 <> 1 begin
    declare @fatherid_1 int, @fatherid1_1 int
    if @dirtype_1 = 1 begin
        select @fatherid_1=parentid from DocSecCategory where id = @dirid_1
    end
    else if @dirtype_1 = 2 begin
        select @fatherid_1=parentid from DocSecCategory where id = @dirid_1
        if @fatherid_1 is null set @fatherid_1 = -1
        if @fatherid_1 = 0 set @fatherid_1 = -1
    end
    else begin
        set @fatherid_1 = -1
    end 
    while @fatherid_1 <> -1 begin
        execute Doc_DirAcl_CheckPermissionEx1 @fatherid_1, 2, @userid_1, @usertype_1, @seclevel_1, @operationcode_1,@departmentid_1,@subcompanyid_1,@roleid_1, @result_1 output, 1, 1
        if @result_1 <> 1 begin
            select @fatherid1_1=parentid from DocSecCategory where id = @fatherid_1
            set @fatherid_1 = @fatherid1_1
			if @fatherid_1 is null set @fatherid_1 = -1
			if @fatherid_1 = 0 set @fatherid_1 = -1
        end
        else begin
            set @fatherid_1 = -1
        end
    end
end
select @result_1 result
if @@error<>0 begin 
    set @flag=1 
    set @msg='检查目录访问权限成功' 
    return end 
else begin 
    set @flag=0 
    set @msg='检查目录访问权限失败' 
    return 
end
GO