CREATE FUNCTION SplitStr
(
	@RowData nvarchar(2000),
	@SplitOn nvarchar(5)
)  
RETURNS @RtnValue table 
(
	Data nvarchar(100)
) 
AS  
BEGIN 
	Declare @Cnt int
	Set @Cnt = 1
	While (Charindex(@SplitOn,@RowData)>0)
	Begin
		Insert Into @RtnValue (data)
		Select 
			Data = ltrim(rtrim(Substring(@RowData,1,Charindex(@SplitOn,@RowData)-1)))

		Set @RowData = Substring(@RowData,Charindex(@SplitOn,@RowData)+1,len(@RowData))
		Set @Cnt = @Cnt + 1
	End
	Insert Into @RtnValue (data)
	Select Data = ltrim(rtrim(@RowData))
	Return
END
GO
alter PROCEDURE Doc_DirAcl_CheckPermission(@dirid_1 int, @dirtype_1 int, @userid_1 int, @usertype_1 int, @seclevel_1 int, @operationcode_1 int, 
@departmentid_1 int,@subcompanyid_1 int, @roleid_1 varchar(1000),@flag int output, @msg varchar(80) output)  AS
declare @count_1 int
declare @result int
set @result = 0
if @usertype_1 = 0 begin
    set @count_1 = (select count(sourceid) from DirAccessControlDetail  where  sourceid = @dirid_1 and  sourcetype=@dirtype_1 and  sharelevel=@operationcode_1 and ((type=1 and content=@departmentid_1 and seclevel<=@seclevel_1) or (type=2 and  content in (select * from SplitStr(@roleid_1,',')) and seclevel<=@seclevel_1) or (type=3 and seclevel<=@seclevel_1) or (type=4 and content=@usertype_1 and seclevel<=@seclevel_1) or (type=5 and content=@userid_1) or (type=6 and content=@subcompanyid_1 and seclevel<=@seclevel_1)))
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
alter PROCEDURE Doc_DirAcl_CheckPermissionEx1(@dirid_1 int, @dirtype_1 int, @userid_1 int, @usertype_1 int, @seclevel_1 int, @operationcode_1 int,
@departmentid_1 int,@subcompanyid_1 int, @roleid_1 varchar(1000), @haspermission_1 int output, @flag int output, @msg varchar(80) output)  AS 
declare @count_1 int
declare @result int
set @result = 0
if @usertype_1 = 0 begin
    set @count_1 = (select count(sourceid) from DirAccessControlDetail  where  sourceid = @dirid_1 and  sourcetype=@dirtype_1 and  sharelevel=@operationcode_1 and ((type=1 and content=@departmentid_1 and seclevel<=@seclevel_1) or (type=2 and content in (select * from SplitStr(@roleid_1,',')) and seclevel<=@seclevel_1) or (type=3 and seclevel<=@seclevel_1) or (type=4 and content=@usertype_1 and seclevel<=@seclevel_1) or (type=5 and content=@userid_1) or (type=6 and content=@subcompanyid_1 and seclevel<=@seclevel_1)))
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
ALTER PROCEDURE Doc_GetPermittedCategory(@userid_1 int, @usertype_1 int, @seclevel_1 int, @operationcode_1 int, @departmentid_1 int,@subcompanyid_1 int, @roleid_1 varchar(1000), @flag integer output , @msg varchar(80) output) as 
create table #temp(categoryid int, categorytype int, superdirid int, superdirtype int, categoryname varchar(200), orderid float)
declare @secdirid_1 int
declare @secdirname_1 varchar(200)
declare @subdirid_1 int, @subdirid1_1 int, @superdirid_1 int, @superdirtype_1 int, @maindirid_1 int
declare @subdirname_1 varchar(200)
declare @count_1 int
declare @orderid_1 float
if @usertype_1 = 0 begin
        declare secdir_cursor cursor for
        select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where id in (select distinct sourceid from DirAccessControlDetail where sharelevel=@operationcode_1 and ((type=1 and content=@departmentid_1 and seclevel<=@seclevel_1) or (type=2 and  content in (select * from SplitStr(@roleid_1,',')) and seclevel<=@seclevel_1) or (type=3 and seclevel<=@seclevel_1) or (type=4 and content=@usertype_1 and seclevel<=@seclevel_1) or (type=5 and content=@userid_1) or (type=6 and content=@subcompanyid_1 and seclevel<=@seclevel_1))) 
end
else begin
    declare secdir_cursor cursor for
    select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where id in (select distinct dirid mainid from DirAccessControlList where dirtype=2 and operationcode=@operationcode_1 and ((permissiontype=3 and seclevel<=@seclevel_1) or (permissiontype=4 and usertype=@usertype_1 and seclevel<=@seclevel_1)))
end
open secdir_cursor
fetch next from secdir_cursor
into @secdirid_1, @secdirname_1, @subdirid_1,@orderid_1
while @@fetch_status = 0 begin
    insert into #temp values(@secdirid_1, 2, @subdirid_1, 1, @secdirname_1, @orderid_1)
    if @subdirid_1 is null set @subdirid_1 = -1
    if @subdirid_1 = 0 set @subdirid_1 = -1    
    while @subdirid_1 <> -1 begin
        select @subdirid1_1=subcategoryid,@subdirname_1=categoryname,@superdirid_1=subcategoryid,@maindirid_1=maincategoryid,@orderid_1=suborder from DocSubCategory where id = @subdirid_1
        if @superdirid_1 = -1 begin
            set @superdirid_1 = @maindirid_1
            set @superdirtype_1 = 0
        end
        else begin
            set @superdirtype_1 = 1
        end
        set @count_1 = 0
        select @count_1=count(categoryid) from #temp where categoryid = @subdirid_1 and categorytype = 1
        if @count_1 <= 0
            insert into #temp values(@subdirid_1, 1, @superdirid_1, @superdirtype_1, @subdirname_1, @orderid_1)
        set @subdirid_1 = @subdirid1_1
    end    
    fetch next from secdir_cursor
    into @secdirid_1, @secdirname_1, @subdirid_1, @orderid_1
