
INSERT INTO HtmlLabelIndex values(19387,'主目录编码') 
GO
INSERT INTO HtmlLabelIndex values(19388,'分目录编码') 
GO
INSERT INTO HtmlLabelIndex values(19389,'子目录编码') 
GO
INSERT INTO HtmlLabelIndex values(19386,'文档编码') 
GO
INSERT INTO HtmlLabelInfo VALUES(19386,'文档编码',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19386,'Document Code',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19387,'主目录编码',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19387,'MainCategory Code',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19388,'分目录编码',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19388,'SubCategory Code',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19389,'子目录编码',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19389,'SecCategory Code',8) 
GO
INSERT INTO HtmlLabelIndex values(19417,'子目录单独流水') 
GO
INSERT INTO HtmlLabelIndex values(19415,'启用子目录编码规则') 
GO
INSERT INTO HtmlLabelIndex values(19416,'子文档单独编码') 
GO
INSERT INTO HtmlLabelIndex values(19418,'日期单独流水') 
GO
INSERT INTO HtmlLabelInfo VALUES(19415,'启用子目录编码规则',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19415,'Use SecCategory Code Rule',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19416,'子文档单独编码',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19416,'SecDocument Code Alone',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19417,'子目录单独流水',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19417,'SecCategory Sequence Alone',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19418,'日期单独流水',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19418,'Date Sequence Alone',8) 
GO

INSERT INTO HtmlLabelIndex values(19381,'编码规则') 
GO
INSERT INTO HtmlLabelInfo VALUES(19381,'编码规则',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19381,'Code Rule',8) 
GO

INSERT INTO HtmlNoteIndex values(86,'该子目录下有文档存在，不能被删除！') 
GO
INSERT INTO HtmlNoteInfo VALUES(86,'该子目录下有文档存在，不能被删除！',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(86,'There are docs under this seccategory,it can''t be deleted!',8) 
GO

ALTER TABLE codemain ADD secDocCodeAlone char(1)
GO
ALTER TABLE codemain ADD secCategorySeqAlone char(1)
GO
ALTER TABLE codemain ADD dateSeqAlone char(1)
GO
ALTER TABLE codemain ADD dateSeqSelect char(1)
GO
ALTER TABLE codemain ADD secCategoryId int
GO

ALTER TABLE DocMainCategory ADD coder varchar(20)
go
ALTER TABLE DocSubCategory ADD coder varchar(20)
go
ALTER TABLE DocSecCategory ADD coder varchar(20)
go

CREATE TABLE DocSecCategoryCoderSeq (
	id int IDENTITY (1, 1) NOT NULL ,
	sequence int ,
	yearSeq int ,
	monthSeq int ,
	daySeq int ,
	secCategoryId int ,
	isUse char(1)
)
GO


ALTER   PROCEDURE Doc_SecCategory_Update (
@id	int,
@subcategoryid 	[int], 
@categoryname 	[varchar](200), 
@coder	[varchar](20), 
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
as update docseccategory set subcategoryid=@subcategoryid, categoryname=@categoryname, coder=@coder, docmouldid=@docmouldid,
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
insert into docseccategory(subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid,markable,markAnonymity,orderable,defaultLockedDoc,allownModiMShareL,allownModiMShareW,maxUploadFileSize,wordmouldid) 
values( @subcategoryid, @categoryname, @docmouldid, @publishable, @replyable, @shareable, @cusertype, @cuserseclevel, @cdepartmentid1, @cdepseclevel1, @cdepartmentid2, @cdepseclevel2, @croleid1, @crolelevel1, @croleid2, @crolelevel2, @croleid3, @crolelevel3, @hasaccessory, @accessorynum, @hasasset, @assetlabel, @hasitems, @itemlabel, @hashrmres, @hrmreslabel, @hascrm, @crmlabel, @hasproject, @projectlabel, @hasfinance, @financelabel, @approveworkflowid,@markable,@markAnonymity,@orderable,@defaultLockedDoc,@allownModiMShareL,@allownModiMShareW,@maxUploadFileSize,@wordmouldid) 
select max(id) from docseccategory 
GO

