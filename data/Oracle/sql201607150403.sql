CREATE TABLE DocPrivateSecCategory (
ID int NOT NULL ,
categoryname varchar(1000) NULL ,
ecology_pinyin_search varchar(1000) NULL ,
parentid int NULL ,
CONSTRAINT DocPrivateSecCategory_PK PRIMARY KEY 
  (
    ID 
  )
)
/
CREATE SEQUENCE  DocPrivateSecCategory_SEQ 
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace TRIGGER DocPrivateSecCategory_TRIGGER before insert on DocPrivateSecCategory for each row
begin 
select DocPrivateSecCategory_SEQ.nextval into :new.id from dual; 
end ;
/

alter table DocSecCategory add  seccategoryType int default 0 not null
/