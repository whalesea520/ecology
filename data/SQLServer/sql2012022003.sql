create PROCEDURE HrmResource_up_AllManagerstr
as
declare @id INT
declare @managerid  INT
declare @tempmanagerid  INT
declare @managerCount  INT
DECLARE @managetstr VARCHAR(4000)
SET @managetstr=''
SET @tempmanagerid=0
SET @managerCount=1
declare cursor0 cursor for SELECT id,managerid FROM HrmResource ORDER BY id
open cursor0                
fetch next from cursor0  into @id,@managerid
while(@@fetch_status=0)     
BEGIN

   WHILE(@managerid<>0 AND @managerid <>'' AND ((@id=@managerid and @managerCount<=1) OR 
        (@id!=@managerid and (@managerCount<=2 AND charindex(','+CAST(@managerid AS VARCHAR(10))+',',@managetstr+',')=0))) )
  BEGIN
     
     SET @tempmanagerid=@managerid
     
     SELECT @managetstr=@managetstr+','+CAST(id AS VARCHAR(10)),@managerid=managerid FROM HrmResource WHERE id=@managerid

     IF @tempmanagerid=@managerid
         SET @managerCount=@managerCount+1
  END
  
  IF @managetstr<>''
     SET @managetstr=@managetstr+','
  
  UPDATE HrmResource SET managerstr=@managetstr WHERE id=@id
  
  SET @managetstr=''   
  SET @tempmanagerid=0
  SET @managerCount=1
  
  fetch next from cursor0  into @id,@managerid
end
close cursor0        
deallocate cursor0
GO

EXEC HrmResource_up_AllManagerstr
GO