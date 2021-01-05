create table docconvertstatus
(
   id         NUMBER(20)  not null,
   docid      NUMBER(15),
   status     NUMBER(1) ,
   constraint PK_docconvertstatus primary key (id)
)
/

create sequence seq_convertstatus
minvalue 1
nomaxvalue
start with 1
increment by 1
nocycle  
cache 10
/

CREATE OR REPLACE TRIGGER tr_convertstatus 
BEFORE INSERT ON docconvertstatus FOR EACH ROW WHEN (new.id is null)
begin
select seq_convertstatus.nextval into:new.id from dual;
end;
/