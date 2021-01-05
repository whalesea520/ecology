create table worktask_wtuserdefault(
	id integer,
	userid integer,
	perpage integer
)
/
create sequence wtuserdefault_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger wtuserdefault_id_Tri
before insert on worktask_wtuserdefault
for each row
begin
select wtuserdefault_id.nextval into :new.id from dual;
end;
/

insert into worktask_wtuserdefault(userid, perpage)
values(1, 20)
/
