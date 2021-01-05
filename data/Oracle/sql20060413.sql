insert into SysPoppupInfo values (9,'/cowork/coworkview.jsp?type=remind','新协作事件需要您处理','y','协作提醒')
/
INSERT INTO HtmlLabelIndex values(18822,'协作提醒') 
/
INSERT INTO HtmlLabelIndex values(18831,'协作主题') 
/
INSERT INTO HtmlLabelInfo VALUES(18822,'协作提醒',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18822,'Cowork Remind',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18831,'协作主题',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18831,'Cowork Subject',8) 
/

update SysPoppupInfo set link='/cowork/CoworkRemindLink.jsp' where type=9
/
delete from SysPoppupRemindInfo where type=9
/
Create or replace Procedure init_CoworkRemind
as
	id_1 integer;
	count_2 integer;
begin
	FOR all_cursor in(select id from HrmResource)
	loop
	id_1 := all_cursor.id;
		select count(id) into count_2 from cowork_items where (concat(concat(',',coworkers),',') like concat(concat('%,', to_char(id_1)),',%'))and (concat(concat(',',isnew),',') not like concat(concat('%,',to_char(id_1 )),',%')) and status=1;
		IF (count_2 <> 0)
		then
			insert into SysPoppupRemindInfo(userid,type,usertype,statistic,remindcount,count) values(id_1,9,'0','y',count_2,count_2);
		END if;
	END loop;
end;
/
call init_CoworkRemind()
/
DROP PROCEDURE init_CoworkRemind
/