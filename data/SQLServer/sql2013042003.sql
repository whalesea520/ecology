CREATE TABLE ofUserInfoUpdate
(
username int,
updatestate int
)
GO

CREATE  TRIGGER Tri_message_userinfoupdate
   ON HrmResource 
   AFTER UPDATE
AS 

DECLARE
	@newid   int,
	@ucount   int
BEGIN
	SELECT @newid = id   FROM inserted
	SELECT @ucount = count(*) from ofUserInfoUpdate where username = @newid and updatestate =1
	if(@ucount<1)
		insert into ofUserInfoUpdate values(@newid,1)
END
GO