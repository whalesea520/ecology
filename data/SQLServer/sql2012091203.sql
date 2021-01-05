ALTER  PROCEDURE HrmRoleSR_SByURCId 
(
   @userid int,
   @rightstr varchar(100), 
   @subcompanyid int, 
   @flag integer output , 
   @msg varchar(80) output
) 
AS
	select max(rightlevel) as rightlevel
	from SysRoleSubcomRight 
	where roleid in(select a.roleid 
			from HrmRoleMembers a,SystemRightRoles b
			where a.roleid=b.roleid and a.resourceid=@userid 
			and b.rightid =(select rightid from SystemRightDetail where rightdetail=@rightstr)
			)
	and subcompanyid=@subcompanyid
	group by subcompanyid
GO