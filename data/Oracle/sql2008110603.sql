CREATE OR REPLACE PROCEDURE Doc_DirAcl_Delete
(
mainid_1 integer, 
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
dirid_1 integer;
dirtype_1 integer;
operationcode_1 integer;
departmentid_1 integer;
subcompanyid_1 integer;
roleid_1 integer;
rolelevel_1 integer;
seclevel_1 integer;
permissiontype_1 integer;
usertype_1 integer;
mainuserid_1 integer;
userid_1 integer;
count_1 integer;
begin
    for permission_cursor in(select dirid, dirtype, seclevel, departmentid, subcompanyid, roleid, rolelevel, usertype, permissiontype, operationcode, userid from DirAccessControlList where mainid = mainid_1)
    loop
        dirid_1 :=permission_cursor.dirid ;
        dirtype_1 :=permission_cursor.dirtype;
        seclevel_1 :=permission_cursor.seclevel;
        departmentid_1 :=permission_cursor.departmentid;
        subcompanyid_1 :=permission_cursor.subcompanyid;
        roleid_1 :=permission_cursor.roleid;
        rolelevel_1 :=permission_cursor.rolelevel;
        usertype_1 :=permission_cursor.usertype;
        permissiontype_1 :=permission_cursor.permissiontype;
        operationcode_1 :=permission_cursor.operationcode;
        mainuserid_1 :=permission_cursor.userid;
        if permissiontype_1 = 1 then
            for users_cursor in(select distinct id from HrmResource where departmentid = departmentid_1 and seclevel >= seclevel_1)
            loop
                userid_1 := users_cursor.id;
                Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,userid_1,0,operationcode_1);
            end loop;
        end if;

        if permissiontype_1 = 2 then
            for users_cursor in(select distinct HrmResource.id h_id from HrmResource, HrmRoleMembers where roleid = roleid_1 and rolelevel >= rolelevel_1 and HrmResource.id = HrmRoleMembers.resourceid and seclevel >= seclevel_1 union select distinct HrmResourceManager.id h_id from HrmResourceManager, HrmRoleMembers where roleid = roleid_1 and rolelevel >= rolelevel_1 and HrmResourceManager.id = HrmRoleMembers.resourceid and seclevel >= seclevel_1 )
            loop
                userid_1 := users_cursor.h_id;
                Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,userid_1,0,operationcode_1);
            end loop;
        end if;

        if permissiontype_1 = 3 then
        for users_cursor in(select distinct id from HrmResource where seclevel >= seclevel_1  union select distinct id from HrmResourceManager where seclevel >= seclevel_1)
        loop
            userid_1 := users_cursor.id;
            Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,userid_1,0,operationcode_1);
        end loop;
        end if;

        if permissiontype_1 = 4 then
        for users_cursor in(select distinct id from HrmResource where seclevel >= seclevel_1  union select distinct id from HrmResourceManager where seclevel >= seclevel_1)
        loop
            userid_1 := users_cursor.id;
            Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,userid_1,usertype_1,operationcode_1);
        end loop;        
        end if;
        
        if permissiontype_1 = 5 then
            Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,mainuserid_1,0,operationcode_1);
        end if;

        if permissiontype_1 = 6 then
            for users_cursor in(select distinct id from HrmResource where subcompanyid1 = subcompanyid_1 and seclevel >= seclevel_1)
            loop
                userid_1 := users_cursor.id;
                Doc_DirAccessPermission_Delete (dirid_1,dirtype_1,userid_1,0,operationcode_1);
            end loop;
        end if;

        delete from DirAccessControlList where mainid = mainid_1;
    end loop;
end;
/

/* 以角色＋角色级别+安全级别的方式增加权限 */

CREATE OR REPLACE PROCEDURE Doc_DirAcl_Insert_Type2
(
dirid_1 integer, 
dirtype_1 integer, 
operationcode_1 integer,
roleid_1 integer, 
rolelevel_1 integer, 
seclevel_1 integer, 
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
userid_1 integer;
count_1 integer;

begin
insert into DirAccessControlList(dirid, dirtype, roleid, rolelevel, seclevel, operationcode, permissiontype) values(dirid_1, dirtype_1, roleid_1, rolelevel_1, seclevel_1, operationcode_1, 2);

for users_cursor in(select distinct HrmResource.id h_id from HrmResource, HrmRoleMembers 
where roleid = roleid_1 and rolelevel >= rolelevel_1 and HrmResource.id = HrmRoleMembers.resourceid and seclevel >= seclevel_1 
 union select distinct HrmResourceManager.id h_id from HrmResourceManager, HrmRoleMembers 
where roleid = roleid_1 and rolelevel >= rolelevel_1 and HrmResourceManager.id = HrmRoleMembers.resourceid and seclevel >= seclevel_1
)
loop
    userid_1 := users_cursor.h_id;
    Doc_DirAccessPermission_Insert (dirid_1,dirtype_1,userid_1,0,operationcode_1);
end loop;

end;
/


/* 以所有人＋安全级别的方式增加权限 */
CREATE OR REPLACE PROCEDURE Doc_DirAcl_Insert_Type3
(
dirid_1 integer,
dirtype_1 integer,
operationcode_1 integer,
seclevel_1 integer,
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
userid_1 integer;
count_1 integer;
begin
insert into DirAccessControlList(dirid, dirtype, seclevel, operationcode, permissiontype) 
values(dirid_1, dirtype_1, seclevel_1, operationcode_1, 3);

for users_cursor in(select distinct id from HrmResource where seclevel >= seclevel_1 union select distinct id from HrmResourceManager where seclevel >= seclevel_1 )
loop
    userid_1 := users_cursor.id;
    Doc_DirAccessPermission_Insert (dirid_1,dirtype_1,userid_1,0,operationcode_1);
end loop;

end;
/

/* 以用户类型＋安全级别的方式增加权限 */
CREATE OR REPLACE PROCEDURE Doc_DirAcl_Insert_Type4
(
dirid_1 integer,
dirtype_1 integer,
operationcode_1 integer,
usertype_1 integer,
seclevel_1 integer,
flag  out integer,
msg    out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
    userid_1 integer;
begin
insert into DirAccessControlList(dirid, dirtype, usertype, seclevel, operationcode, permissiontype) values(dirid_1, dirtype_1, usertype_1, seclevel_1, operationcode_1, 4);

if usertype_1 = 0 then

    for users_cursor in( select distinct id from HrmResource where seclevel >= seclevel_1 union select distinct id from HrmResourceManager where seclevel >= seclevel_1)
    loop
        userid_1 := users_cursor.id;
        Doc_DirAccessPermission_Insert (dirid_1,dirtype_1,userid_1,0,operationcode_1);
    end loop;
end if;
end;
/