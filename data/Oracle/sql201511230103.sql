CREATE TABLE DOC_REPLY 
(
  ID INT NOT NULL,
  DOCID VARCHAR2(20) NOT NULL, 
  USERID VARCHAR2(20) NOT NULL , 
  REPLY_PARENTID INT NOT NULL , 
  CONTENT  CLOB  NOT NULL ,
  RUSERID VARCHAR2(20) NOT NULL , 
  RTYPE INT NOT NULL , 
  REPLYDATE VARCHAR2(20) NOT NULL , 
  REPLYTIME VARCHAR2(20) NOT NULL , 
  ORDERNO VARCHAR2(250) , 
  PARENTID INT , 
  CONSTRAINT DOC_REPLY_PK PRIMARY KEY 
  (
    ID 
  )
)
/
CREATE SEQUENCE  DOC_REPLY_SEQ 
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace TRIGGER DOC_REPLY_TRIGGER before insert on DOC_REPLY for each row
begin 
select DOC_REPLY_SEQ.nextval into :new.id from dual; 
end ;
/

CREATE TABLE REPLY_DOC (
ID int NOT NULL ,
REPLYID int NOT NULL ,
DOCID int NOT NULL ,
REPLYDATE varchar(100) NOT NULL ,
REPLYTIME varchar(100) NOT NULL ,
CONSTRAINT REPLY_DOC_PK PRIMARY KEY 
  (
    ID 
  )
)
/
CREATE SEQUENCE  REPLY_DOC_SEQ 
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace TRIGGER REPLY_DOC_TRIGGER before insert on REPLY_DOC for each row
begin 
select REPLY_DOC_SEQ.nextval into :new.id from dual; 
end ;
/

CREATE TABLE REPLY_IMAGEFILE (
ID int NOT NULL ,
IMAGEFILEID int NOT NULL ,
REPLY_ID int NOT NULL ,
INCONTENT int NOT NULL,
TYPE int NULL ,
IMAGEFILENAME varchar(255) NULL ,
CONSTRAINT REPLY_IMAGEFILE_PK PRIMARY KEY 
  (
    ID 
  )
)
/
CREATE SEQUENCE  REPLY_IMAGEFILE_SEQ 
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace TRIGGER REPLY_IMAGEFILE_TRIGGER before insert on REPLY_IMAGEFILE for each row
begin 
select REPLY_IMAGEFILE_SEQ.nextval into :new.id from dual; 
end ;
/

CREATE TABLE REPLY_WORKFLOW (
ID int NOT NULL ,
REPLYID int NOT NULL ,
WORKFLOWID int NOT NULL ,
REPLYDATE varchar(100) NOT NULL ,
REPLYTIME varchar(100) NOT NULL ,
WORKFLOWNAME varchar(1000) NULL 
, CONSTRAINT REPLY_WORKFLOW_PK PRIMARY KEY 
  (
    ID 
  )
)
/
CREATE SEQUENCE  REPLY_WORKFLOW_SEQ 
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace TRIGGER REPLY_WORKFLOW_TRIGGER before insert on REPLY_WORKFLOW for each row
begin 
select REPLY_WORKFLOW_SEQ.nextval into :new.id from dual; 
end ;
/

CREATE TABLE SYN_OLD_REPLY (
docid int NOT NULL 
)
/

CREATE TABLE PRAISE_INFO (
ID int NOT NULL ,
USERID varchar(30) NOT NULL ,
PRAISE_ID int NOT NULL ,
PRAISE_TYPE int NOT NULL ,
PRAISE_DATE varchar(100) NOT NULL ,
PRAISE_TIME varchar(100) NOT NULL ,
DOCID int NOT NULL ,
CONSTRAINT PRAISE_INFO_PK PRIMARY KEY 
  (
    ID 
  )
)
/
CREATE SEQUENCE  PRAISE_INFO_SEQ 
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace TRIGGER PRAISE_INFO_TRIGGER before insert on PRAISE_INFO for each row
begin 
select PRAISE_INFO_SEQ.nextval into :new.id from dual; 
end ;
/