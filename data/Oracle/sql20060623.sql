Declare
id_1 integer;
count_2 integer;

begin
delete from SysPoppupRemindInfo where type=9;
FOR all_cursor in(select id from HrmResource)
loop
    id_1 := all_cursor.id;
	select count(id) into count_2 from cowork_items where (
	(concat(concat(',',coworkers),',')) like (concat(concat('%,',to_char(id_1)),',%')) or creater = to_char(id_1)) and (concat(concat(',',isnew),',') not like concat(concat('%,',to_char(id_1)),',%')) and status=1;
	IF (count_2 <> 0)
	then
		insert into SysPoppupRemindInfo(userid,type,usertype,statistic,remindcount,count) values(id_1,9,'0','y',count_2,count_2);
	end if;

end loop;
end;
/