create table ofMucRoomUsers
(
	id integer primary key not null,
	loginid  VARCHAR2(60),
	roomname VARCHAR2(200),
	jointime NUMBER(19)
)
/
CREATE SEQUENCE ofMucRoomUsers_seq
   	 START WITH     1
	 INCREMENT BY   1
	 NOCACHE
	 NOMAXVALUE
/

CREATE OR REPLACE TRIGGER ofMucRoomUsers_Tri
     BEFORE INSERT ON ofMucRoomUsers
     FOR EACH ROW
     BEGIN
     SELECT ofMucRoomUsers_seq.nextval INTO :new.id  FROM dual;
     END;
/
