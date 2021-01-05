ALTER PROCEDURE CRM_Contract_Select
	(@crmId_1 [int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)

AS
SELECT * FROM CRM_Contract  where crmId = @crmId_1 order by id asc


GO
