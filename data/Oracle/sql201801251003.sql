create table CRM_CardRegSettings  
(  
id number primary key, 
isopen int,
url varchar2(200),
loginid varchar2(50),
password varchar2(50),
modifydate varchar2(50),
modifytime varchar2(50),
modifyuser varchar2(10)
)
/
CREATE SEQUENCE CRM_CardRegSettings_sequence
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
NOCACHE
/
create trigger CRM_CardRegSettings_trigger before
insert on CRM_CardRegSettings for each row when (new.id is null)
begin
 select CRM_CardRegSettings_sequence.nextval into:new.id from dual;
end;
/
insert into CRM_CardRegSettings (isopen) values (0)
/