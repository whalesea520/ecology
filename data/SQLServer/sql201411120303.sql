create PROCEDURE Doc_DirAcl_CheckPermissionEx2(@dirid_1 int, @dirtype_1 int, @userid_1 int, @usertype_1 int, @seclevel_1 int, @operationcode_1 int,@departmentid_1 int,@subcompanyid_1 int, @roleid_1 varchar(1000),@flag int output, @msg varchar(80) output) AS 
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

create PROCEDURE Doc_GetPermittedCategory_New(
@userid_1 int, 
@usertype_1 int, 
@seclevel_1 int, 
@operationcode_1 int, 
@departmentid_1 int,
@subcompanyid_1 int, 
@roleid_1 varchar(1000), 
@categoryname_1 varchar(200),
@flag integer output , 
@msg varchar(80) output) as 
create table #temp(categoryid int, categorytype int, superdirid int, superdirtype int, categoryname varchar(200), orderid float)
declare @secdirid_1 int
declare @secdirname_1 varchar(200)
declare @subdirid_1 int, @subdirid1_1 int, @superdirid_1 int, @superdirtype_1 int, @maindirid_1 int
declare @subdirname_1 varchar(200)
declare @count_1 int
declare @orderid_1 float
if @usertype_1 = 0 begin
		if @categoryname_1 = '' begin
			declare secdir_cursor cursor for
			select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where id in (select distinct sourceid from DirAccessControlDetail where sharelevel=@operationcode_1 and ((type=1 and content=@departmentid_1 and seclevel<=@seclevel_1) or (type=2 and  content in (select * from SplitStr(@roleid_1,',')) and seclevel<=@seclevel_1) or (type=3 and seclevel<=@seclevel_1) or (type=4 and content=@usertype_1 and seclevel<=@seclevel_1) or (type=5 and content=@userid_1) or (type=6 and content=@subcompanyid_1 and seclevel<=@seclevel_1))) 
		end
		else begin
			declare secdir_cursor cursor for
			select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where categoryname like '%'+@categoryname_1+'%' and id in (select distinct sourceid from DirAccessControlDetail where sharelevel=@operationcode_1 and ((type=1 and content=@departmentid_1 and seclevel<=@seclevel_1) or (type=2 and  content in (select * from SplitStr(@roleid_1,',')) and seclevel<=@seclevel_1) or (type=3 and seclevel<=@seclevel_1) or (type=4 and content=@usertype_1 and seclevel<=@seclevel_1) or (type=5 and content=@userid_1) or (type=6 and content=@subcompanyid_1 and seclevel<=@seclevel_1))) 
		end
end
else begin
	if @categoryname_1 = '' begin
		declare secdir_cursor cursor for
		select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where id in (select distinct dirid mainid from DirAccessControlList where dirtype=2 and operationcode=@operationcode_1 and ((permissiontype=3 and seclevel<=@seclevel_1) or (permissiontype=4 and usertype=@usertype_1 and seclevel<=@seclevel_1)))
	end
	else begin
		declare secdir_cursor cursor for
		select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where categoryname like '%'+@categoryname_1+'%' and  id in (select distinct dirid mainid from DirAccessControlList where dirtype=2 and operationcode=@operationcode_1 and ((permissiontype=3 and seclevel<=@seclevel_1) or (permissiontype=4 and usertype=@usertype_1 and seclevel<=@seclevel_1)))
	end
end
open secdir_cursor
fetch next from secdir_cursor
into @secdirid_1, @secdirname_1, @subdirid_1,@orderid_1
while @@fetch_status = 0 begin
    insert into #temp values(@secdirid_1, 2, @subdirid_1, 2, @secdirname_1, @orderid_1)
    fetch next from secdir_cursor
    into @secdirid_1, @secdirname_1, @subdirid_1,@orderid_1
end
close secdir_cursor
deallocate secdir_cursor
select * from #temp order by orderid,categoryid
GO

