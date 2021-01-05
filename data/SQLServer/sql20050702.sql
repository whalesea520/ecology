alter table CRM_ContractProduct alter column sumPrice decimal(17,2)
go
alter table CRM_ContractProduct alter column price decimal(17,2)
go
alter table CRM_Contract alter column price decimal(17,2)
go



alter PROCEDURE CRM_ContractProduct_Insert 
	(
	 @contractId_1  [int]  ,	
	 @productId_1  [int]  ,
	 @unitId_1  [int]  ,
	 @number_n_1  [int]  ,
	 @price_1  [decimal](17, 2)  ,
	 @currencyId_1  [int]  ,
	 @depreciation_1  [int]  ,
	 @sumPrice_1  [decimal](17, 2)  ,
	 @planDate_1  [char] (10)   ,
	 @factnumber_n_1   [int]  ,
	 @factDate_1  [char] (10)  ,
	 @isFinish_1  [int]  ,
	 @isRemind_1  [int]  ,
	 @flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO [CRM_ContractProduct] 
	 (contractId , 
	 productId , 
	 unitId , number_n , price , currencyId , depreciation , sumPrice , planDate , factnumber_n , factDate , isFinish , isRemind ) 
 
VALUES 
	( @contractId_1,
	 @productId_1,
	 @unitId_1, @number_n_1 , @price_1 , @currencyId_1 , @depreciation_1 , @sumPrice_1 , @planDate_1 , @factnumber_n_1 , @factDate_1 , @isFinish_1 , @isRemind_1)


GO




alter PROCEDURE CRM_ContractProduct_Update1
	(
	 @id_1 	[int] ,	
	 @productId_1  [int]  ,
	 @unitId_1  [int]  ,
	 @currencyId_1  [int]  ,	 
	 @price_1  [decimal](17, 2)  ,	 
	 @depreciation_1  [int]  ,
	 @number_n_1  [int]  ,
	 @sumPrice_1  [decimal](17, 2)  ,
	 @planDate_1  [char] (10)   ,
	 @isRemind_1  [int]  ,
	 @flag integer output,
	 @msg varchar(80) output)

AS UPDATE CRM_ContractProduct SET 
	 productId = @productId_1 , 
	 unitId = @unitId_1, 
	 currencyId = @currencyId_1,
	 price = @price_1, 
	 depreciation = @depreciation_1,
	 number_n = @number_n_1 , 
	 sumPrice = @sumPrice_1, 
	 planDate = @planDate_1 ,
	 isRemind = @isRemind_1 where id = @id_1 


GO





alter PROCEDURE CRM_Contract_Insert 
	(@name_1  varchar (100)   ,
	 @typeId_1  int  ,	
	 @docId_1  varchar (100)   ,
	 @price_1  decimal(17, 2)  ,
	 @crmId_1  int  ,
	 @contacterId_1  int  ,
	 @startDate_1  char (10)   ,
	 @endDate_1  char (10)   ,
	 @manager_1  int  ,
	 @status_1  int  ,
	 @isRemind_1  int  ,
	 @remindDay_1  int  ,
	 @creater_1  int  ,
	 @createDate_1  char (10)   ,
	 @createTime_1  char (10)  ,
	 @prjid_1 int,
	 @flag integer output,
	 @msg varchar(80) output)

AS INSERT INTO CRM_Contract 
	 (name , 
	 typeId , 
	 docId , price , crmId , contacterId , startDate , endDate , manager , status , isRemind , remindDay , creater , createDate , createTime,projid) 
 
VALUES 
	( @name_1,
	 @typeId_1,
	 @docId_1, @price_1 , @crmId_1 , @contacterId_1 , @startDate_1 , @endDate_1 , @manager_1 , @status_1 , @isRemind_1 , @remindDay_1 , @creater_1 , @createDate_1 , @createTime_1,@prjid_1)
select top 1 * from CRM_Contract order by id desc


GO



alter PROCEDURE CRM_Contract_Update 
	(@id_1 	int ,
	 @name_1  varchar (100)   ,
	 @typeId_1  int  ,	
	 @docId_1  varchar (100)   ,
	 @price_1  decimal(17, 2)  ,
	 @crmId_1  int  ,
	 @contacterId_1  int  ,
	 @startDate_1  char (10)   ,
	 @endDate_1  char (10)   ,
	 @manager_1  int  ,
	 @status_1  int  ,
	 @isRemind_1  int  ,
	 @remindDay_1  int  ,
	 @prjid_1 int,
	 @flag integer output,
	 @msg varchar(80) output)

AS
UPDATE CRM_Contract SET name = @name_1, typeId = @typeId_1 , docId = @docId_1 , price = @price_1 , crmId = @crmId_1 , contacterId = @contacterId_1 , startDate = @startDate_1 , endDate = @endDate_1 , manager = @manager_1 , status = @status_1 , isRemind = @isRemind_1 , remindDay = @remindDay_1 ,projid=@prjid_1  where id = @id_1


GO

