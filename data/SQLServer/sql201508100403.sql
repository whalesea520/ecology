CREATE TABLE exp_ftpdetail (
	id int IDENTITY(1,1),
	name varchar(200) NULL , 
	adress varchar(200) NULL , 
	port varchar(20) NULL , 
	path varchar(100) NULL, 
	ftpuser varchar(100) NULL, 
    ftppwd  varchar(100) NULL, 
	createdate varchar(20), 
	creator int null
)
GO
CREATE TABLE exp_localdetail (
	id int IDENTITY(1,1),
	name varchar(200) NULL ,
	path varchar(100) NULL,
	createdate varchar(20),
	creator int null
)
GO

CREATE TABLE exp_dbdetail(
	id int IDENTITY(1,1),
	name varchar(200) NULL , 
	resoure varchar(100) NULL ,
	maintable varchar(100) NULL ,
	detailtable varchar(100) NULL,
	createdate varchar(20),
	creator int null
)
GO



CREATE TABLE exp_dbmaintablesetting  (
	id int IDENTITY(1,1),
	dbsettingid int null, 
	columnname varchar(200) NULL ,
	columntype  varchar(50) NULL ,
	primarykey  char(1) NULL,
	isdoce char(1) NULL,
	doctype  char(1) NULL,
	filename char(1) NULL
)
GO

CREATE TABLE exp_dbdetailtablesetting  (
        id int IDENTITY(1,1),
	dbsettingid int null,
	columnname varchar(200) NULL ,
	columntype  varchar(50) NULL ,
	primarykey  char(1) NULL,
	isdoce char(1) NULL,
	doctype  char(1) NULL,
	mainid char(1) NULL,
	filename char(1) NULL
	
)
GO


CREATE TABLE exp_logdetail  (
	id int IDENTITY(1,1),
	requestname varchar(2000) NULL , 
	requestid int NULL,
	workflowid int null,
	sender int NULL,
	senddate varchar(10) NULL ,
	sendtime varchar(10) NULL , 
	status char(1) NULL ,
	reason varchar(400) NULL ,
	type char(1) NULL
)
GO


CREATE TABLE exp_workflowDetail  (
	id int IDENTITY(1,1),
	workflowid int null,
	workflowname varchar(1000),
	workflowtype int null,
	expid int NULL, 
	createdate varchar(20), 
	creator int null
)
GO




CREATE TABLE exp_ProList (
	id int IDENTITY(1,1) not null PRIMARY KEY,
	ProName varchar(200) NULL ,
	Proid  int  not null, 
	ProType char(1),
	ProFileSaveType char(1)
)

GO


CREATE TABLE exp_XMLProSettings (
	id int IDENTITY(1,1) not null PRIMARY KEY,
	name varchar(200) not NULL ,
	FileSaveType  char(1) NULL , 
	regitType int,
	synType char(1),
	TimeModul char(1) NULL, 
	Frequency int NULL,
	frequencyy int NULL,
	createType char(1) NULL,
	createTime char(8) NULL,

	XMLType char(1) NULL,
	XMLEcodingType char(1) NULL, 
	XMLFileType char(1) NULL,
	XMLHaveRemark  char(1)  NULL,
	xmltext text NULL,
	ExpWorkflowFileFlag  char(1)  NULL,
	ExpWorkflowFileForZipFlag  char(1)  NULL,
	ExpWorkflowRemarkFileFlag  char(1)  NULL,
	ExpWorkflowRemarkFileForZip  char(1)  NULL,
	ExpWorkflowFilePath  varchar(500)  NULL,

	ExpWorkflowInfoFlag  char(1)  NULL,
	ExpWorkflowInfoPath varchar(500)  NULL,
	ExpWorkflowRemarkFlag  char(1)  NULL,
	ExpSignFileFlag  char(1)  NULL,
	ExpSignFilePath  varchar(500)  NULL

)

GO



CREATE TABLE exp_DBProSettings (
	id int IDENTITY(1,1) not null PRIMARY KEY,
	name varchar(200) not NULL , 
	FileSaveType  char(1) NULL ,
	regitType int,
	expTableType  char(1),
	synType char(1),
	TimeModul char(1) NULL, 
	Frequency int NULL, 
	frequencyy int NULL,
	createType char(1) NULL,
	createTime char(8) NULL,


	regitDBId int,
	mainTableKeyType char(1) NULL, 
	dtTableKeyType char(1) NULL, 

	ExpWorkflowFileFlag  char(1)  NULL,
	ExpWorkflowFileForZipFlag  char(1)  NULL,
	ExpWorkflowRemarkFileFlag  char(1)  NULL,
	ExpWorkflowRemarkFileForZip  char(1)  NULL,
	ExpWorkflowFilePath  varchar(500)  NULL,

	ExpWorkflowInfoFlag  char(1)  NULL,
	ExpWorkflowInfoPath varchar(500)  NULL,
	ExpWorkflowRemarkFlag  char(1)  NULL,
	ExpSignFileFlag  char(1)  NULL,
	ExpSignFilePath  varchar(500)  NULL,

	zwMapFiletype  varchar(200)  NULL, 
	fjMapFiletype  varchar(200)  NULL,
	dwdMapFiletype  varchar(200)  NULL,
	mwdMapFiletype  varchar(200)  NULL,
	remarkWDMapFiletype  varchar(200)  NULL,
	remarkFJMapFiletype  varchar(200)  NULL, 
	bdMapFiletype  varchar(200)  NULL

)
GO

CREATE TABLE exp_workflowXML  (
	id int IDENTITY(1,1),
	rgworkflowid int null, 
	xmltext text NULL
)
GO

CREATE TABLE exp_workflowFieldXMLMap (
	id int IDENTITY(1,1),
	rgworkflowid int null, 
	fieldid int NULL,
	fieldhtmltype int NULL ,
	fieldtype  int  NULL,
	fieldName varchar(200) NULL ,
	valueType char(1) NULL,
)
GO


CREATE TABLE exp_workflowFieldDBMap (
	id int IDENTITY(1,1),
	rgworkflowid int null,
	fieldid int NULL,
	fieldhtmltype int NULL ,
	fieldtype  int  NULL,
	fieldName varchar(200) NULL ,
	valueType char(1) NULL,
	expfieldname varchar(200), 
	expfieldtype varchar(100) ,
	fileddbname varchar(200)
	
)
 GO



CREATE TABLE exp_wfDBMainFixField (
	id int IDENTITY(1,1),
	rgworkflowid int null, 
	expfieldname varchar(200), 
	expfieldtype varchar(100),
	value varchar(200),
	talbetype char(1)
)
GO


CREATE TABLE exp_FieldMap_cs (
	id int IDENTITY(1,1),
	rgworkflowid int null,
	 fieldMapid int null,
	fieldvalue  varchar(500)  NULL,
	convertvalue  varchar(500)  NULL,
	protype  char(1)  NULL 
	)
 GO