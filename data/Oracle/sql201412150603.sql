BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE MobileDocSetting';
EXCEPTION
   WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE MobileDocSetting(
	columnid INT NOT NULL,
	scope INT NOT NULL,
	name VARCHAR(100) NOT NULL,
	source INT NOT NULL,
	showOrder INT,
	isreplay INT
)
/

CREATE SEQUENCE MobileDocSetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger MobileDocSetting_Trigger
before insert on MobileDocSetting
for each row
begin
select MobileDocSetting_id.nextval into :new.columnid from dual;
end;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE MobileDocColSetting';
EXCEPTION
   WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE MobileDocColSetting(
	columnid INT NOT NULL,
	docid INT NOT NULL
)
/

DELETE FROM MobileSetting
/