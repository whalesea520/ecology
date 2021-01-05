create table SysRoleSubcomRight (
	id int identity (1, 1) not null ,
	roleid int not null,
	subcompanyid int not null,
	rightlevel int null	
)
go

alter table SystemSet add detachable int
go 

alter table hrmroles add type int
go
update hrmroles set type=0 
go
alter table hrmroles add subcompanyid int
go
update hrmroles set subcompanyid=0 
go

alter table HrmResourceManager add creator int
go
update HrmResourceManager set creator=1
go

update MainMenuInfo set linkAddress='/hrm/roles/HrmRoles_frm.jsp' where id=353
go

INSERT INTO HtmlLabelIndex values(17861,'能否分权') 
GO
INSERT INTO HtmlLabelInfo VALUES(17861,'能否分权',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17861,'could detach right',8) 
GO

INSERT INTO HtmlLabelIndex values(17863,'是否分权') 
GO
INSERT INTO HtmlLabelIndex values(17862,'权限系统设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(17862,'权限系统设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17862,'right config',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17863,'是否分权',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17863,'is detach right',8) 
GO

INSERT INTO HtmlLabelIndex values(17864,'功能权限') 
GO
INSERT INTO HtmlLabelIndex values(17865,'机构权限') 
GO
INSERT INTO HtmlLabelInfo VALUES(17864,'功能权限',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17864,'function right',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17865,'机构权限',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17865,'structure right',8) 
GO

INSERT INTO HtmlLabelIndex values(17866,'赋权角色') 
GO
INSERT INTO HtmlLabelIndex values(17867,'分权角色') 
GO
INSERT INTO HtmlLabelInfo VALUES(17866,'赋权角色',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17866,'config right role',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17867,'分权角色',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17867,'detach right role',8) 
GO

INSERT INTO HtmlLabelIndex values(17868,'所属机构') 
GO
INSERT INTO HtmlLabelInfo VALUES(17868,'所属机构',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17868,'belong structure',8) 
GO

INSERT INTO HtmlLabelIndex values(17871,'机构树') 
GO
INSERT INTO HtmlLabelIndex values(17872,'操作级别') 
GO
INSERT INTO HtmlLabelInfo VALUES(17871,'机构树',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17871,'structure tree',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17872,'操作级别',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17872,'operate level',8) 
GO

INSERT INTO HtmlLabelIndex values(17873,'只读') 
GO
INSERT INTO HtmlLabelIndex values(17875,'禁止') 
GO
INSERT INTO HtmlLabelIndex values(17874,'完全控制') 
GO
INSERT INTO HtmlLabelInfo VALUES(17873,'只读',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17873,'read only',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17874,'完全控制',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17874,'control all',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17875,'禁止',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17875,'forbid',8) 
GO

INSERT INTO HtmlLabelIndex values(17876,'下级联动') 
GO
INSERT INTO HtmlLabelInfo VALUES(17876,'下级联动',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17876,'child synchronization',8) 
GO

