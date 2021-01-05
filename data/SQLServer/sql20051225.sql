/*
  机构树处理存储过程
  输入：userid 当前用户、roleid 当前角色
  输出：当前角色设置机构权限时的机构范围
*/
alter procedure RoleStrTree_SByURId @userid int,@roleid int, @flag integer output , @msg varchar(80) output AS

/*机构权限临时表,得出机构权限交集*/
declare @temptree1 Table (id int,operateType_Range int)
/*添加父id字段*/
declare @temptree2 Table (id int,parent_id int,operateType_Range int)
/*添加节点类型字段，nodetype=0：显示节点、nodetype=1：设置节点*/
declare @temptree3 Table (id int,parent_id int,nodetype int,operateType_Range int)
declare @rowcount int
declare @c1 cursor
declare @id int

/*查看当前角色是否已经设置功能权限*/
select @rowcount=count(*) from SystemRightRoles where roleid=@roleid

if @rowcount>0 begin
	/*如果当前角色已经设置了功能权限，取获得这些权限的角色的机构权限交集，不包括当前角色*/
	insert @temptree1
	select subcompanyid,min(rightlevel)
	from SysRoleSubcomRight 
	where roleid in(select a.roleid 
			from HrmRoleMembers a,SystemRightRoles b
			where a.roleid=b.roleid and a.resourceid=@userid 
			and b.rightid in(select rightid from SystemRightRoles where roleid=@roleid)
			and b.roleid<>@roleid
			)
	group by subcompanyid
	having count(subcompanyid)=(select count(distinct(a.roleid))
			from HrmRoleMembers a,SystemRightRoles b
			where a.roleid=b.roleid and a.resourceid=@userid 
			and b.rightid in(select rightid from SystemRightRoles where roleid=@roleid)
			and b.roleid<>@roleid
			)
end else begin
	/*如果当前角色未设置功能权限，查找当前用户被分权、赋权的所有角色的机构权限交集，不包括当前角色*/
	/*（交集通过having count、min实现）:
		通过having count == 的对比，去除在有的角色中根本没有的机构
		通过min，取所有角色中都有的机构的最小权限
	*/
	insert @temptree1
	select subcompanyid,min(rightlevel)
	from SysRoleSubcomRight 
	where roleid in(select roleid from HrmRoleMembers where resourceid=@userid)
	and roleid<>@roleid
	group by subcompanyid
	having count(subcompanyid)=(select count(roleid) from HrmRoleMembers where resourceid=@userid and roleid<>@roleid)
end

/*添加父id*/
insert @temptree2 select a.id,b.supsubcomid,a.operateType_Range from @temptree1 a,hrmsubcompany b where a.id=b.id 

/*根据机构列表中不在顶级的节点，依次添加上级树路径*/
SET @c1 = CURSOR FORWARD_ONLY STATIC FOR
select id from @temptree2 where parent_id<>0 and parent_id not in(select id from @temptree2)
OPEN @c1
FETCH NEXT FROM @c1 INTO @id	
WHILE @@FETCH_STATUS = 0 
begin 
	insert into @temptree3 select id,supsubcomid,0,0 from getSubComParentTree(@id)
	FETCH NEXT FROM @c1 INTO @id
end 

/*添加本级、下级节点*/
insert into @temptree3 select id ,parent_id ,1,operateType_Range from @temptree2

select * from @temptree3
GO
