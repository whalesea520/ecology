update codedetail set showname='81537' where showname='19387'
GO
update codedetail set showname='81538' where showname='19388'
GO
update codedetail set showname='81539' where showname='19389'
GO
update codedetail set showname='81538' where showname='19417'
GO
alter table DocSecCategory add parentid int
GO
alter table DocSecCategory add dirid int
GO
alter table DocSecCategory add dirType int
GO
alter table DocSecCategory add subcompanyid int
GO
alter table DirAccessControlList add relatedid int
GO

alter table DocSecCatFTPConfig add refreshChildren char(1)
GO

delete from DocSecCategory where dirid in (select id from DocMainCategory) and dirType=0


GO

create table user_favorite_category(
	id int IDENTITY(1,1) not null primary key,
	userid int not null,
	usertype int not null,
	secid int not null
)

GO

insert into DocSecCategory(
	categoryname,
	secorder,
	coder,
	norepeatedname,
	dirid,
	dirType,
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
	croleid2,
	croleid3,
	hasaccessory,
	accessorynum,
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
	iscontroledbydir,
	puboperation,
	childdocreadremind,
	readoptercanprint,
	appliedTemplateId,
	logviewtype,
	appointedWorkflowId,
	printApplyWorkflowId,
	relationable,
	isOpenAttachment,
	maxOfficeDocFileSize,
	isAutoExtendInfo,
	isNotDelHisAtt,
	bacthDownload,
	ecology_pinyin_search,
	subcompanyid
	)
select 
	categoryname,
	categoryorder,
	coder,
	norepeatedname,
	id,
	0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,8,0,0,0,
	[dbo].[getPinYin](categoryname),
	subcompanyid
from DocMainCategory

GO

delete from DocSecCategory where dirid in (select id from DocSubCategory) and dirType=1

GO

insert into DocSecCategory(
	categoryname,
	secorder,
	coder,
	norepeatedname,
	parentid,
	dirid,
	dirType,
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
	croleid2,
	croleid3,
	hasaccessory,
	accessorynum,
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
	iscontroledbydir,
	puboperation,
	childdocreadremind,
	readoptercanprint,
	appliedTemplateId,
	logviewtype,
	appointedWorkflowId,
	printApplyWorkflowId,
	relationable,
	isOpenAttachment,
	maxOfficeDocFileSize,
	isAutoExtendInfo,
	isNotDelHisAtt,
	bacthDownload,
	ecology_pinyin_search
	)
select 
	categoryname,
	suborder,
	coder,
	norepeatedname,
	(select id from DocSecCategory where dirid=DocSubCategory.maincategoryid and dirType=0) as parentid,
	id,
	1,
	0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,8,0,0,0,
	[dbo].[getPinYin](categoryname)
from DocSubCategory

GO

delete from DocSecCatFTPConfig where secCategoryId in (select id from DocSecCategory where dirid in (select id from DocMainCategory) and dirType=0)

GO
insert into DocSecCatFTPConfig(
	secCategoryId,
	refreshChildren,
	isUseFTP,
	FTPConfigId)
select 
	(select id from DocSecCategory where dirid=mainCategoryId and dirType=0) as mainid,
	refreshSubAndSec,
	isUseFTP,FTPConfigId
from DocMainCatFTPConfig

GO

delete from DocSecCatFTPConfig where secCategoryId in (select id from DocSecCategory where dirid in (select id from DocSubCategory) and dirType=1)
GO
insert into DocSecCatFTPConfig(
	secCategoryId,
	refreshChildren,
	isUseFTP,
	FTPConfigId)
select 
	(select id from DocSecCategory where dirid=subCategoryId and dirType=1) as subid,
	refreshSec,
	isUseFTP,FTPConfigId
from DocSubCatFTPConfig

GO

delete from DirAccessControlList where dirid in (select id from DocSecCategory where dirid in (select id from DocMainCategory) and dirtype=0) and dirtype=2
GO
insert into DirAccessControlList(
	dirid,
	dirtype,
	seclevel,
	departmentid,
	roleid,
	rolelevel,
	usertype,
	permissiontype,
	operationcode,
	userid,
	DocSecCategoryTemplateId,
	subcompanyid,
	relatedid)
select 
	isnull((select id from DocSecCategory where dirid=DirAccessControlList.dirid and dirtype=0),0) as secid,
	2,
	seclevel,
	departmentid,
	roleid,
	rolelevel,
	usertype,
	permissiontype,
	operationcode,
	userid,
	DocSecCategoryTemplateId,
	subcompanyid,
	mainid
from DirAccessControlList where dirid>0 and dirtype=0
GO

delete from DirAccessControlList where dirid in (select id from DocSecCategory where dirid in (select id from DocSubCategory) and dirtype=1) and dirtype=2
GO
insert into DirAccessControlList(
	dirid,
	dirtype,
	seclevel,
	departmentid,
	roleid,
	rolelevel,
	usertype,
	permissiontype,
	operationcode,
	userid,
	DocSecCategoryTemplateId,
	subcompanyid,
	relatedid)
select 
	isnull((select id from DocSecCategory where dirid=DirAccessControlList.dirid and dirtype=1),0) as secid,
	2,
	seclevel,
	departmentid,
	roleid,
	rolelevel,
	usertype,
	permissiontype,
	operationcode,
	userid,
	DocSecCategoryTemplateId,
	subcompanyid,
	mainid
from DirAccessControlList where dirid>0 and dirtype=1
GO

update DocSecCategoryDocProperty set labelid=16398 where labelid=67
GO

create PROCEDURE init_seccategory_parent(
@flag integer output , 
@msg varchar(80) output) as 
declare @id_1 int,@subid_1 int
declare secdir_cursor cursor for
select id,subcategoryid from DocSecCategory where dirid is null and dirtype is null
open secdir_cursor
fetch next from secdir_cursor
into @id_1,@subid_1
while @@fetch_status = 0 begin
    update DocSecCategory set parentid = (select id from DocSecCategory where dirid=@subid_1 and dirType=1) where id=@id_1
    fetch next from secdir_cursor
	into @id_1,@subid_1
end
close secdir_cursor
deallocate secdir_cursor
GO

DECLARE	@return_value int,
		@flag int,
		@msg varchar(80)

EXEC init_seccategory_parent 
		@flag = @flag OUTPUT,
		@msg = @msg OUTPUT
		

GO
drop PROCEDURE init_seccategory_parent
GO