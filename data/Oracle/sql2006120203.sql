Create or replace Procedure reset_CoworkRemind(
	flag out integer, 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)
as
	
	id_1 integer;
	count_1 integer;
begin
	for all_cursor in(	
	select id from HrmResource)
	loop
	  id_1 := all_cursor.id ;
	  select count(id) into count_1 from cowork_items where ((coworkers like concat(concat('%,',to_char(id_1)),',%'))
	  or creater=to_char(id_1)) and (isnew not like concat(concat('%,',to_char(id_1)),',%')) and status=1;
	  update SysPoppupRemindInfo set remindcount=count_1,count=count_1 where userid=id_1 and type=9;
	end loop;
end;
/