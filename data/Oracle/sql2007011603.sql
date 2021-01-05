declare subid_1 integer;

begin
 subid_1:=1;

select max(id) as id into subid_1 from HrmSubCompany order by  supsubcomid,showorder;
update hpinfo set subcompanyid=subid_1,creatortype=3,creatorid=subid_1 where id=1 or id=2;
update hplayout set usertype=3,userid=subid_1 where  hpid in (1,2) and usertype=3 and userid=1;

end;
/