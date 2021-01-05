CREATE PROCEDURE workflow_CurOpe_UpdatebyPass
@requestid	int, 
@flag 		integer 	output , 
@msg 		varchar(80) 	output AS 

declare 
@currentdate char(10), 
@currenttime char(8)  
set @currentdate=convert(char(10),getdate(),20) 
set @currenttime=convert(char(8),getdate(),108)  

update workflow_currentoperator 
set isremark = '2',operatedate=@currentdate,operatetime=@currenttime 
where requestid =@requestid and isremark=0 
GO

