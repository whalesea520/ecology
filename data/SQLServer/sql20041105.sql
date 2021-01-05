/* this sql sentence is modify dongping for TD1329
 * date 2003.11.3
 * this file is contain sql and oracle sentence
 **/


/*需要在sql数据库中执行的脚本*/

ALTER  PROCEDURE SysFavourite_Insert 
 (@Resourceid int,
 @Adddate char(10),
 @Addtime char(8),
 @Pagename    varchar(150),
 @URL     varchar(100),
 @flag int  output,
 @msg  varchar(80) output) 
 AS 
 declare    @totalcount   int 

 select @totalcount=count(*) from sysfavourite where URL=@URL and Resourceid = @Resourceid

 if @totalcount<=0 
     begin
         INSERT INTO SysFavourite ( Resourceid, Adddate, Addtime, Pagename, URL) 
         VALUES ( @Resourceid, @Adddate, @Addtime, @Pagename, @URL) 
        select 1
     end
else
    select 0
GO

