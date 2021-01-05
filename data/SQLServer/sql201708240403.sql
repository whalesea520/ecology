alter procedure [docReadTag_AddByUser] 
(@docid_1 	int , 
 @userid_2 	int , 
 @userType_3	int , 
 @flag	int	output, 
 @msg	varchar(4000)	output) 
 AS 
 declare @ifhaveread int,@readcount2 int
 select @ifhaveread = count(userid) 
 from docReadTag 
 where docid = @docid_1 and userid = @userid_2 and userType = @userType_3  
 select @readcount2=readcount+1
 from docReadTag
 where docid = @docid_1 and userid = @userid_2 and userType = @userType_3;
if @ifhaveread is not null and @ifhaveread > 0 
	update DocReadTag set readcount = @readcount2 
	where docid = @docid_1 and userid = @userid_2 and userType = @userType_3 
else 
	insert into  DocReadTag (docid,userid,readcount,usertype) 
	values(@docid_1, @userid_2, 1, @userType_3)		
GO