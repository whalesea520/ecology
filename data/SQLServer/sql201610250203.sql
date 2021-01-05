CREATE PROCEDURE [HrmResourceDateCheck7] ( 
 @today_1 CHAR(10) , 
 @flag INT OUTPUT , 
 @msg VARCHAR(4000) OUTPUT ) 
 AS 
 UPDATE  HrmResource SET     status = 3 WHERE  
 status = 0 AND probationenddate < @today_1 AND probationenddate <> '' AND probationenddate IS NOT NULL 
 UPDATE  HrmResource SET     status = 0 WHERE  
 status = 3 AND ( probationenddate >= @today_1 OR probationenddate = '' OR probationenddate IS NULL )
 GO
