CREATE PROCEDURE workflow_CurOpe_UbySend 
	@requestid	integer, 
	@userid		integer, 
	@usertype	integer, 
	@flag 		integer 	output , 
	@msg 		varchar(80) 	output 
AS declare 
	@currentdate char(10), 
	@currenttime char(8)  
	set @currentdate=convert(char(10),getdate(),20) 
	set @currenttime=convert(char(8),getdate(),108)  
update workflow_currentoperator 
set isremark=2,operatedate=@currentdate,operatetime=@currenttime 
where requestid =@requestid and userid =@userid and usertype=@usertype and isremark=9
GO

Alter PROCEDURE workflow_groupdetail_SByGroup (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) 
AS select *, 1+orders as sort from (SELECT top 10000 * FROM workflow_groupdetail 
WHERE ( groupid = @id and ((signorder != 3 and  signorder != 4) or signorder is null) ) 
order by orders,id)a
union
select *,10000+signorder as sort from (SELECT top 10000 * FROM workflow_groupdetail
WHERE groupid = @id and (signorder = 3 or signorder = 4)
order by signorder,id)b
order by sort
set @flag = 1 set @msg = 'OK!'

GO
