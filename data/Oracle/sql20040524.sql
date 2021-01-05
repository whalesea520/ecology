create or replace PROCEDURE docDetailLog_QueryByDate
	(fromdate_1 char ,
	 todate_1 	char ,
    flag out integer,
    msg out varchar2, 
    thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
SELECT docid, SUM(readCount) 
AS COUNT FROM docReadTag
where docid in (select id from docdetail) and 
docid in (SELECT docid FROM DocDetailLog WHERE (operatedate >= fromdate_1) 
AND (operatedate <= todate_1))GROUP BY docid ORDER BY COUNT DESC;
end;
/
/* 修改检查是否拥有权限的存储过程，附加一个参数用于输出检查结果 */
CREATE or REPLACE PROCEDURE Doc_DirAcl_CheckPermissionEx1
(
dirid_1 integer, 
dirtype_1 integer, 
userid_1 integer,
usertype_1 integer, 
seclevel_1 integer,
operationcode_1 integer, 
haspermission_1 in out integer 

)

AS

count_1 integer;
result integer;

begin
result := 0;

if usertype_1 = 0 then
    if operationcode_1 = 0 then
        select createdoc into count_1 from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and
        userid = userid_1 and usertype = usertype_1;

    elsif operationcode_1 = 1 then
         select createdir into count_1 from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and
        userid = userid_1 and usertype = usertype_1;

    elsif operationcode_1 = 2 then
        select movedoc  into count_1 from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and userid= userid_1 and usertype = usertype_1;

    elsif operationcode_1 = 3 then
        select copydoc into count_1 from DirAccessPermission where dirid = dirid_1 and dirtype = dirtype_1 and
        userid = userid_1 and usertype = usertype_1;

    end if; 
else 
    select  count(mainid) into  count_1 from DirAccessControlList where dirid=dirid_1 and dirtype=dirtype_1 and
   operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and
   usertype=usertype_1 and seclevel<=seclevel_1));
end if;

if  count_1 is not null and count_1>0 then
    result := 1;
end if;

haspermission_1 := result;
end;
/