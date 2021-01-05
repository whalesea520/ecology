ALTER TABLE DocMainCategory ADD
	norepeatedname int NULL
GO

ALTER TABLE DocSubCategory ADD
	norepeatedname int NULL
GO

ALTER TABLE DocSecCategory ADD
	nodownload int NULL,
	norepeatedname int NULL,
	iscontroledbydir int NULL,
	puboperation int NULL,
	childdocreadremind int NULL,
	readoptercanprint int NULL,
	editionIsOpen int NULL,
	editionPrefix VARCHAR(100) NULL,
	readerCanViewHistoryEdition int NULL
GO

CREATE TABLE DocSecCategoryMould (
	id int IDENTITY(1,1) NOT NULL,
	secCategoryId int NULL,
	mouldType int NULL,
	mouldId int NULL,
	isDefault int NULL,
	mouldBind int NULL
)
GO

CREATE TABLE DocSecCategoryMouldBookMark (
	DocSecCategoryMouldId int NULL,
	BookMarkId int NULL,
	DocSecCategoryDocPropertyId int NULL
)
GO

CREATE TABLE DocSecCategoryDocProperty (
	id int IDENTITY(1,1) NOT NULL,
	secCategoryId int NULL,
	viewindex int NULL,
	type int NULL,
	labelid int NULL,
	visible int NULL,
	customName VARCHAR(100) NULL,
	columnWidth int NULL,
	mustInput int NULL,
	isCustom int NULL,
	scope VARCHAR(50) NULL,
	scopeid int NULL,
	fieldid int NULL
)
GO


ALTER TABLE DocDetail ADD
	doccode VARCHAR(50) NULL,
	docedition int NULL,
	doceditionid int NULL,
	ishistory int NULL,
	maindoc int NULL,
	approvetype int NULL,
	readoptercanprint int NULL,
	docvaliduserid int NULL,
	docvaliddate char(10) NULL,
	docvalidtime char(8) NULL,
	docpubuserid int NULL,
	docpubdate char(10) NULL,
	docpubtime char(8) NULL,
	docreopenuserid int NULL,
	docreopendate char(10) NULL,
	docreopentime char(8) NULL,
	docinvaluserid int NULL,
	docinvaldate char(10) NULL,
	docinvaltime char(8) NULL,
	doccanceluserid int NULL,
	doccanceldate char(10) NULL,
	doccanceltime char(8) NULL,
	selectedpubmouldid int NULL
GO

UPDATE DocDetail SET ishistory = 0
GO



CREATE TABLE DocSecCategoryTemplate (
	id int IDENTITY NOT NULL,
	name varchar(200) NULL,
	subcategoryid int NULL,
	categoryname varchar(200) NULL,
	docmouldid int NULL,
	publishable char(1) NULL,
	replyable char(1) NULL,
	shareable char(1) NULL,
	cusertype char(1) NULL,
	cuserseclevel tinyint NULL,
	cdepartmentid1 int NULL,
	cdepseclevel1 tinyint NULL,
	cdepartmentid2 int NULL,
	cdepseclevel2 tinyint NULL,
	croleid1 int NULL,
	crolelevel1 char(1) NULL,
	croleid2 int NULL,
	crolelevel2 char(1) NULL,
	croleid3 int NULL,
	crolelevel3 char(1) NULL,
	hasaccessory char(1) NULL,
	accessorynum tinyint NULL,
	hasasset char(1) NULL,
	assetlabel varchar(200) NULL,
	hasitems char(1) NULL,
	itemlabel varchar(200) NULL,
	hashrmres char(1) NULL,
	hrmreslabel varchar(200) NULL,
	hascrm char(1) NULL,
	crmlabel varchar(200) NULL,
	hasproject char(1) NULL,
	projectlabel varchar(200) NULL,
	hasfinance char(1) NULL,
	financelabel varchar(200) NULL,
	approveworkflowid int NULL,
	markable char(1) NULL,
	markAnonymity char(1) NULL,
	orderable char(1) NULL DEFAULT (0),
	defaultLockedDoc int NULL DEFAULT (0),
	allownModiMShareL int NULL,
	allownModiMShareW int NULL,
	maxUploadFileSize int NULL DEFAULT (5),
	wordmouldid int NULL,
	coder varchar(20) NULL,
	isSetShare int NULL,
	nodownload int NULL,
	norepeatedname int NULL,
	iscontroledbydir int NULL,
	puboperation int NULL,
	childdocreadremind int NULL,
	readoptercanprint int NULL,
	editionIsOpen int NULL,
	editionPrefix varchar(100) NULL,
	readerCanViewHistoryEdition int NULL,
	isOpenApproveWf char(1) NULL,
	validityApproveWf int NULL,
	invalidityApproveWf int NULL
)
GO

