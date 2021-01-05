CREATE TABLE MobileSetting(
	id int NOT NULL, 
	scope integer NOT NULL, 
	module integer NOT NULL, 
	fields varchar(50), 
	value varchar(200)
)
/

create sequence MobileSetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create table workflowBlacklist(
	id int NOT NULL,
	userid integer NOT NULL, 
	workflowid integer NOT NULL
)
/

create sequence workflowBlacklist_id
start with 1
increment by 1
nomaxvalue
nocycle
/
