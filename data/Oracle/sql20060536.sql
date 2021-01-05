CREATE OR REPLACE PROCEDURE hrmroles_selBynameSubcom 
(rolesnameq_1 varchar2,
subcomid_2 integer,
flag out integer ,
msg out varchar2,
thecursor in out cursor_define.weavercursor)
as
 id_1 integer;
 rolesmark_1 varchar2(60);
 rolesname_1 varchar2(200);
 temptype_1 integer;
 subcomid_1 integer;
 id_2 integer; 
 cnt_2 integer;
CURSOR all_cursor is select id,rolesmark,rolesname,type,subcompanyid from hrmroles ;
CURSOR roles_cursor is select id from hrmroles ;
begin  
 open all_cursor;
  loop
  fetch all_cursor INTO id_1,rolesmark_1,rolesname_1,temptype_1,subcomid_1;
  exit when all_cursor%NOTFOUND; 
  insert into temp_table(id,rolesmark,rolesname,temptype,subcomid)
  values (id_1,rolesmark_1,rolesname_1,temptype_1,subcomid_1);
 end  loop;
 
 open roles_cursor;
  loop
   fetch roles_cursor into id_2;
   exit when roles_cursor%NOTFOUND;
   select count(id) into cnt_2 from HrmRoleMembers where roleid=id_2;
   update temp_table set cnt=cnt_2 where id=id_2;
  end loop;
  
  if rolesnameq_1<>'!@#$' then
  open thecursor for
  select id,rolesmark,rolesname,temptype as type,subcomid,cnt from temp_table where rolesname like concat(concat('%',rolesnameq_1),'%') and subcomid=subcomid_2 order by rolesname;
  else
  open thecursor for
  select id,rolesmark,rolesname,temptype as type,subcomid,cnt from temp_table where subcomid=subcomid_2 order by rolesname;
  end if;
 close roles_cursor;
 close all_cursor ;
end;
/
