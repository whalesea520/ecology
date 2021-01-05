alter PROCEDURE Doc_SecCategory_Insert_New 
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
				insert into DocSubCategory(categoryname,maincategoryid,subcategoryid,suborder,norepeatedname)
				select @categoryname, dirid ,-1,@secorder,@noRepeatedName
				from DocSecCategory where id=@parentid
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