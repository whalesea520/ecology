CREATE TABLE ofUserInfoUpdate
(
username integer,
updatestate integer
)
/
CREATE or replace TRIGGER Tri_message_userinfoupdate after update ON HrmResource
for each row
DECLARE
	newid    	integer;
	ucount    	integer;
BEGIN
	newid := :new.id;
	SELECT  count(*) into ucount from  ofUserInfoUpdate where username = newid and updatestate =1;
	IF(ucount<1) THEN
		insert into ofUserInfoUpdate values(newid,1);
	end if;
END;
/