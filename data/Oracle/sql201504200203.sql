CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermissionBE
(
dirid_1 integer,
dirtype_1 integer,
userid_1 varchar2,
usertype_1 integer,
seclevel_1 integer, 
operationcode_1 integer, 
departmentid_1 varchar2,
subcompanyid_1 varchar2,
roleid_1 varchar2,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
AS
count_1 integer;
result integer;
count_num integer;
begin
result := 0;
if usertype_1 = 0 then

  select count (sourceid) into count_num  from DirAccessControlDetail where   sourceid = dirid_1  and  sourcetype=dirtype_1 and  sharelevel=operationcode_1 and ((type=1 and content in (select * from TABLE(CAST(SplitStr(departmentid_1, ',')AS mytable))) and seclevel<=seclevel_1) or (type=2 and content in (select * from TABLE(CAST(SplitStr(roleid_1, ',')AS mytable))) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or    (type=4 and content=usertype_1 and seclevel<=seclevel_1) or(type=5 and content in (select * from TABLE(CAST(SplitStr(userid_1, ',')AS mytable))) ) or(type=6 and content in (select * from TABLE(CAST(SplitStr(subcompanyid_1, ',')AS mytable))) and seclevel<=seclevel_1));
        if(count_num >0) then
               count_1 := 1 ;
        else count_1 := 0 ;
        end if;    
else 
    select count(mainid) into count_1  from DirAccessControlList where dirid=dirid_1 and dirtype=dirtype_1 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1));
end if;
if (count_1 > 0)  then
     result := 1 ;
end if;
open thecursor for
select result result from dual;
end;
/