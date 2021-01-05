alter table workflow_SelectItem add id int IDENTITY
go

ALTER PROCEDURE workflow_SelectItemSelectByid @id varchar(100) , 
@isbill varchar(100) , @flag integer output , @msg varchar(80) output 
AS
select * from workflow_SelectItem where fieldid = @id and isbill = @isbill 
order by id set  @flag = 0 set  @msg = ''
GO
