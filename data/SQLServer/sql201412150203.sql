drop procedure FnaAccountLog_Insert
GO
CREATE PROCEDURE FnaAccountLog_Insert ( @feetypeid_1 int, @resourceid_2 int, @departmentid_3 int, @crmid_4 int, @projectid_5 int, @amount_6 decimal(18,3), @description_7 varchar(250), @occurdate_8 char(10), @releatedid_9 char(10), @releatedname_10 varchar(255), @iscontractid_1 char(1), @flag          integer output, @msg           varchar(80) output)  AS INSERT INTO FnaAccountLog ( feetypeid, resourceid, departmentid, crmid, projectid, amount, description, occurdate, releatedid, releatedname, iscontractid )  VALUES ( @feetypeid_1, @resourceid_2, @departmentid_3, @crmid_4, @projectid_5, @amount_6, @description_7, @occurdate_8, @releatedid_9, @releatedname_10, @iscontractid_1 ) select max(id) from FnaAccountLog
GO
drop procedure FnaAccountLog_Update
GO
create PROCEDURE FnaAccountLog_Update ( @fnalogid_1 int, @amount_6 decimal(18,3), @projectid_5 int, @flag          integer output, @msg           varchar(80) output) AS Update FnaAccountLog set amount=@amount_6, projectid = @projectid_5 WHERE id = @fnalogid_1
GO