Alter table CRM_ProductTable Alter column salesnum decimal(12,2)
GO
ALTER procedure [dbo].[CRM_ProductTable_insert] ( @sellchanceid_1 int , @productid_1 int , @assetunitid_1 int , @currencyid_1 int , @salesprice_1 decimal(12,2) , @salesnum_1 decimal(12,2) , @totelprice_1 decimal(18,2) , @flag	int	output, @msg	varchar(4000)	output) as insert INTO CRM_ProductTable ( sellchanceid , productid , assetunitid, currencyid , salesprice , salesnum, totelprice ) values ( @sellchanceid_1  , @productid_1  , @assetunitid_1  , @currencyid_1  , @salesprice_1 , @salesnum_1  , @totelprice_1 ) 
GO