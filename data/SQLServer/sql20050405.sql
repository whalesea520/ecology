CREATE PROCEDURE DocShare_DeleteByDocidUserid 
(@docid    int, @userid    int, @flag	int output, @msg	varchar(80)	output) as 

delete from docshare where docid=@docid and userid=@userid

GO
