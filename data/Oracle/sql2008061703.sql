CREATE OR REPLACE PROCEDURE HrmRoles_insert_name (rolesmark_1 varchar2, rolesname_1 varchar2, docid_1  integer, type_1 integer, subcompanyid_1 integer, 
flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) as 
begin 
insert into HrmRoles(rolesmark,rolesname,docid,type,subcompanyid) values(rolesmark_1,rolesname_1,docid_1,type_1,subcompanyid_1); open thecursor for 
select max(id) as id from hrmroles; end;
/