ALTER TABLE DocMould ADD
	mouldType int NULL,
	mouldPath varchar(200) NULL
GO

CREATE TABLE MouldBookMark(
	id int NOT NULL IDENTITY (1, 1),
	mouldId int NULL,
	name varchar(100) NULL,
	descript varchar(200) NULL
)
GO

CREATE TABLE DocMouldBookMark(
	id int NOT NULL IDENTITY (1, 1),
	docId int NULL,
	mouldId int NULL,
	bookMarkId int NULL,
	bookMarkValue varchar(200) NULL
)
GO

ALTER TABLE DocSecCategory ADD
	wordmouldid int NULL
GO

INSERT INTO HtmlLabelIndex values(19333,'从已有模板导入') 
GO
INSERT INTO HtmlLabelInfo VALUES(19333,'从已有模板导入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19333,'import from existing',8) 
GO
 
 ALTER   PROCEDURE Doc_SecCategory_Update (
@id	int,
@subcategoryid 	[int], 
@categoryname 	[varchar](200), 
@docmouldid 	[int], 
@publishable 	[char](1),
@replyable 	[char](1),
@shareable 	[char](1),
@cusertype 	[int],
@cuserseclevel 	[tinyint],
@cdepartmentid1 [int], 
@cdepseclevel1 	[tinyint],
@cdepartmentid2 [int],
@cdepseclevel2 	[tinyint],
@croleid1	[int],
@crolelevel1	[char](1), 
@croleid2	[int],
@crolelevel2 	[char](1),
@croleid3	[int], 
@crolelevel3 	[char](1), 
@hasaccessory	[char](1), 
@accessorynum	[tinyint], 
@hasasset	[char](1),
@assetlabel	[varchar](200),
@hasitems	[char](1), 
@itemlabel 	[varchar](200),
@hashrmres 	[char](1),
@hrmreslabel 	[varchar](200),
@hascrm	 	[char](1), 
@crmlabel	[varchar](200),
@hasproject 	[char](1), 
@projectlabel 	[varchar](200),
@hasfinance 	[char](1), 
@financelabel 	[varchar](200), 
@approveworkflowid	int, 
@markable  [char](1),
@markAnonymity [char](1),
@orderable [char](1),
@defaultLockedDoc int ,
@allownModiMShareL int,
@allownModiMShareW int,
@maxUploadFileSize int,
@wordmouldid int,
@flag	int output, @msg	varchar(80)	output) 
as update docseccategory set subcategoryid=@subcategoryid, categoryname=@categoryname, docmouldid=@docmouldid,
 publishable=@publishable, replyable=@replyable, shareable=@shareable, cusertype=@cusertype, cuserseclevel=@cuserseclevel, 
 cdepartmentid1=@cdepartmentid1, cdepseclevel1=@cdepseclevel1, cdepartmentid2=@cdepartmentid2, cdepseclevel2=@cdepseclevel2, 
 croleid1=@croleid1, crolelevel1=@crolelevel1, croleid2=@croleid2, crolelevel2=@crolelevel2, croleid3=@croleid3, crolelevel3=@crolelevel3,
  approveworkflowid=@approveworkflowid, hasaccessory=@hasaccessory, accessorynum=@accessorynum, hasasset=@hasasset,
   assetlabel=@assetlabel, hasitems=@hasitems, itemlabel=@itemlabel, hashrmres=@hashrmres, hrmreslabel=@hrmreslabel,
    hascrm=@hascrm, crmlabel=@crmlabel, hasproject=@hasproject, projectlabel=@projectlabel, hasfinance=@hasfinance,
     financelabel=@financelabel,markable=@markable ,markAnonymity=@markAnonymity,orderable=@orderable,defaultLockedDoc=@defaultLockedDoc,
     allownModiMShareL=@allownModiMShareL,allownModiMShareW=@allownModiMShareW ,maxUploadFileSize=@maxUploadFileSize
     ,wordmouldid=@wordmouldid
      where id=@id 


GO

Alter   PROCEDURE Doc_SecCategory_Insert ( 
  @subcategoryid 	int,
  @categoryname 	varchar(200), 
  @docmouldid 	int,
  @publishable 	char(1), 
  @replyable 	char(1),
  @shareable 	char(1),
  @cusertype 	int, 
  @cuserseclevel 	tinyint, 
  @cdepartmentid1 	int, 
  @cdepseclevel1 	tinyint,
  @cdepartmentid2 	int,
  @cdepseclevel2 	tinyint,
  @croleid1	 		int, 
  @crolelevel1	 	char(1), 
  @croleid2	 	int, 
  @crolelevel2 	char(1),
  @croleid3	 	int, 
  @crolelevel3 	char(1),
  @hasaccessory	 	char(1),
  @accessorynum	 	tinyint, 
  @hasasset		 	char(1),
  @assetlabel	 	varchar(200), 
  @hasitems	 	char(1),
  @itemlabel 	varchar(200), 
  @hashrmres 	char(1),
  @hrmreslabel 	varchar(200), 
  @hascrm	 	char(1),
  @crmlabel	 	varchar(200), 
  @hasproject 	char(1),
  @projectlabel 	varchar(200), 
  @hasfinance 	char(1), 
  @financelabel 	varchar(200), 
  @approveworkflowid	int,
  @markable  char(1),
  @markAnonymity char(1),
  @orderable char(1),
  @defaultLockedDoc int,
  @allownModiMShareL int,
  @allownModiMShareW int,
  @maxUploadFileSize int,
  @wordmouldid int,
  @flag	int output, 
  @msg	varchar(80)	output)
as 
insert into docseccategory values( @subcategoryid, @categoryname, @docmouldid, @publishable, @replyable, @shareable, @cusertype, @cuserseclevel, @cdepartmentid1, @cdepseclevel1, @cdepartmentid2, @cdepseclevel2, @croleid1, @crolelevel1, @croleid2, @crolelevel2, @croleid3, @crolelevel3, @hasaccessory, @accessorynum, @hasasset, @assetlabel, @hasitems, @itemlabel, @hashrmres, @hrmreslabel, @hascrm, @crmlabel, @hasproject, @projectlabel, @hasfinance, @financelabel, @approveworkflowid,@markable,@markAnonymity,@orderable,@defaultLockedDoc,@allownModiMShareL,@allownModiMShareW,@maxUploadFileSize,@wordmouldid) 
select max(id) from docseccategory 
GO

