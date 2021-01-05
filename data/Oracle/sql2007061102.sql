CREATE TABLE Meeting_View_Status
(
	id                integer              PRIMARY KEY NOT NULL,
	meetingId 	      integer              NULL,
	userId 	          integer              NULL,
	userType          char(1)              NULL,
	status		      char(1)              NULL
)
/

CREATE SEQUENCE Meeting_View_Status_Id
    start with 1
    increment by 1
    nomaxvalue
    nocycle 
/

CREATE OR REPLACE TRIGGER Meeting_View_Status_Id_Trigger
	before insert on Meeting_View_Status
	for each row
	begin
	select Meeting_View_Status_Id.nextval into :new.id from dual;
	end ;
/

INSERT INTO HPFieldElement(id, elementId, fieldName, fieldColumn, isDate, transMethod, fieldWidth, linkUrl, valueColumn, isLimitLength, orderNum)
VALUES(64, 12, '602', 'meetingStatus', '0', 'getMeetingStatus', '15', '', '', '', 3)
/

UPDATE HPFieldElement SET orderNum = 4 WHERE id = 29
/

UPDATE HPFieldElement SET orderNum = 5 WHERE id = 30
/