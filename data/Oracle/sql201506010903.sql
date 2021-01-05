CREATE TABLE ofuploadfiles ( 
    id INTEGER PRIMARY KEY,
	filedigest VARCHAR2(100) NOT NULL,
	filesize VARCHAR2(100) NOT NULL,
	filepath VARCHAR2(1000) NOT NULL
) 
/
CREATE SEQUENCE ofuploadfiles_id
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCYCLE
/
CREATE OR REPLACE TRIGGER ofuploadfiles_id_trigger
BEFORE INSERT ON ofuploadfiles
FOR EACH ROW
BEGIN
SELECT ofuploadfiles_id.nextval INTO :new.id FROM dual;
END;
/

ALTER TABLE ofMucRoomFiles ADD isnew CHAR(1)
/

ALTER TABLE ofMucRoomFiles ADD filename VARCHAR2(1000)
/

CREATE TABLE ofofflinefiles (
    id INTEGER PRIMARY KEY,
	loginid VARCHAR2(1000) NOT NULL,
	sendto VARCHAR2(1000) NOT NULL,
	filename VARCHAR2(1000) NOT NULL,
	fileid INTEGER NOT NULL,
	isdoc CHAR(1) NOT NULL,
	doc INTEGER
)
/
CREATE SEQUENCE ofofflinefiles_id
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCYCLE
/
CREATE OR REPLACE TRIGGER ofofflinefiles_id_trigger
BEFORE INSERT ON ofofflinefiles
FOR EACH ROW
BEGIN
SELECT ofofflinefiles_id.nextval INTO :new.id FROM dual;
END;
/