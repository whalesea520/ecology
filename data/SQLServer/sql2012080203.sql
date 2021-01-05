CREATE   PROCEDURE Prj_ProjectInfo_UpdateForMoney ( 
	 @id_1   int,
     @budgetmoney_11     varchar(50), 
     @moneyindeed_12     varchar(50), 
     @budgetincome_13    varchar(50), 
     @imcomeindeed_14    varchar(50), 
     @flag   int output,
     @msg    varchar(80) output 
     ) 
  AS UPDATE Prj_ProjectInfo  SET  budgetmoney   = convert(money,@budgetmoney_11), moneyindeed  = convert(money,@moneyindeed_12), budgetincome  = convert(money,@budgetincome_13), imcomeindeed     = convert(money,@imcomeindeed_14)  WHERE ( id    = @id_1)
  GO