end
close secdir_cursor
deallocate secdir_cursor
declare maindir_cursor cursor for
select id, categoryname, categoryorder from DocMainCategory where id in (select distinct superdirid from #temp where superdirtype = 0)
open maindir_cursor
fetch next from maindir_cursor
into @subdirid_1, @subdirname_1, @orderid_1
while @@fetch_status = 0 begin
    insert into #temp values(@subdirid_1, 0, -1, -1, @subdirname_1, @orderid_1)
    fetch next from maindir_cursor
    into @subdirid_1, @subdirname_1, @orderid_1
end
close maindir_cursor
deallocate maindir_cursor
select * from #temp order by orderid,categoryid
GO
alter PROCEDURE Doc_MainCategory_FindByUser @userid_1 int, @usertype_1 int,@seclevel_1 int, @operationcode_1 int, 
@departmentid_1 int,@subcompanyid_1 int, @roleid_1 varchar(1000),@flag	int	output, @msg varchar(80) output as 
if @operationcode_1 = 0 begin
    select 'mainid' = id from DocMainCategory where id in (
        select distinct maincategoryid from DocSubCategory where id in (
            select distinct subcategoryid from DocSecCategory where id in (
		select distinct sourceid from DirAccessControlDetail where sourcetype=2  and sharelevel=@operationcode_1 and ((type=1 and content=@departmentid_1 and seclevel<=@seclevel_1) or (type=2 and content in (select * from SplitStr(@roleid_1,',')) and seclevel<=@seclevel_1) or (type=3 and seclevel<=@seclevel_1) or (type=4 and content=@usertype_1 and seclevel<=@seclevel_1) or (type=5 and content=@userid_1) or (type=6 and content=@subcompanyid_1 and seclevel<=@seclevel_1))
                )
            )
        )
    order by categoryorder
end
else  begin
    select 'mainid' = id from DocMainCategory where id in (
		select distinct sourceid from DirAccessControlDetail where sourcetype=0  and sharelevel=@operationcode_1 and ((type=1 and content=@departmentid_1 and seclevel<=@seclevel_1) or (type=2 and content in (select * from SplitStr(@roleid_1,',')) and seclevel<=@seclevel_1) or (type=3 and seclevel<=@seclevel_1) or (type=4 and content=@usertype_1 and seclevel<=@seclevel_1) or (type=5 and content=@userid_1) or (type=6 and content=@subcompanyid_1 and seclevel<=@seclevel_1))
        )
    order by categoryorder
end
GO
alter PROCEDURE Doc_SecCategory_FindByUser @userid_1 int, @usertype_1 int, @seclevel_1 int, @operationcode_1 int,
@departmentid_1 int,@subcompanyid_1 int, @roleid_1 varchar(1000), @flag	int	output, @msg	varchar(80) output as 
    select distinct id mainid from DocSecCategory where id in (select distinct sourceid from DirAccessControlDetail where sourcetype=2  and sharelevel=@operationcode_1 and ((type=1 and content=@departmentid_1 and seclevel<=@seclevel_1) or (type=2 and content in (select * from SplitStr(@roleid_1,',')) and seclevel<=@seclevel_1) or (type=3 and seclevel<=@seclevel_1) or (type=4 and content=@usertype_1 and seclevel<=@seclevel_1) or (type=5 and content=@userid_1) or (type=6 and content=@subcompanyid_1 and seclevel<=@seclevel_1))) 
GO
alter PROCEDURE Doc_SubCategory_FindByUser @userid_1 int, @usertype_1 int,@seclevel_1 int, @operationcode_1 int, 
@departmentid_1 int,@subcompanyid_1 int, @roleid_1 varchar(1000), @flag	int	output, @msg	varchar(80) output as 
if @operationcode_1 = 0 begin
    select distinct subcategoryid mainid from DocSecCategory where id in (select distinct sourceid from DirAccessControlDetail where sourcetype=2  and sharelevel=@operationcode_1 and ((type=1 and content=@departmentid_1 and seclevel<=@seclevel_1) or (type=2 and content in (select * from SplitStr(@roleid_1,',')) and seclevel<=@seclevel_1) or (type=3 and seclevel<=@seclevel_1) or (type=4 and content=@usertype_1 and seclevel<=@seclevel_1) or (type=5 and content=@userid_1) or (type=6 and content=@subcompanyid_1 and seclevel<=@seclevel_1))) 
end
else begin
   select distinct sourceid mainid from DirAccessControlDetail where sourcetype=1  and sharelevel=@operationcode_1 and ((type=1 and content=@departmentid_1 and seclevel<=@seclevel_1) or (type=2 and  content in (select * from SplitStr(@roleid_1,',')) and seclevel<=@seclevel_1) or (type=3 and seclevel<=@seclevel_1) or (type=4 and content=@usertype_1 and seclevel<=@seclevel_1) or (type=5 and content=@userid_1) or (type=6 and content=@subcompanyid_1 and seclevel<=@seclevel_1))
end
GO