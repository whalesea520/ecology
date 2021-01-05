Create PROCEDURE Doc_DirAcl_CheckPermissionBE (@dirid_1 int, @dirtype_1 int, @userid_1 varchar(4000), @usertype_1 int, @seclevel_1 int, @operationcode_1 int, 
@departmentid_1 varchar(4000),@subcompanyid_1 varchar(4000), @roleid_1 varchar(4000),@flag int output, @msg varchar(4000) output)  AS
declare @count_1 int
declare @result int
set @result = 0
if @usertype_1 = 0 begin
    set @count_1 = (select count(sourceid) from DirAccessControlDetail  where  sourceid = @dirid_1 and  sourcetype=@dirtype_1 and  sharelevel=@operationcode_1 and ((type=1 and content in(select * from SplitStr(@departmentid_1,',')) and seclevel<=@seclevel_1) or (type=2 and  content in (select * from SplitStr(@roleid_1,',')) and seclevel<=@seclevel_1) or (type=3 and seclevel<=@seclevel_1) or (type=4 and content=@usertype_1 and seclevel<=@seclevel_1) or (type=5 and content in(select * from SplitStr(@userid_1,','))) or (type=6 and content in(select * from SplitStr(@subcompanyid_1,',')) and seclevel<=@seclevel_1)))
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