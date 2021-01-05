alter TRIGGER  delCheckStd ON HrmPerformanceCheckDetail 
FOR  DELETE 
AS
DECLARE @id int
select @id=id from deleted 
delete from  hrmPerformanceCheckStd   where checkDetailId=@id

GO