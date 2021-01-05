CREATE TABLE Fullsearch_E_Faq (
id int NOT NULL PRIMARY KEY,
ask varchar(200) NULL ,
answer varchar(4000) NULL ,
createrId int NULL ,
status int NULL ,
createdate char(10) NULL ,
createtime char(8) NULL ,
processdate char(10) NULL ,
processtime char(8) NULL ,
processId int NULL ,
targetFlag int NULL ,
sendReply int NULL ,
readFlag int NULL ,
checkOutId int NULL ,
targetDo int NULL ,
faqTargetId int NULL ,
commitTag int NULL 
)
/
create sequence Fullsearch_E_Faq_ID
minvalue 1
start with 1
increment by 1
/
create or replace trigger Fullsearch_E_Faq_TRI before insert on Fullsearch_E_Faq for each row
begin select Fullsearch_E_Faq_ID.nextval into :new.id from dual; end;
/