INSERT INTO HtmlLabelIndex values(17888,'管理员名称') 
GO
INSERT INTO HtmlLabelInfo VALUES(17888,'管理员名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17888,'admin name',8) 
GO

create FUNCTION getSubComParentTree (@subcom_id int)  
RETURNS @tree Table (id int,supsubcomid int) AS  
BEGIN 
	declare @temptree Table (num int IDENTITY(1,1),id int,supsubcomid int)
	declare @parent_id int
	
	select @parent_id=supsubcomid from hrmsubcompany where id=@subcom_id
	
	while(@parent_id<>0)
	begin
		insert @temptree
		select id,supsubcomid from hrmsubcompany where id =@parent_id
		select top 1 @parent_id=supsubcomid from @temptree order by num desc
	end

	insert @tree select id,supsubcomid from @temptree order by num desc

	RETURN
END
GO

create procedure HrmRoleSR_SByURCId @userid int,@rightstr varchar(100), @subcompanyid int, @flag integer output , @msg varchar(80) output AS

	select min(rightlevel) as rightlevel
	from SysRoleSubcomRight 
	where roleid in(select a.roleid 
			from HrmRoleMembers a,SystemRightRoles b
			where a.roleid=b.roleid and a.resourceid=@userid 
			and b.rightid =(select rightid from SystemRightDetail where rightdetail=@rightstr)
			)
	and subcompanyid=@subcompanyid
	group by subcompanyid
GO

create procedure HrmRoleSR_SeByURId @userid int,@rightstr varchar(100), @flag integer output , @msg varchar(80) output AS

	select subcompanyid,min(rightlevel) as rightlevel
	from SysRoleSubcomRight 
	where roleid in(select a.roleid 
			from HrmRoleMembers a,SystemRightRoles b
			where a.roleid=b.roleid and a.resourceid=@userid 
			and b.rightid =(select rightid from SystemRightDetail where rightdetail=@rightstr)
			)
	group by subcompanyid
GO

create PROCEDURE hrmroles_selBynameSubcom (@rolesnameq varchar(200),@subcomid int,@flag integer output, @msg varchar(30) output) as 
begin 
set nocount on create table #temp( id int, rolesmark varchar(60), rolesname varchar(200),type int, subcomid int, cnt int null ) 
insert into #temp(id,rolesmark,rolesname,type,subcomid) select id,rolesmark,rolesname,type,subcompanyid from hrmroles  

declare roles_cursor cursor for select id from hrmroles 
open roles_cursor 

declare  @id int,@cnt int fetch next from roles_cursor into @id 
while @@fetch_status=0 begin 
	select @cnt=count(id) from HrmRoleMembers where roleid=@id 
	update  #temp set cnt=@cnt where id=@id 
	fetch next from roles_cursor into @id 
end 
if @rolesnameq<>'!@#$' 

select id,rolesmark,rolesname,type,subcomid,cnt from #temp where rolesname like '%'+@rolesnameq+'%' and subcomid=@subcomid order by rolesname 
else
select id,rolesmark,rolesname,type,subcomid,cnt from #temp where subcomid=@subcomid order by rolesname 
close roles_cursor deallocate roles_cursor end

GO

CREATE PROCEDURE HrmRoleStrRight_Sel @roleid int, @flag int output, @msg varchar(80) output as 

select * from SysRoleSubcomRight where roleid=@roleid

GO

create procedure RoleStrTree_SByURId @userid int,@roleid int, @flag integer output , @msg varchar(80) output AS

declare @temptree1 Table (id int,operateType_Range int)
declare @temptree2 Table (id int,parent_id int,operateType_Range int)
declare @temptree3 Table (id int,parent_id int,nodetype int,operateType_Range int)
declare @rowcount int
declare @c1 cursor
declare @id int

select @rowcount=count(*) from SystemRightRoles where roleid=@roleid

if @rowcount>0
begin
	insert @temptree1
	select subcompanyid,min(rightlevel)
	from SysRoleSubcomRight 
	where roleid in(select a.roleid 
			from HrmRoleMembers a,SystemRightRoles b
			where a.roleid=b.roleid and a.resourceid=@userid 
			and b.rightid in(select rightid from SystemRightRoles where roleid=@roleid)
			)
	group by subcompanyid
	having count(subcompanyid)=(select count(a.roleid)
			from HrmRoleMembers a,SystemRightRoles b
			where a.roleid=b.roleid and a.resourceid=@userid 
			and b.rightid in(select rightid from SystemRightRoles where roleid=@roleid)
			)
end else begin
	insert @temptree1
	select subcompanyid,min(rightlevel)
	from SysRoleSubcomRight 
	where roleid in(select roleid from HrmRoleMembers where resourceid=@userid)
	group by subcompanyid
	having count(subcompanyid)=(select count(roleid) from HrmRoleMembers where resourceid=@userid)
end

insert @temptree2 select a.id,b.supsubcomid,a.operateType_Range from @temptree1 a,hrmsubcompany b where a.id=b.id 

SET @c1 = CURSOR FORWARD_ONLY STATIC FOR
select id from @temptree2 where parent_id<>0 and parent_id not in(select id from @temptree2)
OPEN @c1
FETCH NEXT FROM @c1 INTO @id	
WHILE @@FETCH_STATUS = 0 
begin 
	insert into @temptree3 select id,supsubcomid,0,0 from getSubComParentTree(@id)
end 

insert into @temptree3 select id ,parent_id ,1,operateType_Range from @temptree2

select * from @temptree3

GO

CREATE PROCEDURE HrmRoleStrRight_Del @roleid int, @flag int output, @msg varchar(80) output as begin 
	delete SysRoleSubcomRight where roleid=@roleid 
end 

GO

CREATE PROCEDURE HrmRoleStrRight_Ins 
@roleid int, @subcompanyid int,@rightlevel int, @flag int output, @msg varchar(80) output as 

insert into SysRoleSubcomRight(roleid,subcompanyid,rightlevel) values(@roleid,@subcompanyid,@rightlevel) 

GO

create PROCEDURE hrmroles_selectallbyname (@rolesnameq varchar(200),@flag integer output, @msg varchar(30) output) as 
begin 
set nocount on create table #temp( id int, rolesmark varchar(60), rolesname varchar(200),type int, cnt int null ) 
insert into #temp(id,rolesmark,rolesname,type) select id,rolesmark,rolesname,type from hrmroles  

declare roles_cursor cursor for select id from hrmroles 
open roles_cursor 

declare  @id int,@cnt int fetch next from roles_cursor into @id 
while @@fetch_status=0 begin 
	select @cnt=count(id) from HrmRoleMembers where roleid=@id 
	update  #temp set cnt=@cnt where id=@id 
	fetch next from roles_cursor into @id 
end 
if @rolesnameq<>'!@#$' 

select id,rolesmark,rolesname,type,cnt from #temp where rolesname like '%'+@rolesnameq+'%' order by rolesname 
else
select id,rolesmark,rolesname,type,cnt from #temp order by rolesname 
close roles_cursor deallocate roles_cursor end

GO

alter PROCEDURE HrmRoles_insert 
@rolesmark varchar(60), @rolesname varchar(200), @docid int, @type int, @subcompanyid int, @flag int output, @msg varchar(80) output 
as  
if @docid = 0 
	set @docid = null  
begin insert into HrmRoles(rolesmark,rolesname,docid,type,subcompanyid) values(@rolesmark,@rolesname,@docid,@type,@subcompanyid) 

if @@error<>0 
	begin set @flag=1 set @msg='插入失败' 
end else 
	begin set @flag=0 set @msg='操作成功' 
end 

select id from hrmroles where rolesmark=@rolesmark and rolesname=@rolesname and docid=@docid and type=@type and subcompanyid=@subcompanyid end

GO

alter PROCEDURE hrmroles_update 
@id int, @rolesmark varchar(60), @rolesname varchar(200), @docid int, @type int, @subcompanyid int, @flag int output, @msg varchar(80) output 
as 
if @docid = 0 set @docid = null 
begin update hrmroles set rolesmark=@rolesmark,rolesname=@rolesname,docid=@docid,type=@type, subcompanyid=@subcompanyid where id=@id 

if @@error<>0 
	begin set @flag=1 set @msg='更新失败' 
end else 
	begin set @flag=0 set @msg='更新成功' 
end 

end

GO

alter PROCEDURE hrmroles_selectSingle @id int, @flag int output, @msg varchar(80) output 
as begin 
select rolesmark,rolesname,docid,type,subcompanyid from hrmroles where id=@id 

if @@error<>0 begin set @flag=1 set @msg='操作失败' end else begin set @flag=0 set @msg='操作成功' end  end

GO

alter PROCEDURE hrmroles_selectall @flag integer output, @msg varchar(30) output as 
begin 
	set nocount on create table #temp( id int, rolesmark varchar(60), rolesname varchar(200), type int, cnt int null ) 
	insert into #temp(id,rolesmark,rolesname,type) select id,rolesmark,rolesname,type from hrmroles  
	
	declare roles_cursor cursor for select id from hrmroles 
	open roles_cursor 
	declare  @id int,@cnt int 
	fetch next from roles_cursor into @id 
	while @@fetch_status=0 
	begin 
		select @cnt=count(id) from HrmRoleMembers where roleid=@id 
		update  #temp set cnt=@cnt where id=@id 
		fetch next from roles_cursor into @id 
	end   
	
	select id,rolesmark,rolesname,type,cnt from #temp 
	
	close roles_cursor deallocate roles_cursor 
end

GO

