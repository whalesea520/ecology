ALTER TABLE HrmResource ADD accountname  varchar(200) NULL
GO
ALTER procedure [dbo].[HrmResourceFinanceInfo_Insert] (@id_1 int, @bankid1_2 int, @accountid1_3 varchar(4000), @accumfundaccount_4 varchar(4000),@accountname_5 varchar(4000), @flag int output, @msg varchar(4000) output) AS UPDATE HrmResource SET bankid1 = @bankid1_2, accountid1 = @accountid1_3 , accumfundaccount = @accumfundaccount_4, accountname = @accountname_5 WHERE id = @id_1 
GO