create or replace PROCEDURE systemright_Srightsbygroup
(id_1 integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
open thecursor for
select a.rightid,b.detachable from systemrighttogroup a,SystemRights b where a.groupid= id_1 and a.rightid=b.id order by b.righttype asc,a.rightid asc;
end;
/
