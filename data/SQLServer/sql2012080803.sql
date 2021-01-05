create table modeTreeField(
	id int IDENTITY(1,1) NOT NULL,
	treeFieldName	varchar(80),
	superFieldid	int,
	allSuperFieldId varchar(80),
	treelevel		int,
	isLast			char(1),
	showOrder		decimal(6,2),
	treeFieldDesc	varchar(500)
)
GO

insert into modeTreeField(treeFieldName,superFieldid,allSuperFieldId,treelevel,isLast,showOrder)
values('Ä£¿é',0,'',0,'0','0')
GO

create table modeinfo(
	id				int IDENTITY(1,1) NOT NULL,
	modename		varchar(50),
	modedesc		varchar(255),
	modetype		int,
	formid			int,
	maincategory	int,
	subcategory		int,
	seccategory		int,
	isImportDetail  int,
	codeid			int
)
GO

create table modehtmllayout(
	id			int IDENTITY(1,1) NOT NULL,
	modeid		int,
	formid		int,
	type		int,
	layoutname	varchar(200),
	syspath		varchar(1000),
	colsperrow	int,
	cssfile		int
)
GO

create table modefieldattr(
	id			int IDENTITY(1,1) NOT NULL,
	modeid		int,
	formid		int,
	type		int,
	fieldid		int,
	attrcontent varchar(4000)
	
)
GO

create table modeformfield(
	modeid		int,
	type		int,
	fieldid		int,
	isview		int,
	isedit		int,
	ismandatory	int,
	orderid		decimal(10, 2)
)
GO

create table modeformgroup(
	modeid		int,
	formid		int,
	type		int,
	groupid		int,
	isadd		int,
	isedit		int,
	isdelete	int,
	ishidenull	int,
	Isneed		int,
	isdefault	int
)
GO

create table DefaultValue(
	id				int IDENTITY(1,1) NOT NULL,
	modeid			int,
	fieldid			int,
	customervalue	varchar(255)
)
GO

create table modeattrlinkage(
	id					int IDENTITY(1,1) NOT NULL,
	modeid				int,
	type				int,
	selectfieldid		varchar(20),
	selectfieldvalue	int,
	changefieldids		varchar(255),
	viewattr			int
)
GO

create table modeDataInputentry(
	id					int IDENTITY(1,1) NOT NULL,
	modeid				int,
	triggerName			varchar(100),
	triggerfieldname	varchar(255),
	type				char(1)
)
GO

create table modeDataInputmain(
	id					int IDENTITY(1,1) NOT NULL,
	entryID				int,
	WhereClause			varchar(1000),
	IsCycle				int,
	OrderID				int,
	datasourcename		varchar(100)
)
GO

create table modeDataInputtable(
	id					int IDENTITY(1,1) NOT NULL,
	DataInputID			int,
	TableName			varchar(40),
	Alias				varchar(10),
	FormId				char(1)
)
GO

create table modeDataInputfield(
	id					int IDENTITY(1,1) NOT NULL,
	DataInputID			int,
	TableID				int,
	Type				int,
	DBFieldName			varchar(40),
	PageFieldName		varchar(40)
)
GO

create table moderightinfo(
	id					int IDENTITY(1,1) NOT NULL,	
	modeid				int,
	righttype			int,
	sharetype			int,
	relatedid			int,
	rolelevel			int,
	showlevel			int
)
GO

create table modeDataShare_1(
	id					int IDENTITY(1,1) NOT NULL,	
	sourceid			int,
	type				int,
	content				int,
	seclevel			int,
	sharelevel			int,
	srcfrom				int,
	opuser				int,
	isDefault			int
)
GO


create table ModeCode(
	id				int IDENTITY(1,1) NOT NULL,	
	isUse			int,
	modeId			int,
	codeFieldId		int,
	currentCode		varchar(255)
)
GO

create table ModeCodeDetail(
	id				int IDENTITY(1,1) NOT NULL,	
	codemainid		int,
	showname		int,
	showtype		int,
	showvalue		varchar(50),
	codeorder		int
)
GO