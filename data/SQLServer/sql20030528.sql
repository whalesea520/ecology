alter table license add multilanguage char
GO

update license set multilanguage='n'
GO

alter table license add email char
GO

update license set email='n'
GO

alter table license add meeting char
GO

update license set meeting='n'
GO

alter table license add project char
GO

update license set project='n'
GO

alter table license add crm char
GO

update license set crm='n'
GO

alter table license add cpt char
GO

update license set cpt='n'
GO

alter table license add finance char
GO

update license set finance='n'
GO

alter table license add hrm char
GO

update license set hrm='n'
GO

alter table license add workflow char
GO

update license set workflow='n'
GO

alter table license add document char
GO

update license set document='n'
GO

alter PROCEDURE HrmResource_Trigger_Insert
	(@id_1 	int,
	 @managerid_2 	int,
	 @departmentid_3 	int,
	 @subcompanyid1_4 	int,
	 @seclevel_5 	tinyint,
	 @managerstr_6 	varchar(200),
	 @flag int output, @msg varchar(60) output)
AS 
declare @numcount int
select   @numcount = count(*)  from HrmResource_Trigger where id=@id_1
if @numcount =0 
begin
INSERT INTO HrmResource_Trigger 
	 ( id,
  	   managerid,
 	   departmentid,
	   subcompanyid1,
	   seclevel,
	   managerstr) 
 
VALUES 
	( @id_1,
	 @managerid_2,
	 @departmentid_3,
	 @subcompanyid1_4,
	 0,
	 @managerstr_6)
end
go

 alter PROCEDURE HrmResourceBasicInfo_Insert 
 (@id_1 int, 
  @workcode_2 varchar(60), 
  @lastname_3 varchar(60), 
  @sex_5 char(1), 
  @resoureimageid_6 int, 
  @departmentid_7 int, 
  @costcenterid_8 int, 
  @jobtitle_9 int, 
  @joblevel_10 int, 
  @jobactivitydesc_11 varchar(200), 
  @managerid_12 int, 
  @assistantid_13 int, 
  @status_14 char(1), 
  @locationid_15 int, 
  @workroom_16 varchar(60), 
  @telephone_17 varchar(60), 
  @mobile_18 varchar(60), 
  @mobilecall_19 varchar(30) , 
  @fax_20 varchar(60), 
  @jobcall_21 int, 
  @flag int output, @msg varchar(60) output) 
AS INSERT INTO HrmResource 
(id, 
 workcode, 
 lastname, 
 sex, 
 resourceimageid, 
 departmentid, 
 costcenterid, 
 jobtitle, 
 joblevel, 
 jobactivitydesc, 
 managerid, 
 assistantid, 
 status, 
 locationid, 
 workroom, 
 telephone, 
 mobile, 
 mobilecall, 
 fax, 
 jobcall,
 seclevel) 
VALUES 
(@id_1, 
 @workcode_2, 
 @lastname_3, 
 @sex_5, 
 @resoureimageid_6, 
 @departmentid_7, 
 @costcenterid_8, 
 @jobtitle_9, 
 @joblevel_10, 
 @jobactivitydesc_11, 
 @managerid_12, 
 @assistantid_13, 
 @status_14, 
 @locationid_15, 
 @workroom_16, 
 @telephone_17, 
 @mobile_18, 
 @mobilecall_19, 
 @fax_20, 
 @jobcall_21,
 0)
GO

CREATE procedure HrmCareerApply_CreateInfo
(@id_1 int,
 @createrid_2 int,
 @createdate_3 char(10),
 @lastmodid_4 int,
 @lastmoddate_5 char(10),
 @flag int output, @msg varchar(60) output)
as update HrmCareerApply set
 createrid = @createrid_2,
 createdate = @createdate_3,
 lastmodid = @lastmodid_4,
 lastmoddate = @lastmoddate_5
where
 id = @id_1
GO

create procedure HrmCareerApply_ModInfo
(@id_1 int,
 @lastmodid_2 int,
 @lastmoddate_3 char(10),
 @flag int output, @msg varchar(60) output)
as update HrmCareerApply set
 lastmodid = @lastmodid_2,
 lastmoddate = @lastmoddate_3
where
 id = @id_1

GO

create procedure HrmResourceMaxId_Get
(@flag int output, @msg varchar(60) output)
as 
declare @id_1 integer
select @id_1=currentid from SequenceIndex where indexdesc='resourceid'
update SequenceIndex set currentid = @id_1+1 where indexdesc='resourceid'
select @id_1
go

create procedure SequenceIndexRes_Init
as 
declare @id_1 integer, @resid_2 integer, @curid_3 integer
select @id_1=max(id) from HrmResource
select @resid_2 = max(id) from HrmCareerApply
if( @id_1>@resid_2) set @curid_3= @id_1+1
else  set @curid_3 = @resid_2+1
update SequenceIndex set currentid = @curid_3 where indexdesc='resourceid'
go

exec SequenceIndexRes_Init
go

INSERT INTO HtmlLabelInfo([indexid], [labelname], [languageid])
VALUES (7171, '插件下载', 7)
go        
INSERT  INTO HtmlLabelInfo([indexid], [labelname], [languageid])
VALUES (7171, 'weaverPlugin_download', 8)
go
INSERT  INTO htmllabelindex([id], [indexdesc])
VALUES (7171, '插件下载')
GO


CREATE TABLE [docReadTag] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[userType] [int] NULL ,
	[docid] [int] NULL ,
	[userid] [int]   NULL ,
	[readCount] [int] NULL 
)
GO

