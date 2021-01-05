create table doc_prop
(
  id            INTEGER NOT NULL,
  propkey      	VARCHAR2(200),
  propvalue     VARCHAR2(200),
  propdesc		VARCHAR2(200)
)
/
ALTER TABLE doc_prop ADD PRIMARY KEY (ID)
/
create sequence doc_prop_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 50
order
/

create or replace trigger doc_prop_TRIGGER  before INSERT ON doc_prop for each row
begin SELECT doc_prop_id.nextval INTO:new.id from dual; end;
/

insert into doc_prop (propkey,propvalue, propdesc) values ('docsrecycle','0','文档回收站开关')
/

insert into doc_prop (propkey,propvalue, propdesc) values ('docsautoclean','0','文档回收站自动清理开关')
/

insert into doc_prop (propkey,propvalue, propdesc) values ('autodeletedays','30','文档回收站自动清理天数')
/

CREATE TABLE recycle_DocDetail(
	id INTEGER NOT NULL,
	maincategory INTEGER NULL,
	subcategory INTEGER NULL,
	seccategory INTEGER NULL,
	doctype INTEGER NULL,
	doclangurage INTEGER NULL,
	docapprovable char(1) NULL,
	docreplyable char(1) NULL,
	isreply char(1) NULL,
	replydocid INTEGER NULL,
	docsubject VARCHAR2(1000) NULL,
	docsharetype char(1) NULL,
	shareroleid INTEGER NULL,
	docpublishtype char(1) NULL,
	itemid INTEGER NULL,
	itemmaincategoryid INTEGER NULL,
	hrmresid INTEGER NULL,
	crmid INTEGER NULL,
	projectid INTEGER NULL,
	financeid INTEGER NULL,
	financerefenceid1 INTEGER NULL,
	financerefenceid2 INTEGER NULL,
	doccreaterid INTEGER NULL,
	docdepartmentid INTEGER NULL,
	doccreatedate char(10) NULL,
	doccreatetime char(8) NULL,
	doclastmoduserid INTEGER NULL,
	doclastmoddate char(10) NULL,
	doclastmodtime char(8) NULL,
	docapproveuserid INTEGER NULL,
	docapprovedate char(10) NULL,
	docapprovetime char(8) NULL,
	docarchiveuserid INTEGER NULL,
	docarchivedate char(10) NULL,
	docarchivetime char(8) NULL,
	docstatus INTEGER NULL,
	parentids VARCHAR2(1000) NULL,
	assetid INTEGER NULL,
	ownerid INTEGER NULL,
	keyword VARCHAR2(1000) NULL,
	accessorycount INTEGER NULL,
	replaydoccount INTEGER NULL,
	usertype char(1) NULL,
	docno VARCHAR2(1000) NULL,
	cancopy char(1) NULL,
	canremind char(1) NULL,
	countMark INTEGER NULL,
	sumMark INTEGER NULL,
	sumReadCount INTEGER NULL,
	orderable char(1) NULL,
	docExtendName char(10) NULL,
	doccode VARCHAR2(1000) NULL,
	docedition INTEGER NULL,
	doceditionid INTEGER NULL,
	ishistory INTEGER NULL,
	maindoc INTEGER NULL,
	approvetype INTEGER NULL,
	readoptercanprint INTEGER NULL,
	docvaliduserid INTEGER NULL,
	docvaliddate char(10) NULL,
	docvalidtime char(8) NULL,
	docpubuserid INTEGER NULL,
	docpubdate char(10) NULL,
	docpubtime char(8) NULL,
	docreopenuserid INTEGER NULL,
	docreopendate char(10) NULL,
	docreopentime char(8) NULL,
	docinvaluserid INTEGER NULL,
	docinvaldate char(10) NULL,
	docinvaltime char(8) NULL,
	doccanceluserid INTEGER NULL,
	doccanceldate char(10) NULL,
	doccanceltime char(8) NULL,
	selectedpubmouldid INTEGER NULL,
	checkOutStatus char(1) NULL,
	checkOutUserId INTEGER NULL,
	checkOutUserType char(1) NULL,
	checkOutDate char(10) NULL,
	checkOutTime char(8) NULL,
	hasUsedTemplet char(1) NULL,
	invalidationdate char(10) NULL,
	docCreaterType char(1) NULL,
	docLastModUserType char(1) NULL,
	docApproveUserType char(1) NULL,
	docValidUserType char(1) NULL,
	docInvalUserType char(1) NULL,
	docArchiveUserType char(1) NULL,
	docCancelUserType char(1) NULL,
	docPubUserType char(1) NULL,
	docReopenUserType char(1) NULL,
	ownerType char(1) NULL,
	canPrintedNum INTEGER NULL,
	hasPrintedNum INTEGER NOT NULL,
	approverequestid INTEGER NULL,
	fromworkflow INTEGER NULL,
	istop INTEGER NULL,
	topdate VARCHAR2(1000) NULL,
	toptime VARCHAR2(1000) NULL,
	topstartdate VARCHAR2(1000) NULL,
	topenddate VARCHAR2(1000) NULL,
	invalidRequestId INTEGER NULL,
	editMouldId INTEGER NULL,
	ecology_pinyin_search VARCHAR2(1000) NULL,
	docVestIn INTEGER NOT NULL,
	docdeleteuserid INTEGER NOT NULL,   
	docdeleteDate char(10) NOT NULL,
    docdeleteTime char(8) NOT NULL
  )
