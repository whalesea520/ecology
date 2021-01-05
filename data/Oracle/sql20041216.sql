CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermissionEx (
 dirid_1 integer,
 dirtype_1 integer,
 userid_1 integer,
 usertype_1 integer,
 seclevel_1 integer,
 operationcode_1 integer,
 flag out integer  , msg  out varchar2, thecursor IN OUT cursor_define.weavercursor )
 AS
 result_1 integer; mainid_1 integer; fatherid_1 integer; fatherid1_1 integer;

 /* 检查目录本身是否有权限 */
 begin
Doc_DirAcl_CheckPermissionEx1 (dirid_1, dirtype_1, userid_1, usertype_1, seclevel_1, operationcode_1, result_1);

if result_1 <> 1  then
 
    /* 取得上级目录 */
    if dirtype_1 = 1 then
        select  subcategoryid into fatherid_1 from DocSubCategory where id = dirid_1;
    elsif dirtype_1 = 2 then
        select  subcategoryid into fatherid_1 from DocSecCategory where id = dirid_1;
	
        if fatherid_1 is null then
            fatherid_1 := -1;
        end if;

        if fatherid_1 = 0  then
            fatherid_1 := -1;
        end if;
    else
	fatherid_1 := -1;
    end if;

     /* 检查主目录是否有权限 */
     if dirtype_1 = 1 then
        select  maincategoryid into mainid_1 from DocSubCategory where id = dirid_1;
        Doc_DirAcl_CheckPermissionEx1 (mainid_1, 0, userid_1, usertype_1, seclevel_1, operationcode_1, result_1);
		if result_1=1 then     
			fatherid_1 := -1;     
		end if;
   
	elsif dirtype_1 = 2 and fatherid_1 <> -1 then

	    select  maincategoryid into mainid_1 from DocSubCategory where id = fatherid_1;
	    Doc_DirAcl_CheckPermissionEx1 (mainid_1, 0, userid_1, usertype_1, seclevel_1, operationcode_1, result_1);
	    if result_1=1 then
		fatherid_1 := -1;
	    end if;

	    /* 自下而上依次检查各级分目录是否有权限 */
	    while fatherid_1 <> -1
	    loop Doc_DirAcl_CheckPermissionEx1(fatherid_1, 1, userid_1, usertype_1, seclevel_1, operationcode_1, result_1); 
		    if result_1 <> 1 then
			    select  subcategoryid into fatherid1_1 from DocSubCategory where id = fatherid_1; fatherid_1 := fatherid1_1;
		    else
			fatherid_1 := -1;
		    end if;
	    end loop;

	end if;
end if;
 open thecursor for select result_1 result from dual;  end;
/
