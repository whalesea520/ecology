CREATE TABLE OUTTER_ENTRANCE_LOG
(
  ID            integer not null,
  USERID        integer,
  SYSID         varchar2(1000),
  CREATEDATE    varchar2(10),
  CREATETIME    varchar2(8)
)
/

CREATE SEQUENCE OUTTER_ENTRANCE_LOG_SEQ
MINVALUE 1
MAXVALUE 99999999999999999999
START WITH 1
INCREMENT BY 1
CACHE 50
ORDER
/

CREATE OR REPLACE TRIGGER OUTTER_ENTRANCE_LOG_TRI 
BEFORE INSERT ON OUTTER_ENTRANCE_LOG 
FOR EACH ROW
BEGIN 
  SELECT OUTTER_ENTRANCE_LOG_SEQ.NEXTVAL INTO :NEW.ID FROM DUAL; 
  END;
/



ALTER TABLE OUTTER_SYS 
ADD 
  CREATEDATE varchar2(10)
/

ALTER TABLE OUTTER_SYS 
ADD 
  CREATETIME varchar2(8)
/

ALTER TABLE OUTTER_SYS 
ADD 
  MODIFYDATE varchar2(10)
/

ALTER TABLE OUTTER_SYS 
ADD 
  MODIFYTIME varchar2(8)
/

UPDATE OUTTER_SYS SET CREATEDATE = to_char(sysdate,'yyyy-MM-dd'), CREATETIME = to_char(sysdate,'HH24:mi:ss'), 
MODIFYDATE = to_char(sysdate,'yyyy-MM-dd'), MODIFYTIME = to_char(sysdate,'HH24:mi:ss')
/



ALTER TABLE OUTTER_ACCOUNT 
ADD 
  CREATEDATE varchar2(10)
/

ALTER TABLE OUTTER_ACCOUNT 
ADD 
  CREATETIME varchar2(8)
/

ALTER TABLE OUTTER_ACCOUNT 
ADD 
  MODIFYDATE varchar2(10)
/

ALTER TABLE OUTTER_ACCOUNT 
ADD 
  MODIFYTIME varchar2(8)
/

UPDATE OUTTER_ACCOUNT SET CREATEDATE = to_char(sysdate,'yyyy-MM-dd'), CREATETIME = to_char(sysdate,'HH24:mi:ss'), 
MODIFYDATE = to_char(sysdate,'yyyy-MM-dd'), MODIFYTIME = to_char(sysdate,'HH24:mi:ss')
/