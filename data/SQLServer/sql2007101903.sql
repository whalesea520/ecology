ALTER PROCEDURE CRM_ContacterTitle_SelectAll (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [CRM_ContacterTitle] order by id set @flag = 1 set @msg = 'OK!'

GO
