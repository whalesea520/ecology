create table SysPoppupRemindInfoConfig
(
	id integer primary key not null,
	resourceid integer,
	id_type  VARCHAR2(10),
	ids VARCHAR2(10),
	idsmodule integer default 0
)
/
CREATE SEQUENCE SysPoppupRemindInfoConfig_seq
   	 START WITH     1
	 INCREMENT BY   1
	 NOCACHE
	 NOMAXVALUE
/

CREATE OR REPLACE TRIGGER SysPoppupRemindConfig_Tri
     BEFORE INSERT ON SysPoppupRemindInfoConfig
     FOR EACH ROW
     BEGIN
     SELECT SysPoppupRemindInfoConfig_seq.nextval INTO :new.id  FROM dual;
     END;
/