ALTER TABLE DirAccessControlList ADD
DocSecCategoryTemplateId int NULL
GO

ALTER TABLE secCreaterDocPope ADD
DocSecCategoryTemplateId int NULL
GO

ALTER TABLE DocSecCategoryShare ADD
DocSecCategoryTemplateId int NULL
GO

ALTER TABLE CodeMain ADD
DocSecCategoryTemplateId int NULL
GO

ALTER TABLE DocSecCategoryDocProperty ADD
DocSecCategoryTemplateId int NULL
GO

ALTER TABLE DocSecCategoryMould ADD
DocSecCategoryTemplateId int NULL
GO



insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4166,'文档发布','DocEdit:Publish',16) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4167,'文档失效','DocEdit:Invalidate',16) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4168,'文档作废','DocEdit:Cancel',16) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4169,'文档重新打开','DocEdit:Reopen',16) 
GO


INSERT INTO SequenceIndex(indexdesc,currentid) values('doceditionid',1)
GO

INSERT INTO HtmlLabelIndex values(19449,'禁止文档重名') 
GO
INSERT INTO HtmlLabelInfo VALUES(19449,'禁止文档重名',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19449,'No repeated document name',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19450,'版本管理') 
GO
INSERT INTO HtmlLabelInfo VALUES(19450,'版本管理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19450,'Edition Manager',8) 
GO

INSERT INTO HtmlLabelIndex values(19451,'文档属性页') 
GO
INSERT INTO HtmlLabelInfo VALUES(19451,'文档属性页',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19451,'Document Properties',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19456,'目录模版') 
GO
INSERT INTO HtmlLabelInfo VALUES(19456,'目录模版',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19456,'DirectoryMould',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19457,'允许发布为新闻') 
GO
INSERT INTO HtmlLabelInfo VALUES(19457,'允许发布为新闻',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19457,'can be published to news',8) 
GO

INSERT INTO HtmlLabelIndex values(19458,'禁止文档下载') 
GO
INSERT INTO HtmlLabelInfo VALUES(19458,'禁止文档下载',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19458,'No download',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19459,'是否受控目录') 
GO
INSERT INTO HtmlLabelInfo VALUES(19459,'是否受控目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19459,'is controled by directory',8) 
GO

INSERT INTO HtmlLabelIndex values(19460,'发布操作') 
GO
INSERT INTO HtmlLabelInfo VALUES(19460,'发布操作',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19460,'publication operation',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19461,'子文档阅读提醒') 
GO
INSERT INTO HtmlLabelInfo VALUES(19461,'子文档阅读提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19461,'child document read Remind',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19462,'允许只读操作人打印') 
GO
INSERT INTO HtmlLabelInfo VALUES(19462,'允许只读操作人打印',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19462,'read operator can print',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19463,'由文档设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(19463,'由文档设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19463,'by document setting',8) 
GO


INSERT INTO HtmlLabelIndex values(19468,'另存为模板') 
GO
INSERT INTO HtmlLabelInfo VALUES(19468,'另存为模板',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19468,'Save as template',8) 
GO

INSERT INTO HtmlLabelIndex values(19471,'模版类型') 
GO
INSERT INTO HtmlLabelInfo VALUES(19471,'模版类型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19471,'Mould Type',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19472,'模版选择') 
GO
INSERT INTO HtmlLabelInfo VALUES(19472,'模版选择',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19472,'Select Mould',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19473,'模版绑定') 
GO
INSERT INTO HtmlLabelInfo VALUES(19473,'模版绑定',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19473,'Bind Mould',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19474,'html显示模版') 
GO
INSERT INTO HtmlLabelIndex values(19475,'html编辑模版') 
GO
INSERT INTO HtmlLabelIndex values(19476,'word显示模版') 
GO
INSERT INTO HtmlLabelIndex values(19477,'word编辑模版') 
GO
INSERT INTO HtmlLabelInfo VALUES(19474,'html显示模版',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19474,'HTML View Mould',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19475,'html编辑模版',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19475,'HTML Edit Mould',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19476,'word显示模版',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19476,'WORD View Mould',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19477,'word编辑模版',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19477,'WORD Edit Mould',8) 
GO

INSERT INTO HtmlLabelIndex values(19478,'正常文档绑定') 
GO
INSERT INTO HtmlLabelInfo VALUES(19478,'正常文档绑定',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19478,'Normal Document Binded',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19479,'临时文档绑定') 
GO
INSERT INTO HtmlLabelInfo VALUES(19479,'临时文档绑定',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19479,'Temporary Document Binded',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19480,'内容设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(19480,'内容设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19480,'Content Setting',8) 
GO

INSERT INTO HtmlLabelIndex values(19499,'模版字段关联赋值') 
GO
INSERT INTO HtmlLabelInfo VALUES(19499,'模版字段关联赋值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19499,'Mould Field Association Evaluate',8) 
GO

INSERT INTO HtmlLabelIndex values(19505,'同一种模版类型和同一种模版绑定只能选择一个默认值!') 
GO
INSERT INTO HtmlLabelInfo VALUES(19505,'同一种模版类型和同一种模版绑定只能选择一个默认值!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19505,'Same Mould and Same Mould Bind can select only one default value!',8) 
GO

INSERT INTO HtmlLabelIndex values(19506,'同一种模版类型只能选择一个正常文档绑定!') 
GO
INSERT INTO HtmlLabelInfo VALUES(19506,'同一种模版类型只能选择一个正常文档绑定!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19506,'Same Mould Type can select only one normal document binding!',8) 
GO

INSERT INTO HtmlLabelIndex values(19507,'同一种模版类型只能选择一个临时文档绑定!') 
GO
INSERT INTO HtmlLabelInfo VALUES(19507,'同一种模版类型只能选择一个临时文档绑定!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19507,'Same Mould Type can select only one temporary document binding!',8) 
GO

INSERT INTO HtmlLabelIndex values(19508,'未选择模版') 
GO
INSERT INTO HtmlLabelInfo VALUES(19508,'未选择模版',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19508,'No mould is selected !',8) 
GO

INSERT INTO HtmlLabelIndex values(19509,'列宽') 
GO
INSERT INTO HtmlLabelInfo VALUES(19509,'列宽',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19509,'col width',8) 
GO

INSERT INTO HtmlLabelIndex values(19511,'显示模版')
GO
INSERT INTO HtmlLabelInfo VALUES(19511,'显示模版',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19511,'Display Mould',8)
GO

INSERT INTO HtmlLabelIndex values(19512,'关键字')
GO
INSERT INTO HtmlLabelInfo VALUES(19512,'关键字',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19512,'Key Word',8)
GO

INSERT INTO HtmlLabelIndex values(19513,'主文档')
GO
INSERT INTO HtmlLabelInfo VALUES(19513,'主文档',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19513,'Main Document',8)
GO

INSERT INTO HtmlLabelIndex values(19515,'被引用列表')
GO
INSERT INTO HtmlLabelInfo VALUES(19515,'被引用列表',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19515,'refered list',8)
GO

INSERT INTO HtmlLabelIndex values(19516,'自定义') 
GO
INSERT INTO HtmlLabelInfo VALUES(19516,'自定义',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19516,'user-defined',8) 
GO

INSERT INTO HtmlLabelIndex values(19522,'自定义字段标签不能为空') 
GO
INSERT INTO HtmlLabelIndex values(19523,'自定义字段标签不能相同') 
GO
INSERT INTO HtmlLabelInfo VALUES(19522,'自定义字段标签不能为空',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19522,'User Definition Field Label can not be Null',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19523,'自定义字段标签不能相同',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19523,'User Definition Field Label can not be Same',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19528,'只读权限操作人可查看历史版本') 
GO
INSERT INTO HtmlLabelInfo VALUES(19528,'只读权限操作人可查看历史版本',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19528,'read-only operator can view history edition',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19541,'文档标题') 
GO
INSERT INTO HtmlLabelInfo VALUES(19541,'文档标题',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19541,'Document Title',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19542,'文档编号') 
GO
INSERT INTO HtmlLabelInfo VALUES(19542,'文档编号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19542,'Document Number',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19543,'文档版本') 
GO
INSERT INTO HtmlLabelInfo VALUES(19543,'文档版本',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19543,'Document Edition',8) 
GO

INSERT INTO HtmlLabelIndex values(19544,'文档状态') 
GO
INSERT INTO HtmlLabelInfo VALUES(19544,'文档状态',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19544,'Document Status',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19587,'版本信息') 
GO
INSERT INTO HtmlLabelInfo VALUES(19587,'版本信息',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19587,'Edition',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19588,'回复信息') 
GO
INSERT INTO HtmlLabelInfo VALUES(19588,'回复信息',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19588,'Reply Info',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19661,'共有') 
GO
INSERT INTO HtmlLabelIndex values(19662,'个版本') 
GO
INSERT INTO HtmlLabelInfo VALUES(19661,'共有',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19661,'Total',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19662,'个版本',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19662,'Edition',8) 
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
  @isSetShare int,
  @noDownload int,
  @noRepeatedName int,
  @isControledByDir int,
  @pubOperation int,
  @childDocReadRemind int,
  @readOpterCanPrint int,
  @flag	int output, 
  @msg	varchar(80)	output)
as 
insert into docseccategory(subcategoryid,categoryname,docmouldid,publishable,replyable,shareable,cusertype,cuserseclevel,cdepartmentid1,cdepseclevel1,cdepartmentid2,cdepseclevel2,croleid1,crolelevel1,croleid2,crolelevel2,croleid3,crolelevel3,hasaccessory,accessorynum,hasasset,assetlabel,hasitems,itemlabel,hashrmres,hrmreslabel,hascrm,crmlabel,hasproject,projectlabel,hasfinance,financelabel,approveworkflowid,markable,markAnonymity,orderable,defaultLockedDoc,allownModiMShareL,allownModiMShareW,maxUploadFileSize,wordmouldid,isSetShare,nodownload,norepeatedname,iscontroledbydir,puboperation,childdocreadremind,readoptercanprint) 
values( @subcategoryid, @categoryname, @docmouldid, @publishable, @replyable, @shareable, @cusertype, @cuserseclevel, @cdepartmentid1, @cdepseclevel1, @cdepartmentid2, @cdepseclevel2, @croleid1, @crolelevel1, @croleid2, @crolelevel2, @croleid3, @crolelevel3, @hasaccessory, @accessorynum, @hasasset, @assetlabel, @hasitems, @itemlabel, @hashrmres, @hrmreslabel, @hascrm, @crmlabel, @hasproject, @projectlabel, @hasfinance, @financelabel, @approveworkflowid,@markable,@markAnonymity,@orderable,@defaultLockedDoc,@allownModiMShareL,@allownModiMShareW,@maxUploadFileSize,@wordmouldid,@isSetShare,@noDownload,@noRepeatedName,@isControledByDir,@pubOperation,@childDocReadRemind,@readOpterCanPrint) 
select max(id) from docseccategory 
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
@isSetShare int,
@noDownload int,
@noRepeatedName int,
@isControledByDir int,
@pubOperation int,
@childDocReadRemind int,
@readOpterCanPrint int,
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
     ,wordmouldid=@wordmouldid,isSetShare=@isSetShare,
     nodownload=@noDownload,norepeatedname=@noRepeatedName,iscontroledbydir=@isControledByDir,
     puboperation=@pubOperation,childdocreadremind=@childDocReadRemind,readoptercanprint=@readOpterCanPrint
      where id=@id 


GO

INSERT INTO HtmlLabelIndex values(19536,'文档生效审批') 
GO
INSERT INTO HtmlLabelIndex values(19538,'字段关联赋值') 
GO
INSERT INTO HtmlLabelIndex values(19535,'审批类型') 
GO
INSERT INTO HtmlLabelIndex values(19539,'文挡属性页字段') 
GO
INSERT INTO HtmlLabelIndex values(19537,'文档失效审批') 
GO
INSERT INTO HtmlLabelInfo VALUES(19535,'审批类型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19535,'Approve Type',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19536,'文档生效审批',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19536,'Document Validity Approve',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19537,'文档失效审批',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19537,'Document Invalidity Approve',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19538,'字段关联赋值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19538,'Field Association Evaluate',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19539,'文挡属性页字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19539,'Document Properties Field',8) 
GO

INSERT INTO HtmlLabelIndex values(19540,'启用审批工作流') 
GO
INSERT INTO HtmlLabelInfo VALUES(19540,'启用审批工作流',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19540,'Open Approve Workflow',8) 
GO

INSERT INTO HtmlLabelIndex values(19546,'请先选择审批流程！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19546,'请先选择审批流程！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19546,'Please choose the approve workflow first!',8) 
GO

INSERT INTO HtmlLabelIndex values(19561,'置为') 
GO
INSERT INTO HtmlLabelInfo VALUES(19561,'置为',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19561,'Set as',8) 
GO

INSERT INTO HtmlLabelIndex values(19562,'当前字段没有其他属性！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19562,'当前字段没有其他属性！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19562,'Current field hasn''t other attribute!',8) 
GO

INSERT INTO HtmlLabelIndex values(19563,'生效/正常') 
GO
INSERT INTO HtmlLabelIndex values(19564,'待发布') 
GO
INSERT INTO HtmlLabelInfo VALUES(19563,'生效/正常',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19563,'Valid/Normal',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19564,'待发布',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19564,'Be about to publish',8) 
GO


INSERT INTO HtmlLabelIndex values(19615,'批量审批') 
GO
INSERT INTO HtmlLabelInfo VALUES(19615,'批量审批',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19615,'Batch Approve',8) 
GO

INSERT INTO HtmlLabelIndex values(19686,'重新打开归档') 
GO
INSERT INTO HtmlLabelIndex values(19687,'重新打开作废') 
GO
INSERT INTO HtmlLabelIndex values(19688,'强制签入') 
GO
INSERT INTO HtmlLabelInfo VALUES(19686,'重新打开归档',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19686,'Reopen From Archive',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19687,'重新打开作废',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19687,'Reopen From Cancellation',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19688,'强制签入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19688,'Check In Compellably',8) 
GO

INSERT INTO HtmlLabelIndex values(19689,'请先选择操作的记录！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19689,'请先选择操作的记录！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19689,'Please choose the operated record first!',8) 
GO


INSERT INTO HtmlLabelIndex values(19690,'签出人') 
GO
INSERT INTO HtmlLabelIndex values(19693,'签入') 
GO
INSERT INTO HtmlLabelIndex values(19692,'签出') 
GO
INSERT INTO HtmlLabelIndex values(19691,'签出时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(19690,'签出人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19690,'Check Out Person',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19691,'签出时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19691,'Check Out Time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19692,'签出',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19692,'Check Out',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19693,'签入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19693,'Check In',8) 
GO

INSERT INTO HtmlLabelIndex values(19695,'文档已被签出，不能编辑！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19695,'文档已被签出，不能编辑！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19695,'The document has been checked out,couldn''t been edited!',8) 
GO

ALTER TABLE DocSecCategory ADD  isOpenApproveWf char(1) null
GO

ALTER TABLE DocSecCategory ADD  validityApproveWf int null
GO

ALTER TABLE DocSecCategory ADD  invalidityApproveWf int null
GO

ALTER TABLE DocDetail ADD  checkOutStatus char(1) null
GO

ALTER TABLE DocDetail ADD  checkOutUserId int null
GO

ALTER TABLE DocDetail ADD  checkOutUserType char(1) null
GO

ALTER TABLE DocDetail ADD  checkOutDate char(10) null
GO

ALTER TABLE DocDetail ADD  checkOutTime char(8) null
GO


CREATE TABLE DocSecCategoryApproveWfDetail (
	id int IDENTITY (1, 1) NOT NULL ,
        secCategoryId int NULL , 
        approveType char(1) NULL ,
        workflowId int NULL ,
        workflowFieldId int NULL ,
        docPropertyFieldId int NULL 
) 
GO


CREATE TABLE DocApproveWf (
	id int IDENTITY (1, 1) NOT NULL ,
        docId int NULL , 
        approveType char(1) NULL ,
        requestId int NULL , 
	status char(1)  NULL
) 
GO
INSERT INTO HtmlLabelIndex values(19174,'权限管理') 
GO
INSERT INTO HtmlLabelInfo VALUES(19174,'权限管理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19174,'Rights Manager',8) 
GO