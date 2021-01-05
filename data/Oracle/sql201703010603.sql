CREATE TABLE social_ImGroup(
	id int primary key,
    name varchar2(100),
	createUserId varchar2(100)
)
/
create sequence social_ImGroup_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/
create or replace trigger social_ImGroup_trigger 
before insert on social_ImGroup
for each row 
begin 
	select social_ImGroup_seq.nextval into:new.id from dual;
end;
/
CREATE TABLE social_ImGroup_Rel(
	id int primary key,
    rel_id int,
	userId varchar2(100),
	groupId varchar2(100),
	groupName varchar2(1000),	
	groupRowID int,
	isOpenFire int
)
/
create sequence social_ImGroup_Rel_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/
create or replace trigger social_ImGroup_Rel_trigger 
before insert on social_ImGroup_Rel
for each row 
begin 
	select social_ImGroup_Rel_seq.nextval into:new.id from dual;
end;
/
insert into social_ImGroup(name,createUserId) values('我的群聊','ALL')
/
delete from social_ImGroup_Rel
/
insert into social_ImGroup_rel (rel_id,userid,groupid,groupName,isopenfire)
select (select id from social_ImGroup where name = '我的群聊' and createUserId = 'ALL') as rel_id,a.userid,a.group_id ,b.targetname,a.isopenfire from
(select userid,group_id,isopenfire from mobile_rongGroup group by userid,group_id,isopenfire) a,(select targetid,targetname from social_IMConversation group by targetid,targetname) b
where a.group_id = b.targetid
/