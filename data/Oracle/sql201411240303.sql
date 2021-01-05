CREATE TABLE wechat_news (
id  INTEGER not null primary key ,
name varchar2(200) NULL ,
createrid INTEGER NULL ,
createtime varchar2(19) NULL ,
updatetime varchar2(19) NULL ,
newstype INTEGER NULL ,
isdel char(1)   DEFAULT 0 NULL 
)
/
create sequence wechat_news_id
minvalue 1
start with 1
increment by 1
/
create or replace trigger wechat_news_tri
before insert on wechat_news for each row
begin
select wechat_news_id.nextval into :new.id from dual;
end;
/


CREATE TABLE wechat_news_material (
id INTEGER not null primary key ,
title varchar2(500)   NULL ,
summary varchar2(500)   NULL ,
content clob   NULL ,
url varchar2(500)   NULL ,
picUrl varchar2(500)   NULL ,
userid int NULL ,
dsporder int NULL ,
newsId int NULL 
)
/
create sequence wechat_news_material_id
minvalue 1
start with 1
increment by 1
/
create or replace trigger wechat_news_material_tri
before insert on wechat_news_material for each row
begin
select wechat_news_material_id.nextval into :new.id from dual;
end;
/

alter table wechat_msg add isNews int DEFAULT 0
/
update wechat_msg set isNews=0
/