Alter PROCEDURE CRM_CustomerInfo_Delete 
(@id 		[int], 
@deleted 	[tinyint], 
@flag	[int]	output, 
@msg	[varchar](80)	output) 
AS 
UPDATE [CRM_CustomerInfo]  SET [deleted] = @deleted WHERE ( [id] = @id) 
delete from CRM_Contract where( crmId = @id )  
set @flag = 1 
set @msg = 'OK!'

GO

delete from CRM_Contract where crmId in(select id  from CRM_CustomerInfo where deleted  = 1)
go
