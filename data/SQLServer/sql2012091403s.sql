ALTER TABLE CRM_PayInfo ALTER COLUMN factprice decimal(15,2)
GO

ALTER  PROCEDURE CRM_PayInfo_Insert
	@id_1		int,
	@factprice_1	decimal(15,2),
	@factdate_1 char(10),
	@creater_1 int,
    @formNum_1   [varchar] (150) ,
	@flag		int	output, 
	@msg		varchar(80) output
as
	insert into CRM_PayInfo
	(payid,factprice,factdate,creater,formNum)
	values
	(	@id_1,@factprice_1,	@factdate_1 ,@creater_1 ,@formNum_1)

GO