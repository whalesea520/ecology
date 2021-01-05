

alter procedure RoleStrTree_SByURId @userid int,@roleid int, @flag integer output , @msg varchar(80) output AS


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
	having count(subcompanyid)=(select count(distinct(a.roleid))
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
	FETCH NEXT FROM @c1 INTO @id
end 


insert into @temptree3 select id ,parent_id ,1,operateType_Range from @temptree2

select * from @temptree3
GO

