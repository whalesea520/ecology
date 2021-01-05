CREATE TABLE cowork_hidden(
	id int IDENTITY(1,1) NOT NULL,
	coworkid int NULL,
	userid int NULL,
 CONSTRAINT PK_cowork_hidden PRIMARY KEY(id) 
)
GO

CREATE TABLE cowork_important(
	id int IDENTITY(1,1) NOT NULL,
	coworkid int NULL,
	userid int NULL,
 CONSTRAINT PK_cowork__important PRIMARY KEY(id)
)
GO

CREATE TABLE cowork_item_label(
	id int IDENTITY(1,1) NOT NULL,
	coworkid int NULL,
	labelid int NULL,
 CONSTRAINT PK_cowork_item_label PRIMARY KEY (id)
)
GO

CREATE TABLE cowork_read(
	id int IDENTITY(1,1) NOT NULL,
	coworkid int NULL,
	userid int NULL,
 CONSTRAINT PK_cowork_read PRIMARY KEY (id) 
)
GO

CREATE TABLE cowork_label(
	id int IDENTITY(1,1) NOT NULL,
	userid int NULL,
	name varchar(200),
	icon varchar(200),
	createdate varchar(50),
	createtime varchar(50),
 CONSTRAINT PK_cowork_label PRIMARY KEY (id) 
)
GO

ALTER TABLE cowork_discuss   ADD  id  int primary key  identity(1,1)
GO
ALTER TABLE cowork_discuss   ADD floorNum int null
GO
ALTER TABLE cowork_discuss   ADD replayid int null
GO

update cowork_discuss set replayid=0
Go

create table  coworkshare (
  id int IDENTITY (1, 1) NOT NULL,
  sourceid      int         NOT NULL,
  type      int         NOT NULL, 
  content      varchar(4000)         NOT NULL,
  seclevel      int         NOT NULL, 
  sharelevel      int         NOT NULL,
   srcfrom      int         NOT NULL
)
GO

ALTER PROCEDURE cowork_discuss_insert (
	@coworkid_1 	[int],
	@discussant_2 	[int],
	@createdate_3 	[char](10),
	@createtime_4 	[char](8),
	@remark_5 	[text],
	@relatedprj_6  [varchar](500),
	@relatedcus_7  [varchar](500),
	@relatedwf_8 	[varchar](500),
	@relateddoc_9  [varchar](500),
	@relatedacc_10 [varchar](500), 
	@mutil_prjs_11 [varchar](500),
	@floorNum_12 [int],@replayid_13 [int],
	@flag integer output , 
	@msg varchar(80) output
)
AS INSERT INTO [cowork_discuss] (
	[coworkid], 
	[discussant],
	[createdate],
	[createtime],
	[remark],
	[relatedprj],
	[relatedcus], 
	[relatedwf], 
	[relateddoc],
	[ralatedaccessory],
	[mutil_prjs],
	[floorNum],
	[replayid])
    VALUES (
	@coworkid_1,
	@discussant_2,
	@createdate_3,
	@createtime_4,
	@remark_5,
	@relatedprj_6,
	@relatedcus_7,
	@relatedwf_8,
	@relateddoc_9,
	@relatedacc_10,
	@mutil_prjs_11,
	@floorNum_12,
	@replayid_13)
GO
