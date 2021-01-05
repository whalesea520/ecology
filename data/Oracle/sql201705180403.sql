CREATE TABLE DocTopService(
	id int primary key,
	docid int NULL,
	operateTime varchar(19) NULL
)
/

create sequence DocTopService_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger DocTopService_id_Tri
before insert on DocTopService
for each row
begin
select DocTopService_id.nextval into :new.id from dual;
end;
/