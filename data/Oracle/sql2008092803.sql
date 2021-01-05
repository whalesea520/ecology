CREATE or REPLACE PROCEDURE HrmResource_SelectByManagerID 
 (id_1 integer, 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
  AS
begin
open thecursor for  
  select * from HrmResource 
  where 
    managerid = id_1 
    and (status =0 or status = 1 or status =2 or status =3) order by dsporder;
end;
/