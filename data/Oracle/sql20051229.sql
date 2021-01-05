CREATE or replace PROCEDURE HrmRoles_deleteSingle
	(roleid_1 integer,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
as
	id_1 integer;
begin 
	select count(id) into id_1 from hrmrolemembers where roleid=roleid_1;
	if id_1<>0 then
		flag:=11;
		open thecursor for
		select flag from dual; 
		return;
	else 
		delete hrmroles where id=roleid_1;
		delete from SystemRightRoles where roleid=roleid_1;
		delete from SysRoleSubcomRight where roleid=roleid_1;
		flag:=0;
		open thecursor for
		select flag from dual; 
	end if;
end;
/