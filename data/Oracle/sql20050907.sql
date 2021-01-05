/*
  机构树处理存储过程
  输入：userid 当前用户、roleid 当前角色
  输出：当前角色设置机构权限时的机构范围
*/
create or replace  procedure RoleStrTree_SByURId (
	userid_1 integer,
	roleid_2 integer,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
AS
 rowcount integer;
 id_1 integer;

begin
/*查看当前角色是否已经设置功能权限*/
select count(roleid) into rowcount from SystemRightRoles where roleid=roleid_2;
if rowcount>0 then
	/*如果当前角色已经设置了功能权限，取获得这些功能权限对应的机构权限合集，再取这些机构权限合集之间的交集，不包括当前角色*/
	/*对同一功能权限,取机构权限的最大值*/
	insert into temptree4(rightid,subcomid,rightlevel)
	select b.rightid,c.subcompanyid,max(c.rightlevel)
	from HrmRoleMembers a,SystemRightRoles b,SysRoleSubcomRight c
	where a.roleid=b.roleid and a.roleid=c.roleid and a.resourceid=userid_1 
	and b.rightid in(select rightid from SystemRightRoles where roleid=roleid_2)
	and b.roleid<>roleid_2
	group by b.rightid,c.subcompanyid;
	/*对不同功能权限,取机构权限的最小值*/
	insert into temptree1(id,operateType_Range)
	select subcomid,min(rightlevel)
	from temptree4 
	group by subcomid
	having count(subcomid)=(select count(distinct(rightid)) from temptree4);
else
/*如果当前角色未设置功能权限，查找当前用户被分权、赋权的所有角色的机构权限交集，不包括当前角色*/
	/*（交集通过having count、min实现）:
		通过having count == 的对比，去除在有的角色中根本没有的机构
		通过min，取所有角色中都有的机构的最小权限
	*/
	insert into temptree1(id,operateType_Range)
	select subcompanyid,min(rightlevel)
	from SysRoleSubcomRight 
	where roleid in(select roleid from HrmRoleMembers where resourceid=userid_1)
	and roleid<>roleid_2
	group by subcompanyid
	having count(subcompanyid)=(select count(roleid) from HrmRoleMembers where resourceid=userid_1 and roleid<>roleid_2);
end if;

/*添加父id*/
insert into temptree2(id,parent_id,operateType_Range) select a.id,b.supsubcomid,a.operateType_Range from temptree1 a,hrmsubcompany b where a.id=b.id ;

/*根据机构列表中不在顶级的节点，依次添加上级树路径*/
FOR c1 in( 
select id from temptree2 where parent_id<>0 and parent_id not in(select id from temptree2))
loop 
    id_1 := c1.id;
	select count(id) into rowcount from temptree3 where id=(select id from table(cast(getSubComParentTree(id_1) as tab_tree)));
	if rowcount=0 then
	insert into temptree3(id,parent_id,nodetype,operateType_Range) select id,supsubcomid,0,0 from table(cast(getSubComParentTree(id_1) as tab_tree));
	end if;
end loop;

/*添加本级、下级节点*/
insert into temptree3(id,parent_id,nodetype,operateType_Range) select id ,parent_id ,1,operateType_Range from temptree2;
open thecursor for
select * from temptree3;
end;
/

