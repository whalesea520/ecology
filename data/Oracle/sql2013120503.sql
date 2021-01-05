CREATE TABLE ofdocupload ( 
    id integer not null,
    imageFileId number,
    uploaddate varchar(10),
    uploadtime varchar(8)
) 
/
create sequence ofdocupload_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger ofdocupload_id_trigger
before insert on ofdocupload
for each row
begin
select ofdocupload_id.nextval into :new.id from dual;
end;
/
