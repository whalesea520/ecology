CREATE or replace procedure HrmRoleSR_SeByURId
	(userid integer,
	rightstr varchar2,
	flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS
begin
    open thecursor for
	select subcompanyid,max(rightlevel) as rightlevel
	from SysRoleSubcomRight 
	where roleid in(select a.roleid 
			from HrmRoleMembers a,SystemRightRoles b
			where a.roleid=b.roleid and a.resourceid=userid 
			and b.rightid =(select rightid from SystemRightDetail where rightdetail=rightstr)
			)group by subcompanyid;
end;
/