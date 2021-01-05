
ALTER PROCEDURE workflow_SelectItemSelectByid @id varchar(100) , 
@isbill varchar(100) , @flag integer output , @msg varchar(80) output 
AS
select * from workflow_SelectItem where fieldid = @id and isbill = @isbill 
order by listorder,id set  @flag = 0 set  @msg = ''

GO