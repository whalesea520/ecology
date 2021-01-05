ALTER PROCEDURE Prj_WorkType_SelectAll (@flag	[int]	output, @msg	[varchar](80)	output) AS SELECT * FROM [Prj_WorkType] order by id asc set @flag = 1 set @msg = 'OK!'

GO