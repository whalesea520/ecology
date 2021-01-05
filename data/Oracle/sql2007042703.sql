Declare subid_1 integer;
        count_1 integer;

begin
 subid_1:=1;

select max(id) as id into subid_1 from HrmSubCompany order by  supsubcomid,showorder;
update hpinfo set subcompanyid=subid_1,creatortype=3,creatorid=subid_1 where id=1 or id=2;
update hplayout set usertype=3,userid=subid_1 where  hpid in (1,2) and usertype=3 and userid=1;
update hpElementSettingDetail set userid=subid_1,usertype=3 where userid=1 and hpid in(1,2);

for tmp_cursor in (select id,hpid from hpelement where hpid=1 or hpid=2)
loop
    select count(*) into count_1 from hpElementSettingDetail where eid=tmp_cursor.id and hpid=tmp_cursor.hpid and userid=subid_1 and usertype=3;
	   
    if count_1=0  then
	   insert into hpElementSettingDetail(userid,usertype,eid,perpage,linkmode,showfield,sharelevel,hpid) values(subid_1,3,tmp_cursor.id,5,2,'',2,tmp_cursor.hpid);
    end if;
end loop ;
end;
/
