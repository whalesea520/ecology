ALTER TABLE HrmResource add isADAccount char(1)
GO
UPDATE HrmResource SET isADAccount = '1' WHERE account is not NULL and account <>''
 and (userUsbType is null or userUsbType = '')
GO
UPDATE HrmResource SET loginid = account WHERE account is not NULL and account <>''
 and (userUsbType is null or userUsbType = '')
GO
