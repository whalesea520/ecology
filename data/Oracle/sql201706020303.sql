create table DocCheckInOut (
    id integer  not null,
    docId integer null,
    checkOutStatus char(1) null,
    checkOutUserId integer null,
    checkOutUserType char(1) null,
    checkOutDate char(10) null,
    checkOutTime char(8) null
)  
/

create sequence DocCheckInOut_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger DocCheckInOut_id_tri
before insert on DocCheckInOut
for each row
begin
select DocCheckInOut_id.nextval into :new.id from dual;
end;
/


create  INDEX DocCheckInOut_docId on DocCheckInOut(docId)
/