CREATE PROCEDURE docReadTag_SelectByuserid
	(@docid_1 	[int] ,
	 @userid_2 	[int] ,
	 @userType_3	[int] ,
  	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS
select  userid   from docReadTag where docid = @docid_1 and userid = @userid_2 and userType = @userType_3
GO


CREATE PROCEDURE docDetail_QueryByDocid
	(@docid_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS
select DocSubject,maincategory,docdepartmentid,doccreaterid  from Docdetail where id = @docid_1 
GO



CREATE PROCEDURE docDetailLog_QueryByDate
	(@fromdate_1 	[char](10) ,
	 @todate_1 	[char](10) ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS
SELECT docid, SUM(readCount) AS COUNT FROM docReadTag where docid in (SELECT docid FROM DocDetailLog WHERE (operatedate >= @fromdate_1) AND (operatedate <= @todate_1))GROUP BY docid ORDER BY COUNT DESC
GO

/*谭晓鹏*/

CREATE TABLE DirAccessControlList (
	mainid int IDENTITY (1, 1) NOT NULL ,
	dirid int NOT NULL ,
	dirtype int NOT NULL ,
	seclevel int NULL ,
	departmentid int NULL ,
	roleid int NULL ,
	rolelevel int NULL ,
	usertype int NULL ,
	permissiontype int NOT NULL ,
	operationcode int NOT NULL ,
	userid int NULL 
)
GO

CREATE TABLE DirAccessPermission (
	dirid int NOT NULL ,
	dirtype int NOT NULL ,
	userid int NOT NULL ,
	usertype int NOT NULL ,
	createdoc int NOT NULL ,
	createdir int NOT NULL ,
	movedoc int NOT NULL 
)
GO

ALTER TABLE DirAccessControlList  ADD 
	CONSTRAINT PK_DirAccessControlList PRIMARY KEY  CLUSTERED 
	(
		mainid
	) 
GO

ALTER TABLE DirAccessPermission  ADD 
	CONSTRAINT PK_DirAccessPermission PRIMARY KEY  CLUSTERED 
	(
		dirid,
		dirtype,
		userid,
		usertype
	) 
GO

/*
    2003年6月3日增加
*/

ALTER TABLE DirAccessPermission  ADD
    copydoc int DEFAULT 0 NOT NULL

GO

/* 增加一个用户-资源访问许可（仅限存储过程调用） */
CREATE PROCEDURE Doc_DirAccessPermission_Insert(@dirid_1 int, @dirtype_1 int, @userid_1 int, @usertype_1 int, @operationcode_1 int)  AS

declare @count_1 int

if @operationcode_1 = 0 begin
  set @count_1 = (select createdoc from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
  if @count_1 is null
      insert into DirAccessPermission(dirid, dirtype, userid, usertype, createdoc, createdir, movedoc, copydoc) values(@dirid_1, @dirtype_1, @userid_1, @usertype_1, 1, 0, 0, 0)
  else
      update DirAccessPermission set createdoc = (@count_1+1) where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
end
else if @operationcode_1 = 1 begin
    set @count_1 = (select createdir from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
    if @count_1 is null
        insert into DirAccessPermission(dirid, dirtype, userid, usertype, createdoc, createdir, movedoc, copydoc) values(@dirid_1, @dirtype_1, @userid_1, @usertype_1, 0, 1, 0, 0)
    else
        update DirAccessPermission set createdir = (@count_1+1) where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
end
else if @operationcode_1 = 2 begin
    set @count_1 = (select movedoc from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
    if @count_1 is null
        insert into DirAccessPermission(dirid, dirtype, userid, usertype, createdoc, createdir, movedoc, copydoc) values(@dirid_1, @dirtype_1, @userid_1, @usertype_1, 0, 0, 1, 0)
    else
        update DirAccessPermission set movedoc = (@count_1+1) where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
end
else if @operationcode_1 = 3 begin
    select @count_1 = copydoc from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
    if @count_1 is null
        insert into DirAccessPermission(dirid, dirtype, userid, usertype, createdoc, createdir, movedoc, copydoc) values(@dirid_1, @dirtype_1, @userid_1, @usertype_1, 0, 0, 0, 1)
    else
        update DirAccessPermission set copydoc = (@count_1+1) where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
end

GO

/* 删除一个用户-资源访问许可（仅限存储过程调用） */
CREATE PROCEDURE Doc_DirAccessPermission_Delete(@dirid_1 int, @dirtype_1 int, @userid_1 int, @usertype_1 int, @operationcode_1 int)  AS

declare @count_1 int

if @operationcode_1 = 0 begin
  set @count_1 = (select createdoc from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
  if not (@count_1 is null) and (@count_1 > 0) begin
    update DirAccessPermission set createdoc = (@count_1-1) where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
  end
end
else if @operationcode_1 = 1 begin
  set @count_1 = (select createdir from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
  if not (@count_1 is null) and (@count_1 > 0) begin
    update DirAccessPermission set createdir = (@count_1-1) where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
  end
end
else if @operationcode_1 = 2 begin
  set @count_1 = (select movedoc from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
  if not (@count_1 is null) and (@count_1 > 0) begin
    update DirAccessPermission set movedoc = (@count_1-1) where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
  end
end
else if @operationcode_1 = 3 begin
  select @count_1 = copydoc from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
  if not (@count_1 is null) and (@count_1 > 0) begin
    update DirAccessPermission set copydoc = (@count_1-1) where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
  end
end

GO

/* 以部门＋安全级别的方式增加权限 */
CREATE PROCEDURE Doc_DirAcl_Insert_Type1(@dirid_1 int, @dirtype_1 int, @operationcode_1 int, @departmentid_1 int, @seclevel_1 int, @flag int output, @msg varchar(80) output)  AS

insert into DirAccessControlList(dirid, dirtype, departmentid, seclevel, operationcode, permissiontype) values(@dirid_1, @dirtype_1, @departmentid_1, @seclevel_1, @operationcode_1, 1)

declare @userid_1 int
declare @count int
declare users_cursor cursor for
select distinct id from HrmResource where departmentid = @departmentid_1 and seclevel >= @seclevel_1

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

/* 以角色＋角色级别+安全级别的方式增加权限 */

CREATE PROCEDURE Doc_DirAcl_Insert_Type2(@dirid_1 int, @dirtype_1 int, @operationcode_1 int, @roleid_1 int, @rolelevel_1 int, @seclevel_1 int, @flag int output, @msg varchar(80) output)  AS

insert into DirAccessControlList(dirid, dirtype, roleid, rolelevel, seclevel, operationcode, permissiontype) values(@dirid_1, @dirtype_1, @roleid_1, @rolelevel_1, @seclevel_1, @operationcode_1, 2)

declare @userid_1 int
declare @count int
declare users_cursor cursor for
select distinct HrmResource.id from HrmResource, HrmRoleMembers 
where roleid = @roleid_1 and rolelevel >= @rolelevel_1 and HrmResource.id = HrmRoleMembers.resourceid and seclevel >= @seclevel_1

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
CREATE PROCEDURE Doc_DirAcl_Insert_Type3(@dirid_1 int, @dirtype_1 int, @operationcode_1 int, @seclevel_1 int, @flag int output, @msg varchar(80) output)  AS

insert into DirAccessControlList(dirid, dirtype, seclevel, operationcode, permissiontype) values(@dirid_1, @dirtype_1, @seclevel_1, @operationcode_1, 3)

declare @userid_1 int
declare @count int
declare users_cursor cursor for
select distinct id from HrmResource where seclevel >= @seclevel_1

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
CREATE PROCEDURE Doc_DirAcl_Insert_Type4(@dirid_1 int, @dirtype_1 int, @operationcode_1 int, @usertype_1 int, @seclevel_1 int, @flag int output, @msg varchar(80) output)  AS

insert into DirAccessControlList(dirid, dirtype, usertype, seclevel, operationcode, permissiontype) values(@dirid_1, @dirtype_1, @usertype_1, @seclevel_1, @operationcode_1, 4)

if @usertype_1 = 0 begin
  declare @userid_1 int
  declare @count int
  declare users_cursor cursor for
  select distinct id from HrmResource where seclevel >= @seclevel_1
  
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

/* 以人力资源的方式增加权限 */
CREATE PROCEDURE Doc_DirAcl_Insert_Type5(@dirid_1 int, @dirtype_1 int, @operationcode_1 int, @userid_1 int, @flag int output, @msg varchar(80) output)  AS

insert into DirAccessControlList(dirid, dirtype, userid, operationcode, permissiontype) values(@dirid_1, @dirtype_1, @userid_1, @operationcode_1, 5)
execute Doc_DirAccessPermission_Insert @dirid_1,@dirtype_1,@userid_1,0,@operationcode_1

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

/* 删除权限 */
CREATE PROCEDURE Doc_DirAcl_Delete(@mainid_1 int, @flag int output, @msg varchar(80) output)  AS

declare @dirid_1 int, @dirtype_1 int, @operationcode_1 int, @departmentid_1 int, @roleid_1 int, @rolelevel_1 int, @seclevel_1 int, @permissiontype_1 int, @usertype_1 int, @mainuserid_1 int
declare permission_cursor cursor for
select dirid, dirtype, seclevel, departmentid, roleid, rolelevel, usertype, permissiontype, operationcode, userid from DirAccessControlList where mainid = @mainid_1

open permission_cursor
fetch next from permission_cursor
into @dirid_1, @dirtype_1, @seclevel_1, @departmentid_1, @roleid_1, @rolelevel_1, @usertype_1, @permissiontype_1, @operationcode_1, @mainuserid_1

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
    select distinct HrmResource.id from HrmResource, HrmRoleMembers where roleid = @roleid_1 and rolelevel >= @rolelevel_1 and HrmResource.id = HrmRoleMembers.resourceid and seclevel >= @seclevel_1
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
    select distinct id from HrmResource where seclevel >= @seclevel_1
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
      select distinct id from HrmResource where seclevel >= @seclevel_1
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

/* 删除了目录后清理权限 */
create procedure Doc_DirAcl_CPermissionForDir(@dirid_1 int, @dirtype_1 int, @flag int output, @msg varchar(80) output) as 

delete from DirAccessControlList where dirid = @dirid_1 and dirtype = @dirtype_1
delete from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1

if @@error<>0 begin 
    set @flag=1 
    set @msg='清除目录访问权限表成功' 
    return end 
else begin 
    set @flag=0 
    set @msg='清除目录访问权限表失败' 
    return 
end

GO

/* 删除了用户后清理权限 */
create procedure Doc_DirAcl_CPermissionForUser(@userid_1 int, @usertype_1 int, @flag int output, @msg varchar(80) output) as 

if @usertype_1 = 0 begin
    delete from DirAccessPermission where userid = @userid_1 and usertype = @usertype_1
end

if @@error<>0 begin 
    set @flag=1 
    set @msg='清除目录访问权限表成功' 
    return end 
else begin 
    set @flag=0 
    set @msg='清除目录访问权限表失败' 
    return 
end
GO

/* 为单个用户授予所有被权限表允许的权限 */
CREATE PROCEDURE Doc_DirAcl_GrantUserPermission(@userid_1 int, @flag int output, @msg varchar(80) output)  AS

/*  处理和HrmResource表的字段相关的权限判断，此时读出的安全级别也会在后面使用 */

declare @departmentid_1 int, @seclevel_1 int
declare user_cursor cursor for
select departmentid, seclevel from HrmResource where id = @userid_1
open user_cursor
fetch next from user_cursor
into @departmentid_1, @seclevel_1
close user_cursor
deallocate user_cursor

declare @mainid_1 int, @dirid_1 int, @dirtype_1 int, @operationcode_1 int
declare @isValidUser int

if @@fetch_status = 0 begin
  set @isValidUser = 1
  declare permission_cursor cursor for
  select mainid, dirid, dirtype, operationcode from DirAccessControlList 
  where (permissiontype=1 and departmentid=@departmentid_1 and seclevel<=@seclevel_1) or 
        (permissiontype=3 and seclevel<=@seclevel_1) or
        (permissiontype=4 and usertype=0 and seclevel<=@seclevel_1) or
        (permissiontype=5 and userid=@userid_1)
  
  open permission_cursor
  fetch next from permission_cursor
  into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1
  
  while @@fetch_status = 0
  begin
    execute Doc_DirAccessPermission_Insert @dirid_1,@dirtype_1,@userid_1,0,@operationcode_1
    fetch next from permission_cursor
    into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1
  end
  
  close permission_cursor
  deallocate permission_cursor
end
else begin
  set @isValidUser = 0
end

/* 处理角色相关的权限判断 */

if @isValidUser = 1 begin
  declare @roleid_1 int, @rolelevel_1 int
  declare user_role_cursor cursor for
  select roleid, rolelevel from HrmRoleMembers where resourceid = @userid_1
  
  open user_role_cursor
  fetch next from user_role_cursor
  into @roleid_1, @rolelevel_1
  
  while @@fetch_status = 0 begin
    declare permission_cursor cursor for
    select mainid, dirid, dirtype, operationcode from DirAccessControlList 
    where (permissiontype=2 and roleid=@roleid_1 and rolelevel<=@rolelevel_1 and seclevel<=@seclevel_1)
    
    open permission_cursor
    fetch next from permission_cursor
    into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1
    while @@fetch_status = 0
    begin
      execute Doc_DirAccessPermission_Insert @dirid_1,@dirtype_1,@userid_1,0,@operationcode_1
      fetch next from permission_cursor
      into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1
    end
    close permission_cursor
    deallocate permission_cursor
    
    fetch next from user_role_cursor
    into @roleid_1, @rolelevel_1
  end
  
  close user_role_cursor
  deallocate user_role_cursor
end

if @@error<>0 begin 
    set @flag=1 
    set @msg='激活目录访问权限成功' 
    return end 
else begin 
    set @flag=0 
    set @msg='激活目录访问权限失败' 
    return 
end
GO

/* 为单个用户剥夺所有被权限表允许的权限 */
CREATE PROCEDURE Doc_DirAcl_DUserPermission(@userid_1 int, @flag int output, @msg varchar(80) output)  AS

/*  处理和HrmResource表的字段相关的权限判断，此时读出的安全级别也会在后面使用 */

declare @departmentid_1 int, @seclevel_1 int
declare user_cursor cursor for
select departmentid, seclevel from HrmResource where id = @userid_1
open user_cursor
fetch next from user_cursor
into @departmentid_1, @seclevel_1
close user_cursor
deallocate user_cursor

declare @mainid_1 int, @dirid_1 int, @dirtype_1 int, @operationcode_1 int
declare @isValidUser int

if @@fetch_status = 0 begin
  set @isValidUser = 1
  declare permission_cursor cursor for
  select mainid, dirid, dirtype, operationcode from DirAccessControlList 
  where (permissiontype=1 and departmentid=@departmentid_1 and seclevel<=@seclevel_1) or 
        (permissiontype=3 and seclevel<=@seclevel_1) or
        (permissiontype=4 and usertype=0 and seclevel<=@seclevel_1) or 
        (permissiontype=5 and userid=@userid_1)
  
  open permission_cursor
  fetch next from permission_cursor
  into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1
  
  while @@fetch_status = 0
  begin
    execute Doc_DirAccessPermission_Delete @dirid_1,@dirtype_1,@userid_1,0,@operationcode_1
    fetch next from permission_cursor
    into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1
  end
  
  close permission_cursor
  deallocate permission_cursor
end
else begin
  set @isValidUser = 0
end

/* 处理角色相关的权限判断 */

if @isValidUser = 1 begin
  declare @roleid_1 int, @rolelevel_1 int
  declare user_role_cursor cursor for
  select roleid, rolelevel from HrmRoleMembers where resourceid = @userid_1
  
  open user_role_cursor
  fetch next from user_role_cursor
  into @roleid_1, @rolelevel_1
  
  while @@fetch_status = 0 begin
    declare permission_cursor cursor for
    select mainid, dirid, dirtype, operationcode from DirAccessControlList 
    where (permissiontype=2 and roleid=@roleid_1 and rolelevel<=@rolelevel_1 and seclevel<=@seclevel_1)
    
    open permission_cursor
    fetch next from permission_cursor
    into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1
    while @@fetch_status = 0
    begin
      execute Doc_DirAccessPermission_Delete @dirid_1,@dirtype_1,@userid_1,0,@operationcode_1
      fetch next from permission_cursor
      into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1
    end
    close permission_cursor
    deallocate permission_cursor
    
    fetch next from user_role_cursor
    into @roleid_1, @rolelevel_1
  end
  
  close user_role_cursor
  deallocate user_role_cursor
end

if @@error<>0 begin 
    set @flag=1 
    set @msg='取消目录访问权限成功' 
    return end 
else begin 
    set @flag=0 
    set @msg='取消目录访问权限失败' 
    return 
end
GO

/* 检查是否拥有权限 */
CREATE PROCEDURE Doc_DirAcl_CheckPermission(@dirid_1 int, @dirtype_1 int, @userid_1 int, @usertype_1 int, @seclevel_1 int, @operationcode_1 int, @flag int output, @msg varchar(80) output)  AS

declare @count_1 int
declare @result int

set @result = 0

if @usertype_1 = 0 begin
    if @operationcode_1 = 0 begin
        set @count_1 = (select createdoc from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
    end
    else if @operationcode_1 = 1 begin
        set @count_1 = (select createdir from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
    end
    else if @operationcode_1 = 2 begin
        set @count_1 = (select movedoc from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
    end
    else if @operationcode_1 = 3 begin
        select @count_1 = copydoc from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
    end
end
else begin
    set @count_1 = (select count(mainid) from DirAccessControlList where dirid=@dirid_1 and dirtype=@dirtype_1 and operationcode=@operationcode_1 and ((permissiontype=3 and seclevel<=@seclevel_1) or (permissiontype=4 and usertype=@usertype_1 and seclevel<=@seclevel_1)))
end

if (not (@count_1 is null)) and (@count_1 > 0) begin
    set @result = 1
end

select @result result

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

/* 查找用户拥有权限的主目录 */
CREATE PROCEDURE Doc_MainCategory_FindByUser @userid_1 int, @usertype_1 int, @operationcode_1 int, @flag	int	output, @msg varchar(80) output as 
if @operationcode_1 = 0 begin
    select 'mainid' = id from DocMainCategory where id in (
        select distinct maincategoryid from DocSubCategory where id in (
            select distinct subcategoryid from DocSecCategory where id in (
                select distinct dirid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=2 and createdoc > 0
                )
            )
        )
    order by categoryorder
end
else if @operationcode_1 = 1 begin
    select 'mainid' = id from DocMainCategory where id in (
                select distinct dirid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=0 and createdir > 0
        )
    order by categoryorder
end
else if @operationcode_1 = 2 begin
    select 'mainid' = id from DocMainCategory where id in (
                select distinct dirid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=0 and movedoc > 0
        )
    order by categoryorder
end
else if @operationcode_1 = 3 begin
    select 'mainid' = id from DocMainCategory where id in (
                select distinct dirid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=0 and copydoc > 0
        )
    order by categoryorder
end
GO

/* 查找用户拥有权限的分目录 */
CREATE PROCEDURE Doc_SubCategory_FindByUser @userid_1 int, @usertype_1 int, @operationcode_1 int, @flag	int	output, @msg	varchar(80) output as 
if @operationcode_1 = 0 begin
    select distinct subcategoryid mainid from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=2 and createdoc>0)
end
else if @operationcode_1 = 1 begin
    select distinct dirid mainid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=1 and createdir>0
end
else if @operationcode_1 = 2 begin
    select distinct dirid mainid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=1 and movedoc>0
end
else if @operationcode_1 = 3 begin
    select distinct dirid mainid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=1 and copydoc>0
end
GO

/* 查找用户拥有权限的子目录 */
CREATE PROCEDURE Doc_SecCategory_FindByUser @userid_1 int, @usertype_1 int, @operationcode_1 int, @flag	int	output, @msg	varchar(80) output as 
if @operationcode_1 = 0 begin
    select distinct id mainid from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=2 and createdoc>0)
end
else if @operationcode_1 = 1 begin
    select distinct id mainid from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=2 and createdir>0)
end
else if @operationcode_1 = 2 begin
    select distinct id mainid from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=2 and movedoc>0)
end
else if @operationcode_1 = 3 begin
    select distinct id mainid from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=2 and copydoc>0)
end  
GO

/* 查找外部用户拥有权限的主目录 */
CREATE PROCEDURE Doc_MainCategory_FByUser_Out @usertype_1 int, @seclevel_1 int, @operationcode_1 int, @flag	int	output, @msg varchar(80) output as 
if @operationcode_1 = 0 begin
    select 'mainid' = id from DocMainCategory where id in (
        select distinct maincategoryid from DocSubCategory where id in (
            select distinct subcategoryid from DocSecCategory where id in (
                select distinct dirid from DirAccessControlList where dirtype=2 and operationcode=@operationcode_1 and ((permissiontype=3 and seclevel<=@seclevel_1) or (permissiontype=4 and usertype=@usertype_1 and seclevel<=@seclevel_1))
                )
            )
        )
    order by categoryorder
end
else if (@operationcode_1 = 1) or (@operationcode_1 = 2) or (@operationcode_1 = 3) begin
    select 'mainid' = id from DocMainCategory where id in (
        select distinct dirid from DirAccessControlList where dirtype=0 and operationcode=@operationcode_1 and ((permissiontype=3 and seclevel<=@seclevel_1) or (permissiontype=4 and usertype=@usertype_1 and seclevel<=@seclevel_1))
        )
    order by categoryorder
end

GO

/* 查找外部用户拥有权限的分目录 */
CREATE PROCEDURE Doc_SubCategory_FindByUser_Out @usertype_1 int, @seclevel_1 int, @operationcode_1 int, @flag	int	output, @msg	varchar(80) output as 
if @operationcode_1 = 0 begin
    select distinct subcategoryid mainid from DocSecCategory where id in (
        select distinct dirid from DirAccessControlList where dirtype=2 and operationcode=@operationcode_1 and ((permissiontype=3 and seclevel<=@seclevel_1) or (permissiontype=4 and usertype=@usertype_1 and seclevel<=@seclevel_1))
        )
end
else if (@operationcode_1 = 1) or (@operationcode_1 = 2) or (@operationcode_1 = 3) begin
    select distinct id mainid from DocSubCategory where id in (
        select distinct dirid from DirAccessControlList where dirtype=1 and operationcode=@operationcode_1 and ((permissiontype=3 and seclevel<=@seclevel_1) or (permissiontype=4 and usertype=@usertype_1 and seclevel<=@seclevel_1))
        )
end
GO

/* 查找外部用户拥有权限的子目录 */
CREATE PROCEDURE Doc_SecCategory_FindByUser_Out(@usertype_1 int, @seclevel_1 int, @operationcode_1 int, @flag int output, @msg varchar(80) output)  AS

select distinct dirid mainid from DirAccessControlList where dirtype=2 and operationcode=@operationcode_1 and ((permissiontype=3 and seclevel<=@seclevel_1) or (permissiontype=4 and usertype=@usertype_1 and seclevel<=@seclevel_1))

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

/* 根据目录选择权限 */
CREATE PROCEDURE Doc_DirAcl_SByDirID (@dirid_1 int, @dirtype_1 int, @operationcode_1 int, @flag	int output, @msg	varchar(80)	output) as 
    select * from DirAccessControlList where dirid=@dirid_1 and dirtype=@dirtype_1 and operationcode=@operationcode_1
GO

/* 当用户基本信息发生变化时用来取消权限 */
CREATE PROCEDURE Doc_DirAcl_DUserP_BasicChange(@userid_1 int, @departmentid_1 int, @seclevel_1 int)  AS

declare @mainid_1 int, @dirid_1 int, @dirtype_1 int, @operationcode_1 int

/* 处理对1,3,4,5类权限的影响 */
declare permission_cursor cursor for
select mainid, dirid, dirtype, operationcode from DirAccessControlList 
where (permissiontype=1 and departmentid=@departmentid_1 and seclevel<=@seclevel_1) or 
      (permissiontype=3 and seclevel<=@seclevel_1) or
      (permissiontype=4 and usertype=0 and seclevel<=@seclevel_1) or 
      (permissiontype=5 and userid=@userid_1)

open permission_cursor
fetch next from permission_cursor
into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1

while @@fetch_status = 0
begin
  execute Doc_DirAccessPermission_Delete @dirid_1,@dirtype_1,@userid_1,0,@operationcode_1
  fetch next from permission_cursor
  into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1
end

close permission_cursor
deallocate permission_cursor

/* 处理对2类权限的影响 */
declare @roleid_1 int, @rolelevel_1 int
declare user_role_cursor cursor for
select roleid, rolelevel from HrmRoleMembers where resourceid = @userid_1

open user_role_cursor
fetch next from user_role_cursor
into @roleid_1, @rolelevel_1

while @@fetch_status = 0 begin
  declare permission_cursor1 cursor for
  select mainid, dirid, dirtype, operationcode from DirAccessControlList 
  where (permissiontype=2 and roleid=@roleid_1 and rolelevel<=@rolelevel_1 and seclevel<=@seclevel_1)
  
  open permission_cursor1
  fetch next from permission_cursor1
  into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1
  while @@fetch_status = 0
  begin
    execute Doc_DirAccessPermission_Delete @dirid_1,@dirtype_1,@userid_1,0,@operationcode_1
    fetch next from permission_cursor1
    into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1
  end
  close permission_cursor1
  deallocate permission_cursor1
  
  fetch next from user_role_cursor
  into @roleid_1, @rolelevel_1
end

close user_role_cursor
deallocate user_role_cursor

GO

/* 当用户角色发生变化时用来取消相关权限 */
CREATE PROCEDURE Doc_DirAcl_DUserP_RoleChange(@userid_1 int, @roleid_1 int, @rolelevel_1 int, @seclevel_1 int)  AS

declare @mainid_1 int, @dirid_1 int, @dirtype_1 int, @operationcode_1 int
declare permission_cursor cursor for
select mainid, dirid, dirtype, operationcode from DirAccessControlList 
where (permissiontype=2 and roleid=@roleid_1 and rolelevel<=@rolelevel_1 and seclevel<=@seclevel_1)

open permission_cursor
fetch next from permission_cursor
into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1
while @@fetch_status = 0
begin
  execute Doc_DirAccessPermission_Delete @dirid_1,@dirtype_1,@userid_1,0,@operationcode_1
  fetch next from permission_cursor
  into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1
end
close permission_cursor
deallocate permission_cursor

GO

/* 当用户基本信息发生变化时用来授予权限 */
CREATE PROCEDURE Doc_DirAcl_GUserP_BasicChange(@userid_1 int, @departmentid_1 int, @seclevel_1 int)  AS

declare @mainid_1 int, @dirid_1 int, @dirtype_1 int, @operationcode_1 int
/* 处理对1,3,4,5类权限的影响 */
declare permission_cursor cursor for
select mainid, dirid, dirtype, operationcode from DirAccessControlList 
where (permissiontype=1 and departmentid=@departmentid_1 and seclevel<=@seclevel_1) or 
      (permissiontype=3 and seclevel<=@seclevel_1) or
      (permissiontype=4 and usertype=0 and seclevel<=@seclevel_1) or 
      (permissiontype=5 and userid=@userid_1)

open permission_cursor
fetch next from permission_cursor
into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1

while @@fetch_status = 0
begin
  execute Doc_DirAccessPermission_Insert @dirid_1,@dirtype_1,@userid_1,0,@operationcode_1
  fetch next from permission_cursor
  into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1
end

close permission_cursor
deallocate permission_cursor

/* 处理对2类权限的影响 */
declare @roleid_1 int, @rolelevel_1 int
declare user_role_cursor cursor for
select roleid, rolelevel from HrmRoleMembers where resourceid = @userid_1

open user_role_cursor
fetch next from user_role_cursor
into @roleid_1, @rolelevel_1

while @@fetch_status = 0 begin
  declare permission_cursor1 cursor for
  select mainid, dirid, dirtype, operationcode from DirAccessControlList 
  where (permissiontype=2 and roleid=@roleid_1 and rolelevel<=@rolelevel_1 and seclevel<=@seclevel_1)
  
  open permission_cursor1
  fetch next from permission_cursor1
  into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1
  while @@fetch_status = 0
  begin
    execute Doc_DirAccessPermission_Insert @dirid_1,@dirtype_1,@userid_1,0,@operationcode_1
    fetch next from permission_cursor1
    into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1
  end
  close permission_cursor1
  deallocate permission_cursor1
  
  fetch next from user_role_cursor
  into @roleid_1, @rolelevel_1
end

close user_role_cursor
deallocate user_role_cursor
  
GO

/* 当用户角色发生变化时用来取消权限 */
CREATE PROCEDURE Doc_DirAcl_GUserP_RoleChange(@userid_1 int, @roleid_1 int, @rolelevel_1 int, @seclevel_1 int)  AS

declare @mainid_1 int, @dirid_1 int, @dirtype_1 int, @operationcode_1 int
declare permission_cursor cursor for
select mainid, dirid, dirtype, operationcode from DirAccessControlList 
where (permissiontype=2 and roleid=@roleid_1 and rolelevel<=@rolelevel_1 and seclevel<=@seclevel_1)

open permission_cursor
fetch next from permission_cursor
into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1
while @@fetch_status = 0
begin
  execute Doc_DirAccessPermission_Insert @dirid_1,@dirtype_1,@userid_1,0,@operationcode_1
  fetch next from permission_cursor
  into @mainid_1, @dirid_1, @dirtype_1, @operationcode_1
end
close permission_cursor
deallocate permission_cursor
GO

/* 从旧表插入数据 */
CREATE PROCEDURE Doc_DirAcl_InsertFromOldTable as 

declare @secid_1 int, @usertype_1 int, @seclevel_1 int
declare @department1_1 int, @dseclevel1_1 int, @department2_1 int, @dseclevel2_1 int
declare @roleid1_1 int, @rolelevel1_1 int, @roleid2_1 int, @rolelevel2_1 int, @roleid3_1 int, @rolelevel3_1 int
declare oldpermission_cursor cursor for
select id,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3 from DocSecCategory

open oldpermission_cursor
fetch next from oldpermission_cursor
into @secid_1, @usertype_1, @seclevel_1, @department1_1, @dseclevel1_1, @department2_1, @dseclevel2_1, @roleid1_1, @rolelevel1_1, @roleid2_1, @rolelevel2_1, @roleid3_1, @rolelevel3_1

while @@fetch_status=0 begin
  execute Doc_DirAcl_Insert_Type4 @secid_1,2,0,@usertype_1,@seclevel_1,1,1
  if not (@department1_1=0) begin
    execute Doc_DirAcl_Insert_Type1 @secid_1,2,0,@department1_1,@dseclevel1_1,1,1
  end
  if not (@department2_1=0) begin
    execute Doc_DirAcl_Insert_Type1 @secid_1,2,0,@department2_1,@dseclevel2_1,1,1
  end
  if not (@roleid1_1=0) begin
    execute Doc_DirAcl_Insert_Type2 @secid_1,2,0,@roleid1_1,@rolelevel1_1,0,1,1
  end
  if not (@roleid2_1=0) begin
    execute Doc_DirAcl_Insert_Type2 @secid_1,2,0,@roleid2_1,@rolelevel2_1,0,1,1
  end
  if not (@roleid3_1=0) begin
    execute Doc_DirAcl_Insert_Type2 @secid_1,2,0,@roleid3_1,@rolelevel3_1,0,1,1
  end
  
  fetch next from oldpermission_cursor
  into @secid_1, @usertype_1, @seclevel_1, @department1_1, @dseclevel1_1, @department2_1, @dseclevel2_1, @roleid1_1, @rolelevel1_1, @roleid2_1, @rolelevel2_1, @roleid3_1, @rolelevel3_1
end

close oldpermission_cursor
deallocate oldpermission_cursor

GO

exec Doc_DirAcl_InsertFromOldTable
go

insert into htmllabelinfo values(7175, '部门＋安全级别', 7)
go
insert into htmllabelinfo values(7175, 'department+security level', 8)
go
insert into htmllabelinfo values(7176, '角色＋安全级别＋级别', 7)
go
insert into htmllabelinfo values(7176, 'role+security level+role level', 8)
go
insert into htmllabelinfo values(7177, '安全级别', 7)
go
insert into htmllabelinfo values(7177, 'security level', 8)
go
insert into htmllabelinfo values(7178, '用户类型＋安全级别', 7)
go
insert into htmllabelinfo values(7178, 'usertype+security level', 8)
go
insert into htmllabelinfo values(7179, '用户类型', 7)
go
insert into htmllabelinfo values(7179, 'usertype', 8)
go

/* 修改hrmresource的trigger */
alter TRIGGER Tri_Update_HrmresourceShare ON Hrmresource WITH ENCRYPTION
FOR UPDATE
AS
Declare @resourceid_1 int,
        @subresourceid_1 int,
        @supresourceid_1 int,
        @olddepartmentid_1 int,
        @departmentid_1 int,
	    @subcompanyid_1 int,
        @oldseclevel_1	 int,
	    @seclevel_1	 int,
        @docid_1	 int,
        @crmid_1	 int,
	    @prjid_1	 int,
	    @cptid_1	 int,
        @sharelevel_1  int,
        @countrec      int,
        @countdelete   int,
        @oldmanagerstr_1    varchar(200),
        @managerstr_1    varchar(200)
        
/* 从刚修改的行中查找修改的resourceid 等 */
select @olddepartmentid_1 = departmentid, @oldseclevel_1 = seclevel , 
       @oldmanagerstr_1 = managerstr from deleted
select @resourceid_1 = id , @departmentid_1 = departmentid, @subcompanyid_1 = subcompanyid1 ,  
       @seclevel_1 = seclevel , @managerstr_1 = managerstr from inserted

/* 如果部门和安全级别信息被修改 */
if ( @departmentid_1 <>@olddepartmentid_1 or  @seclevel_1 <> @oldseclevel_1 or @oldseclevel_1 is null )     
begin
    if @departmentid_1 is null   set @departmentid_1 = 0
    if @subcompanyid_1 is null   set @subcompanyid_1 = 0

    /* 修改目录许可表 */
    if ((@olddepartmentid_1 is not null) and (@oldseclevel_1 is not null)) begin
        execute Doc_DirAcl_DUserP_BasicChange @resourceid_1, @olddepartmentid_1, @oldseclevel_1
    end
    if ((@departmentid_1 is not null) and (@seclevel_1 is not null)) begin
        execute Doc_DirAcl_GUserP_BasicChange @resourceid_1, @departmentid_1, @seclevel_1
    end

    /* 该人新建文档目录的列表 */
    exec DocUserCategory_InsertByUser @resourceid_1,'0','',''
    
    /* DOC 部分*/

    /* 删除原有的该人的所有文档共享信息 */
	delete from DocShareDetail where userid = @resourceid_1 and usertype = 1

    /* 定义临时表变量 */
    Declare @temptablevalue  table(docid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevalue 中 */
    /*  自己创建的或者是 owner 的文章可以编辑 */
    declare docid_cursor cursor for
    select distinct id from DocDetail where ( doccreaterid = @resourceid_1 or ownerid = @resourceid_1 ) and usertype= '1'
    open docid_cursor 
    fetch next from docid_cursor into @docid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevalue values(@docid_1, 2)
        fetch next from docid_cursor into @docid_1
    end
    close docid_cursor deallocate docid_cursor


    /* 自己下级的文档 */
    /* 查找下级 */
    declare @managerstr_11 varchar(200) 
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subdocid_cursor cursor for
    select distinct id from DocDetail where ( doccreaterid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) or ownerid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) ) and usertype= '1'
    open subdocid_cursor 
    fetch next from subdocid_cursor into @docid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1
        if @countrec = 0  insert into @temptablevalue values(@docid_1, 1)
        fetch next from subdocid_cursor into @docid_1
    end
    close subdocid_cursor deallocate subdocid_cursor
         


    /* 由文档的共享获得的权利 , 将共享分成两个部分, 角色共享一个部分.其它一个部分,否则查询太慢*/
    declare sharedocid_cursor cursor for
    select distinct docid , sharelevel from DocShare  where  (foralluser=1 and seclevel<= @seclevel_1 )  or ( userid= @resourceid_1 ) or (departmentid= @departmentid_1 and seclevel<= @seclevel_1 )
    open sharedocid_cursor 
    fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalue values(@docid_1, @sharelevel_1)
        end
        else if @sharelevel_1 = 2  
        begin
            update @temptablevalue set sharelevel = 2 where docid=@docid_1 /* 共享是可以编辑, 则都修改原有记录    */   
        end
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    end 
    close sharedocid_cursor deallocate sharedocid_cursor

    declare sharedocid_cursor cursor for
    select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.docid and t3.resourceid= @resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= @seclevel_1 and ( (t2.rolelevel=0  and t1.docdepartmentid= @departmentid_1 ) or (t2.rolelevel=1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= @subcompanyid_1 ) or (t3.rolelevel=2) )
    open sharedocid_cursor 
    fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalue values(@docid_1, @sharelevel_1)
        end
        else if @sharelevel_1 = 2  
        begin
            update @temptablevalue set sharelevel = 2 where docid=@docid_1 /* 共享是可以编辑, 则都修改原有记录    */   
        end
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    end 
    close sharedocid_cursor deallocate sharedocid_cursor



    /* 将临时表中的数据写入共享表 */
    declare alldocid_cursor cursor for
    select * from @temptablevalue
    open alldocid_cursor 
    fetch next from alldocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into docsharedetail values(@docid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from alldocid_cursor into @docid_1 , @sharelevel_1
    end
    close alldocid_cursor deallocate alldocid_cursor


    /* ------- CRM  部分 ------- */


    /* 删除原有的该人的所有客户共享信息 */
	delete from CrmShareDetail where userid = @resourceid_1 and usertype = 1

    /* 定义临时表变量 */
    Declare @temptablevaluecrm  table(crmid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluecrm 中 */
    /*  自己是 manager 的客户 2 */
    declare crmid_cursor cursor for
    select id from CRM_CustomerInfo where manager = @resourceid_1 
    open crmid_cursor 
    fetch next from crmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluecrm values(@crmid_1, 2)
        fetch next from crmid_cursor into @crmid_1
    end
    close crmid_cursor deallocate crmid_cursor


    /* 自己下级的客户 3 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcrmid_cursor cursor for
    select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcrmid_cursor 
    fetch next from subcrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 3)
        fetch next from subcrmid_cursor into @crmid_1
    end
    close subcrmid_cursor deallocate subcrmid_cursor
 
    /* 作为crm管理员能看到的客户 */
    declare rolecrmid_cursor cursor for
   select distinct t1.id from CRM_CustomerInfo  t1, hrmrolemembers  t2  where t2.roleid=8 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open rolecrmid_cursor 
    fetch next from rolecrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 4)
        fetch next from rolecrmid_cursor into @crmid_1
    end
    close rolecrmid_cursor deallocate rolecrmid_cursor	 


    /* 由客户的共享获得的权利 1 2 */
    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor



    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department=@departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor


    /* 将临时表中的数据写入共享表 */
    declare allcrmid_cursor cursor for
    select * from @temptablevaluecrm
    open allcrmid_cursor 
    fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(@crmid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    end
    close allcrmid_cursor deallocate allcrmid_cursor



    /* ------- PROJ 部分 ------- */

    /* 定义临时表变量 */
    Declare @temptablevaluePrj  table(prjid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluePrj 中 */
    /*  自己的项目2 */
    declare prjid_cursor cursor for
    select id from Prj_ProjectInfo where manager = @resourceid_1 
    open prjid_cursor 
    fetch next from prjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluePrj values(@prjid_1, 2)
        fetch next from prjid_cursor into @prjid_1
    end
    close prjid_cursor deallocate prjid_cursor


    /* 自己下级的项目3 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subprjid_cursor cursor for
    select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subprjid_cursor 
    fetch next from subprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1
        if @countrec = 0  insert into @temptablevaluePrj values(@prjid_1, 3)
        fetch next from subprjid_cursor into @prjid_1
    end
    close subprjid_cursor deallocate subprjid_cursor
 
    /* 作为项目管理员能看到的项目4 */
    declare roleprjid_cursor cursor for
   select distinct t1.id from Prj_ProjectInfo  t1, hrmrolemembers  t2  where t2.roleid=9 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open roleprjid_cursor 
    fetch next from roleprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1
        if @countrec = 0  insert into @temptablevaluePrj values(@prjid_1, 4)
        fetch next from roleprjid_cursor into @prjid_1
    end
    close roleprjid_cursor deallocate roleprjid_cursor	 


    /* 由项目的共享获得的权利 1 2 */
    declare shareprjid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open shareprjid_cursor 
    fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, @sharelevel_1)
        end
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    end 
    close shareprjid_cursor deallocate shareprjid_cursor


    declare shareprjid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and  t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department=@departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open shareprjid_cursor 
    fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, @sharelevel_1)
        end
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    end 
    close shareprjid_cursor deallocate shareprjid_cursor



    /* 项目成员5 (内部用户) */
	declare @members_1 varchar(200)
	set @members_1 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 
    declare inuserprjid_cursor cursor for
    SELECT  id FROM Prj_ProjectInfo   WHERE  (','+members+','  LIKE  @members_1)  and isblock='1' 
    open inuserprjid_cursor 
    fetch next from inuserprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, 5)
        end
        fetch next from inuserprjid_cursor into @prjid_1
    end 
    close inuserprjid_cursor deallocate inuserprjid_cursor


    /* 删除原有的与该人员相关的所有项目权 */
    delete from PrjShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allprjid_cursor cursor for
    select * from @temptablevaluePrj
    open allprjid_cursor 
    fetch next from allprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(@prjid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allprjid_cursor into @prjid_1 , @sharelevel_1
    end
    close allprjid_cursor deallocate allprjid_cursor


    /* ------- CPT 部分 ------- */

    /* 定义临时表变量 */
    Declare @temptablevalueCpt  table(cptid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevalueCpt 中 */
    /*  自己的资产2 */
    declare cptid_cursor cursor for
    select id from CptCapital where resourceid = @resourceid_1 
    open cptid_cursor 
    fetch next from cptid_cursor into @cptid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevalueCpt values(@cptid_1, 2)
        fetch next from cptid_cursor into @cptid_1
    end
    close cptid_cursor deallocate cptid_cursor


    /* 自己下级的资产1 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcptid_cursor cursor for
    select id from CptCapital where ( resourceid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcptid_cursor 
    fetch next from subcptid_cursor into @cptid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1
        if @countrec = 0  insert into @temptablevalueCpt values(@cptid_1, 1)
        fetch next from subcptid_cursor into @cptid_1
    end
    close subcptid_cursor deallocate subcptid_cursor
 
   
    /* 由资产的共享获得的权利 1 2 */
    declare sharecptid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecptid_cursor 
    fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalueCpt values(@cptid_1, @sharelevel_1)
        end
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    end 
    close sharecptid_cursor deallocate sharecptid_cursor


    declare sharecptid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= @resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= @seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= @departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= @subcompanyid_1 ) or (t3.rolelevel=2) )
    open sharecptid_cursor 
    fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalueCpt values(@cptid_1, @sharelevel_1)
        end       
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    end 
    close sharecptid_cursor deallocate sharecptid_cursor
    


    /* 删除原有的与该人员相关的所有资产权 */
    delete from CptShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allcptid_cursor cursor for
    select * from @temptablevalueCpt
    open allcptid_cursor 
    fetch next from allcptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(@cptid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allcptid_cursor into @cptid_1 , @sharelevel_1
    end
    close allcptid_cursor deallocate allcptid_cursor



end        /* 结束修改了部门和安全级别的情况 */
            

       
/* 对于修改了经理字段,新的所有上级增加对该下级的文档共享,共享级别为可读 */
if ( @countdelete > 0 and @managerstr_1 <> @oldmanagerstr_1 )  /* 新建人力资源时候对经理字段的改变不考虑 */
begin
    if ( @managerstr_1 is not null and len(@managerstr_1) > 1 )  /* 有上级经理 */
    begin

        set @managerstr_1 = ',' + @managerstr_1

	/* ------- DOC 部分 ------- */
        declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, DocDetail t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and ( t2.doccreaterid = @resourceid_1 or t2.ownerid = @resourceid_1 ) and t2.usertype= '1' ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @docid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(docid) from docsharedetail where docid = @docid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into docsharedetail values(@docid_1,@supresourceid_1,1,1)
            end
            fetch next from supuserid_cursor into @supresourceid_1, @docid_1
        end
        close supuserid_cursor deallocate supuserid_cursor
	
	/* ------- CRM 部分 ------- */
        declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, CRM_CustomerInfo t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and  t2.manager = @resourceid_1  ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @crmid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(@crmid_1,@supresourceid_1,1,3)
            end
            fetch next from supuserid_cursor into @supresourceid_1, @crmid_1
        end
        close supuserid_cursor deallocate supuserid_cursor


	/* ------- PROJ 部分 ------- */
	declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, Prj_ProjectInfo t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and  t2.manager = @resourceid_1  ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @prjid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(@prjid_1,@supresourceid_1,1,3)
            end
            fetch next from supuserid_cursor into @supresourceid_1, @prjid_1
        end
        close supuserid_cursor deallocate supuserid_cursor


	/* ------- CPT 部分 ------- */
	declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, CptCapital t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and  t2.resourceid = @resourceid_1  ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @cptid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(@cptid_1,@supresourceid_1,1,1)
            end
            fetch next from supuserid_cursor into @supresourceid_1, @cptid_1
        end
        close supuserid_cursor deallocate supuserid_cursor


    end             /* 有上级经理判定结束 */
end   /* 修改经理的判定结束 */

go

/* 修改hrmrolemembers的trigger 对于角色表的更新 */
ALTER TRIGGER Tri_Update_HrmRoleMembersShare ON HrmRoleMembers WITH ENCRYPTION
FOR INSERT, UPDATE, DELETE
AS
Declare @roleid_1 int,
        @resourceid_1 int,
        @oldrolelevel_1 char(1),
        @oldroleid_1 int,
        @oldresourceid_1 int,
        @rolelevel_1 char(1),
        @docid_1	 int,
	    @crmid_1	 int,
	    @prjid_1	 int,
	    @cptid_1	 int,
        @sharelevel_1  int,
        @departmentid_1 int,
	    @subcompanyid_1 int,
        @seclevel_1	 int,
        @countrec      int,
        @countdelete   int,
        @countinsert   int
        
/* 某一个人加入一个角色或者在角色中的级别升高进行处理,这两种情况都是增加了共享的范围,不需要删除
原有共享信息,只需要判定增加的部分, 对于在角色中级别的降低或者删除某一个成员,只能删除全部共享细节,从作人力资源一个
人的部门或者安全级别改变的操作 */

select @countdelete = count(*) from deleted
select @countinsert = count(*) from inserted

select @oldrolelevel_1 = rolelevel, @oldroleid_1 = roleid, @oldresourceid_1 = resourceid from deleted

if @countinsert > 0 
    select @roleid_1 = roleid , @resourceid_1 = resourceid, @rolelevel_1 = rolelevel from inserted
else 
    select @roleid_1 = roleid , @resourceid_1 = resourceid, @rolelevel_1 = rolelevel from deleted

/* 如果有删除原有数据，则将许可表中的权限许可数减一 */
if (@countdelete > 0) begin
    select @seclevel_1 = seclevel from hrmresource where id = @oldresourceid_1
    if @seclevel_1 is not null begin
        execute Doc_DirAcl_DUserP_RoleChange @oldresourceid_1, @oldroleid_1, @oldrolelevel_1, @seclevel_1
    end
end
/* 如果有增加新数据，则将许可表中的权限许可数加一 */
if (@countinsert > 0) begin
    select @seclevel_1 = seclevel from hrmresource where id = @resourceid_1
    if @seclevel_1 is not null begin
        execute Doc_DirAcl_GUserP_RoleChange @resourceid_1, @roleid_1, @rolelevel_1, @seclevel_1
    end
end

if ( @countinsert >0 and ( @countdelete = 0 or @rolelevel_1  > @oldrolelevel_1 ) )     
begin
    select @departmentid_1 = departmentid , @subcompanyid_1 = subcompanyid1 , @seclevel_1 = seclevel 
    from hrmresource where id = @resourceid_1 
    if @departmentid_1 is null   set @departmentid_1 = 0
    if @subcompanyid_1 is null   set @subcompanyid_1 = 0

    if @rolelevel_1 = '2'       /* 新的角色级别为总部级 */
    begin 

	/* ------- DOC 部分 ------- */

        declare sharedocid_cursor cursor for
        select distinct docid , sharelevel from DocShare where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open sharedocid_cursor 
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(docid) from docsharedetail where docid = @docid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into docsharedetail values(@docid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update docsharedetail set sharelevel = 2 where docid=@docid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        end 
        close sharedocid_cursor deallocate sharedocid_cursor

	/* ------- CRM 部分 ------- */

	declare sharecrmid_cursor cursor for
        select distinct relateditemid , sharelevel from CRM_ShareInfo where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open sharecrmid_cursor 
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CrmShareDetail values(@crmid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CrmShareDetail set sharelevel = 2 where crmid=@crmid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        end 
        close sharecrmid_cursor deallocate sharecrmid_cursor


	/* ------- PROJ 部分 ------- */

	declare shareprjid_cursor cursor for
        select distinct relateditemid , sharelevel from Prj_ShareInfo where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open shareprjid_cursor 
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into PrjShareDetail values(@prjid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update PrjShareDetail set sharelevel = 2 where prjid=@prjid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor


	/* ------- CPT 部分 ------- */

	declare sharecptid_cursor cursor for
        select distinct relateditemid , sharelevel from CptCapitalShareInfo where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open sharecptid_cursor 
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CptShareDetail values(@cptid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CptShareDetail set sharelevel = 2 where cptid=@cptid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor


    end
    else if @rolelevel_1 = '1'          /* 新的角色级别为分部级 */
    begin

	/* ------- DOC 部分 ------- */
        declare sharedocid_cursor cursor for
        select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2 , hrmdepartment  t4 where t1.id=t2.docid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= @subcompanyid_1
        open sharedocid_cursor 
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(docid) from docsharedetail where docid = @docid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into docsharedetail values(@docid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update docsharedetail set sharelevel = 2 where docid=@docid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        end 
        close sharedocid_cursor deallocate sharedocid_cursor


	/* ------- CRM 部分 ------- */
       declare sharecrmid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department = t4.id and t4.subcompanyid1= @subcompanyid_1
        open sharecrmid_cursor 
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CrmShareDetail values(@crmid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CrmShareDetail set sharelevel = 2 where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        end 
        close sharecrmid_cursor deallocate sharecrmid_cursor

	/* ------- PRJ 部分 ------- */

	declare shareprjid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department=t4.id and t4.subcompanyid1= @subcompanyid_1
        open shareprjid_cursor 
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into PrjShareDetail values(@prjid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update PrjShareDetail set sharelevel = 2 where prjid=@prjid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor

	/* ------- CPT 部分 ------- */

	declare sharecptid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.departmentid=t4.id and t4.subcompanyid1= @subcompanyid_1
        open sharecptid_cursor 
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CptShareDetail values(@cptid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CptShareDetail set sharelevel = 2 where cptid=@cptid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor


    end
    else if @rolelevel_1 = '0'          /* 为新建时候设定级别为部门级 */
    begin

        /* ------- DOC 部分 ------- */

	declare sharedocid_cursor cursor for
        select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2 where t1.id=t2.docid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.docdepartmentid= @departmentid_1
        open sharedocid_cursor 
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(docid) from docsharedetail where docid = @docid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into docsharedetail values(@docid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update docsharedetail set sharelevel = 2 where docid=@docid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        end 
        close sharedocid_cursor deallocate sharedocid_cursor
	
	/* ------- CRM 部分 ------- */

	declare sharecrmid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department = @departmentid_1
        open sharecrmid_cursor 
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CrmShareDetail values(@crmid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CrmShareDetail set sharelevel = 2 where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        end 
        close sharecrmid_cursor deallocate sharecrmid_cursor

	/* ------- PRJ 部分 ------- */

	declare shareprjid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department= @departmentid_1
        open shareprjid_cursor 
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into PrjShareDetail values(@prjid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update PrjShareDetail set sharelevel = 2 where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor

	/* ------- CPT 部分 ------- */

	declare sharecptid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.departmentid= @departmentid_1
        open sharecptid_cursor 
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CptShareDetail values(@cptid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CptShareDetail set sharelevel = 2 where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor

    end
end
else if ( @countdelete > 0 and ( @countinsert = 0 or @rolelevel_1  < @oldrolelevel_1 ) ) /* 当为删除或者级别降低 */
begin
    select @departmentid_1 = departmentid , @subcompanyid_1 = subcompanyid1 , @seclevel_1 = seclevel 
    from hrmresource where id = @resourceid_1 
    if @departmentid_1 is null   set @departmentid_1 = 0
    if @subcompanyid_1 is null   set @subcompanyid_1 = 0
	
    /* 删除原有的该人的所有文档共享信息 */
	delete from DocShareDetail where userid = @resourceid_1 and usertype = 1

    /* 定义临时表变量 */
    Declare @temptablevalue  table(docid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevalue 中 */
    /*  自己创建的或者是 owner 的文章可以编辑 */
    declare docid_cursor cursor for
    select distinct id from DocDetail where ( doccreaterid = @resourceid_1 or ownerid = @resourceid_1 ) and usertype= '1'
    open docid_cursor 
    fetch next from docid_cursor into @docid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevalue values(@docid_1, 2)
        fetch next from docid_cursor into @docid_1
    end
    close docid_cursor deallocate docid_cursor


    /* 自己下级的文档 */
    /* 查找下级 */
    declare @managerstr_11 varchar(200) 
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subdocid_cursor cursor for
    select distinct id from DocDetail where ( doccreaterid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) or ownerid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) ) and usertype= '1'
    open subdocid_cursor 
    fetch next from subdocid_cursor into @docid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1
        if @countrec = 0  insert into @temptablevalue values(@docid_1, 1)
        fetch next from subdocid_cursor into @docid_1
    end
    close subdocid_cursor deallocate subdocid_cursor
         


    /* 由文档的共享获得的权利 , 将共享分成两个部分, 角色共享一个部分.其它一个部分,否则查询太慢*/
    declare sharedocid_cursor cursor for
    select distinct docid , sharelevel from DocShare  where  (foralluser=1 and seclevel<= @seclevel_1 )  or ( userid= @resourceid_1 ) or (departmentid= @departmentid_1 and seclevel<= @seclevel_1 )
    open sharedocid_cursor 
    fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalue values(@docid_1, @sharelevel_1)
        end
        else if @sharelevel_1 = 2  
        begin
            update @temptablevalue set sharelevel = 2 where docid=@docid_1 /* 共享是可以编辑, 则都修改原有记录    */   
        end
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    end 
    close sharedocid_cursor deallocate sharedocid_cursor

    declare sharedocid_cursor cursor for
    select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2,  HrmRoleMembers  t3 , hrmdepartment t4 where t1.id=t2.docid and t3.resourceid= @resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= @seclevel_1 and ( (t2.rolelevel=0  and t1.docdepartmentid= @departmentid_1 ) or (t2.rolelevel=1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= @subcompanyid_1 ) or (t3.rolelevel=2) )
    open sharedocid_cursor 
    fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalue values(@docid_1, @sharelevel_1)
        end
        else if @sharelevel_1 = 2  
        begin
            update @temptablevalue set sharelevel = 2 where docid=@docid_1 /* 共享是可以编辑, 则都修改原有记录    */   
        end
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    end 
    close sharedocid_cursor deallocate sharedocid_cursor

    /* 将临时表中的数据写入共享表 */
    declare alldocid_cursor cursor for
    select * from @temptablevalue
    open alldocid_cursor 
    fetch next from alldocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into docsharedetail values(@docid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from alldocid_cursor into @docid_1 , @sharelevel_1
    end
    close alldocid_cursor deallocate alldocid_cursor

    /* ------- CRM  部分 ------- */


    /* 删除原有的该人的所有客户共享信息 */
	delete from CrmShareDetail where userid = @resourceid_1 and usertype = 1

    /* 定义临时表变量 */
    Declare @temptablevaluecrm  table(crmid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluecrm 中 */
    /*  自己是 manager 的客户 2 */
    declare crmid_cursor cursor for
    select id from CRM_CustomerInfo where manager = @resourceid_1 
    open crmid_cursor 
    fetch next from crmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluecrm values(@crmid_1, 2)
        fetch next from crmid_cursor into @crmid_1
    end
    close crmid_cursor deallocate crmid_cursor


    /* 自己下级的客户 3 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcrmid_cursor cursor for
    select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcrmid_cursor 
    fetch next from subcrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 3)
        fetch next from subcrmid_cursor into @crmid_1
    end
    close subcrmid_cursor deallocate subcrmid_cursor
 
    /* 作为crm管理员能看到的客户 */
    declare rolecrmid_cursor cursor for
   select distinct t1.id from CRM_CustomerInfo  t1, hrmrolemembers  t2  where t2.roleid=8 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open rolecrmid_cursor 
    fetch next from rolecrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 4)
        fetch next from rolecrmid_cursor into @crmid_1
    end
    close rolecrmid_cursor deallocate rolecrmid_cursor	 


    /* 由客户的共享获得的权利 1 2 */
    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid = @departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor



    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department = @departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor


    /* 将临时表中的数据写入共享表 */
    declare allcrmid_cursor cursor for
    select * from @temptablevaluecrm
    open allcrmid_cursor 
    fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(@crmid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    end
    close allcrmid_cursor deallocate allcrmid_cursor



    /* ------- PROJ 部分 ------- */

    /* 定义临时表变量 */
    Declare @temptablevaluePrj  table(prjid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluePrj 中 */
    /*  自己的项目2 */
    declare prjid_cursor cursor for
    select id from Prj_ProjectInfo where manager = @resourceid_1 
    open prjid_cursor 
    fetch next from prjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluePrj values(@prjid_1, 2)
        fetch next from prjid_cursor into @prjid_1
    end
    close prjid_cursor deallocate prjid_cursor


    /* 自己下级的项目3 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subprjid_cursor cursor for
    select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subprjid_cursor 
    fetch next from subprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1
        if @countrec = 0  insert into @temptablevaluePrj values(@prjid_1, 3)
        fetch next from subprjid_cursor into @prjid_1
    end
    close subprjid_cursor deallocate subprjid_cursor
 
    /* 作为项目管理员能看到的项目4 */
    declare roleprjid_cursor cursor for
   select distinct t1.id from Prj_ProjectInfo  t1, hrmrolemembers  t2  where t2.roleid=9 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open roleprjid_cursor 
    fetch next from roleprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1
        if @countrec = 0  insert into @temptablevaluePrj values(@prjid_1, 4)
        fetch next from roleprjid_cursor into @prjid_1
    end
    close roleprjid_cursor deallocate roleprjid_cursor	 


    /* 由项目的共享获得的权利 1 2 */
    declare shareprjid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open shareprjid_cursor 
    fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, @sharelevel_1)
        end
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    end 
    close shareprjid_cursor deallocate shareprjid_cursor


    declare shareprjid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and  t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department=@departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open shareprjid_cursor 
    fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, @sharelevel_1)
        end
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    end 
    close shareprjid_cursor deallocate shareprjid_cursor



    /* 项目成员5 (内部用户) */
    declare inuserprjid_cursor cursor for
    SELECT distinct t2.id FROM Prj_TaskProcess  t1,Prj_ProjectInfo  t2 WHERE  t1.hrmid =@resourceid_1 and t2.id=t1.prjid and t1.isdelete<>'1' and t2.isblock='1' 

    
    open inuserprjid_cursor 
    fetch next from inuserprjid_cursor into @prjid_1 
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, 5)
        end
        fetch next from inuserprjid_cursor into @prjid_1
    end 
    close inuserprjid_cursor deallocate inuserprjid_cursor


    /* 删除原有的与该人员相关的所有项目权 */
    delete from PrjShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allprjid_cursor cursor for
    select * from @temptablevaluePrj
    open allprjid_cursor 
    fetch next from allprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(@prjid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allprjid_cursor into @prjid_1 , @sharelevel_1
    end
    close allprjid_cursor deallocate allprjid_cursor


    /* ------- CPT 部分 ------- */

    /* 定义临时表变量 */
    Declare @temptablevalueCpt  table(cptid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevalueCpt 中 */
    /*  自己的资产2 */
    declare cptid_cursor cursor for
    select id from CptCapital where resourceid = @resourceid_1 
    open cptid_cursor 
    fetch next from cptid_cursor into @cptid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevalueCpt values(@cptid_1, 2)
        fetch next from cptid_cursor into @cptid_1
    end
    close cptid_cursor deallocate cptid_cursor


    /* 自己下级的资产1 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcptid_cursor cursor for
    select id from CptCapital where ( resourceid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcptid_cursor 
    fetch next from subcptid_cursor into @cptid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1
        if @countrec = 0  insert into @temptablevalueCpt values(@cptid_1, 1)
        fetch next from subcptid_cursor into @cptid_1
    end
    close subcptid_cursor deallocate subcptid_cursor
 
   
    /* 由资产的共享获得的权利 1 2 */
    declare sharecptid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecptid_cursor 
    fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@cptid_1, @sharelevel_1)
        end
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    end 
    close sharecptid_cursor deallocate sharecptid_cursor


    declare sharecptid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= @resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= @seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= @departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= @subcompanyid_1 ) or (t3.rolelevel=2) )
    open sharecptid_cursor 
    fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalueCpt values(@cptid_1, @sharelevel_1)
        end       
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    end 
    close sharecptid_cursor deallocate sharecptid_cursor
    


    /* 删除原有的与该人员相关的所有资产权 */
    delete from CptShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allcptid_cursor cursor for
    select * from @temptablevalueCpt
    open allcptid_cursor 
    fetch next from allcptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(@cptid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allcptid_cursor into @cptid_1 , @sharelevel_1
    end
    close allcptid_cursor deallocate allcptid_cursor

end        /* 结束角色删除或者级别降低的处理 */
go

