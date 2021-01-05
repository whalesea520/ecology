ALTER table workflow_billfield ADD selectItemType CHAR(1)
/
ALTER table workflow_billfield ADD pubchoiceId INTEGER
/
ALTER table workflow_billfield ADD pubchilchoiceId INTEGER
/
ALTER table workflow_billfield ADD statelev INTEGER
/


UPDATE workflow_billfield set selectItemType='0' WHERE selectItemType IS NULL
/




CREATE TABLE selectItemLog
(
	id INTEGER NOT NULL,
	objid INTEGER,
	selectname varchar2 (1000) ,
	logmodule varchar2 (20) ,
	logtype varchar2 (80) ,
	operator varchar2 (400) ,
	operatorname varchar2 (400) ,
	optdatetime varchar2 (400)
) 

/
CREATE SEQUENCE selectItemLog_id
INCREMENT BY 1
START WITH 1
MINVALUE 1 NOMAXVALUE
NOCYCLE
/


create or replace trigger selectItemLog_trigger
before insert on selectItemLog
for each row
begin
select selectItemLog_id.nextval into :new.id from dual;
end
/


ALTER TABLE mode_selectitempage ADD operatetime VARCHAR2(20)
/
ALTER TABLE mode_selectitempage ADD formids VARCHAR2(2000)
/

ALTER TABLE mode_selectitempagedetail ADD name1 VARCHAR2(1000)
/
ALTER TABLE mode_selectitempagedetail ADD name2 VARCHAR2(1000)
/

