create table social_IMSessionkey(
  id int ,
  userid varchar(100),
  sessionkey varchar(500),
  logindate varchar(20)
)
/
create sequence social_IMSessionkey_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/

create or replace trigger social_IMSessionkey_tri
before insert on social_IMSessionkey
for each row 
begin 
	select social_IMSessionkey_seq.nextval into:new.id from sys.dual;
end;
/