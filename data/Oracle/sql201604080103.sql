alter table meeting add qrticket VARCHAR2(100)
/
CREATE TABLE meeting_sign(
id int NOT NULL primary key ,
meetingid int NOT NULL ,
userid int NOT NULL ,
attendType int NOT NULL ,
signTime varchar(20) NULL ,
signReson varchar(1000) NULL,
flag int NOT NULL,
longitude NUMBER(20,6) NULL,
latitude NUMBER(20,6) NULL,
signRemark varchar(1000) NULL
)
/
create sequence meeting_sign_ID
minvalue 1
start with 1
increment by 1
/
create or replace trigger meeting_sign_TRI before insert on meeting_sign for each row
begin select meeting_sign_ID.nextval into :new.id from dual; end;
/
