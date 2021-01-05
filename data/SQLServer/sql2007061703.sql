 ALTER TABLE SysFavourite
ALTER COLUMN url varchar(1000)
GO

 
 Alter PROCEDURE SysFavourite_Insert (
 @Resourceid int, 
 @Adddate char(10), 
 @Addtime char(8), 
 @Pagename    varchar(150), 
 @URL     varchar(1000), 
 @flag int  output, 
 @msg  varchar(80) output) 
 AS 
 declare    @totalcount   int 
 select @totalcount=count(*) from sysfavourite where URL=@URL 
 if @totalcount<=0 
 begin 
 INSERT INTO SysFavourite ( Resourceid, Adddate, Addtime, Pagename, URL) VALUES ( @Resourceid, @Adddate, @Addtime, @Pagename, @URL) 
 select 1 end else select 0
GO