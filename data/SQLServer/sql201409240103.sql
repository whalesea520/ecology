CREATE FUNCTION dbo.fun_getUUID32(@newid varchar(36))  
RETURNS VARCHAR(32)  
AS  
BEGIN  
    DECLARE @id VARCHAR(32);  
  
    select @id=SUBSTRING(@newid,1,8)+SUBSTRING(@newid,10,4)+SUBSTRING(@newid,15,4)+ SUBSTRING(@newid,20,4)+SUBSTRING(@newid,25,12)  
  
    RETURN @id  
  
END  
go
update modeinfo set modecode = dbo.fun_getUUID32(NEWID()) where modecode is null or modecode=''
go