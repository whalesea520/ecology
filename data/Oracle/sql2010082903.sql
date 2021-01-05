CREATE OR REPLACE PROCEDURE createdocseclevel 
AS
resourceid_1 integer;
departmentid_1 integer;
subcompanyid_1 integer;
seclevel_1 integer;
begin
for hrmresource_cursor in(select t.id,t.departmentid,t.subcompanyid1,t.seclevel FROM HrmResource t where t.seclevel = 0)
loop
    resourceid_1 := hrmresource_cursor.id ; 
    departmentid_1 := hrmresource_cursor.departmentid ; 
    subcompanyid_1 := hrmresource_cursor.subcompanyid1 ; 
    seclevel_1 := hrmresource_cursor.seclevel ; 
    Doc_DirAcl_GUserP_BasicChange (resourceid_1,departmentid_1,subcompanyid_1,seclevel_1);
end loop;
end;
/

CALL createdocseclevel()
/

drop PROCEDURE createdocseclevel
/
