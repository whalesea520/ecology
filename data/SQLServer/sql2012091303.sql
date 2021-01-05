ALTER TABLE CptStockInDetail ALTER COLUMN  innumber  float
GO
ALTER TABLE CptStockInDetail ALTER COLUMN  plannumber  float
GO

ALTER  PROCEDURE CptStockInDetail_Insert ( 
@cptstockinid_1 	int  , 
@cpttype_1 		int  , 
@plannumber_1 		float, 
@innumber_1 		float, 
@price_1 		decimal(15, 2)  , 
@customerid_1		int  ,
@SelectDate_1		char(10)  ,
@capitalspec_1		varchar(60)  ,
@location_1		varchar(100)  ,
@invoice_1		varchar(80)  ,
@flag	int	output, 
@msg	varchar(80)	output ) AS 

INSERT INTO CptStockInDetail (cptstockinid, cpttype, plannumber, innumber, price, customerid, SelectDate, capitalspec, location, invoice) 
VALUES (@cptstockinid_1, @cpttype_1, @plannumber_1, @innumber_1 , @price_1, @customerid_1, @SelectDate_1, @capitalspec_1, @location_1, @invoice_1) 

select max(id) from CptStockInDetail

GO

ALTER PROCEDURE CptStockInDetail_Update (
	@id_1 [int] ,
	@innumber_1 [float] , 
	@flag	[int]	output, 
	@msg	[varchar](80)	output
)
AS 
update CptStockInDetail set  innumber=@innumber_1  where id = @id_1
GO