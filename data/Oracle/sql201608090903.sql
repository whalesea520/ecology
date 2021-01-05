CREATE TABLE mode_carremindset(
ID int NOT NULL primary key,
isremind int NULL ,
remindtype int NULL 
)
/
create sequence mode_carremindset_ID
minvalue 1
increment by 1
/
create or replace trigger mode_carremindset_TR
 before insert on mode_carremindset for each row 
begin select mode_carremindset_ID.nextval into :new.id from dual; 
end;
/