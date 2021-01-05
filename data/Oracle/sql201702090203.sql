create table blog_zan(
    id int primary key,
    blogid int,
    userid int,
    zantime varchar(50)
)
/
create sequence blog_zan_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_zan_id_tri
before insert on blog_zan
for each row
begin
select blog_zan_id.nextval into :new.id from dual;
end;
/
