alter PROCEDURE HrmRoles_deleteSingle @roleid int, @flag int output, @msg varchar(80) output as 
begin 
if exists(select id from hrmrolemembers where roleid=@roleid) begin 
	set @flag=11 
	select @flag 
	return 
end else begin 
	delete from hrmroles where id=@roleid 
	delete from SystemRightRoles where roleid=@roleid 
	delete from SysRoleSubcomRight where roleid=@roleid 
	set @flag=0 
	select @flag 
end 
end

GO