/

create table RECYCLE_DOCDETAILCONTENT
(
  docid      INTEGER not null,
  doccontent CLOB
)
/
  
CREATE TABLE recycle_DocShare(
	id INTEGER  NOT NULL,
	docid INTEGER NULL,
	sharetype INTEGER NULL,
	seclevel INTEGER NULL,
	rolelevel INTEGER NULL,
	sharelevel INTEGER NULL,
	userid INTEGER NULL,
	subcompanyid INTEGER NULL,
	departmentid INTEGER NULL,
	roleid INTEGER NULL,
	foralluser INTEGER NULL,
	crmid INTEGER NULL,
	sharesource INTEGER NULL,
	isSecDefaultShare char(1) NULL,
	orgGroupId INTEGER NULL,
	downloadlevel INTEGER NULL,
	allmanagers VARCHAR2(2000) NULL,
	includesub char(10) NULL,
	orgid char(10) NULL,
	seclevelmax char(10) NOT NULL,
	joblevel char(10) NOT NULL,
	jobdepartment char(10) NOT NULL,
	jobsubcompany char(10) NOT NULL,
	jobids char(10) NOT NULL)
/

CREATE TABLE recycle_shareinnerdoc(
	id INTEGER  NOT NULL,
	sourceid INTEGER NOT NULL,
	type INTEGER NOT NULL,
	content INTEGER NOT NULL,
	seclevel INTEGER NOT NULL,
	sharelevel INTEGER NOT NULL,
	srcfrom INTEGER NOT NULL,
	opuser INTEGER NOT NULL,
	sharesource INTEGER NULL,
	downloadlevel INTEGER NULL,
	seclevelmax char(10) NOT NULL,
	joblevel char(10) NOT NULL,
	jobdepartment char(10) NOT NULL,
	jobsubcompany char(10) NOT NULL)
/

CREATE TABLE recycle_DocImageFile(
	id INTEGER NOT NULL,
	docid INTEGER NULL,
	imagefileid INTEGER NULL,
	imagefilename VARCHAR2(1000) NULL,
	imagefiledesc VARCHAR2(1000) NULL,
	imagefilewidth INTEGER NULL,
	imagefileheight INTEGER NULL,
	imagefielsize INTEGER NULL,
	docfiletype VARCHAR2(1000) NULL,
	versionId INTEGER NULL,
	versionDetail VARCHAR2(1000) NULL,
	isextfile char(1) NULL,
	hasUsedTemplet char(1) NULL,
	signatureCount INTEGER NULL )
/

CREATE TABLE recycle_ImageFile(
	imagefileid INTEGER NOT NULL,
	imagefilename VARCHAR2(1000) NULL,
	imagefiletype VARCHAR2(1000) NULL,
	imagefile BLOB NULL,
	imagefileused INTEGER NULL,
	filerealpath VARCHAR2(1000) NULL,
	iszip char(1) NULL,
	isencrypt char(1) NULL,
	fileSize VARCHAR2(1000) NULL,
	downloads INTEGER NOT NULL,
	miniimgpath VARCHAR2(1000) NULL,
	imgsize VARCHAR2(1000) NULL,
	isFTP char(1) NULL,
	FTPConfigId INTEGER NULL,
	isaesencrypt INTEGER NULL,
	aescode VARCHAR2(1000) NULL,
	TokenKey VARCHAR2(1000) NULL,
	StorageStatus char(1) NULL,
	comefrom VARCHAR2(1000) NULL,
	objId INTEGER NULL,
	objotherpara VARCHAR2(1000) NULL,
	delfilerealpath char(1) NULL)
/
