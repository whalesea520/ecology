CREATE TABLE social_ImSignatures(
	id int primary key,
    userid varchar2(100),
	signatures varchar2(1000),
	signdate  varchar2(100)
)
/

create sequence social_ImSignatures_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/

create or replace trigger social_ImSignatures_trigger 
before insert on social_ImSignatures
for each row 
begin 
	select social_ImSignatures_seq.nextval into:new.id from dual;
end;
/