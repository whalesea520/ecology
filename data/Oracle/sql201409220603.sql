CREATE TABLE HrmResourceFile(
	id int NOT NULL,
	resourceid int NULL,
	fieldid int NULL,
	docid int NULL,
	docname varchar(4000) NULL,
	doccreater int NULL,
	createdate varchar(10) NULL,
	createtime varchar(8) NULL,
	scopeId int NULL
)
/
create sequence HrmResourceFile_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
CREATE OR REPLACE TRIGGER HrmResourceFile_Trigger before insert on HrmResourceFile for each row begin select HrmResourceFile_id.nextval into :new.id from dual; end;
/