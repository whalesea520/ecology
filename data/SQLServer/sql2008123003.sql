alter table sysfavourite drop column addtime
go
alter table sysfavourite alter column Adddate [varchar] (20)
go
alter table sysfavourite add  importlevel [int] NULL
go
alter table sysfavourite add  favouritetype [int] NULL DEFAULT (0)
go



CREATE TABLE [SysFavourite_favourite] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[favouriteid] [int] NULL ,
	[sysfavouriteid] [int] NULL ,
	[resourceid] [int] NULL ,
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO


CREATE TABLE [favourite] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[Resourceid] [int] NULL ,
	[Adddate] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[favouritename] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,
	[favouritedesc] [varchar] (1000) COLLATE Chinese_PRC_CI_AS NULL ,
	[displayorder] [int] NULL ,
	[parentid] [int] NULL ,
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO


CREATE TABLE [favourite_tab] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[favouriteid] [int] NULL ,
	[tabid] [int] NULL ,
	[favouriteAlias] [varchar] (200) COLLATE Chinese_PRC_CI_AS NULL ,
	[favouritePageSize] [int] NULL DEFAULT (10),
	[favouriteTitleSize] [int] NULL DEFAULT (25),
	[showFavouriteTitle] [int] NULL DEFAULT (1),
	[showFavouriteLevel] [int] NULL DEFAULT (1),
	[Resourceid] [int] NULL ,
	[position] [int] NULL DEFAULT (1),
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO


CREATE TABLE [favouritetab] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[Resourceid] [int] NULL ,
	[Adddate] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[tabname] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,
	[tabdesc] [varchar] (1000) COLLATE Chinese_PRC_CI_AS NULL ,
	[displayorder] [int] NULL ,
	 PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO


CREATE TABLE [FavouriteLastActive] (
	[activeid] [int] NULL ,
	[Resourceid] [int] NULL ,
	[activetitle] [varchar] (150) COLLATE Chinese_PRC_CI_AS NULL ,
	[activetype] [int] NULL 
) ON [PRIMARY]
GO




CREATE PROCEDURE Favourite_Insert
	@userid int,
	@adddate char(20),
	@favouritename char(100),
	@favouritedesc char(200),
	@displayorder int,
	@parentid int,
	@flag integer output,
	@msg varchar(80) output
AS
	insert into favourite(resourceid,adddate,favouritename,favouritedesc,displayorder,parentid)
	VALUES (@userid,@adddate,@favouritename,@favouritedesc,@displayorder,@parentid)
	select @@IDENTITY from favourite
GO


CREATE PROCEDURE Favourite_Tab_Insert
	@favouriteid int,
	@tabid int,
	@favouritealias char(100),
	@favouritepagesize int,
	@favouritetitlesize int,
	@showFavouritetitle int,
	@showfavouritelevel int,
	@resourceid int,
	@flag integer output,
	@msg varchar(80) output
AS
	insert into favourite_tab(favouriteid,tabid,favouriteAlias,favouritepagesize,favouritetitlesize,showFavouritetitle,showfavouritelevel,resourceid)
	VALUES (@favouriteid,@tabid,@favouritealias,@favouritepagesize,@favouritetitlesize,@showFavouritetitle,@showfavouritelevel,@resourceid)
	select @@IDENTITY from favourite_tab
GO


CREATE PROCEDURE FavouriteTab_Insert
	@resourceid int,
	@adddate char(20),
	@tabname char(100),
	@tabdesc char(200),
	@displayorder int,
	@flag integer output,
	@msg varchar(80) output
AS
	insert into favouritetab(resourceid,adddate,tabname,tabdesc,displayorder)
	VALUES (@resourceid,@adddate,@tabname,@tabdesc,@displayorder)
	select @@IDENTITY from favouritetab
GO


ALTER PROCEDURE SysFavourite_Insert
	@userid int,
	@adddate char(20),
	@pagename char(100),
	@url char(100),
	@importlevel int,
	@favouritetype int,
	@flag integer output,
	@msg varchar(80) output
AS
	insert into sysfavourite(resourceid,adddate,pagename,url,importlevel,favouritetype)
	VALUES (@userid,@adddate,@pagename,@url,@importlevel,@favouritetype)
	select @@IDENTITY from sysfavourite
GO



CREATE PROCEDURE SelectSysFavourite_Insert
	@sysfavouriteid int,
	@adddate varchar(20),
	@flag integer output,
	@msg varchar(80) output
AS
	insert into sysfavourite
	  (resourceid, adddate, pagename, url, importlevel,favouritetype)
	  select resourceid, @adddate, pagename, url, importlevel,favouritetype
	    from sysfavourite
	   where id = @sysfavouriteid
	select @@IDENTITY from sysfavourite
GO

drop PROCEDURE SysFavourite_SelectByUserID
go

CREATE PROCEDURE SysFavourite_SelectByUserID 
@resourceid int,
@flag integer output,
@msg varchar(80) output
as select top 20 * from sysfavourite where resourceid=@resourceid order by resourceid,adddate desc
GO

update sysfavourite set importlevel=1,favouritetype=0
GO

insert into sysfavourite_favourite
  (favouriteid, sysfavouriteid, resourceid)
  select -1, id, resourceid
    from sysfavourite
   where id not in (select sysfavouriteid from sysfavourite_favourite)
GO