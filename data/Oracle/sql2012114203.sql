CREATE SEQUENCE hws_markId
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE
 /
 
CREATE TABLE HandwrittenSignature(
  markId number(15)  NOT NULL,
  markName varchar2(100) NOT NULL,
  hrmresid number(15) NOT NULL,
  password varchar2(50) NOT NULL,
  markPath varchar2(200) NULL,
  markType varchar2(10) NULL,
  markSize number(15) NULL,
  markDate date NULL,
  lastmodificationtime date NULL
)
/