CREATE TABLE ImageFileBackUp (
	id    integer	 NOT NULL,
        imageFileId integer NULL
)
/
create sequence ImageFileBackUp_Id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger ImageFileBackUp_Tri
before insert on ImageFileBackUp
for each row
begin
select ImageFileBackUp_Id.nextval into :new.id from dual;
end;
/

CREATE TABLE MailResourceFileBackUp (
	id    integer	 NOT NULL,
        mailResourceFileId integer NULL
)
/
create sequence MailResourceFileBackUp_Id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger MailResourceFileBackUp_Tri
before insert on MailResourceFileBackUp
for each row
begin
select MailResourceFileBackUp_Id.nextval into :new.id from dual;
end;
/

CREATE OR REPLACE TRIGGER Tri_ImageFile_BackUp
AFTER UPDATE  ON ImageFile REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
Declare
imageFileId_1 integer;
begin
    imageFileId_1 := :old.imageFileId;

    insert into ImageFileBackUp(imageFileId) values(imageFileId_1)  ;

end ;
/

CREATE OR REPLACE TRIGGER Tri_MailResourceFile_BackUp
AFTER UPDATE  ON MailResourceFile REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
Declare
MailResourceFileId_1 integer;
begin
    MailResourceFileId_1 := :old.id;

    insert into MailResourceFileBackUp(MailResourceFileId) values(MailResourceFileId_1)  ;

end ;
/
