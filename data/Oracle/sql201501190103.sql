ALTER TABLE HrmResource add isADAccount char(1)
/
UPDATE HrmResource SET isADAccount = '1' WHERE account is not NULL 
 and (userUsbType is null or userUsbType = '')
/
UPDATE HrmResource SET loginid = account WHERE account is not NULL 
 and (userUsbType is null or userUsbType = '')
/