create PROCEDURE Doc_SecCategory_Insert_New 
	( @subcategoryid 	int, 
		@categoryname 	varchar(200), 
		@docmouldid 	int, 
		@publishable 	char(1), 
		@replyable 	char(1), 
		@shareable 	char(1), 
		@cusertype 	int, 
		@cuserseclevel 	tinyint, 
		@cdepartmentid1 	int, 
		@cdepseclevel1 	tinyint, 
		@cdepartmentid2 	int, 
		@cdepseclevel2 	tinyint, 
		@croleid1	 		int, 
		@crolelevel1	 	char(1), 
		@croleid2	 	int, 
		@crolelevel2 	char(1), 
		@croleid3	 	int, 
		@crolelevel3 	char(1), 
		@hasaccessory	 	char(1), 
		@accessorynum	 	tinyint, 
		@hasasset		 	char(1), 
		@assetlabel	 	varchar(200), 
		@hasitems	 	char(1), 
		@itemlabel 	varchar(200), 
		@hashrmres 	char(1), 
		@hrmreslabel 	varchar(200), 
		@hascrm	 	char(1), 
		@crmlabel	 	varchar(200), 
		@hasproject 	char(1), 
		@projectlabel 	varchar(200), 
		@hasfinance 	char(1), 
		@financelabel 	varchar(200), 
		@approveworkflowid	int, 
		@markable  char(1), 
		@markAnonymity char(1), 
		@orderable char(1), 
		@defaultLockedDoc int, 
		@allownModiMShareL int, 
		@allownModiMShareW int, 
		@maxUploadFileSize int, 
		@wordmouldid int, 
		@isSetShare int, 
		@noDownload int, 
		@noRepeatedName int, 
		@isControledByDir int, 
		@pubOperation int, 
		@childDocReadRemind int, 
		@readOpterCanPrint int, 
		@isLogControl char(1),
		@subcompanyId int,
		@level int, 
		@parentid int,
		@secorder float,
		@flag	int output, 
		@msg	varchar(80)	output) as 
		declare @dirid int
		declare @dirtype int
		if @level=1 begin
			set @dirtype = 0
			insert into DocMainCategory(categoryname,categoryiconid,categoryorder,coder,norepeatedname,subcompanyid)
			values(@categoryname,0,@secorder,0,@noRepeatedName,@subcompanyId)
			declare maindir_cursor cursor for
				select MAX(id) from DocMainCategory  where categoryname=@categoryname
			open maindir_cursor
			fetch next from maindir_cursor
			into @dirid
			close maindir_cursor
			deallocate maindir_cursor
		end
		else begin
			if @level=2 begin
				set @dirtype = 1
				declare dirid_cursor cursor for
					select dirid from DocSecCategory where id=@parentid
					open dirid_cursor
					fetch next from dirid_cursor
					into @dirid
				insert into DocSubCategory(categoryname,maincategoryid,subcategoryid,suborder,norepeatedname)
				values(@categoryname,@dirid,-1,@secorder,@noRepeatedName)
				declare subdir_cursor cursor for
					select MAX(id) from DocSubCategory where categoryname=@categoryname
					open subdir_cursor
					fetch next from subdir_cursor
					into @dirid
				close subdir_cursor
				deallocate subdir_cursor
			end
		end
	insert into docseccategory(
		subcategoryid,
		categoryname,
		docmouldid,
		publishable,
		replyable,
		shareable,
		cusertype,
		cuserseclevel,
		cdepartmentid1,
		cdepseclevel1,
		cdepartmentid2,
		cdepseclevel2,
		croleid1,
		crolelevel1,
		croleid2,
		crolelevel2,
		croleid3,
		crolelevel3,
		hasaccessory,
		accessorynum,
		hasasset,
		assetlabel,
		hasitems,
		itemlabel,
		hashrmres,
		hrmreslabel,
		hascrm,
		crmlabel,
		hasproject,
		projectlabel,
		hasfinance,
		financelabel,
		approveworkflowid,
		markable,
		markAnonymity,
		orderable,
		defaultLockedDoc,
		allownModiMShareL,
		allownModiMShareW,
		maxUploadFileSize,
		wordmouldid,
		isSetShare,
		nodownload,
		norepeatedname,
		iscontroledbydir,
		puboperation,
		childdocreadremind,
		readoptercanprint,
		isLogControl,
		subcompanyId,
		parentid,
		dirid,
		dirType
		) 
	values( 
		@subcategoryid, 
		@categoryname, 
		@docmouldid, 
		@publishable, 
		@replyable, 
		@shareable, 
		@cusertype, 
		@cuserseclevel, 
		@cdepartmentid1, 
		@cdepseclevel1, 
		@cdepartmentid2, 
		@cdepseclevel2, 
		@croleid1, 
		@crolelevel1, 
		@croleid2, 
		@crolelevel2, 
		@croleid3, 
		@crolelevel3, 
		@hasaccessory, 
		@accessorynum, 
		@hasasset, 
		@assetlabel, 
		@hasitems, 
		@itemlabel, 
		@hashrmres, 
		@hrmreslabel, 
		@hascrm, 
		@crmlabel, 
		@hasproject, 
		@projectlabel, 
		@hasfinance, 
		@financelabel, 
		@approveworkflowid,
		@markable,
		@markAnonymity,
		@orderable,
		@defaultLockedDoc,
		@allownModiMShareL,
		@allownModiMShareW,
		@maxUploadFileSize,
		@wordmouldid,
		@isSetShare,
		@noDownload,
		@noRepeatedName,
		@isControledByDir,
		@pubOperation,
		@childDocReadRemind,
		@readOpterCanPrint,
		@isLogControl,
		@subcompanyId,
		@parentid,
		@dirid,
		@dirtype
		) 
	select max(id) from docseccategory where categoryname = @categoryname
GO