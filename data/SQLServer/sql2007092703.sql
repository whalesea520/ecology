alter PROCEDURE Meeting_Decision_SelectAll ( @meetingid int,  @flag	int	output, @msg	varchar(80)	output) AS SELECT * FROM Meeting_Decision where meetingid = @meetingid  order by id set @flag = 1 set @msg = 'OK!' 

GO