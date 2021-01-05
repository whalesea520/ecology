INSERT INTO HtmlLabelIndex values(19330,'警告：数据太大，无法保存！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19330,'警告：数据太大，无法保存！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19330,'Alert:the data is too large,and it can''t be saved!',8) 
GO

alter table CRM_ContractProduct add tempcol decimal(10,2)
GO
update CRM_ContractProduct set tempcol = number_n
GO
alter table CRM_ContractProduct drop column number_n
GO
alter table CRM_ContractProduct add number_n decimal(10,2)
GO
update CRM_ContractProduct set number_n = tempcol
GO
alter table CRM_ContractProduct drop column tempcol
GO

Alter PROCEDURE CRM_ContractProduct_Insert ( 
	@contractId_1  [int]  , 
	@productId_1  [int]  , 
	@unitId_1  [int]  , 
	@number_n_1  [decimal](10, 2)  , 
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
AS INSERT INTO [CRM_ContractProduct] (
	contractId , 
	productId , 
	unitId , 
	number_n , 
	price , 
	currencyId , 
	depreciation , 
	sumPrice , 
	planDate , 
	factnumber_n , 
	factDate , 
	isFinish , 
	isRemind )  
VALUES ( 
	@contractId_1, 
	@productId_1, 
	@unitId_1, 
	@number_n_1 , 
	@price_1 , 
	@currencyId_1 , 
	@depreciation_1 , 
	@sumPrice_1 , 
	@planDate_1 , 
	@factnumber_n_1 , 
	@factDate_1 , 
	@isFinish_1 , 
	@isRemind_1)  
GO


Alter PROCEDURE CRM_ContractProduct_Update1 ( 
	@id_1 	[int] , 
	@productId_1  [int]  , 
	@unitId_1  [int]  , 
	@currencyId_1  [int]  , 
	@price_1  [decimal](17, 2)  , 
	@depreciation_1  [int]  , 
	@number_n_1  [decimal](10, 2)  , 
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
	isRemind = @isRemind_1 
	where id = @id_1  
GO

