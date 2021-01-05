CREATE or REPLACE PROCEDURE SystemRight_selectRightGroup 
(
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor 
)

as
id_1 integer;
groupname_1 varchar2(200);
count_1 integer;
count_2 integer;
begin

select count(*) into count_1  from SystemRights ;
insert into temp_table_01 (id,groupname,cnt)  values(-1,'全部',count_1) ;

for right_cursor in (select id , rightgroupname from SystemRightGroups  where id<>-2 order by id )
loop
    id_1 := right_cursor.id;
    groupname_1 := right_cursor.rightgroupname;
    select count(rightid) INTO  count_1  from SystemRightToGroup where groupid= id_1;
    insert into temp_table_01 (id,groupname,cnt)  values (id_1,groupname_1,count_1) ;
end loop;

select  count(distinct a.id) into count_2 from SystemRights a left join SystemRightToGroup b on a.id=b.rightid where b.rightid is null;
insert into temp_table_01 (id,groupname,cnt)  values(-2,'其它权限组',count_2);

open thecursor for
select id,groupname,cnt from temp_table_01 ;
end;
/

delete from SystemRightToGroup where groupid=(select id from SystemRightGroups where rightgroupmark='OTHADM')
/
delete from SystemRightGroups where rightgroupmark='OTHADM'
/

insert into SystemRightGroups(rightgroupmark,rightgroupname,rightgroupremark)
values ('OTHADM','其它权限组','所有未分组的权限')
/
update SystemRightGroups set id = -2 where rightgroupmark='OTHADM'
/

INSERT INTO HtmlLabelIndex values(18871,'相关项目任务') 
/
INSERT INTO HtmlLabelInfo VALUES(18871,'相关项目任务',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18871,'Relative Project Task',8) 
/