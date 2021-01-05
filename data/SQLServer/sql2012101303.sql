ALTER TABLE HrmSalaryResourcePay ADD isBatch char(1) null
GO

ALTER PROCEDURE HrmSalaryResourcePay_Insert
  (@itemid_1 	int, @resourceid_2 	int, @resourcepay_3 	decimal(10,2),@isBatch_4 char,
   @flag	int	output, @msg	varchar(80)	output)  
   AS 
   INSERT INTO HrmSalaryResourcePay 
   (itemid, resourceid, resourcepay,isBatch)  
   VALUES ( @itemid_1, @resourceid_2, @resourcepay_3,@isBatch_4)
GO   