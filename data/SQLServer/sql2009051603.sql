drop PROCEDURE SysFavourite_Insert
GO

CREATE PROCEDURE SysFavourite_Insert
	@userid int,
	@adddate char(20),
	@pagename char(100),
	@url char(1000),
	@importlevel int,
	@favouritetype int,
	@flag integer output,
	@msg varchar(80) output
AS
	insert into sysfavourite(resourceid,adddate,pagename,url,importlevel,favouritetype)
	VALUES (@userid,@adddate,@pagename,@url,@importlevel,@favouritetype)
	select @@IDENTITY from sysfavourite
GO