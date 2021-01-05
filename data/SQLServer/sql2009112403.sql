CREATE  PROCEDURE  GetDBDateAndTime @flag integer output , @msg varchar(80) output
AS 
declare @currentdate char(10),@currenttime char(8)
set @currentdate=convert(char(10),getdate(),20)
set @currenttime=convert(char(8),getdate(),108)
begin
	select @currentdate as dbdate,@currenttime as dbtime
end    

GO
