update codedetail set showname='81537' where showname='19387'
/
update codedetail set showname='81538' where showname='19388'
/
update codedetail set showname='81539' where showname='19389'
/
update codedetail set showname='81538' where showname='19417'
/
alter table DocSecCategory add parentid integer
/
alter table DocSecCategory add dirid integer
/
alter table DocSecCategory add dirType integer
/
alter table DocSecCategory add subcompanyid integer
/
alter table DirAccessControlList add relatedid integer
/

alter table DocSecCatFTPConfig add refreshChildren char(1)
/

delete from DocSecCategory where dirid in (select id from DocMainCategory) and dirType=0
/

create table user_favorite_category(
	ID integer  NOT NULL primary key,
	userid integer not null,
	usertype integer not null,
	secid integer not null
)
/

create sequence user_favorite_category_id
	minvalue 1
	maxvalue 999999999999999999999999999
	start with 1
	increment by 1
	cache 20
/

create or replace trigger   user_fav_category_id_TRIGGER
  before insert on user_favorite_category
  for each row
begin
  select user_favorite_category_id.nextval into :new.id from dual;
end;
/

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
	getPinYin(categoryname),
	subcompanyid
from DocMainCategory

/

delete from DocSecCategory where dirid in (select id from DocSubCategory) and dirType=1

/

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
	getPinYin(categoryname)
from DocSubCategory
/
delete from DocSecCatFTPConfig where secCategoryId in (select id from DocSecCategory where dirid in (select id from DocMainCategory) and dirType=0)
/
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
/

delete from DocSecCatFTPConfig where secCategoryId in (select id from DocSecCategory where dirid in (select id from DocSubCategory) and dirType=1)
/
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
/
delete from DirAccessControlList where dirid in (select id from DocSecCategory where dirid in (select id from DocMainCategory) and dirtype=0) and dirtype=2
/
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
	nvl((select id from DocSecCategory where dirid=DirAccessControlList.dirid and dirtype=0),0) as secid,
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
/

delete from DirAccessControlList where dirid in (select id from DocSecCategory where dirid in (select id from DocSubCategory) and dirtype=1) and dirtype=2
/
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
	nvl((select id from DocSecCategory where dirid=DirAccessControlList.dirid and dirtype=1),0) as secid,
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
/
update DocSecCategoryDocProperty set labelid=16398 where labelid=67
/
create or replace PROCEDURE init_seccategory_parent as 
id_1 integer;
subid_1 integer;
begin
	for secdir_cursor in(select id,subcategoryid from DocSecCategory where dirid is null and dirtype is null)
	loop
	    id_1 := secdir_cursor.id;
	    subid_1 := secdir_cursor.subcategoryid;
	    update DocSecCategory set parentid = (select id from DocSecCategory where dirid=subid_1 and dirType=1) where id=id_1;
	end loop;
end;
/

call init_seccategory_parent()
/

drop PROCEDURE init_seccategory_parent
/
