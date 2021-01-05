alter procedure [docReadTag_AddByUser] 
(@docid_1 	int , 
@userid_2 	int , 
@userType_3	int , 
@flag	int	output, 
@msg	varchar(4000)	output) 
AS 
declare 
@readcount int select @readcount = count(userid) from docReadTag where docid = @docid_1 and userid = @userid_2 and userType = @userType_3 
if @readcount is not null and @readcount > 0 
update DocReadTag set readcount = readcount+1 where docid = @docid_1 and userid = @userid_2 and userType = @userType_3 
else 
insert into  DocReadTag (docid,userid,readcount,usertype) values(@docid_1, @userid_2, 1, @userType_3)
go