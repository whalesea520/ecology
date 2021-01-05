CREATE TABLE COREMAILSETTING
(
  ISUSE               integer,
  SYSTEMADDRESS       varchar2(200),
  ORGID               varchar2(200),
  PROVIDERID          varchar2(200),
  DOMAIN              varchar2(200),
  ISSYNC              integer,
  BINDFIELD           varchar2(500)
)
/



CREATE TABLE COREMAILLOG
(
  ID                  integer not null,
  DATATYPE            integer,
  OPERATEDATA         varchar2(1000),
  OPERATETYPE         integer,
  OPERATERESULT       integer,
  OPERATEREMARK       varchar2(2000),
  LOGDATE             varchar2(50),
  LOGTIME             varchar2(50)
)
/

CREATE SEQUENCE COREMAILLOG_SEQ
MINVALUE 1
MAXVALUE 99999999999999999999
START WITH 1
INCREMENT BY 1
CACHE 50
ORDER
/

CREATE OR REPLACE TRIGGER COREMAILLOG_TRI 
BEFORE INSERT ON COREMAILLOG 
FOR EACH ROW
BEGIN 
  SELECT COREMAILLOG_SEQ.NEXTVAL INTO :NEW.ID FROM DUAL; 
  END;
/


insert into hpBaseElement(id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc,isuse,titleEN,titleTHK,loginview,isbase) 
values('CoreMail','2','CoreMail” œ‰','resource/image/16_wev8.gif',-1,'-1','','CoreMail” œ‰','1','CoreMail','CoreMail‡]œ‰','0','1')
/