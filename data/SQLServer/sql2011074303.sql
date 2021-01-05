Alter PROCEDURE workflow_groupdetail_SByGroup (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) 
AS
SELECT *, case when signorder in(3,4) then 10000+signorder else 1+orders  end as sort from workflow_groupdetail where groupid=@id order by sort,id
set @flag = 1 set @msg = 'OK!'

GO