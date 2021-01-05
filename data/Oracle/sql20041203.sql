 /*TD:1420,Oracle存在分给管理主目录权限,却无权创建子目录的问题.修改者:DP-董平*/
 
 CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermissionEx1 ( 
 dirid_1 integer,
 dirtype_1 integer,
 userid_1 integer, 
 usertype_1 integer, 
 seclevel_1 integer,
 operationcode_1 integer,
 haspermission_1 in out integer  
 
 )  AS  count_1 integer; result integer;  
 
 begin 
 result := 0;  
 
 if usertype_1 = 0 then 
	 if operationcode_1 = 0 then 
		for count_1_cursor IN (
			select createdoc  from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1)
		loop
			count_1 := count_1_cursor.createdoc;
		end loop;
	 
	 elsif operationcode_1 = 1 then 
	 
		for count_1_cursor IN (
			select createdir  from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1)
		loop
			count_1 := count_1_cursor.createdir;
		end loop;		
		
	 
	 elsif operationcode_1 = 2 then
	 
		for count_1_cursor IN (
			select movedoc  from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1)
		loop
			count_1 := count_1_cursor.movedoc;
		end loop;	
	 
	 elsif operationcode_1 = 3 then 

		for count_1_cursor IN (
			select copydoc  from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid = userid_1 and usertype = usertype_1)
		loop
			count_1 := count_1_cursor.copydoc;
		end loop;
	 
	 end if; 
else 
	select  count(mainid) into  count_1 from DirAccessControlList where dirid=dirid_1 and dirtype=dirtype_1 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1)); 
 
 end if;  
 
 if  count_1 is not null and count_1>0 then result := 1; end if; 
 
 haspermission_1 := result; end;
/

