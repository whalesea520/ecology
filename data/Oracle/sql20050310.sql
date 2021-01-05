 CREATE or REPLACE PROCEDURE hrmroles_selectall 
 (
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
 as 
 id_1 integer;
 rolesmark_1 varchar2(60);
 rolesname_1 varchar2(200);
 id_2 integer;
 cnt_2 integer;
CURSOR all_cursor is select id,rolesmark,rolesname from hrmroles ;
CURSOR roles_cursor is select id from hrmroles ;
 begin 
	open all_cursor;
		loop
		fetch all_cursor INTO id_1,rolesmark_1,rolesname_1; 
		exit when all_cursor%NOTFOUND;	
	 insert into temp_table_02 (id,rolesmark,rolesname)
	 values (id_1,rolesmark_1,rolesname_1) ;
	end  loop;

    
	open roles_cursor;
		loop
		fetch roles_cursor INTO id_2; 
		exit when roles_cursor%NOTFOUND;	

	  select count(id) INTO cnt_2 from HrmRoleMembers where roleid=id_2 ;
      update  temp_table_02 set cnt=cnt_2 where id=id_2 ;
	end  loop;
 open thecursor for
 select id,rolesmark,rolesname,cnt from temp_table_02 order by rolesmark; 
 close all_cursor ;
 close roles_cursor ;
end;
/



