alter PROCEDURE Doc_DirAcl_CheckPermissionEx2(@dirid_1 int, @dirtype_1 int, @userid_1 int, @usertype_1 int, @seclevel_1 int, @operationcode_1 int,@departmentid_1 int,@subcompanyid_1 int, @roleid_1 varchar(1000),@flag int output, @msg varchar(80) output) AS 
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
    set @msg='���Ŀ¼����Ȩ�޳ɹ�' 
    return end 
else begin 
    set @flag=0 
    set @msg='���Ŀ¼����Ȩ��ʧ��' 
    return 
end
GO