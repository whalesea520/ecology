create sequence mailWorkRemindLog_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/

create or replace trigger mailWorkRemindLog_tri
before insert on mailWorkRemindLog
for each row 
begin 
    select mailWorkRemindLog_seq.nextval into:new.id 

 from sys.dual;
end;
/