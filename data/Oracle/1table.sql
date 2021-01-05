CREATE TABLE Base_FreeField (
	tablename varchar2 (2)  NULL ,
	dff01name varchar2 (100)  NULL ,
	dff01use smallint NULL ,
	dff02name varchar2 (100)  NULL ,
	dff02use smallint NULL ,
	dff03name varchar2 (100)  NULL ,
	dff03use smallint NULL ,
	dff04name varchar2 (100)  NULL ,
	dff04use smallint NULL ,
	dff05name varchar2 (100)  NULL ,
	dff05use smallint NULL ,
	nff01name varchar2 (100)  NULL ,
	nff01use smallint NULL ,
	nff02name varchar2 (100)  NULL ,
	nff02use smallint NULL ,
	nff03name varchar2 (100)  NULL ,
	nff03use smallint NULL ,
	nff04name varchar2 (100)  NULL ,
	nff04use smallint NULL ,
	nff05name varchar2 (100)  NULL ,
	nff05use smallint NULL ,
	tff01name varchar2 (100)  NULL ,
	tff01use smallint NULL ,
	tff02name varchar2 (100)  NULL ,
	tff02use smallint NULL ,
	tff03name varchar2 (100)  NULL ,
	tff03use smallint NULL ,
	tff04name varchar2 (100)  NULL ,
	tff04use smallint NULL ,
	tff05name varchar2 (100)  NULL ,
	tff05use smallint NULL ,
	bff01name varchar2 (100)  NULL ,
	bff01use smallint NULL ,
	bff02name varchar2 (100)  NULL ,
	bff02use smallint NULL ,
	bff03name varchar2 (100)  NULL ,
	bff03use smallint NULL ,
	bff04name varchar2 (100)  NULL ,
	bff04use smallint NULL ,
	bff05name varchar2 (100)  NULL ,
	bff05use smallint NULL 
)
/
CREATE TABLE Bill_ExpenseDetail (

	expenseid integer NULL ,
	relatedate char (10)  NULL ,
	detailremark varchar2 (250)  NULL ,
	feetypeid integer NULL ,
	feesum number(10, 2) NULL ,
	accessory integer NULL ,
	invoicenum varchar2 (250)  NULL ,
	feerule number(10, 2) NULL 
)
/
create table Bill_HrmResourceAbsense (
id integer  NOT NULL,		
departmentid     integer NULL,					
resourceid       integer NULL,					
absenseremark    varchar2(4000) NULL,					
startdate        char(10) NULL,				
starttime        char(8) NULL,				
enddate          char(10) NULL,				/*请假结束日期*/
endtime          char(8) NULL,				/*请假结束时间*/
absenseday       number(10,2) NULL,				/*请假天数*/
workflowid       integer  NULL,					/*相应的工作流id*/
workflowname     varchar2(100) NULL,				/*相应的工作流名称*/
datefield1 varchar2 (10) NULL,				/*以下为自定义字段*/
datefield2 varchar2 (10) NULL,
datefield3 varchar2 (10) NULL,
datefield4 varchar2 (10) NULL,
datefield5 varchar2 (10) NULL,
numberfield1 float NULL,
numberfield2 float NULL,
numberfield3 float NULL,
numberfield4 float NULL,
numberfield5 float NULL,
textfield1 varchar2 (100) NULL,
textfield2 varchar2 (100) NULL,
textfield3 varchar2 (100) NULL,
textfield4 varchar2 (100) NULL,
textfield5 varchar2 (100) NULL,
tinyintfield1 integer NULL,
tinyintfield2 integer NULL,
tinyintfield3 integer NULL,
tinyintfield4 integer NULL,
tinyintfield5 integer NULL,
usestatus      char(1) NULL					/*实现状态 0或者空 : 未实现 1: 实现, 2: 删除*/
)
/
create sequence Bill_HrmResourceAbsense_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Bill_HrmResourceAbsense_Tri
before insert on Bill_HrmResourceAbsense
for each row
begin
select Bill_HrmResourceAbsense_id.nextval into :new.id from dual;
end;
/

create table Bill_Meetingroom (
    id integer  NOT NULL ,
	requestid   integer  default 0,
	resourceid  integer  NULL,
    departmentid integer NULL,
	meetingroomid integer NULL,
	begindate varchar2 (10) NULL,
	begintime varchar2 (5)  NULL,
	enddate   varchar2 (10) NULL,
	endtime   varchar2 (5)  NULL,
	reason    varchar2(4000) NULL,
	relatecpt integer NULL,
	relatecrm integer NULL,
	relatedoc integer NULL,
	relatereq integer NULL,
    relatemeeting integer NULL  
)
/
create sequence Bill_Meetingroom_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Bill_Meetingroom_Trigger
before insert on Bill_Meetingroom
for each row
begin
select Bill_Meetingroom_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CRM_AddressType (
	id integer NOT NULL ,
	fullname varchar2 (50)  NULL ,
	description varchar2 (150)  NULL ,
	candelete char (1)  NULL 
)
/
create sequence CRM_AddressType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_AddressType_Trigger
before insert on CRM_AddressType
for each row
begin
select CRM_AddressType_id.nextval into :new.id from dual;
end;
/


CREATE TABLE CRM_ContactLog (
	id integer NOT NULL ,
	customerid integer NULL ,
	contacterid integer NULL ,
	resourceid integer NULL ,
	contactway integer NULL ,
	ispassive smallint NULL ,
	subject varchar2 (100)  NULL ,
	contacttype integer NULL ,
	contactdate varchar2 (10)  NULL ,
	contacttime varchar2 (8)  NULL ,
	enddate varchar2 (10)  NULL ,
	endtime varchar2 (8)  NULL ,
	contactinfo varchar2(4000) NULL ,
	documentid integer NULL ,
	submitdate varchar2 (10)  NULL ,
	submittime varchar2 (8)  NULL ,
	issublog smallint NULL ,
	parentid integer NULL ,
	isprocessed smallint NULL ,
	processdate varchar2 (10)  NULL ,
	processtime varchar2 (8)  NULL ,
	isfinished smallint NULL ,
	agentid integer NULL 
)
/
create sequence CRM_ContactLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_ContactLog_Trigger
before insert on CRM_ContactLog
for each row
begin
select CRM_ContactLog_id.nextval into :new.id from dual;
end;
/


CREATE TABLE CRM_ContactWay (
	id integer NOT NULL ,
	fullname varchar2 (50)  NULL ,
	description varchar2 (150)  NULL 
)
/
create sequence CRM_ContactWay_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_ContactWay_Trigger
before insert on CRM_ContactWay
for each row
begin
select CRM_ContactWay_id.nextval into :new.id from dual;
end;
/


CREATE TABLE CRM_ContacterTitle (
	id integer NOT NULL ,
	fullname varchar2 (50)  NULL ,
	description varchar2 (150)  NULL ,
	usetype char (1)  NULL ,
	language integer NULL ,
	abbrev varchar2 (50)  NULL 
)
/
create sequence CRM_ContacterTitle_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_ContacterTitle_Trigger
before insert on CRM_ContacterTitle
for each row
begin
select CRM_ContacterTitle_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CRM_CreditInfo (
	id integer NOT NULL ,
	fullname varchar2 (50)  NULL ,
	creditamount number(12,3) NULL 
)
/
create sequence CRM_CreditInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_CreditInfo_Trigger
before insert on CRM_CreditInfo
for each row
begin
select CRM_CreditInfo_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CRM_CustomerAddress (
	typeid integer NOT NULL ,
	customerid integer  NOT NULL,
	isequal smallint NULL ,
	address1 varchar2 (250)  NULL ,
	address2 varchar2 (250)  NULL ,
	address3 varchar2 (250)  NULL ,
	zipcode varchar2 (10)  NULL ,
	city integer NULL ,
	country integer NULL ,
	province integer NULL ,
	county varchar2 (50)  NULL ,
	phone varchar2 (50)  NULL ,
	fax varchar2 (50)  NULL ,
	email varchar2 (150)  NULL ,
	contacter integer NULL ,
	datefield1 varchar2 (10)  NULL ,
	datefield2 varchar2 (10)  NULL ,
	datefield3 varchar2 (10)  NULL ,
	datefield4 varchar2 (10)  NULL ,
	datefield5 varchar2 (10)  NULL ,
	numberfield1 float NULL ,
	numberfield2 float NULL ,
	numberfield3 float NULL ,
	numberfield4 float NULL ,
	numberfield5 float NULL ,
	textfield1 varchar2 (100)  NULL ,
	textfield2 varchar2 (100)  NULL ,
	textfield3 varchar2 (100)  NULL ,
	textfield4 varchar2 (100)  NULL ,
	textfield5 varchar2 (100)  NULL ,
	tinyintfield1 smallint  NULL,
	tinyintfield2 smallint  NULL,
	tinyintfield3 smallint  NULL,
	tinyintfield4 smallint  NULL,
	tinyintfield5 smallint  NULL
	)
/


	CREATE TABLE CRM_CustomerContacter (
	id integer NOT NULL,
	customerid integer NULL ,
	title integer NULL ,
	fullname varchar2 (50)  NULL ,
	lastname varchar2 (50)  NULL ,
	firstname varchar2 (50)  NULL ,
	jobtitle varchar2 (100)  NULL ,
	email varchar2 (150)  NULL ,
	phoneoffice varchar2 (20)  NULL ,
	phonehome varchar2 (20)  NULL ,
	mobilephone varchar2 (20)  NULL ,
	fax varchar2 (20)  NULL ,
	language integer NULL ,
	manager integer NULL ,
	main smallint NULL ,
	picid integer NULL ,
	datefield1 varchar2 (10)  NULL ,
	datefield2 varchar2 (10)  NULL ,
	datefield3 varchar2 (10)  NULL ,
	datefield4 varchar2 (10)  NULL ,
	datefield5 varchar2 (10)  NULL ,
	numberfield1 float NULL ,
	numberfield2 float NULL ,
	numberfield3 float NULL ,
	numberfield4 float NULL ,
	numberfield5 float NULL ,
	textfield1 varchar2 (100)  NULL ,
	textfield2 varchar2 (100)  NULL ,
	textfield3 varchar2 (100)  NULL ,
	textfield4 varchar2 (100)  NULL ,
	textfield5 varchar2 (100)  NULL ,
	tinyintfield1 smallint NULL,
	tinyintfield2 smallint NULL,
	tinyintfield3 smallint NULL,
	tinyintfield4 smallint NULL,
    tinyintfield5 smallint NULL
)
/
create sequence CRM_CustomerContacter_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_CustomerContacter_Trigger
before insert on CRM_CustomerContacter
for each row
begin
select CRM_CustomerContacter_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CRM_CustomerDesc (
	id integer NOT NULL ,
	fullname varchar2 (50)  NULL ,
	description varchar2 (150)  NULL 
)
/
create sequence CRM_CustomerDesc_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_CustomerDesc_Trigger
before insert on CRM_CustomerDesc
for each row
begin
select CRM_CustomerDesc_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CRM_CustomerInfo (
	id integer  NOT NULL ,
	name varchar2 (50)  NULL ,
	language integer NULL ,
	engname varchar2 (50)  NULL ,
	address1 varchar2 (250)  NULL ,
	address2 varchar2 (250)  NULL ,
	address3 varchar2 (250)  NULL ,
	zipcode varchar2 (10)  NULL ,
	city integer NULL ,
	country integer NULL ,
	province integer NULL ,
	county varchar2 (50)  NULL ,
	phone varchar2 (50)  NULL ,
	fax varchar2 (50)  NULL ,
	email varchar2 (150)  NULL ,
	website varchar2 (150)  NULL ,
	source integer NULL ,
	sector integer NULL ,
	size_n integer NULL ,
	manager integer NULL ,
	agent integer NULL ,
	parentid integer NULL ,
	department integer NULL ,
	fincode integer NULL ,
	currency integer NULL ,
	contractlevel integer NULL ,
	creditlevel integer NULL ,
	creditoffset number(12,3) NULL ,
	discount number(12,3) NULL ,
	taxnumber varchar2 (50)  NULL ,
	bankacount varchar2 (50)  NULL ,
	invoiceacount integer NULL ,
	deliverytype integer NULL ,
	paymentterm integer NULL ,
	paymentway integer NULL ,
	saleconfirm integer NULL ,
	creditcard varchar2 (50)  NULL ,
	creditexpire varchar2 (10)  NULL ,
	documentid integer NULL ,
	picid integer NULL ,
	type integer NULL ,
	typebegin varchar2 (10)  NULL ,
	description integer NULL ,
	status integer NULL ,
	rating integer NULL ,
	datefield1 varchar2 (10)  NULL ,
	datefield2 varchar2 (10)  NULL ,
	datefield3 varchar2 (10)  NULL ,
	datefield4 varchar2 (10)  NULL ,
	datefield5 varchar2 (10)  NULL ,
	numberfield1 float NULL ,
	numberfield2 float NULL ,
	numberfield3 float NULL ,
	numberfield4 float NULL ,
	numberfield5 float NULL ,
	textfield1 varchar2 (100)  NULL ,
	textfield2 varchar2 (100)  NULL ,
	textfield3 varchar2 (100)  NULL ,
	textfield4 varchar2 (100)  NULL ,
	textfield5 varchar2 (100)  NULL ,
	tinyintfield1 smallint NULL ,
	tinyintfield2 smallint NULL ,
	tinyintfield3 smallint NULL ,
	tinyintfield4 smallint NULL ,
	tinyintfield5 smallint NULL ,
	deleted smallint NULL ,
	subcompanyid1 integer NULL ,
	seclevel integer NULL ,
	PortalLoginid varchar2 (60)  NULL ,
	PortalPassword varchar2 (100)  NULL ,
	PortalStatus smallint NULL ,
	createdate varchar2 (10)  NULL 
)
/
create sequence CRM_CustomerInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_CustomerInfo_Trigger
before insert on CRM_CustomerInfo
for each row
begin
select CRM_CustomerInfo_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CRM_CustomerRating (
	id integer NOT NULL ,
	fullname varchar2 (60)  NULL ,
	description varchar2 (150)  NULL ,
	workflow11 integer NULL ,
	workflow12 integer NULL ,
	workflow21 integer NULL ,
	workflow22 integer NULL ,
	workflow31 integer NULL ,
	workflow32 integer NULL ,
	canupgrade char (1)  NULL 
)
/


CREATE TABLE CRM_CustomerSize (
	id integer NOT NULL ,
	fullname varchar2 (50)  NULL ,
	description varchar2 (150)  NULL 
)
/
create sequence CRM_CustomerSize_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_CustomerSize_Trigger
before insert on CRM_CustomerSize
for each row
begin
select CRM_CustomerSize_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CRM_CustomerStatus (
	id integer NOT NULL ,
	fullname varchar2 (50)  NULL ,
	description varchar2 (150)  NULL 
)
/


CREATE TABLE CRM_CustomerType (
	id integer NOT NULL ,
	fullname varchar2 (50)  NULL ,
	description varchar2 (150)  NULL ,
	candelete char (1)  NULL ,
	canedit char (1)  NULL 
)
/
create sequence CRM_CustomerType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_CustomerType_Trigger
before insert on CRM_CustomerType
for each row
begin
select CRM_CustomerType_id.nextval into :new.id from dual;
end;
/


CREATE TABLE CRM_Customize (
	userid integer NULL ,
	row1col1 integer NULL ,
	row1col2 integer NULL ,
	row1col3 integer NULL ,
	row1col4 integer NULL ,
	row1col5 integer NULL ,
	row1col6 integer NULL ,
	row2col1 integer NULL ,
	row2col2 integer NULL ,
	row2col4 integer NULL ,
	row2col3 integer NULL ,
	row2col5 integer NULL ,
	row2col6 integer NULL ,
	row3col1 integer NULL ,
	row3col2 integer NULL ,
	row3col3 integer NULL ,
	row3col4 integer NULL ,
	row3col5 integer NULL ,
	row3col6 integer NULL ,
	logintype smallint default 0
)
/

CREATE TABLE CRM_CustomizeOption (
	id integer NOT NULL ,
	tabledesc integer NULL ,
	fieldname varchar2 (50)  NULL ,
	labelid integer NULL ,
	labelname varchar2 (100)  NULL 
)
/

CREATE TABLE CRM_DeliveryType (
	id integer NOT NULL ,
	fullname varchar2 (50)  NULL ,
	description varchar2 (150)  NULL ,
	sendtype varchar2 (150)  NULL ,
	shipment varchar2 (150)  NULL ,
	receive varchar2 (150)  NULL 
)
/
create sequence CRM_DeliveryType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_DeliveryType_Trigger
before insert on CRM_DeliveryType
for each row
begin
select CRM_DeliveryType_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CRM_Log (
	customerid integer NULL ,
	logtype char (2)  NULL ,
	documentid integer NULL ,
	logcontent varchar2(4000)  NULL ,
	submitdate varchar2 (10)  NULL ,
	submittime varchar2 (8)  NULL ,
	submiter integer NULL ,
	clientip char (15)  NULL ,
	submitertype smallint NULL 
)
/


CREATE TABLE CRM_LoginLog (
	id integer NOT NULL ,
	logindate char (10)  NULL ,
	logintime char (8)  NULL ,
	ipaddress char (15)  NULL 
)
/

CREATE TABLE CRM_Modify (
	customerid integer NULL ,
	tabledesc char (1)  NULL ,
	type integer NULL ,
	addresstype integer NULL ,
	fieldname varchar2 (100)  NULL ,
	modifydate varchar2 (10)  NULL ,
	modifytime varchar2 (8)  NULL ,
	original varchar2 (255)  NULL ,
	modified varchar2 (255)  NULL ,
	modifier integer NULL ,
	clientip char (15)  NULL ,
	submitertype smallint NULL 
)
/
CREATE TABLE CRM_PaymentTerm (
	id integer NOT NULL ,
	fullname varchar2 (50)  NULL ,
	description varchar2 (150)  NULL 
)
/
create sequence CRM_PaymentTerm_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_PaymentTerm_Trigger
before insert on CRM_PaymentTerm
for each row
begin
select CRM_PaymentTerm_id.nextval into :new.id from dual;
end;
/


CREATE TABLE CRM_SectorInfo (
	id integer NOT NULL ,
	fullname varchar2 (50)  NULL ,
	description varchar2 (150)  NULL ,
	parentid integer NULL ,
	seclevel integer NULL ,
	sectors varchar2 (255)  NULL 
)
/


CREATE TABLE CRM_ShareInfo (
	id integer NOT NULL ,
	relateditemid integer NULL ,
	sharetype smallint NULL ,
	seclevel smallint NULL ,
	rolelevel smallint NULL ,
	sharelevel smallint NULL ,
	userid integer NULL ,
	departmentid integer NULL ,
	roleid integer NULL ,
	foralluser smallint NULL ,
	crmid integer default 0
)
/
create sequence CRM_ShareInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_ShareInfo_Trigger
before insert on CRM_ShareInfo
for each row
begin
select CRM_ShareInfo_id.nextval into :new.id from dual;
end;
/


CREATE TABLE CRM_TradeInfo (
	id integer NOT NULL  ,
	fullname varchar2 (50)  NULL ,
	rangelower number(12,3) NULL ,
	rangeupper number(12,3) NULL 
)
/
create sequence CRM_TradeInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_TradeInfo_Trigger
before insert on CRM_TradeInfo
for each row
begin
select CRM_TradeInfo_id.nextval into :new.id from dual;
end;
/


CREATE TABLE CRM_ViewLog (
	customerid integer NULL ,
	type integer NULL ,
	modifydate varchar2 (10)  NULL ,
	modifytime varchar2 (8)  NULL ,
	modifier integer NULL ,
	clientip char (15)  NULL 
)
/

CREATE TABLE CRM_ViewLog1 (
	id integer NOT NULL ,
	viewer integer NULL ,
	viewdate char (10)  NULL ,
	viewtime char (8)  NULL ,
	ipaddress char (15)  NULL ,
	submitertype smallint NULL 
)
/

CREATE TABLE CRM_ledgerinfo (
	customerid integer  NOT NULL,
	customercode varchar2 (10)  NULL ,
	tradetype char (1)   ,
	ledger1 integer NULL ,
	ledger2 integer NULL 
)
/


CREATE TABLE CptAssortmentShare (
	id integer  NOT NULL ,
	assortmentid integer NULL ,
	sharetype smallint NULL ,
	seclevel smallint NULL ,
	rolelevel smallint NULL ,
	sharelevel smallint NULL ,
	userid integer NULL ,
	departmentid integer NULL ,
	roleid integer NULL ,
	foralluser smallint NULL ,
	crmid integer default 0
)
/
create sequence CptAssortmentShare_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger CptAssortmentShare_Trigger
before insert on CptAssortmentShare
for each row
begin
select CptAssortmentShare_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CptCapital (
	id int  NOT NULL ,
	mark varchar2 (60)  NULL ,
	name varchar2 (60)  NULL ,
	barcode varchar2 (30)  NULL ,
	startdate char (10)  NULL ,
	enddate char (10)  NULL ,
	seclevel smallint NULL ,
	departmentid integer NULL ,
	costcenterid integer NULL ,
	resourceid integer NULL ,
	crmid integer NULL ,
	sptcount char (1)  NULL ,
	currencyid integer NULL ,
	capitalcost number(18, 2) NULL ,
	startprice  number(18, 2) NULL ,
	depreendprice number(18, 2) NULL ,
	capitalspec varchar2 (60)  NULL ,
	capitallevel varchar2 (30)  NULL ,
	manufacturer varchar2 (100)  NULL ,
	manudate char (10)  NULL ,
	capitaltypeid integer NULL ,
	capitalgroupid integer NULL ,
	unitid integer NULL ,
	capitalnum integer NULL ,
	currentnum integer NULL ,
	replacecapitalid integer NULL ,
	version varchar2 (60)  NULL ,
	itemid integer NULL ,
	remark varchar2(4000)  NULL ,
	capitalimageid integer NULL ,
	depremethod1 integer NULL ,
	depremethod2 integer NULL ,
	deprestartdate char (10)  NULL ,
	depreenddate char (10)  NULL ,
	customerid integer NULL ,
	attribute smallint NULL ,
	stateid integer NULL ,
	location varchar2 (100)  NULL ,
	usedhours number(18, 3) NULL ,
	datefield1 char (10)  NULL ,
	datefield2 char (10)  NULL ,
	datefield3 char (10)  NULL ,
	datefield4 char (10)  NULL ,
	datefield5 char (10)  NULL ,
	numberfield1 float NULL ,
	numberfield2 float NULL ,
	numberfield3 float NULL ,
	numberfield4 float NULL ,
	numberfield5 float NULL ,
	textfield1 varchar2 (100)  NULL ,
	textfield2 varchar2 (100)  NULL ,
	textfield3 varchar2 (100)  NULL ,
	textfield4 varchar2 (100)  NULL ,
	textfield5 varchar2 (100)  NULL ,
	tinyintfield1 char (1)  NULL ,
	tinyintfield2 char (1)  NULL ,
	tinyintfield3 char (1)  NULL ,
	tinyintfield4 char (1)  NULL ,
	tinyintfield5 char (1)  NULL ,
	createrid integer NULL ,
	createdate char (10)  NULL ,
	createtime char (8)  NULL ,
	lastmoderid integer NULL ,
	lastmoddate char (10)  NULL ,
	lastmodtime char (8)  NULL ,
	isdata char (1)  NULL ,
	datatype integer NULL ,
	relatewfid integer NULL ,
	fnamark varchar2 (60)  NULL ,
	alertnum integer NULL ,
	counttype char (1)  NULL ,
	isinner char (1)  NULL 
)
/
create sequence CptCapital_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CptCapital_Trigger
before insert on CptCapital
for each row
begin
select CptCapital_id.nextval INTO :new.id from dual;
end;
/

CREATE TABLE CptCapitalAssortment (
	id integer NOT NULL,
	assortmentname varchar2 (60)  NULL ,
	assortmentremark varchar2(4000)  NULL ,
	supassortmentid integer NULL ,
	supassortmentstr varchar2 (200)  NULL ,
	subassortmentcount integer default 0 ,
	capitalcount integer default 0 ,
	assortmentmark varchar2 (30)  NULL 
)
/
create sequence CptCapitalAssortment_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CptCapitalAssortment_Trigger
before insert on CptCapitalAssortment
for each row
begin
select CptCapitalAssortment_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CptCapitalGroup (
	id integer NOT NULL,
	name varchar2 (60)  NULL ,
	description varchar2 (200)  NULL ,
	parentid integer NULL 
)
/
create sequence CptCapitalGroup_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CptCapitalGroup_Trigger
before insert on CptCapitalGroup
for each row
begin
select CptCapitalGroup_id.nextval into :new.id from dual;
end;
/


CREATE TABLE CptCapitalShareInfo (
	id integer NOT NULL,
	relateditemid integer NULL ,
	sharetype smallint NULL ,
	seclevel smallint NULL ,
	rolelevel smallint NULL ,
	sharelevel smallint NULL ,
	userid integer NULL ,
	departmentid integer NULL ,
	roleid integer NULL ,
	foralluser smallint NULL ,
	crmid integer default 0,
	sharefrom integer NULL 
)
/
create sequence CptCapitalShareInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CptCapitalShareInfo_Trigger
before insert on CptCapitalShareInfo
for each row
begin
select CptCapitalShareInfo_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CptCapitalState (
	id integer NOT NULL ,
	name varchar2 (60)  NULL ,
	description varchar2 (200)  NULL ,
	issystem char (1)  NULL 
)
/
create sequence CptCapitalState_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CptCapitalState_Trigger
before insert on CptCapitalState
for each row
begin
select CptCapitalState_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CptCapitalType (
	id integer NOT NULL ,
	name varchar2 (60)  NULL ,
	description varchar2 (200)  NULL 
)
/
create sequence CptCapitalType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CptCapitalType_Trigger
before insert on CptCapitalType
for each row
begin
select CptCapitalType_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CptCheckStock (
	id integer NOT NULL,
	checkstockno varchar2 (20)  NULL ,
	checkstockdesc varchar2 (200)  NULL ,
	departmentid integer NULL ,
	location varchar2 (200)  NULL ,
	checkerid integer NULL ,
	approverid integer NULL ,
	createdate varchar2 (10)  NULL ,
	approvedate varchar2 (10)  NULL ,
	checkstatus char (1) default '0'
)
/
create sequence CptCheckStock_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CptCheckStock_Trigger
before insert on CptCheckStock
for each row
begin
select CptCheckStock_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CptCheckStockList (
	id integer NOT NULL ,
	checkstockid integer NULL ,
	capitalid integer NULL ,
	theorynumber integer NULL ,
	realnumber integer NULL ,
	price number(10, 2) default 0 ,
	remark varchar2 (200)  NULL 
)
/
create sequence CptCheckStockList_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CptCheckStockList_Trigger
before insert on CptCheckStockList
for each row
begin
select CptCheckStockList_id.nextval into :new.id from dual;
end;
/


CREATE TABLE CptDepreMethod1 (
	id integer NOT NULL,
	name varchar2 (60)  NULL ,
	description varchar2 (200)  NULL ,
	depretype char (1)  NULL ,
	timelimit number(18, 3) NULL ,
	startunit number(5, 3) NULL ,
	endunit number(5, 3) NULL ,
	deprefunc varchar2 (200)  NULL 
)
/
create sequence CptDepreMethod1_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CptDepreMethod1_Trigger
before insert on CptDepreMethod1
for each row
begin
select CptDepreMethod1_id.nextval into :new.id from dual;
end;
/


CREATE TABLE CptDepreMethod2 (
	id integer NOT NULL,
	depreid integer NULL ,
	time number(9, 3) NULL ,
	depreunit number(5, 3) NULL 
)
/
create sequence CptDepreMethod2_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CptDepreMethod2_Trigger
before insert on CptDepreMethod2
for each row
begin
select CptDepreMethod2_id.nextval into :new.id from dual;
end;
/


CREATE TABLE CptRelateWorkflow (
	id integer NOT NULL ,
	name varchar2 (60)  NULL 
)
/

CREATE TABLE CptSearchMould (
	id integer  NOT NULL ,
	mouldname varchar2 (200)  NULL ,
	userid integer NULL ,
	mark varchar2 (60)  NULL ,
	name varchar2 (60)  NULL ,
	startdate char (10)  NULL ,
	startdate1 char (10)  NULL ,
	enddate char (10)  NULL ,
	enddate1 char (10)  NULL ,
	seclevel smallint NULL ,
	seclevel1 smallint NULL ,
	departmentid integer NULL ,
	costcenterid integer NULL ,
	resourceid integer NULL ,
	currencyid integer NULL ,
	capitalcost varchar2 (30)  NULL ,
	capitalcost1 varchar2 (30)  NULL ,
	startprice varchar2 (30)  NULL ,
	startprice1 varchar2 (30)  NULL ,
	depreendprice varchar2 (30)  NULL ,
	depreendprice1 varchar2 (30)  NULL ,
	capitalspec varchar2 (60)  NULL ,
	capitallevel varchar2 (30)  NULL ,
	manufacturer varchar2 (100)  NULL ,
	manudate char (10)  NULL ,
	manudate1 char (10)  NULL ,
	capitaltypeid integer NULL ,
	capitalgroupid integer NULL ,
	unitid integer NULL ,
	capitalnum varchar2 (30)  NULL ,
	capitalnum1 varchar2 (30)  NULL ,
	currentnum varchar2 (30)  NULL ,
	currentnum1 varchar2 (30)  NULL ,
	replacecapitalid integer NULL ,
	version varchar2 (60)  NULL ,
	itemid integer NULL ,
	depremethod1 integer NULL ,
	depremethod2 integer NULL ,
	deprestartdate char (10)  NULL ,
	deprestartdate1 char (10)  NULL ,
	depreenddate char (10)  NULL ,
	depreenddate1 char (10)  NULL ,
	customerid integer NULL ,
	attribute char (1)  NULL ,
	stateid integer NULL ,
	location varchar2 (100)  NULL ,
	isdata char (1)  NULL ,
	isinner char (1)  NULL ,
	counttype char (1)  NULL 
)
/
create sequence CptSearchMould_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CptSearchMould_Trigger
before insert on CptSearchMould
for each row
begin
select CptSearchMould_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CptShareDetail (
	cptid integer NULL ,
	userid integer NULL ,
	usertype integer NULL ,
	sharelevel integer NULL 
)
/

CREATE TABLE CptUseLog (
	id integer NOT NULL,
	capitalid integer NULL ,
	usedate char (10)  NULL ,
	usedeptid integer NULL ,
	useresourceid integer NULL ,
	usecount number(18, 2) NULL ,
	useaddress varchar2 (200)  NULL ,
	userequest integer NULL ,
	maintaincompany varchar2 (100)  NULL ,
	fee number(10, 2) NULL ,
	usestatus integer  NULL ,
	remark varchar2(4000)  NULL ,
	olddeptid integer NULL 
)
/
create sequence CptUseLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CptUseLog_Trigger
before insert on CptUseLog
for each row
begin
select CptUseLog_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CrmShareDetail (
	crmid integer NULL ,
	userid integer NULL ,
	usertype integer NULL ,
	sharelevel integer NULL 
)
/


CREATE TABLE DocApproveRemark (
	id integer NOT NULL,
	docid integer NULL ,
	approveremark varchar2 (2000)  NULL ,
	approverid integer NULL ,
	approvedate char (10)  NULL ,
	approvetime char (8)  NULL ,
	isapprover char (1)  NULL 
)
/
create sequence DocApproveRemark_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocApproveRemark_Trigger
before insert on DocApproveRemark
for each row
begin
select DocApproveRemark_id.nextval into :new.id from dual;
end;
/


CREATE TABLE DocDetail (
	id integer NOT NULL ,
	maincategory integer NULL ,
	subcategory integer NULL ,
	seccategory integer NULL ,
	doctype integer NULL ,
	doclangurage smallint NULL ,
	docapprovable char (1)  NULL ,
	docreplyable char (1)  NULL ,
	isreply char (1)  NULL ,
	replydocid integer NULL ,
	docsubject varchar2 (200)  NULL ,
	doccontent long  NULL ,
	docsharetype char (1)  NULL ,
	shareroleid integer NULL ,
	docpublishtype char (1)  NULL ,
	itemid integer NULL ,
	itemmaincategoryid integer NULL ,
	hrmresid integer NULL ,
	crmid integer NULL ,
	projectid integer NULL ,
	financeid integer NULL ,
	financerefenceid1 integer NULL ,
	financerefenceid2 integer NULL ,
	doccreaterid integer NULL ,
	docdepartmentid integer NULL ,
	doccreatedate char (10)  NULL ,
	doccreatetime char (8)  NULL ,
	doclastmoduserid integer NULL ,
	doclastmoddate char (10)  NULL ,
	doclastmodtime char (8)  NULL ,
	docapproveuserid integer NULL ,
	docapprovedate char (10)  NULL ,
	docapprovetime char (8)  NULL ,
	docarchiveuserid integer NULL ,
	docarchivedate char (10)  NULL ,
	docarchivetime char (8)  NULL ,
	docstatus char (1)  NULL ,
	parentids varchar2 (255)  NULL ,
	assetid integer NULL ,
	ownerid integer NULL ,
	keyword varchar2 (255)  NULL ,
	accessorycount integer NULL ,
	replaydoccount integer NULL ,
	usertype char (1)  NULL ,
	docno varchar2 (100)  NULL 
)
/

alter table DocDetail drop column doccontent
/
alter table DocDetail add doccontent clob
/

CREATE TABLE DocDetailLog (
	id integer NOT NULL,
	docid integer NULL ,
	docsubject varchar2 (200)  NULL ,
	doccreater integer NULL ,
	operatetype varchar2 (2)  NULL ,
	operatedesc varchar2 (200)  NULL ,
	operateuserid integer NULL ,
	operatedate char (10)  NULL ,
	operatetime char (8)  NULL ,
	clientaddress char (15)  NULL 
)
/
CREATE sequence DocDetailLog_id 
start with 1
increment by 1
nomaxvalue
nocycle
/
CREATE OR replace trigger DocDetailLog_Trigger
before INSERT ON DocDetailLog
for each row
begin
SELECT DocDetailLog_id.nextval INTO:new.id from DocDetailLog;
end;
/


CREATE TABLE DocFrontpage (
	id integer NOT NULL,
	frontpagename varchar2 (200)  NULL ,
	frontpagedesc varchar2 (200)  NULL ,
	isactive char (1)  NULL ,
	departmentid integer NULL ,
	linktype varchar2 (2)  NULL ,
	hasdocsubject char (1)  NULL ,
	hasfrontpagelist char (1)  NULL ,
	newsperpage smallint NULL ,
	titlesperpage smallint NULL ,
	defnewspicid integer NULL ,
	backgroundpicid integer NULL ,
	importdocid integer NULL ,
	headerdocid integer NULL ,
	footerdocid integer NULL ,
	secopt varchar2 (2)  NULL ,
	seclevelopt smallint NULL ,
	departmentopt integer NULL ,
	dateopt integer NULL ,
	languageopt integer NULL ,
	clauseopt varchar2(4000)  NULL ,
	newsclause varchar2(4000)  NULL ,
	languageid integer NULL ,
	publishtype integer NULL 
)
/
create sequence DocFrontpage_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocFrontpage_Trigger
before insert on DocFrontpage
for each row
begin
select DocFrontpage_id.nextval into:new.id from dual;
end;
/


CREATE TABLE DocImageFile (
	id integer NOT NULL,
	docid integer NULL ,
	imagefileid integer NULL ,
	imagefilename varchar2 (200)  NULL ,
	imagefiledesc varchar2 (200)  NULL ,
	imagefilewidth smallint NULL ,
	imagefileheight smallint NULL ,
	imagefielsize smallint NULL ,
	docfiletype char (1)  NULL 
)
/
create sequence DocImageFile_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocImageFile_Trigger
before insert on DocImageFile
for each row
begin
select DocImageFile_id.nextval INTO :new.id from dual;
end;
/


CREATE TABLE DocMailMould (
	id integer NOT NULL ,
	mouldname varchar2 (200)  NULL ,
	mouldtext varchar2(4000)  NULL ,
	isdefault char (1)  NULL 
)
/
create sequence DocMailMould_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocMailMould_Trigger
before insert on DocMailMould
for each row
begin
select DocMailMould_id.nextval into:new.id from dual;
end;
/


CREATE TABLE DocMainCategory (
	id integer NOT NULL ,
	categoryname varchar2 (200)  NULL ,
	categoryiconid integer NULL ,
	categoryorder integer default 0 
)
/
create sequence DocMainCategory_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocMainCategory_Trigger
before insert on DocMainCategory
for each row
begin
select DocMainCategory_id.nextval into:new.id from dual;
end;
/

CREATE TABLE DocMould (
	id integer NOT NULL ,
	mouldname varchar2 (200)  NULL ,
	mouldtext varchar2(4000)  NULL ,
	issysdefault char (1)  default '0' ,
	isuserdefault char (1)  NULL ,
	ismaildefault char (1)  NULL 
)
/
create sequence DocMould_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocMould_Trigger
before insert on DocMould
for each row
begin
select DocMould_id.nextval INTO :new.id from dual;
end;
/


CREATE TABLE DocMouldFile (
	id integer NOT NULL ,
	mouldname varchar2 (200)  NULL ,
	mouldtext varchar2(4000)  NULL 
)
/
create sequence DocMouldFile_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocMouldFile_Trigger
before insert on DocMouldFile
for each row
begin
select DocMouldFile_id.nextval INTO :new.id from dual;
end;
/

CREATE TABLE DocPicUpload (
	id integer NOT NULL ,
	picname varchar2 (200)  NULL ,
	pictype char (1)  NULL ,
	imagefilename varchar2 (200)  NULL ,
	imagefileid integer NULL ,
	imagefilewidth smallint NULL ,
	imagefileheight smallint NULL ,
	imagefilesize integer NULL ,
	imagefilescale number(12,3) NULL 
)
/
create sequence DocPicUpload_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocPicUpload_Trigger
before insert on DocPicUpload
for each row
begin
select DocPicUpload_id.nextval INTO :new.id from dual;
end;
/

CREATE TABLE DocSearchDefine (
	userid integer  unique,
	subjectdef char (1)  NULL ,
	contentdef char (1)  NULL ,
	replydef char (1)  NULL ,
	dociddef char (1)  NULL ,
	createrdef char (1)  NULL ,
	categorydef char (1)  NULL ,
	doctypedef char (1)  NULL ,
	departmentdef char (1)  NULL ,
	languragedef char (1)  NULL ,
	hrmresdef char (1)  NULL ,
	itemdef char (1)  NULL ,
	itemmaincategorydef char (1)  NULL ,
	crmdef char (1)  NULL ,
	projectdef char (1)  NULL ,
	financedef char (1)  NULL ,
	financerefdef1 char (1)  NULL ,
	financerefdef2 char (1)  NULL ,
	publishdef char (1)  NULL ,
	statusdef char (1)  NULL ,
	keyworddef varchar2 (255)  NULL ,
	ownerdef integer NULL 
)
/


CREATE TABLE DocSearchMould (
	id integer NOT NULL ,
	mouldname varchar2 (200)  NULL ,
	userid integer NULL ,
	docsubject varchar2 (200)  NULL ,
	doccontent varchar2 (200)  NULL ,
	containreply char (1)  NULL ,
	maincategory integer NULL ,
	subcategory integer NULL ,
	seccategory integer NULL ,
	docid integer NULL ,
	createrid integer NULL ,
	departmentid integer NULL ,
	doclangurage smallint NULL ,
	hrmresid integer NULL ,
	itemid integer NULL ,
	itemmaincategoryid integer NULL ,
	crmid integer NULL ,
	projectid integer NULL ,
	financeid integer NULL ,
	docpublishtype char (1)  NULL ,
	docstatus char (1)  NULL ,
	keyword varchar2 (255)  NULL ,
	ownerid integer NULL ,
	docno varchar2 (60)  NULL ,
	doclastmoddatefrom char (10)  NULL ,
	doclastmoddateto char (10)  NULL ,
	docarchivedatefrom char (10)  NULL ,
	docarchivedateto char (10)  NULL ,
	doccreatedatefrom char (10)  NULL ,
	doccreatedateto char (10)  NULL ,
	docapprovedatefrom char (10)  NULL ,
	docapprovedateto char (10)  NULL ,
	replaydoccountfrom integer NULL ,
	replaydoccountto integer NULL ,
	accessorycountfrom integer NULL ,
	accessorycountto integer NULL ,
	doclastmoduserid integer NULL ,
	docarchiveuserid integer NULL ,
	docapproveuserid integer NULL ,
	assetid integer NULL 
)
/
create sequence DocSearchMould_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocSearchMould_Trigger
before insert on DocSearchMould
for each row
begin
select DocSearchMould_id.nextval INTO :new.id from dual;
end;
/


CREATE TABLE DocSecCategory (
	id integer NOT NULL,
	subcategoryid integer NULL ,
	categoryname varchar2 (200)  NULL ,
	docmouldid integer NULL ,
	publishable char (1)  NULL ,
	replyable char (1)  NULL ,
	shareable char (1)  NULL ,
	cusertype char (1)  NULL ,
	cuserseclevel smallint NULL ,
	cdepartmentid1 integer NULL ,
	cdepseclevel1 smallint NULL ,
	cdepartmentid2 integer NULL ,
	cdepseclevel2 smallint NULL ,
	croleid1 integer NULL ,
	crolelevel1 char (1)  NULL ,
	croleid2 integer NULL ,
	crolelevel2 char (1)  NULL ,
	croleid3 integer NULL ,
	crolelevel3 char (1)  NULL ,
	hasaccessory char (1)  NULL ,
	accessorynum smallint NULL ,
	hasasset char (1)  NULL ,
	assetlabel varchar2 (200)  NULL ,
	hasitems char (1)  NULL ,
	itemlabel varchar2 (200)  NULL ,
	hashrmres char (1)  NULL ,
	hrmreslabel varchar2 (200)  NULL ,
	hascrm char (1)  NULL ,
	crmlabel varchar2 (200)  NULL ,
	hasproject char (1)  NULL ,
	projectlabel varchar2 (200)  NULL ,
	hasfinance char (1)  NULL ,
	financelabel varchar2 (200)  NULL ,
	approveworkflowid integer NULL 
)
/
create sequence DocSecCategory_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocSecCategory_Trigger
before insert on DocSecCategory
for each row
begin
select DocSecCategory_id.nextval INTO :new.id from dual;
end;
/


CREATE TABLE DocSecCategoryShare (
	id integer NOT NULL,
	seccategoryid integer NULL ,
	sharetype integer NULL ,
	seclevel smallint NULL ,
	rolelevel smallint NULL ,
	sharelevel smallint NULL ,
	userid integer NULL ,
	subcompanyid integer NULL ,
	departmentid integer NULL ,
	roleid integer NULL ,
	foralluser smallint NULL 
)
/
create sequence DocSecCategoryShare_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocSecCategoryShare_Trigger
before insert on DocSecCategoryShare
for each row
begin
select DocSecCategoryShare_id.nextval INTO :new.id from dual;
end;
/


CREATE TABLE DocSecCategoryType (
	seccategoryid integer NULL ,
	typeid integer NULL 
)
/

CREATE TABLE DocShare (
	id integer NOT NULL ,
	docid integer NULL ,
	sharetype integer NULL ,
	seclevel smallint NULL ,
	rolelevel smallint NULL ,
	sharelevel smallint NULL ,
	userid integer NULL ,
	subcompanyid integer NULL ,
	departmentid integer NULL ,
	roleid integer NULL ,
	foralluser smallint NULL ,
	crmid integer default 0 
)  
/
create sequence DocShare_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocShare_Trigger
before insert on DocShare
for each row
begin
select DocShare_id.nextval INTO :new.id from dual;
end;
/


CREATE TABLE DocShareDetail (
	docid integer NULL ,
	userid integer NULL ,
	usertype integer NULL ,
	sharelevel integer NULL 
)
/

CREATE TABLE DocSubCategory (
	id integer NOT NULL ,
	maincategoryid integer NULL ,
	categoryname varchar2 (200)  NULL 
)
/
create sequence DocSubCategory_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocSubCategory_Trigger
before insert on DocSubCategory
for each row
begin
select DocSubCategory_id.nextval INTO :new.id from dual;
end;
/


CREATE TABLE DocSysDefault (
	fgpicwidth smallint NULL ,
	fgpicfixtype char (1)  NULL ,
	docdefmouldid integer NULL ,
	docapprovewfid integer NULL
	)
/

CREATE TABLE DocType (
	id integer not null ,
	typename varchar2 (200)  NULL ,
	isactive char (1)  NULL ,
	hasaccessory char (1)  NULL ,
	accessorynum smallint NULL ,
	hasitems char (1)  NULL ,
	itemclause varchar2 (200)  NULL ,
	itemlabel varchar2 (200)  NULL ,
	hasitemmaincategory char (1)  NULL ,
	itemmaincategorylabel varchar2 (200)  NULL ,
	hashrmres char (1)  NULL ,
	hrmresclause varchar2 (200)  NULL ,
	hrmreslabel varchar2 (200)  NULL ,
	hascrm char (1)  NULL ,
	crmclause varchar2 (200)  NULL ,
	crmlabel varchar2 (200)  NULL ,
	hasproject char (1)  NULL ,
	projectclause varchar2 (200)  NULL ,
	projectlabel varchar2 (200)  NULL ,
	hasfinance char (1)  NULL ,
	financeclause varchar2 (200)  NULL ,
	financelabel varchar2 (200)  NULL ,
	hasrefence1 char (1)  NULL ,
	hasrefence2 char (1)  NULL 
)
/
create sequence DocType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocType_Trigger
before insert on DocType
for each row
begin
select DocType_id.nextval INTO :new.id from dual;
end;
/


CREATE TABLE DocUserCategory (
	secid integer NULL ,
	mainid integer NULL ,
	subid integer NULL ,
	userid integer NULL ,
	usertype char (1)  NULL 
)
/


CREATE TABLE DocUserDefault (
	id integer NOT NULL  ,
	userid integer UNIQUE ,
	hascreater char (1)  NULL ,
	hascreatedate char (1)  NULL ,
	hascreatetime char (1)  NULL ,
	hasdocid char (1)  NULL ,
	hascategory char (1)  NULL ,
	numperpage smallint NULL ,
	selectedcategory varchar2(4000)  NULL ,
	hasreplycount char (1)  NULL ,
	hasaccessorycount char (1)  NULL 
)
/
create sequence DocUserDefault_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocUserDefault_Trigger
before insert on DocUserDefault
for each row
begin
select DocUserDefault_id.nextval into:new.id from dual;
end;
/


CREATE TABLE DocUserView (
	docid integer NULL ,
	userid integer NULL 
)
/


CREATE TABLE ErrorMsgIndex (
	id integer not null ,
       indexdesc    varchar2(100)                            
)
/


CREATE TABLE ErrorMsgInfo (
	indexid integer NULL ,
	msgname varchar2 (200)  NULL ,
	languageid smallint NULL 
)
/

CREATE TABLE FnaAccount (
	id integer not null,
	ledgerid integer NULL ,
	tranperiods char (6)  NULL ,
	trandaccount number(18, 3) NULL ,
	trancaccount number(18, 3) NULL ,
	tranremain number(18, 3) NULL ,
	tranbalance char (1)  NULL 
)
/
create sequence FnaAccount_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaAccount_Trigger
before insert on FnaAccount
for each row
begin
select FnaAccount_id.nextval into :new.id from dual;
end;
/

CREATE TABLE FnaAccountCostcenter (
	id integer not null,
	ledgerid integer NULL ,
	costcenterid integer NULL ,
	tranperiods char (6)  NULL ,
	tranaccount number(18, 3) NULL ,
	tranbalance char (1)  NULL 
)
/
create sequence FnaAccountCostcenter_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaAccountCostcenter_Trigger
before insert on FnaAccountCostcenter
for each row
begin
select FnaAccountCostcenter_id.nextval into :new.id from dual;
end;
/

CREATE TABLE FnaAccountDepartment (
	id integer not null,
	ledgerid integer NULL ,
	departmentid integer NULL ,
	tranperiods char (6)  NULL ,
	tranaccount number(18, 3) NULL ,
	tranbalance char (1)  NULL 
)
/
create sequence FnaAccountDepartment_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaAccountDepartment_Trigger
before insert on FnaAccountDepartment
for each row
begin
select FnaAccountDepartment_id.nextval into :new.id from dual;
end;
/

CREATE TABLE FnaAccountList (
	id integer not null,
	ledgerid integer NULL ,
	tranid integer NULL ,
	tranperiods char (6)  NULL ,
	tranmark integer NULL ,
	trandate char (10)  NULL ,
	tranremark varchar2 (200)  NULL ,
	tranaccount number(18, 3) NULL ,
	tranbalance char (1)  NULL ,
	tranremain number(18, 3) NULL 
)
/
create sequence FnaAccountList_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaAccountList_Trigger
before insert on FnaAccountList
for each row
begin
select FnaAccountList_id.nextval into :new.id from dual;
end;
/

CREATE TABLE FnaBudget (
	id integer  NOT NULL ,
	budgetmoduleid integer NULL ,
	budgetperiods char (6)  NULL ,
	budgetdepartmentid integer NULL ,
	budgetcostercenterid integer NULL ,
	budgetresourceid integer NULL ,
	budgetcurrencyid integer NULL ,
	budgetdefcurrencyid integer NULL ,
	budgetexchangerate varchar2 (20)  NULL ,
	budgetremark varchar2 (250)  NULL ,
	budgetstatus char (1)  NULL ,
	createrid integer NULL ,
	createdate char (10)  NULL ,
	approverid integer NULL ,
	approverdate char (10)  NULL 
)
/
create sequence FnaBudget_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaBudget_Trigger
before insert on FnaBudget
for each row
begin
select FnaBudget_id.nextval into :new.id from dual;
end;
/

CREATE TABLE FnaBudgetCostcenter (
	id integer not null ,
	ledgerid integer NULL ,
	costcenterid integer NULL ,
	budgetmoduleid integer NULL ,
	budgetperiods char (6)  NULL ,
	budgetaccount number(18, 3) NULL 
)
/
CREATE sequence FnaBudgetCostcenter_id
start with 1
increment by 1
nomaxvalue
nocycle
/
CREATE OR replace trigger FnaBudgetCostcenter_Trigger
before INSERT on FnaBudgetCostcenter
for each row
begin
SELECT FnaBudgetCostcenter_id.nextval INTO :new.id from dual;
end;
/


CREATE TABLE FnaBudgetDepartment (
	id integer not null ,
	ledgerid integer NULL ,
	departmentid integer NULL ,
	budgetmoduleid integer NULL ,
	budgetperiods char (6)  NULL ,
	budgetaccount number(18, 3) NULL 
)
/
CREATE sequence FnaBudgetDepartment_id
start with 1
increment by 1
nomaxvalue
nocycle
/
CREATE OR replace trigger FnaBudgetDepartment_Trigger
before INSERT on FnaBudgetDepartment
for each row
begin
SELECT FnaBudgetDepartment_id.nextval INTO :new.id from dual;
end;
/

CREATE TABLE FnaBudgetDetail (
	id integer not null ,
	budgetid integer NULL ,
	ledgerid integer NULL ,
	budgetcrmid integer NULL ,
	budgetitemid integer NULL ,
	budgetdocid integer NULL ,
	budgetprojectid integer NULL ,
	budgetaccount number(18, 3) NULL ,
	budgetdefaccount number(18, 3) NULL ,
	budgetremark varchar2 (200)  NULL 
)
/
create sequence FnaBudgetDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaBudgetDetail_Trigger
before insert on FnaBudgetDetail
for each row
begin
select FnaBudgetDetail_id.nextval into :new.id from dual;
end;
/

CREATE TABLE FnaBudgetList (
	id integer not null  ,
	ledgerid integer NULL ,
	budgetid integer NULL ,
	budgetmoduleid integer NULL ,
	budgetperiods char (6)  NULL ,
	budgetdepartmentid integer NULL ,
	budgetcostcenterid integer NULL ,
	budgetresourceid integer NULL ,
	budgetremark varchar2 (200)  NULL ,
	budgetaccount number(18, 3) NULL 
)
/
create sequence FnaBudgetList_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaBudgetList_Trigger
before insert on FnaBudgetList
for each row
begin
select FnaBudgetList_id.nextval into :new.id from dual;
end;
/

CREATE TABLE FnaBudgetModule (
	id integer not null ,
	budgetname varchar2 (60)  NULL ,
	budgetdesc varchar2 (200)  NULL ,
	fnayear char (4)  NULL ,
	periodsidfrom integer NULL ,
	periodsidto integer NULL 
)
/
create sequence FnaBudgetModule_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaBudgetModule_Trigger
before insert on FnaBudgetModule
for each row
begin
select FnaBudgetModule_id.nextval into :new.id from dual;
end;
/

CREATE TABLE FnaBudgetfeeType (
	id integer  not null,
	name varchar2 (50)  NULL ,
	description varchar2 (250)  NULL 
)  
/
create sequence FnaBudgetfeeType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaBudgetfeeType_Trigger
before insert on FnaBudgetfeeType
for each row
begin
select FnaBudgetfeeType_id.nextval into :new.id from dual;
end;
/

CREATE TABLE FnaCurrency (
	id integer not null,
	currencyname varchar2 (60)  NULL ,
	currencydesc varchar2 (200)  NULL ,
	activable char (1)  NULL ,
	isdefault char (1)  NULL 
)
/
create sequence FnaCurrency_id                             
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger FnaCurrency_Trigger              
before insert on FnaCurrency                               
for each row                                               
begin                                                      
select FnaCurrency_id.nextval INTO :new.id from dual;      
end;                                                       
/       

CREATE TABLE FnaCurrencyExchange (
	id integer not null ,
	defcurrencyid integer NULL ,
	thecurrencyid integer NULL ,
	fnayear char (4)  NULL ,
	periodsid integer NULL ,
	fnayearperiodsid char (6)  NULL ,
	avgexchangerate varchar2 (20)  NULL ,
	endexchangerage varchar2 (20)  NULL 
)
/
create sequence FnaCurrencyExchange_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaCurrencyExchange_Trigger
before insert on FnaCurrencyExchange
for each row
begin
select FnaCurrencyExchange_id.nextval into :new.id from dual;
end;
/

CREATE TABLE FnaDptToKingdee (
	departmentid integer NULL ,
	kingdeecode varchar2 (20)  NULL 
)
/


CREATE TABLE FnaExpensefeeRules (
	feeid integer NULL ,
	resourceid integer NULL ,
	standardfee number(10, 3) NULL 
)
/

CREATE TABLE FnaExpensefeeType (
	id integer not null ,
	name varchar2 (50)  NULL ,
	remark varchar2 (250)  NULL 
)
/
create sequence FnaExpensefeeType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaExpensefeeType_Trigger
before insert on FnaExpensefeeType
for each row
begin
select FnaExpensefeeType_id.nextval into :new.id from dual;
end;
/

CREATE TABLE FnaIndicator (
	id integer not null,
	indicatorname varchar2 (60)  NULL ,
	indicatordesc varchar2 (200)  NULL ,
	indicatortype char (1)  NULL ,
	indicatorbalance char (1)  NULL ,
	haspercent char (1)  NULL ,
	indicatoridfirst integer NULL ,
	indicatoridlast integer NULL 
)
/
CREATE sequence FnaIndicator_id
start with 1
increment by 1
nomaxvalue
nocycle
/
CREATE OR replace trigger FnaIndicator_Trigger
before INSERT on FnaIndicator
for each row
begin
SELECT FnaIndicator_id.nextval INTO :new.id from dual;
end;
/

CREATE TABLE FnaIndicatordetail (
	id integer not null ,
	indicatorid integer NULL ,
	ledgerid integer NULL 
)
/
CREATE sequence FnaIndicatordetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
CREATE OR replace trigger FnaIndicatordetail_Trigger
before insert on FnaIndicatordetail
for each row
begin
select FnaIndicatordetail_id.nextval into :new.id from dual;
end;
/


CREATE TABLE FnaLedger (
	id integer not null ,
	ledgermark varchar2 (60)  NULL ,
	ledgername varchar2 (200)  NULL ,
	ledgertype char (1)  NULL ,
	ledgergroup char (1)  NULL ,
	ledgerbalance char (1)  NULL ,
	autosubledger char (1)  NULL ,
	ledgercurrency char (1)  NULL ,
	supledgerid integer NULL ,
	subledgercount integer default 0 ,
	categoryid integer NULL ,
	initaccount number(18, 3) default 0.000 ,
	supledgerall varchar2 (100)  NULL 
)
/
create sequence FnaLedger_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaLedger_Tr
before insert on FnaLedger
for each row
begin
select FnaLedger_id.nextval into :new.id from dual;
end;
/


CREATE TABLE FnaLedgerCategory (
	id integer not null ,
	categoryname varchar2 (60)  NULL ,
	categorydesc varchar2 (200)  NULL 
)
/
create sequence FnaLedgerCategory_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaLedgerCategory_Trigger
before insert on FnaLedgerCategory
for each row
begin
select FnaLedgerCategory_id.nextval into :new.id from dual;
end;
/

CREATE TABLE FnaTransaction (
	id integer  NOT NULL ,
	tranmark integer NULL ,
	trandate char (10)  NULL ,
	tranperiods char (6)  NULL ,
	trandepartmentid integer NULL ,
	trancostercenterid integer NULL ,
	trancurrencyid integer NULL ,
	trandefcurrencyid integer NULL ,
	tranexchangerate varchar2 (20)  NULL ,
	tranaccessories smallint NULL ,
	tranresourceid integer NULL ,
	trancrmid integer NULL ,
	tranitemid integer NULL ,
	trandocid integer NULL ,
	tranprojectid integer NULL ,
	trandaccount number(18, 3) NULL ,
	trancaccount number(18, 3) NULL ,
	trandefdaccount number(18, 3) NULL ,
	trandefcaccount number(18, 3) NULL ,
	tranremark varchar2 (250)  NULL ,
	transtatus char (1)  NULL ,
	createrid integer NULL ,
	createdate char (10)  NULL ,
	approverid integer NULL ,
	approverdate char (10)  NULL ,
	manual char (1)  default '0'
)
/
create sequence FnaTransaction_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaTransaction_Trigger
before insert on FnaTransaction
for each row
begin
select FnaTransaction_id.nextval into :new.id from dual;
end;
/

CREATE TABLE FnaTransactionDetail (
	id integer not null,
	tranid integer NULL ,
	ledgerid integer NULL ,
	tranaccount number(18, 3) NULL ,
	trandefaccount number(18, 3) NULL ,
	tranbalance char (1)  NULL ,
	tranremark varchar2 (200)  NULL 
) 
/
create sequence FnaTransactionDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaTransactionDetail_Trigger
before insert on FnaTransactionDetail
for each row
begin
select FnaTransactionDetail_id.nextval into :new.id from dual;
end;
/

CREATE TABLE FnaYearsPeriods (
	id integer not null,
	fnayear char (4)  NULL ,
	startdate char (10)  NULL ,
	enddate char (10)  NULL ,
    budgetid    integer null
)
/
create sequence FnaYearsPeriods_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger FnaYearsPeriods_Trigger     
before insert on FnaYearsPeriods                        
for each row                                               
begin                                                      
select FnaYearsPeriods_id.nextval INTO :new.id from dual;
end;  
/

CREATE TABLE FnaYearsPeriodsList (
	id integer not null ,
	fnayearid integer NULL ,
	Periodsid integer NULL ,
	fnayear char (4)  NULL ,
	startdate char (10)  NULL ,
	enddate char (10)  NULL ,
	isclose char (1)  default '0' ,
	isactive char (1)  default '1' ,
	fnayearperiodsid char (6)  NULL 
)  
/
create sequence FnaYearsPeriodsList_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaYearsPeriodsList_Trigger
before insert on FnaYearsPeriodsList
for each row
begin
select FnaYearsPeriodsList_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmActivitiesCompetency (
	id integer not null ,
	jobactivityid integer NULL ,
	competencyid integer NULL 
)
/
create sequence HrmActivitiesCompetency_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmActivitiesCompetency_T
before insert on HrmActivitiesCompetency
for each row
begin
select HrmActivitiesCompetency_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmApplyRemark (
	id integer NOT NULL ,
	applyid integer NULL ,
	remark varchar2 (200)  NULL ,
	resourceid integer NULL ,
	date_n  char(10)  NULL ,
	time  char(8)  NULL 
)
/
create sequence HrmApplyRemark_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmApplyRemark_Trigger
before insert on HrmApplyRemark
for each row
begin
select HrmApplyRemark_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmBank (
	id integer  not null,
	bankname varchar2 (60)  NULL ,
	bankdesc varchar2 (200)  NULL ,
	checkstr varchar2 (100)  NULL 
)
/
create sequence HrmBank_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmBank_Trigger
before insert on HrmBank
for each row
begin
select HrmBank_id.nextval INTO :new.id from dual;
end;
/


CREATE TABLE HrmCareerApply (
	id integer not null,
	ischeck char (1)  NULL ,
	ishire char (1)  NULL ,
	loginid varchar2 (60)  NULL ,
	password varchar2 (100)  NULL ,
	firstname varchar2 (60)  NULL ,
	lastname varchar2 (60)  NULL ,
	aliasname varchar2 (60)  NULL ,
	titleid integer NULL ,
	sex char (1)  NULL ,
	birthday char (10)  NULL ,
	nationality integer NULL ,
	defaultlanguage integer NULL ,
	systemlanguage integer NULL ,
	certificatecategory varchar2 (30)  NULL ,
	certificatenum varchar2 (60)  NULL ,
	nativeplace varchar2 (100)  NULL ,
	educationlevel char (1)  NULL ,
	bememberdate char (10)  NULL ,
	bepartydate char (10)  NULL ,
	bedemocracydate char (10)  NULL ,
	regresidentplace varchar2 (60)  NULL ,
	healthinfo char (1)  NULL ,
	residentplace varchar2 (60)  NULL ,
	policy varchar2 (30)  NULL ,
	degree varchar2 (30)  NULL ,
	height varchar2 (10)  NULL ,
	homepage varchar2 (100)  NULL ,
	maritalstatus char (1)  NULL ,
	marrydate char (10)  NULL ,
	train varchar2(4000)  NULL ,
	resourceimageid integer NULL ,
	officephone varchar2 (60)  NULL ,
	mobile varchar2 (60)  NULL ,
	mobilecall varchar2 (60)  NULL ,
	email varchar2 (60)  NULL ,
	countryid integer NULL ,
	locationid integer NULL ,
	workroom varchar2 (60)  NULL ,
	homeaddress varchar2 (100)  NULL ,
	homepostcode varchar2 (20)  NULL ,
	homephone varchar2 (60)  NULL ,
	timezone integer NULL ,
	worktype varchar2 (60)  NULL ,
	usekind integer NULL ,
	workcode varchar2 (60)  NULL ,
	contractbegintime char (10)  NULL ,
	startdate char (10)  NULL ,
	enddate char (10)  NULL ,
	contractdate char (10)  NULL ,
	resourcetype char (1)  NULL ,
	jobtitle integer NULL ,
	jobgroup integer NULL ,
	jobright varchar2 (100)  NULL ,
	jobcall integer NULL ,
	jobtype integer NULL ,
	jobactivity integer NULL ,
	jobactivitydesc varchar2 (200)  NULL ,
	joblevel smallint NULL ,
	seclevel smallint NULL ,
	departmentid integer NULL ,
	subcompanyid1 integer NULL ,
	subcompanyid2 integer NULL ,
	subcompanyid3 integer NULL ,
	subcompanyid4 integer NULL ,
	costcenterid integer NULL ,
	managerid integer NULL ,
	assistantid integer NULL ,
	purchaselimit number(10, 3) NULL ,
	currencyid integer NULL ,
	bankid1 integer NULL ,
	accountid1 varchar2 (100)  NULL ,
	bankid2 integer NULL ,
	accountid2 varchar2 (100)  NULL ,
	securityno varchar2 (100)  NULL ,
	accumfundaccount varchar2 (30)  NULL ,
	creditcard varchar2 (100)  NULL ,
	expirydate char (10)  NULL ,
	datefield1 varchar2 (10)  NULL ,
	datefield2 varchar2 (10)  NULL ,
	datefield3 varchar2 (10)  NULL ,
	datefield4 varchar2 (10)  NULL ,
	datefield5 varchar2 (10)  NULL ,
	numberfield1 float NULL ,
	numberfield2 float NULL ,
	numberfield3 float NULL ,
	numberfield4 float NULL ,
	numberfield5 float NULL ,
	textfield1 varchar2 (100)  NULL ,
	textfield2 varchar2 (100)  NULL ,
	textfield3 varchar2 (100)  NULL ,
	textfield4 varchar2 (100)  NULL ,
	textfield5 varchar2 (100)  NULL ,
	tinyintfield1 smallint NULL ,
	tinyintfield2 smallint NULL ,
	tinyintfield3 smallint NULL ,
	tinyintfield4 smallint NULL ,
	tinyintfield5 smallint NULL ,
	createrid integer NULL ,
	createdate char (10)  NULL ,
	lastmodid integer NULL ,
	lastmoddate char (10)  NULL ,
	lastlogindate char (10)  NULL ,
	careerid integer NULL 
)
/
CREATE TABLE HrmCareerApplyOtherInfo (
	id integer not null,
	applyid integer NULL ,
	category char (1)  NULL ,
	contactor varchar2 (30)  NULL ,
	major varchar2 (60)  NULL ,
	salarynow varchar2 (60)  NULL ,
	worktime varchar2 (10)  NULL ,
	salaryneed varchar2 (60)  NULL ,
	currencyid   integer null ,	
	reason varchar2 (200)  NULL ,
	otherrequest varchar2 (200)  NULL ,
	selfcomment varchar2(4000)  NULL 
)
/
create sequence HrmCareerApplyOtherInfo_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger HrmCareerApplyOtherInfo_Tr  
before insert on HrmCareerApplyOtherInfo                        
for each row                                               
begin                                                      
select HrmCareerApplyOtherInfo_id.nextval INTO :new.id from dual;
end;  
/

CREATE TABLE HrmCareerInvite (
	id integer not null ,
	careername varchar2 (80)  NULL ,
	careerpeople char (4)  NULL ,
	careerage varchar2 (60)  NULL ,
	careersex char (1)  NULL ,
	careeredu char (1)  NULL ,
	careermode varchar2 (60)  NULL ,
	careeraddr varchar2 (100)  NULL ,
	careerclass varchar2 (60)  NULL ,
	careerdesc varchar2(4000)  NULL ,
	careerrequest varchar2(4000)  NULL ,
	careerremark varchar2(4000)  NULL ,
	careertype char (1)  default '0' ,
	createrid integer NULL ,
	createdate char (10)  NULL ,
	lastmodid integer NULL ,
	lastmoddate char (10)  NULL 
)
/
create sequence HrmCareerInvite_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmCareerInvite_Trigger
before insert on HrmCareerInvite
for each row
begin
select HrmCareerInvite_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmCareerWorkexp (
	id integer not null,
	ftime char (10)  NULL ,
	ttime char (10)  NULL ,
	company varchar2 (100)  NULL ,
	jobtitle varchar2 (100)  NULL ,
	workdesc varchar2(4000)  NULL ,
	applyid integer NULL 
)
/
create sequence HrmCareerWorkexp_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmCareerWorkexp_Trigger
before insert on HrmCareerWorkexp
for each row
begin
select HrmCareerWorkexp_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmCertification (
	id integer  not null,
	resourceid integer NULL ,
	datefrom char (10)  NULL ,
	dateto char (10)  NULL ,
	certname varchar2 (60)  NULL ,
	awardfrom varchar2 (100)  NULL ,
	createid integer NULL ,
	createdate char (10)  NULL ,
	createtime char (8)  NULL ,
	lastmoderid integer NULL ,
	lastmoddate char (10)  NULL ,
	lastmodtime char (8)  NULL 
)
/
create sequence HrmCertification_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmCertification_Trigger
before insert on HrmCertification
for each row
begin
select HrmCertification_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmCity (
	id integer not null ,
	cityname varchar2 (60)  NULL ,
	citylongitude number(8, 3) NULL ,
	citylatitude number(8, 3) NULL ,
	provinceid integer NULL ,
	countryid integer NULL 
)
/

CREATE TABLE HrmCompany (
	id smallint not null,
	companyname varchar2 (200)  NULL 
)
/


CREATE TABLE HrmCompetency (
	id integer not null ,
	competencymark varchar2 (60)  NULL ,
	competencyname varchar2 (200)  NULL ,
	competencyremark varchar2(4000)  NULL 
)
/
create sequence HrmCompetency_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmCompetency_Trigger
before insert on HrmCompetency
for each row
begin
select HrmCompetency_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmComponentStat (
	id integer  not null  ,
	resourceid integer NULL ,
	salarystat number(10, 3) NULL ,
	periodyear char (4)  NULL ,
	periodmonth char (2)  NULL 
)
/
create sequence HrmComponentStat_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmComponentStat_Trigger
before insert on HrmComponentStat
for each row
begin
select HrmComponentStat_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmCostcenter (
	id  integer not null ,		
	costcentermark varchar2 (60)  NULL ,
	costcentername varchar2 (200)  NULL ,
	activable char (1)  NULL ,
	departmentid integer NULL ,
	ccsubcategory1 integer NULL ,
	ccsubcategory2 integer NULL ,
	ccsubcategory3 integer NULL ,
	ccsubcategory4 integer NULL 
)
/
create sequence HrmCostcenter_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmCostcenter_Trigger
before insert on HrmCostcenter
for each row
begin
select HrmCostcenter_id.nextval INTO :new.id from dual;
end;
/

CREATE TABLE HrmCostcenterMainCategory (
	id smallint not null,
	ccmaincategoryname varchar2 (200)  NULL 
)
/

CREATE TABLE HrmCostcenterSubCategory (
	id integer  not null,
	ccsubcategoryname varchar2 (60)  NULL ,
	ccsubcategorydesc varchar2 (200)  NULL ,
	ccmaincategoryid smallint NULL ,
	isdefault char (1) default '0'  NULL 
)
/
create sequence HrmCostcenterSubCategory_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmCostcenterSubCategory_Tr
before insert on HrmCostcenterSubCategory
for each row
begin
select HrmCostcenterSubCategory_id.nextval into :new.id from dual;
end;
/


CREATE TABLE HrmCountry (
	id integer not null,
	countryname varchar2 (60)  NULL ,
	countrydesc varchar2 (200)  NULL 
)
/
create sequence HrmCountry_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmCountry_Trigger
before insert on HrmCountry
for each row
begin
select HrmCountry_id.nextval INTO :new.id from dual;
end;
/

CREATE TABLE HrmDepartment (
    id  integer  not null ,		
	departmentmark varchar2 (60)  NULL ,
	departmentname varchar2 (200)  NULL ,
	countryid  integer  null,		
	addedtax varchar2 (50)  NULL ,
	website varchar2 (200)  NULL ,
	startdate char (10)  NULL ,
	enddate char (10)  NULL ,
	currencyid   integer null ,		
	seclevel smallint NULL ,
	subcompanyid1 integer NULL ,
	subcompanyid2 integer NULL ,
	subcompanyid3 integer NULL ,
	subcompanyid4 integer NULL ,
	createrid integer NULL ,
	createrdate char (10)  NULL ,
	lastmoduserid integer NULL ,
	lastmoddate char (10)  NULL 
)
/
create sequence HrmDepartment_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmDepartment_Trigger
before insert on HrmDepartment
for each row
begin
select HrmDepartment_id.nextval INTO :new.id from dual;
end;
/


CREATE TABLE HrmEducationInfo (
	id integer not null,
	resourceid integer NULL ,
	startdate char (10)  NULL ,
	enddate char (10)  NULL ,
	school varchar2 (100)  NULL ,
	speciality varchar2 (60)  NULL ,
	educationlevel char (1)  NULL ,
	studydesc varchar2(4000)  NULL ,
	createid integer NULL ,
	createdate char (10)  NULL ,
	createtime char (8)  NULL ,
	lastmoderid integer NULL ,
	lastmoddate char (10)  NULL ,
	lastmodtime char (8)  NULL 
)
/
create sequence HrmEducationInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmEducationInfo_Trigger
before insert on HrmEducationInfo
for each row
begin
select HrmEducationInfo_id.nextval INTO :new.id from dual;
end;
/
CREATE TABLE HrmFamilyInfo (
	id integer not null,
	resourceid integer NULL ,
	member varchar2 (30)  NULL ,
	title varchar2 (30)  NULL ,
	company varchar2 (100)  NULL ,
	jobtitle varchar2 (100)  NULL ,
	address varchar2 (100)  NULL ,
	createid integer NULL ,
	createdate char (10)  NULL ,
	createtime char (8)  NULL ,
	lastmoderid integer NULL ,
	lastmoddate char (10)  NULL ,
	lastmodtime char (8)  NULL 
)
/
create sequence HrmFamilyInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmFamilyInfo_Trigger
before insert on HrmFamilyInfo
for each row
begin
select HrmFamilyInfo_id.nextval into :new.id from dual;
end;
/

create table HrmJobActivities (				
id  integer   not null ,		
jobactivitymark    varchar2(60),				
jobactivityname    varchar2(200),			
docid  integer null  ,			
jobactivityremark    varchar2(4000) ,				
jobgroupid     integer					
)
/
create sequence HrmJobActivities_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmJobActivities
before insert on HrmJobActivities
for each row
begin
select HrmJobActivities_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmJobCall (
	id integer not null ,
	name varchar2 (60)  NULL ,
	description varchar2 (60)  NULL 
)
/
create sequence HrmJobCall_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmJobCall_Tr
before insert on HrmJobCall
for each row
begin
select HrmJobCall_id.nextval into :new.id from dual;
end;
/

create table HrmJobGroups (				
id  integer not null ,		
jobgroupmark    varchar2(60),				
jobgroupname    varchar2(200),				
docid  integer null,			
jobgroupremark   varchar2(4000)			
)
/
create sequence HrmJobGroups_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmJobGroups_Trigger
before insert on HrmJobGroups
for each row
begin
select HrmJobGroups_id.nextval INTO :new.id from dual;
end;
/

CREATE TABLE HrmJobTitles (
	id integer not null ,
	jobtitlemark varchar2 (60)  NULL ,
	jobtitlename varchar2 (200)  NULL ,
	seclevel smallint NULL ,
	joblevelfrom    smallint default 0 ,			
    joblevelto      smallint default 0 ,			
	docid  integer null ,
	jobtitleremark varchar2(4000)  NULL ,
	jobgroupid integer NULL ,
	jobactivityid integer NULL 
 )
/
create sequence HrmJobTitles_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmJobTitles_Trigger
before insert on HrmJobTitles
for each row
begin
select HrmJobTitles_id.nextval INTO :new.id from dual;
end;
/

CREATE TABLE HrmJobType (
	id integer not null,
	name varchar2 (60)  NULL ,
	description varchar2 (60)  NULL 
)
/
create sequence HrmJobType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmJobType_Trigger
before insert on HrmJobType
for each row
begin
select HrmJobType_id.nextval into :new.id from dual;
end;
/
CREATE TABLE HrmLanguageAbility (
	id integer not null ,
	resourceid integer NULL ,
	language varchar2 (30)  NULL ,
	level_n char (1)  NULL ,
	memo varchar2(4000)  NULL ,
	createid integer NULL ,
	createdate char (10)  NULL ,
	createtime char (8)  NULL ,
	lastmoderid integer NULL ,
	lastmoddate char (10)  NULL ,
	lastmodtime char (8)  NULL 
)
/
create sequence HrmLanguageAbility_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmLanguageAbility_Trigger
before insert on HrmLanguageAbility
for each row
begin
select HrmLanguageAbility_id.nextval into :new.id from dual;
end;
/
CREATE TABLE HrmListValidate (
	id integer NOT NULL ,
	name varchar2 (50)  NULL ,
	validate_n integer default 0
)
/

CREATE TABLE HrmLocations (
	id  integer  not null ,		
	locationname varchar2 (200)  NULL ,
	locationdesc varchar2 (200)  NULL ,
	address1 varchar2 (200)  NULL ,
	address2 varchar2 (200)  NULL ,
	locationcity varchar2 (200)  NULL ,
	postcode varchar2 (20)  NULL ,
	countryid  integer  not null ,		
	telephone varchar2 (60)  NULL ,
	fax varchar2 (60)  NULL 
)
/
create sequence HrmLocations_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmLocations_Trigger
before insert on HrmLocations
for each row
begin
select HrmLocations_id.nextval INTO :new.id from dual;
end;
/


CREATE TABLE HrmOtherInfoType (
	id integer not null ,
	typename varchar2 (60)  NULL ,
	typeremark varchar2 (200)  NULL 
)
/
create sequence HrmOtherInfoType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmOtherInfoType_Trigger
before insert on HrmOtherInfoType
for each row
begin
select HrmOtherInfoType_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmPeriod (
	departmentid integer unique,
	periodyear char (4)  NULL ,
	periodmonth char (2)  NULL 
)
/

CREATE TABLE HrmPlanColor (
	resourceid integer NULL ,
	basictype integer NULL ,
	colorid1 varchar2 (6)  NULL ,
	colorid2 varchar2 (6)  NULL 
)
/


CREATE TABLE HrmProvince (
	id integer not null ,
	provincename varchar2 (60)  NULL ,
	provincedesc varchar2 (200)  NULL ,
	countryid integer NULL 
)
/

CREATE TABLE HrmPubHoliday (
	id  integer not null ,		
	countryid  integer  null ,
	holidaydate char (10)  NULL ,
	holidayname varchar2 (200)  NULL 
)
/
create sequence HrmPubHoliday_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmPubHoliday_Trigger
before insert on HrmPubHoliday
for each row
begin
select HrmPubHoliday_id.nextval INTO :new.id from dual;
end;
/

CREATE TABLE HrmResource (
	id integer NOT NULL ,
	loginid varchar2 (60)  NULL ,
	password varchar2 (100)  NULL ,
	firstname varchar2 (60)  NULL ,
	lastname varchar2 (60)  NULL ,
	aliasname varchar2 (60)  NULL ,
	titleid integer NULL ,
	sex char (1)  NULL ,
	birthday char (10)  NULL ,
	nationality integer NULL ,
	defaultlanguage integer NULL ,
	systemlanguage integer NULL ,
	maritalstatus char (1)  NULL ,
	marrydate char (10)  NULL ,
	telephone varchar2 (60)  NULL ,
	mobile varchar2 (60)  NULL ,
	mobilecall varchar2 (60)  NULL ,
	email varchar2 (60)  NULL ,
	countryid integer NULL ,
	locationid integer NULL ,
	timezone integer NULL ,
	workroom varchar2 (60)  NULL ,
	homeaddress varchar2 (100)  NULL ,
	homepostcode varchar2 (20)  NULL ,
	homephone varchar2 (60)  NULL ,
	resourcetype char (1)  NULL ,
	startdate char (10)  NULL ,
	enddate char (10)  NULL ,
	contractdate char (10)  NULL ,
	jobtitle integer NULL ,
	jobgroup integer NULL ,
	jobactivity integer NULL ,
	jobactivitydesc varchar2 (200)  NULL ,
	joblevel smallint NULL ,
	seclevel smallint NULL ,
	departmentid integer NULL ,
	subcompanyid1 integer NULL ,
	subcompanyid2 integer NULL ,
	subcompanyid3 integer NULL ,
	subcompanyid4 integer NULL ,
	costcenterid integer NULL ,
	managerid integer NULL ,
	assistantid integer NULL ,
	purchaselimit number(10, 3) NULL ,
	currencyid integer NULL ,
	bankid1 integer NULL ,
	accountid1 varchar2 (100)  NULL ,
	bankid2 integer NULL ,
	accountid2 varchar2 (100)  NULL ,
	securityno varchar2 (100)  NULL ,
	creditcard varchar2 (100)  NULL ,
	expirydate char (10)  NULL ,
	resourceimageid integer NULL ,
	createrid integer NULL ,
	createdate char (10)  NULL ,
	lastmodid integer NULL ,
	lastmoddate char (10)  NULL ,
	lastlogindate char (10)  NULL ,
	datefield1 varchar2 (10)  NULL ,
	datefield2 varchar2 (10)  NULL ,
	datefield3 varchar2 (10)  NULL ,
	datefield4 varchar2 (10)  NULL ,
	datefield5 varchar2 (10)  NULL ,
	numberfield1 float NULL ,
	numberfield2 float NULL ,
	numberfield3 float NULL ,
	numberfield4 float NULL ,
	numberfield5 float NULL ,
	textfield1 varchar2 (100)  NULL ,
	textfield2 varchar2 (100)  NULL ,
	textfield3 varchar2 (100)  NULL ,
	textfield4 varchar2 (100)  NULL ,
	textfield5 varchar2 (100)  NULL ,
	tinyintfield1 smallint NULL ,
	tinyintfield2 smallint NULL ,
	tinyintfield3 smallint NULL ,
	tinyintfield4 smallint NULL ,
	tinyintfield5 smallint NULL ,
	certificatecategory varchar2 (30)  NULL ,
	certificatenum varchar2 (60)  NULL ,
	nativeplace varchar2 (100)  NULL ,
	educationlevel char (1)  NULL ,
	bememberdate char (10)  NULL ,
	bepartydate char (10)  NULL ,
	bedemocracydate char (10)  NULL ,
	workcode varchar2 (60)  NULL ,
	regresidentplace varchar2 (60)  NULL ,
	healthinfo char (1)  NULL ,
	residentplace varchar2 (60)  NULL ,
	policy varchar2 (30)  NULL ,
	degree varchar2 (30)  NULL ,
	height varchar2 (10)  NULL ,
	homepage varchar2 (100)  NULL ,
	train varchar2(4000)  NULL ,
	worktype varchar2 (60)  NULL ,
	usekind integer NULL ,
	contractbegintime char (10)  NULL ,
	jobright varchar2 (100)  NULL ,
	jobcall integer NULL ,
	jobtype integer NULL ,
	accumfundaccount varchar2 (30)  NULL ,
	birthplace varchar2 (60)  NULL ,
	folk varchar2 (30)  NULL ,
	residentphone varchar2 (60)  NULL ,
	residentpostcode varchar2 (60)  NULL ,
	extphone varchar2 (50)  NULL ,
	dsporder integer NULL 
)
/
CREATE TABLE HrmResourceCompetency (
	id integer not null ,
	resourceid integer unique,
	competencyid integer unique ,
	lastgrade float NULL ,
	lastdate char (10)  NULL ,
	currentgrade float NULL ,
	currentdate char (10)  NULL ,
	countgrade float NULL ,
	counttimes integer NULL 
)
/
create sequence HrmResourceCompetency_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmResourceCompetency_Trigger
before insert on HrmResourceCompetency
for each row
begin
select HrmResourceCompetency_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmResourceComponent (
	id  integer not null ,		
	resourceid integer NULL ,
	componentid integer NULL ,
	componentmark varchar2 (60)  NULL ,
	ledgerid integer NULL ,
	componentperiod char (1)  NULL ,
	selbank char (1)  NULL ,
	bankid integer null ,			
	salarysum number(10, 3) NULL ,
	canedit char (1)  NULL ,
	currencyid  integer null ,		
	startdate char (10)  NULL ,
	enddate char (10)  NULL ,
	hasused char (1)  NULL ,
	remark varchar2(4000)  NULL ,
	createid integer NULL ,
	createdate char (10)  NULL ,
	lastmoderid integer NULL ,
	lastmoddate char (10)  NULL 
)
/
create sequence HrmResourceComponent_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmResourceComponent_Trigger
before insert on HrmResourceComponent
for each row
begin
select HrmResourceComponent_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmResourceOtherInfo (
	id  integer not null ,		
	resourceid integer NULL ,
	infoname varchar2 (100)  NULL ,
	startdate char (10)  NULL ,
	enddate char (10)  NULL ,
	docid  integer null,			
	inforemark varchar2(4000)  NULL ,
	infotype integer NULL ,
	seclevel smallint NULL ,
	createid integer NULL ,
	createdate char (10)  NULL ,
	lastmoderid integer NULL ,
	lastmoddate char (10)  NULL 
)
/
create sequence HrmResourceOtherInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmResourceOtherInfo_Trigger
before insert on HrmResourceOtherInfo
for each row
begin
select HrmResourceOtherInfo_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmResourceSkill (
	id integer not null,
	resourceid integer NULL ,
	skilldesc varchar2 (200)  NULL 
)
/
create sequence HrmResourceSkill_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmResourceSkill_Trigger
before insert on HrmResourceSkill
for each row
begin
select HrmResourceSkill_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmRewardsRecord (
	id integer not null,
	resourceid integer NULL ,
	rewardsdate char (10)  NULL ,
	rewardstype integer NULL ,
	remark varchar2(4000)  NULL ,
	createid integer NULL ,
	createdate char (10)  NULL ,
	createtime char (8)  NULL ,
	lastmoderid integer NULL ,
	lastmoddate char (10)  NULL ,
	lastmodtime char (8)  NULL 
)
/
create sequence HrmRewardsRecord_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmRewardsRecord_Trigger
before insert on HrmRewardsRecord
for each row
begin
select HrmRewardsRecord_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmRewardsType (
	id integer not null ,
	flag char (1)  NULL ,
	name varchar2 (60)  NULL ,
	description varchar2 (60)  NULL 
)
/
create sequence HrmRewardsType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmRewardsType_Trigger
before insert on HrmRewardsType
for each row
begin
select HrmRewardsType_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmRoleMembers (
	id integer   ,
	roleid integer NULL ,
	resourceid integer NULL ,
	rolelevel char (1)  NULL 
)
/
create sequence HrmRoleMembers_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmRoleMembers_Trigger
before insert on HrmRoleMembers
for each row
begin
select HrmRoleMembers_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmRoles (
id integer not null ,
rolesmark varchar2 (60)  NULL ,
rolesname varchar2 (200)  NULL ,
docid  integer null			
)
/
create sequence HrmRoles_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmRoles_Trigger
before insert on HrmRoles
for each row
begin
select HrmRoles_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmSalaryComponent (
        id  integer  not null ,		
	componentname varchar2 (200)  NULL ,
	countryid  integer  null ,		
	jobactivityid integer NULL ,
	componenttype char (1)  NULL ,
	componentperiod char (1)  NULL ,
	currencyid   integer null ,		
	ledgerid integer NULL ,
	docid  integer null,			
	startdate char (10)  NULL ,
	enddate char (10)  NULL ,
	includetex char (1)  NULL ,
	componenttypeid integer NULL 
)
/
create sequence HrmSalaryComponent_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSalaryComponent_Trigger
before insert on HrmSalaryComponent
for each row
begin
select HrmSalaryComponent_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmSalaryComponentDetail (
	componentid integer NULL ,
	detailmark varchar2 (60)  NULL ,
	joblevel smallint NULL ,
	salarysum number(10, 3) NULL ,
	editable char (1)  NULL 
)
/

CREATE TABLE HrmSalaryComponentTypes (
	id integer not null ,
	typemark varchar2 (60)  NULL ,
	typename varchar2 (200)  NULL ,
	colorid varchar2 (6)  NULL ,
	typeorder integer default 0
)
/
create sequence HrmSalaryComponentTypes_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSalaryComponentTypes_Tr
before insert on HrmSalaryComponentTypes
for each row
begin
select HrmSalaryComponentTypes_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmSchedule (
	id integer not null,
	relatedid integer NULL ,
	monstarttime1 char (5)  NULL ,
	monendtime1 char (5)  NULL ,
	monstarttime2 char (5)  NULL ,
	monendtime2 char (5)  NULL ,
	tuestarttime1 char (5)  NULL ,
	tueendtime1 char (5)  NULL ,
	tuestarttime2 char (5)  NULL ,
	tueendtime2 char (5)  NULL ,
	wedstarttime1 char (5)  NULL ,
	wedendtime1 char (5)  NULL ,
	wedstarttime2 char (5)  NULL ,
	wedendtime2 char (5)  NULL ,
	thustarttime1 char (5)  NULL ,
	thuendtime1 char (5)  NULL ,
	thustarttime2 char (5)  NULL ,
	thuendtime2 char (5)  NULL ,
	fristarttime1 char (5)  NULL ,
	friendtime1 char (5)  NULL ,
	fristarttime2 char (5)  NULL ,
	friendtime2 char (5)  NULL ,
	satstarttime1 char (5)  NULL ,
	satendtime1 char (5)  NULL ,
	satstarttime2 char (5)  NULL ,
	satendtime2 char (5)  NULL ,
	sunstarttime1 char (5)  NULL ,
	sunendtime1 char (5)  NULL ,
	sunstarttime2 char (5)  NULL ,
	sunendtime2 char (5)  NULL ,
	totaltime char (5)  NULL ,
	scheduletype char (1)  NULL 
)
/
create sequence HrmSchedule_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSchedule_Trigger
before insert on HrmSchedule
for each row
begin
select HrmSchedule_id.nextval INTO :new.id from dual;
end;
/
CREATE TABLE HrmScheduleDiff (
	id  integer not null ,		
	diffname varchar2 (60)  NULL ,
	diffdesc varchar2 (200)  NULL ,
	difftype char (1)  NULL ,
	difftime char (1)  NULL ,
	mindifftime smallint NULL ,
	workflowid integer NULL ,
	salaryable char (1)  NULL ,
	counttype char (1)  NULL ,
	countnum number(10, 3) NULL ,
	currencyid   integer null,		
	docid  integer null,	
	diffremark varchar2(4000)  NULL 
)
/
create sequence HrmScheduleDiff_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmScheduleDiff_Trigger
before insert on HrmScheduleDiff
for each row
begin
select HrmScheduleDiff_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmSearchMould (
	id integer not null,
	mouldname varchar2 (200)  NULL ,
	userid integer NULL ,
	resourceid integer NULL ,
	resourcename varchar2 (60)  NULL ,
	jobtitle integer NULL ,
	activitydesc varchar2 (200)  NULL ,
	jobgroup integer NULL ,
	jobactivity integer NULL ,
	costcenter integer NULL ,
	competency integer NULL ,
	resourcetype char (1)  NULL ,
	status char (1)  NULL ,
	subcompany1 integer NULL ,
	subcompany2 integer NULL ,
	subcompany3 integer NULL ,
	subcompany4 integer NULL ,
	department integer NULL ,
	location integer NULL ,
	manager integer NULL ,
	assistant integer NULL ,
	roles integer NULL ,
	seclevel smallint NULL ,
	joblevel smallint NULL ,
	workroom varchar2 (60)  NULL ,
	telephone varchar2 (60)  NULL ,
	startdate char (10)  NULL ,
	enddate char (10)  NULL ,
	contractdate char (10)  NULL ,
	birthday char (10)  NULL ,
	sex char (1)  NULL ,
	seclevelTo smallint NULL ,
	joblevelTo smallint NULL ,
	startdateTo char (10)  NULL ,
	enddateTo char (10)  NULL ,
	contractdateTo char (10)  NULL ,
	birthdayTo char (10)  NULL ,
	age integer NULL ,
	ageTo integer NULL 
)
/
create sequence HrmSearchMould_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSearchMould_Trigger
before insert on HrmSearchMould
for each row
begin
select HrmSearchMould_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmSpeciality (
	id integer not null,
	name varchar2 (60)  NULL ,
	description varchar2 (60)  NULL 
)
/
create sequence HrmSpeciality_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSpeciality_Trigger
before insert on HrmSpeciality
for each row
begin
select HrmSpeciality_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmSubCompany (
	id integer not null  ,
	subcompanyname varchar2 (200)  NULL ,
	subcompanydesc varchar2 (200)  NULL ,
	companyid smallint NULL ,
	isdefault char (1) default '0' 
)
/
create sequence HrmSubCompany_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSubCompany_Trigger
before insert on HrmSubCompany
for each row
begin
select HrmSubCompany_id.nextval INTO :new.id from dual;
end;
/

CREATE TABLE HrmTrainRecord (
	id integer  not null ,
	resourceid integer NULL ,
	trainstartdate char (10)  NULL ,
	trainenddate char (10)  NULL ,
	traintype integer NULL ,
	trainrecord varchar2(4000)  NULL ,
	createid integer NULL ,
	createdate char (10)  NULL ,
	createtime char (8)  NULL ,
	lastmoderid integer NULL ,
	lastmoddate char (10)  NULL ,
	lastmodtime char (8)  NULL ,
	trainhour number(18, 3) NULL ,
	trainunit varchar2 (100)  NULL 
)
/
create sequence HrmTrainRecord_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmTrainRecord_Trigger
before insert on HrmTrainRecord
for each row
begin
select HrmTrainRecord_id.nextval into :new.id from dual;
end;
/
CREATE TABLE HrmTrainType (
	id integer not null,
	name varchar2 (60)  NULL ,
	description varchar2 (60)  NULL 
)
/
create sequence HrmTrainType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmTrainType_Trigger
before insert on HrmTrainType
for each row
begin
select HrmTrainType_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmUseKind (
	id integer not null ,
	name varchar2 (60)  NULL ,
	description varchar2 (60)  NULL 
)
/
create sequence HrmUseKind_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmUseKind_Trigger
before insert on HrmUseKind
for each row
begin
select HrmUseKind_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmUserDefine (
	userid integer unique ,
	hasresourceid char (1)  NULL ,
	hasresourcename char (1)  NULL ,
	hasjobtitle char (1)  NULL ,
	hasactivitydesc char (1)  NULL ,
	hasjobgroup char (1)  NULL ,
	hasjobactivity char (1)  NULL ,
	hascostcenter char (1)  NULL ,
	hascompetency char (1)  NULL ,
	hasresourcetype char (1)  NULL ,
	hasstatus char (1)  NULL ,
	hassubcompany char (1)  NULL ,
	hasdepartment char (1)  NULL ,
	haslocation char (1)  NULL ,
	hasmanager char (1)  NULL ,
	hasassistant char (1)  NULL ,
	hasroles char (1)  NULL ,
	hasseclevel char (1)  NULL ,
	hasjoblevel char (1)  NULL ,
	hasworkroom char (1)  NULL ,
	hastelephone char (1)  NULL ,
	hasstartdate char (1)  NULL ,
	hasenddate char (1)  NULL ,
	hascontractdate char (1)  NULL ,
	hasbirthday char (1)  NULL ,
	hassex char (1)  NULL ,
	projectable char (1)  NULL ,
	crmable char (1)  NULL ,
	itemable char (1)  NULL ,
	docable char (1)  NULL ,
	workflowable char (1)  NULL ,
	subordinateable char (1)  NULL ,
	trainable char (1)  NULL ,
	budgetable char (1)  NULL ,
	fnatranable char (1)  NULL ,
	dspperpage smallint NULL ,
	hasage char (1)  NULL 
)
/
CREATE TABLE HrmWelfare (
	id integer not null ,
	resourceid integer NULL ,
	datefrom char (10)  NULL ,
	dateto char (10)  NULL ,
	basesalary number(18, 2) NULL ,
	homesub number(18, 2) NULL ,
	vehiclesub number(18, 2) NULL ,
	mealsub number(18, 2) NULL ,
	othersub number(18, 2) NULL ,
	adjustreason varchar2 (200)  NULL ,
	createid integer NULL ,
	createdate char (10)  NULL ,
	createtime char (8)  NULL ,
	lastmoderid integer NULL ,
	lastmoddate char (10)  NULL ,
	lastmodtime char (8)  NULL 
)
/
create sequence HrmWelfare_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmWelfare_Trigger
before insert on HrmWelfare
for each row
begin
select HrmWelfare_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmWorkResume (
	id integer not null,
	resourceid integer NULL ,
	startdate char (10)  NULL ,
	enddate char (10)  NULL ,
	company varchar2 (100)  NULL ,
	companystyle integer NULL ,
	jobtitle varchar2 (30)  NULL ,
	workdesc varchar2(4000)  NULL ,
	leavereason varchar2 (200)  NULL ,
	createid integer NULL ,
	createdate char (10)  NULL ,
	createtime char (8)  NULL ,
	lastmoderid integer NULL ,
	lastmoddate char (10)  NULL ,
	lastmodtime char (8)  NULL 
)
/
create sequence HrmWorkResume_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmWorkResume_Trigger
before insert on HrmWorkResume
for each row
begin
select HrmWorkResume_id.nextval into :new.id from dual;
end;
/
CREATE TABLE HrmWorkResumeIn (
	id integer not null ,
	resourceid integer NULL ,
	datefrom char (10)  NULL ,
	dateto char (10)  NULL ,
	departmentid integer NULL ,
	jobtitle integer NULL ,
	joblevel smallint NULL ,
	createid integer NULL ,
	createdate char (10)  NULL ,
	createtime char (8)  NULL ,
	lastmoderid integer NULL ,
	lastmoddate char (10)  NULL ,
	lastmodtime char (8)  NULL 
)  
/
create sequence HrmWorkResumeIn_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmWorkResumeIn_Trigger
before insert on HrmWorkResumeIn
for each row
begin
select HrmWorkResumeIn_id.nextval into :new.id from dual;
end;
/



CREATE TABLE HtmlLabelIndex (
	id integer not null ,
	indexdesc varchar2 (400)  unique
)
/
CREATE TABLE HtmlLabelInfo (
	indexid integer  ,
	labelname varchar2 (2000)  NULL ,
	languageid smallint NULL 
)
/

CREATE TABLE HtmlNoteIndex (
	id integer not null ,
	indexdesc varchar2 (100) unique
)
/

CREATE TABLE HtmlNoteInfo (
	indexid integer  ,
	notename varchar2 (300)  NULL ,
	languageid smallint NULL 
)
/

CREATE TABLE IT (
	inner1 varchar2 (255)  NULL ,
	lx1 varchar2 (255)  NULL ,
	lx2 varchar2 (255)  NULL ,
	mc varchar2 (255)  NULL ,
	bh varchar2 (255)  NULL ,
	bm varchar2 (255)  NULL ,
	syr varchar2 (255)  NULL ,
	zt varchar2 (255)  NULL ,
	ggxh varchar2 (255)  NULL ,
	jg float NULL ,
	rq varchar2 (255)  NULL ,
	bz varchar2 (255)  NULL 
)
/

CREATE TABLE ImageFile (
	imagefileid integer not null ,
	imagefilename varchar2 (200)  NULL ,
	imagefiletype varchar2 (50)  NULL ,
	imagefile blob NULL ,
	imagefileused integer NULL 
)
/

CREATE TABLE LgcAsset (
	id integer not null ,
	assetmark varchar2 (60)  NULL ,
	barcode varchar2 (30)  NULL ,
	seclevel smallint NULL ,
	assetimageid integer NULL ,
	assettypeid integer NULL ,
	assetunitid integer NULL ,
	replaceassetid integer NULL ,
	assetversion varchar2 (20)  NULL ,
	assetattribute varchar2 (100)  NULL ,
	counttypeid integer NULL ,
	assortmentid integer NULL ,
	assortmentstr varchar2 (200)  NULL ,
	relatewfid integer NULL 
)
/
create sequence LgcAsset_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcAsset_Trigger
before insert on LgcAsset
for each row
begin
select LgcAsset_id.nextval into :new.id from dual;
end;
/


CREATE TABLE LgcAssetAssortment (
	id integer not null ,
	assortmentmark varchar2 (60)  NULL ,
	assortmentname varchar2 (60)  NULL ,
	seclevel smallint NULL ,
	resourceid integer NULL ,
	assortmentimageid integer NULL ,
	assortmentremark varchar2(4000)  NULL ,
	supassortmentid integer NULL ,
	supassortmentstr varchar2 (200)  NULL ,
	subassortmentcount integer default 0,
	assetcount integer default 0,
	dff01name varchar2 (100)  NULL ,
	dff01use smallint NULL ,
	dff02name varchar2 (100)  NULL ,
	dff02use smallint NULL ,
	dff03name varchar2 (100)  NULL ,
	dff03use smallint NULL ,
	dff04name varchar2 (100)  NULL ,
	dff04use smallint NULL ,
	dff05name varchar2 (100)  NULL ,
	dff05use smallint NULL ,
	nff01name varchar2 (100)  NULL ,
	nff01use smallint NULL ,
	nff02name varchar2 (100)  NULL ,
	nff02use smallint NULL ,
	nff03name varchar2 (100)  NULL ,
	nff03use smallint NULL ,
	nff04name varchar2 (100)  NULL ,
	nff04use smallint NULL ,
	nff05name varchar2 (100)  NULL ,
	nff05use smallint NULL ,
	tff01name varchar2 (100)  NULL ,
	tff01use smallint NULL ,
	tff02name varchar2 (100)  NULL ,
	tff02use smallint NULL ,
	tff03name varchar2 (100)  NULL ,
	tff03use smallint NULL ,
	tff04name varchar2 (100)  NULL ,
	tff04use smallint NULL ,
	tff05name varchar2 (100)  NULL ,
	tff05use smallint NULL ,
	bff01name varchar2 (100)  NULL ,
	bff01use smallint NULL ,
	bff02name varchar2 (100)  NULL ,
	bff02use smallint NULL ,
	bff03name varchar2 (100)  NULL ,
	bff03use smallint NULL ,
	bff04name varchar2 (100)  NULL ,
	bff04use smallint NULL ,
	bff05name varchar2 (100)  NULL ,
	bff05use smallint NULL 
)
/
create sequence LgcAssetAssortment_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcAssetAssortment_Trigger
before insert on LgcAssetAssortment
for each row
begin
select LgcAssetAssortment_id.nextval into :new.id from dual;
end;
/

CREATE TABLE LgcAssetCountry (
	id integer  NOT NULL ,
	assetid integer NULL ,
	assetname varchar2 (60)  NULL ,
	assetcountyid integer NULL ,
	startdate char (10)  NULL ,
	enddate char (10)  NULL ,
	departmentid integer NULL ,
	resourceid integer NULL ,
	assetremark varchar2(4000)  NULL ,
	currencyid integer NULL ,
	salesprice number(18, 3) NULL ,
	costprice number(18, 3) NULL ,
	datefield1 char (10)  NULL ,
	datefield2 char (10)  NULL ,
	datefield3 char (10)  NULL ,
	datefield4 char (10)  NULL ,
	datefield5 char (10)  NULL ,
	numberfield1 float NULL ,
	numberfield2 float NULL ,
	numberfield3 float NULL ,
	numberfield4 float NULL ,
	numberfield5 float NULL ,
	textfield1 varchar2 (100)  NULL ,
	textfield2 varchar2 (100)  NULL ,
	textfield3 varchar2 (100)  NULL ,
	textfield4 varchar2 (100)  NULL ,
	textfield5 varchar2 (100)  NULL ,
	tinyintfield1 char (1)  NULL ,
	tinyintfield2 char (1)  NULL ,
	tinyintfield3 char (1)  NULL ,
	tinyintfield4 char (1)  NULL ,
	tinyintfield5 char (1)  NULL ,
	createrid integer NULL ,
	createdate char (10)  NULL ,
	lastmoderid integer NULL ,
	lastmoddate char (10)  NULL ,
	isdefault char (1)  NULL 
)
/
CREATE sequence LgcAssetCountry_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcAssetCountry_Trigger
before insert on LgcAssetCountry
for each row
begin
select LgcAssetCountry_id.nextval into :new.id from dual;
end;
/

CREATE TABLE LgcAssetCrm (
	id integer  not null ,		
	assetid integer NULL ,
	crmid integer NULL ,
	countryid integer NULL ,
	ismain      char(1) default '0',			
	assetcode char (60)  NULL ,
	currencyid   integer null ,		
	purchaseprice number(18, 3) NULL ,
	taxrate integer NULL ,
	unitid integer NULL ,
	packageunit varchar2 (100)  NULL ,
	supplyremark varchar2(4000)  NULL ,
	docid  integer null ,			
	contractid integer NULL 
)
/
create sequence LgcAssetCrm_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcAssetCrm_Trigger
before insert on LgcAssetCrm
for each row
begin
select LgcAssetCrm_id.nextval into :new.id from dual;
end;
/

CREATE TABLE LgcAssetPrice (
	id integer not null ,		
	assetid integer NULL ,
	assetcountyid integer NULL ,
	pricedesc varchar2 (200)  NULL ,
	numfrom integer NULL ,
	numto integer NULL ,
	currencyid   integer null ,		
	unitprice number(18, 3) NULL ,
	taxrate integer NULL 
)
/
CREATE sequence LgcAssetPrice_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcAssetPrice_Trigger
before insert on LgcAssetPrice
for each row
begin
select LgcAssetPrice_id.nextval into :new.id from dual;
end;
/
CREATE TABLE LgcAssetRelationType (
	id integer not null ,
	typename varchar2 (60)  NULL ,
	typedesc varchar2 (200)  NULL ,
	typekind char (1)  NULL ,
	shopadvice char (1)  NULL ,
	contractlimit char (1)  NULL 
)
/
create sequence LgcAssetRelationType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcAssetRelationType_Trigger
before insert on LgcAssetRelationType
for each row
begin
select LgcAssetRelationType_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE LgcAssetStock (
	id integer  not null ,
	warehouseid integer  ,
	assetid integer  ,
	stocknum float NULL ,
	unitprice number(18, 3) default 0 
)
/
create sequence LgcAssetStock_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcAssetStock_Trigger
before insert on LgcAssetStock
for each row
begin
select LgcAssetStock_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE LgcAssetType (
	id integer not null,
	typemark varchar2 (60)  NULL ,
	typename varchar2 (60)  NULL ,
	typedesc varchar2 (200)  NULL 
)
/
create sequence LgcAssetType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create trigger LgcAssetType_Trigger
before insert on LgcAssetType
for each row
begin
select LgcAssetType_id.nextval into :new.id from dual;
end ;
/
CREATE TABLE LgcAssetUnit (
	id integer not null ,
	unitmark varchar2 (60)  NULL ,
	unitname varchar2 (60)  NULL ,
	unitdesc varchar2 (200)  NULL 
)
/
create sequence LgcAssetUnit_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcAssetUnit_Trigger
before insert on LgcAssetUnit
for each row
begin
select LgcAssetUnit_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE LgcCatalogs (
	id integer  not null ,
	catalogname varchar2 (60)  NULL ,
	catalogdesc varchar2 (200)  NULL ,
	catalogorder integer NULL ,
	perpage integer NULL ,
	seclevelfrom smallint NULL ,
	seclevelto smallint NULL ,
	navibardsp char (1)  NULL ,
	navibarbgcolor char (6)  NULL ,
	navibarfontcolor char (6)  NULL ,
	navibarfontsize varchar2 (20)  NULL ,
	navibarfonttype varchar2 (20)  NULL ,
	toolbardsp char (1)  NULL ,
	toolbarwidth integer default 200,
	toolbarbgcolor char (6)  NULL ,
	toolbarfontcolor char (6)  NULL ,
	toolbarlinkbgcolor char (6)  NULL ,
	toolbarlinkfontcolor char (6)  NULL ,
	toolbarfontsize varchar2 (20)  NULL ,
	toolbarfonttype varchar2 (20)  NULL ,
	countrydsp char (1)  NULL ,
	countrydeftype char (1)  NULL ,
	countryid integer NULL ,
	searchbyname char (1)  NULL ,
	searchbycrm char (1)  NULL ,
	searchadv char (1)  NULL ,
	assortmentdsp char (1)  NULL ,
	assortmentname varchar2 (60)  NULL ,
	assortmentsql varchar2(4000)  NULL ,
	attributedsp char (1)  NULL ,
	attributecol integer NULL ,
	attributefontsize varchar2 (20)  NULL ,
	attributefonttype varchar2 (20)  NULL ,
	assetsql varchar2(4000)  NULL ,
	assetcol1 varchar2 (40)  NULL ,
	assetcol2 varchar2 (40)  NULL ,
	assetcol3 varchar2 (40)  NULL ,
	assetcol4 varchar2 (40)  NULL ,
	assetcol5 varchar2 (40)  NULL ,
	assetcol6 varchar2 (40)  NULL ,
	assetfontsize varchar2 (40)  NULL ,
	assetfonttype varchar2 (40)  NULL ,
	webshopdap char (1)  NULL ,
	webshoptype char (1)  NULL ,
	webshopreturn char (1)  NULL ,
	webshopmanageid integer NULL ,
	createrid integer NULL ,
	createdate char (10)  NULL ,
	lastmoderid integer NULL ,
	lastmoddate char (10)  NULL 
)
/
create sequence LgcCatalogs_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcCatalogs_Trigger
before insert on LgcCatalogs
for each row
begin
select LgcCatalogs_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE LgcConfiguration (
	id integer not null ,
	supassetid integer NULL ,
	subassetid integer NULL ,
	relationtypeid integer NULL 
)
/
create sequence LgcConfiguration_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcConfiguration_Trigger
before insert on LgcConfiguration
for each row
begin
select LgcConfiguration_id.nextval into :new.id from dual;
end;
/

CREATE TABLE LgcCountType (
	id integer not null ,
	typename varchar2 (60)  NULL ,
	typedesc varchar2 (200)  NULL ,
	salesinid integer NULL ,
	salescostid integer NULL ,
	salestaxid integer NULL ,
	purchasetaxid integer NULL ,
	stockid integer NULL ,
	stockdiffid integer NULL ,
	producecostid integer NULL 
)
/
create sequence LgcCountType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcCountType_Trigger
before insert on LgcCountType
for each row
begin
select LgcCountType_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE LgcPaymentType (
	id integer not null ,
	typename varchar2 (60)  NULL ,
	typedesc varchar2 (200)  NULL ,
	paymentid integer NULL 
)
/
create sequence LgcPaymentType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcPaymentType_Trigger
before insert on LgcPaymentType
for each row
begin
select LgcPaymentType_id.nextval into :new.id from dual;
end ;
/


CREATE TABLE LgcRelateWorkflow (
	id integer NULL ,
	name varchar2 (80)  NULL 
)
/
CREATE TABLE LgcSearchDefine (
	userid integer null ,
	hasassetmark char (1)  NULL ,
	hasassetname char (1)  NULL ,
	hasassetcountry char (1)  NULL ,
	hasassetassortment char (1)  NULL ,
	hasassetstatus char (1)  NULL ,
	hasassettype char (1)  NULL ,
	hasassetversion char (1)  NULL ,
	hasassetattribute char (1)  NULL ,
	hasassetsalesprice char (1)  NULL ,
	hasdepartment char (1)  NULL ,
	hasresource char (1)  NULL ,
	hascrm char (1)  NULL ,
    perpage  integer default 20,				
	assetcol1 varchar2 (40)  NULL ,
	assetcol2 varchar2 (40)  NULL ,
	assetcol3 varchar2 (40)  NULL ,
	assetcol4 varchar2 (40)  NULL ,
	assetcol5 varchar2 (40)  NULL ,
	assetcol6 varchar2 (40)  NULL 
)
/

CREATE TABLE LgcSearchMould (
	id integer not null,
	mouldname varchar2 (200)  NULL ,
	userid integer NULL ,
	assetmark varchar2 (60)  NULL ,
	assetname varchar2 (60)  NULL ,
	assetcountry integer NULL ,
	assetassortment integer NULL ,
	assetstatus char (1)  NULL ,
	assettype integer NULL ,
	assetversion varchar2 (20)  NULL ,
	assetattribute varchar2 (100)  NULL ,
	assetsalespricefrom number(18, 3) NULL ,
	assetsalespriceto number(18, 3) NULL ,
	departmentid integer NULL ,
	resourceid integer NULL ,
	crmid integer NULL 
)
/
create sequence LgcSearchMould_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcSearchMould_Trigger
before insert on LgcSearchMould
for each row
begin
select LgcSearchMould_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE LgcStockInOut (
	id integer NOT NULL ,
	instockno integer NULL ,
	outstockno integer NULL ,
	warehouseid integer NULL ,
	stockdate char (10)  NULL ,
	departmentid integer NULL ,
	costcenterid integer NULL ,
	resourceid integer NULL ,
	crmid integer NULL ,
	projectid integer NULL ,
	docid integer NULL ,
	stockmodeid integer NULL ,
	modetype char (1)  NULL ,
	relativeid integer NULL ,
	createrid integer NULL ,
	createdate char (10)  NULL ,
	currencyid integer NULL ,
	defcurrencyid integer NULL ,
	exchangerate number(18, 3) default 1 ,
	defcountprice number(18, 3) NULL ,
	defcounttax number(18, 3) NULL ,
	countprice number(18, 3) default 0,
	counttax number(18, 3) default 0,
	stockremark varchar2 (200)  NULL ,
	status char (1)  NULL ,
	datefield1 varchar2 (10)  NULL ,
	datefield2 varchar2 (10)  NULL ,
	datefield3 varchar2 (10)  NULL ,
	datefield4 varchar2 (10)  NULL ,
	datefield5 varchar2 (10)  NULL ,
	numberfield1 float NULL ,
	numberfield2 float NULL ,
	numberfield3 float NULL ,
	numberfield4 float NULL ,
	numberfield5 float NULL ,
	textfield1 varchar2 (100)  NULL ,
	textfield2 varchar2 (100)  NULL ,
	textfield3 varchar2 (100)  NULL ,
	textfield4 varchar2 (100)  NULL ,
	textfield5 varchar2 (100)  NULL ,
	tinyintfield1 smallint NULL ,
	tinyintfield2 smallint NULL ,
	tinyintfield3 smallint NULL ,
	tinyintfield4 smallint NULL ,
	tinyintfield5 smallint NULL 
)
/
create sequence LgcStockInOut_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcStockInOut_Trigger
before insert on LgcStockInOut
for each row
begin
select LgcStockInOut_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE LgcStockInOutDetail (
	id integer not null ,		
	inoutid integer NULL ,
	assetid integer NULL ,
	batchmark varchar2 (20)  NULL ,
	number_n float NULL ,
	currencyid   integer null,		
	defcurrencyid   integer null ,	
	exchangerate     number(18,3)  default 1,	
	defunitprice number(18, 3) NULL ,
	unitprice	 number(18,3)		default 0,	
	taxrate		 integer		default 0
	)
/
create sequence LgcStockInOutDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcStockInOutDetail_Trigger
before insert on LgcStockInOutDetail
for each row
begin
select LgcStockInOutDetail_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE LgcStockMode (
	id integer not null ,
	modename varchar2 (60)  NULL ,
	modetype char (1)  NULL ,
	modestatus char (1)  default '1' ,
	modedesc varchar2 (200)  NULL 
)
/
create sequence LgcStockMode_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcStockMode_Trigger
before insert on LgcStockMode
for each row
begin
select LgcStockMode_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE LgcWarehouse (
	id integer not null,
	warehousename varchar2 (40)  NULL ,
	warehousedesc varchar2 (200)  NULL ,
	roleid integer NULL 
)
/
create sequence LgcWarehouse_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcWarehouse_Trigger
before insert on LgcWarehouse
for each row
begin
select LgcWarehouse_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE LgcWebShop (
	id integer not null ,		
	usertype smallint NULL ,
	userid integer NULL ,
	username varchar2 (60)  NULL ,
	usercountry integer NULL ,
	useremail varchar2 (60)  NULL ,
	receiveaddress varchar2 (200)  NULL ,
	receivetype integer NULL ,
	postcode varchar2 (10)  NULL ,
	telephone1 varchar2 (20)  NULL ,
	telephone2 varchar2 (20)  NULL ,
	paymentmode varchar2 (2)  NULL ,
	currencyid   integer null ,		
	purchasecount number(18, 3) NULL ,
	purchaseremark varchar2(4000)  NULL ,
	purchasedate char (10)  NULL ,
	purchasestatus char (1)  NULL ,
	manageid integer NULL 
)
/
create sequence LgcWebShop_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcWebShop_Trigger
before insert on LgcWebShop
for each row
begin
select LgcWebShop_id.nextval into :new.id from dual;
end ;
/
CREATE TABLE LgcWebShopDetail (
	id integer not null ,		
	webshopid integer NULL ,
	assetid integer NULL ,
	countryid integer NULL ,
	currencyid   integer null ,		
	assetprice number(18, 3) NULL ,
	taxrate integer NULL ,
	purchasenum float NULL 
)
/
create sequence LgcWebShopDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcWebShopDetail_Trigger
before insert on LgcWebShopDetail
for each row
begin
select LgcWebShopDetail_id.nextval into :new.id from dual;
end ;
/
CREATE TABLE LgcWebShopReceiveType (
	id integer not null,
	typename varchar2 (60)  NULL ,
	typeesc varchar2(4000)  NULL ,
	typecountry integer NULL 
)
/
create sequence LgcWebShopReceiveType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger LgcWebShopReceiveType_Trigger
before insert on LgcWebShopReceiveType
for each row
begin
select LgcWebShopReceiveType_id.nextval into :new.id from dual;
end ;
/
CREATE TABLE MailPassword (
	resourceid integer not null,
	resourcemail varchar2 (60)  NULL ,
	password varchar2 (40)  NULL 
)
/

CREATE TABLE MailResource (
	id integer not null ,
	resourceid integer NULL ,
	priority char (1)  NULL ,
	sendfrom varchar2 (200)  NULL ,
	sendcc varchar2 (200)  NULL ,
	sendbcc varchar2 (200)  NULL ,
	sendto varchar2 (200)  NULL ,
	senddate varchar2 (30)  NULL ,
	size_n integer NULL ,
	subject varchar2 (250)  NULL ,
	content varchar2(4000)  NULL ,
	mailtype char (1)  NULL 
)  
/
create sequence MailResource_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger MailResource_Trigger
before insert on MailResource
for each row
begin
select MailResource_id.nextval into :new.id from dual;
end ;
/
CREATE TABLE MailResourceFile (
	id integer  not null,
	mailid integer NULL ,
	filename varchar2 (100)  NULL ,
	attachfile blob NULL ,
	filetype varchar2 (60)  NULL 
)
/
create sequence MailResourceFile_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger MailResourceFile_Trigger
before insert on MailResourceFile
for each row
begin
select MailResourceFile_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE MailShare (
	id integer  NOT NULL ,
	mailgroupid integer NULL ,
	sharetype smallint NULL ,
	seclevel smallint NULL ,
	rolelevel smallint NULL ,
	sharelevel smallint NULL ,
	userid integer NULL ,
	subcompanyid integer NULL ,
	departmentid integer NULL ,
	roleid integer NULL ,
	foralluser smallint NULL ,
	sharedcrm integer NULL 
)
/
create sequence MailShare_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger MailShare_Trigger
before insert on MailShare
for each row
begin
select MailShare_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE MailUser (
	mailgroupid integer NULL ,
	resourceid integer NULL 
)
/

CREATE TABLE MailUserAddress (
	mailgroupid integer NULL ,
	mailaddress varchar2 (255)  NULL ,
	maildesc varchar2 (255)  NULL 
)
/


CREATE TABLE MailUserGroup (
	mailgroupid integer  NOT NULL ,
	mailgroupname varchar2 (200)  NULL ,
	operatedesc varchar2 (255)  NULL ,
	createrid integer NULL ,
	createrdate char (10)  NULL 
)
/
create sequence MailUserGroup_mailgroupid
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger MailUserGroup_Trigger
before insert on MailUserGroup
for each row
begin
select MailUserGroup_mailgroupid.nextval INTO :new.mailgroupid from dual;
end;
/

CREATE TABLE MailUserShare (
	mailgroupid integer NULL ,
	userid integer NULL 
)
/


CREATE TABLE Meeting (
	id integer  NOT NULL ,
	meetingtype integer NULL ,
	name varchar2 (255)  NULL ,
	caller integer NULL ,
	contacter integer NULL ,
	address integer NULL ,
	begindate varchar2 (10)  NULL ,
	begintime varchar2 (8)  NULL ,
	enddate varchar2 (10)  NULL ,
	endtime varchar2 (8)  NULL ,
	desc_n varchar2 (255)  NULL ,
	creater integer NULL ,
	createdate varchar2 (10)  NULL ,
	createtime varchar2 (8)  NULL ,
	approver integer NULL ,
	approvedate varchar2 (10)  NULL ,
	approvetime varchar2 (8)  NULL ,
	isapproved smallint default 0 ,
	isdecision smallint default 0 ,
	decision varchar2(4000)  NULL ,
	decisiondocid integer NULL ,
	decisiondate varchar2 (10)  NULL ,
	decisiontime varchar2 (8)  NULL ,
	decisionhrmid integer NULL ,
	projectid integer NULL ,
	totalmember integer NULL ,
	othermembers varchar2(4000)  NULL ,
	othersremark varchar2(4000)  NULL ,
	addressdesc varchar2 (255)  NULL 
)
/
create sequence Meeting_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Meeting_Trigger
before insert on Meeting
for each row
begin
select Meeting_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE MeetingCaller (
	id integer  NOT NULL ,
	meetingtype integer NULL ,
	callertype integer NULL ,
	seclevel integer NULL ,
	rolelevel integer NULL ,
	userid integer NULL ,
	departmentid integer NULL ,
	roleid integer NULL ,
	foralluser integer NULL 
)
/
create sequence MeetingCaller_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger MeetingCaller_Trigger
before insert on MeetingCaller
for each row
begin
select MeetingCaller_id.nextval into :new.id from dual;
end ;
/


CREATE TABLE Meeting_Address (
	id integer NOT NULL ,
	meetingtype integer NULL ,
	addressid integer NULL ,
	desc_n varchar2 (255)  NULL 
)
/
create sequence Meeting_Address_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Meeting_Address_Trigger
before insert on Meeting_Address
for each row
begin
select Meeting_Address_id.nextval into :new.id from dual;
end ;
/


CREATE TABLE Meeting_Decision (
	id integer  NOT NULL ,
	meetingid integer NULL ,
	requestid integer NULL ,
	coding varchar2 (100)  NULL ,
	subject varchar2 (255)  NULL ,
	hrmid01 varchar2 (255)  NULL ,
	hrmid02 integer NULL ,
	begindate varchar2 (10)  NULL ,
	begintime varchar2 (8)  NULL ,
	enddate varchar2 (10)  NULL ,
	endtime varchar2 (8)  NULL 
)
/
create sequence Meeting_Decision_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Meeting_Decision_Trigger
before insert on Meeting_Decision
for each row
begin
select Meeting_Decision_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE Meeting_Member (
	id integer  NOT NULL ,
	meetingtype integer NULL ,
	membertype smallint NULL ,
	memberid integer NULL ,
	desc_n varchar2 (255)  NULL 
)
/
create sequence Meeting_Member_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Meeting_Member_Trigger
before insert on Meeting_Member
for each row
begin
select Meeting_Member_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE Meeting_Member2 (
	id integer  NOT NULL ,
	meetingid integer NULL ,
	membertype smallint NULL ,
	memberid integer NULL ,
	membermanager integer NULL ,
	isattend varchar2 (50)  NULL ,
	begindate varchar2 (10)  NULL ,
	begintime varchar2 (8)  NULL ,
	enddate varchar2 (10)  NULL ,
	endtime varchar2 (8)  NULL ,
	bookroom varchar2 (50)  NULL ,
	roomstander varchar2 (50)  NULL ,
	bookticket varchar2 (50)  NULL ,
	ticketstander varchar2 (50)  NULL ,
	othermember varchar2 (255)  NULL 
)
/
create sequence Meeting_Member2_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Meeting_Member2_Trigger
before insert on Meeting_Member2
for each row
begin
select Meeting_Member2_id.nextval into :new.id from dual;
end ;
/


CREATE TABLE Meeting_MemberCrm (
	id integer  NOT NULL ,
	meetingid integer NULL ,
	memberrecid integer NULL ,
	name varchar2 (100)  NULL ,
	sex smallint NULL ,
	occupation varchar2 (100)  NULL ,
	tel varchar2 (100)  NULL ,
	handset varchar2 (100)  NULL ,
	desc_n varchar2 (255)  NULL 
)
/
create sequence Meeting_MemberCrm_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Meeting_MemberCrm_Trigger
before insert on Meeting_MemberCrm
for each row
begin
select Meeting_MemberCrm_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE Meeting_Service (
	id integer  NOT NULL ,
	meetingtype integer NULL ,
	hrmid integer NULL ,
	name varchar2 (255)  NULL ,
	desc_n varchar2 (255)  NULL 
)
/
create sequence Meeting_Service_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Meeting_Service_Trigger
before insert on Meeting_Service
for each row
begin
select Meeting_Service_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE Meeting_Service2 (
	id integer  NOT NULL ,
	meetingid integer NULL ,
	hrmid integer NULL ,
	name varchar2 (255)  NULL ,
	desc_n varchar2 (255)  NULL 
)
/
create sequence Meeting_Service2_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Meeting_Service2_Trigger
before insert on Meeting_Service2
for each row
begin
select Meeting_Service2_id.nextval into :new.id from dual;
end ;
/


CREATE TABLE Meeting_Topic (
	id integer NOT NULL ,
	meetingid integer NULL ,
	subject varchar2 (255)  NULL ,
	hrmid integer NULL ,
	isopen smallint NULL ,
	hrmids varchar2 (255)  NULL ,
	projid integer NULL ,
	crmid integer NULL 
)
/
create sequence Meeting_Topic_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Meeting_Topic_Trigger
before insert on Meeting_Topic
for each row
begin
select Meeting_Topic_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE Meeting_TopicDate (
	id integer  NOT NULL ,
	meetingid integer NULL ,
	topicid integer NULL ,
	begindate varchar2 (10)  NULL ,
	begintime varchar2 (8)  NULL ,
	enddate varchar2 (10)  NULL ,
	endtime varchar2 (8)  NULL 
)
/
create sequence Meeting_TopicDate_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Meeting_TopicDate_Trigger
before insert on Meeting_TopicDate
for each row
begin
select Meeting_TopicDate_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE Meeting_TopicDoc (
	id integer  NOT NULL ,
	meetingid integer NULL ,
	topicid integer NULL ,
	docid integer NULL ,
	hrmid integer NULL 
)
/
create sequence Meeting_TopicDoc_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Meeting_TopicDoc_Trigger
before insert on Meeting_TopicDoc
for each row
begin
select Meeting_TopicDoc_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE Meeting_Type (
	id integer  NOT NULL ,
	name varchar2 (255)  NULL ,
	approver integer NULL ,
	desc_n varchar2 (255)  NULL 
)
/
create sequence Meeting_Type_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Meeting_Type_Trigger
before insert on Meeting_Type
for each row
begin
select Meeting_Type_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE NewDocFrontpage (
	usertype integer NULL ,
	userid integer NULL ,
	docid integer NULL 
)
/

CREATE TABLE PrjShareDetail (
	prjid integer NULL ,
	userid integer NULL ,
	usertype integer NULL ,
	sharelevel integer NULL 
)
/

CREATE TABLE Prj_Cpt (
	id integer  NOT NULL ,
	prjid integer NULL ,
	taskid integer NULL ,
	isactived smallint default 0 ,
	version smallint NULL ,
	requestid integer default 0 ,
	type smallint default 0 
)
/
create sequence Prj_Cpt_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_Cpt_Trigger
before insert on Prj_Cpt
for each row
begin
select Prj_Cpt_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE Prj_Customer (
	id integer  NOT NULL ,
	prjid integer NULL ,
	taskid integer NULL ,
	customerid integer NULL ,
	powerlevel smallint NULL ,
	reasondesc varchar2 (100)  NULL 
)
/
create sequence Prj_Customer_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_Customer_Trigger
before insert on Prj_Customer
for each row
begin
select Prj_Customer_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE Prj_Doc (
	id integer NOT NULL ,
	prjid integer NULL ,
	taskid integer NULL ,
	isactived smallint default 0,
	version smallint NULL ,
	docid integer default 0 ,
	type smallint default 0
)
/
create sequence Prj_Doc_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_Doc_Trigger
before insert on Prj_Doc
for each row
begin
select Prj_Doc_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE Prj_Jianbao (
	projectid integer NULL ,
	type char (2)  NULL ,
	documentid integer NULL ,
	content varchar2 (255)  NULL ,
	submitdate varchar2 (10)  NULL ,
	submittime varchar2 (8)  NULL ,
	submiter integer NULL ,
	clientip char (15)  NULL ,
	submitertype smallint NULL 
)
/


CREATE TABLE Prj_Log (
	projectid integer NULL ,
	logtype char (2)  NULL ,
	documentid integer NULL ,
	logcontent varchar2 (255)  NULL ,
	submitdate varchar2 (10)  NULL ,
	submittime varchar2 (8)  NULL ,
	submiter integer NULL ,
	clientip char (15)  NULL ,
	submitertype smallint NULL 
)
/


CREATE TABLE Prj_Material (
	id integer  NOT NULL ,
	prjid integer NULL ,
	taskid integer NULL ,
	material varchar2 (100)  NULL ,
	unit varchar2 (10)  NULL ,
	version varchar2 (200)  NULL ,
	begindate varchar2 (10)  NULL ,
	enddate varchar2 (10)  NULL ,
	quantity integer default 0 ,
	cost number(10, 2) default 0.00
)
/
create sequence Prj_Material_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_Material_Trigger
before insert on Prj_Material
for each row
begin
select Prj_Material_id.nextval into :new.id from dual;
end ;
/


CREATE TABLE Prj_MaterialProcess (
	id integer  NOT NULL ,
	prjid integer NULL ,
	taskid integer NULL ,
	material varchar2 (100)  NULL ,
	unit varchar2 (10)  NULL ,
	isactived smallint default 0 ,
	begindate varchar2 (10)  NULL ,
	enddate varchar2 (10)  NULL ,
	quantity integer default 0 ,
	cost number(10, 2) default 0.00
)
/
create sequence Prj_MaterialProcess_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_MaterialProcess_Trigger
before insert on Prj_MaterialProcess
for each row
begin
select Prj_MaterialProcess_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE Prj_Member (
	id integer  NOT NULL ,
	prjid integer NULL ,
	taskid integer NULL ,
	relateid integer NOT NULL ,
	version varchar2 (200)  NULL ,
	begindate varchar2 (10)  NULL ,
	enddate varchar2 (10)  NULL ,
	workday number(10, 1) default 0.0,
	cost number(10, 2) default 0.00
)
/
create sequence Prj_Member_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_Member_Trigger
before insert on Prj_Member
for each row
begin
select Prj_Member_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE Prj_MemberProcess (
	id integer  NOT NULL ,
	prjid integer NULL ,
	taskid integer NULL ,
	relateid integer NOT NULL ,
	isactived smallint default 0,
	begindate varchar2 (10)  NULL ,
	enddate varchar2 (10)  NULL ,
	workday number(10, 1) default 0.0 ,
	cost number(10, 2) default 0.00
)
/
create sequence Prj_MemberProcess_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_MemberProcess_Trigger
before insert on Prj_MemberProcess
for each row
begin
select Prj_MemberProcess_id.nextval into :new.id from dual;
end ;
/



CREATE TABLE Prj_Modify (
	projectid integer NULL ,
	type char (20)  NULL ,
	fieldname varchar2 (100)  NULL ,
	modifydate varchar2 (10)  NULL ,
	modifytime varchar2 (8)  NULL ,
	original varchar2 (255)  NULL ,
	modified varchar2 (255)  NULL ,
	modifier integer NULL ,
	clientip char (15)  NULL ,
	submitertype smallint NULL 
)
/


CREATE TABLE Prj_PlanInfo (
	id integer  NOT NULL ,
	prjid integer NULL ,
	subject varchar2 (50)  NULL ,
	begindate varchar2 (10)  NULL ,
	enddate varchar2 (10)  NULL ,
	begintime varchar2 (8)  NULL ,
	endtime varchar2 (8)  NULL ,
	resourceid integer NULL ,
	content varchar2 (255)  NULL ,
	budgetmoney varchar2 (50)  NULL ,
	docid integer NULL ,
	plansort integer NULL ,
	plantype integer NULL ,
	updatedate varchar2 (10)  NULL ,
	updatetime varchar2 (5)  NULL ,
	updater integer NULL ,
	validate_n integer NULL 
)
/
create sequence Prj_PlanInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_PlanInfo_Trigger
before insert on Prj_PlanInfo
for each row
begin
select Prj_PlanInfo_id.nextval into :new.id from dual;
end ;
/


CREATE TABLE Prj_PlanSort (
	id integer  not null ,
	fullname varchar2 (50)  NULL ,
	description varchar2 (150)  NULL 
)
/
create sequence Prj_PlanSort_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_PlanSort_Trigger
before insert on Prj_PlanSort
for each row
begin
select Prj_PlanSort_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Prj_PlanType (
	id integer not null ,
	fullname varchar2 (50)  NULL ,
	description varchar2 (150)  NULL 
)
/
create sequence Prj_PlanType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_PlanType_Trigger
before insert on Prj_PlanType
for each row
begin
select Prj_PlanType_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Prj_Processing (
	id integer not null ,
	prjid integer NULL ,
	planid integer NULL ,
	title varchar2 (50)  NULL ,
	content varchar2 (255)  NULL ,
	type integer NULL ,
	docid integer NULL ,
	parentids varchar2 (255)  NULL ,
	submitdate varchar2 (10)  NULL ,
	submittime varchar2 (5)  NULL ,
	submiter integer NULL ,
	updatedate varchar2 (10)  NULL ,
	updatetime varchar2 (5)  NULL ,
	updater integer NULL ,
	isprocessed smallint NULL ,
	processdate varchar2 (10)  NULL ,
	processtime varchar2 (8)  NULL ,
	processor integer NULL 
)
/
create sequence Prj_Processing_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_Processing_Trigger
before insert on Prj_Processing
for each row
begin
select Prj_Processing_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Prj_ProcessingType (
	id integer not null ,
	fullname varchar2 (30)  NULL ,
	description varchar2 (150)  NULL ,
	isdefault smallint NULL 
)
/
create sequence Prj_ProcessingType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_ProcessingType_Trigger
before insert on Prj_ProcessingType
for each row
begin
select Prj_ProcessingType_id.nextval into :new.id from dual;
end;
/




CREATE TABLE Prj_ProjectInfo (
	id integer not null ,
	name varchar2 (50)  NULL ,
	description varchar2 (250)  NULL ,
	prjtype integer NULL ,
	worktype integer NULL ,
	securelevel integer NULL ,
	status integer NULL ,
	isblock smallint NULL ,
	managerview smallint NULL ,
	parentview smallint NULL ,
	budgetmoney number(12,3) NULL ,
	moneyindeed number(12,3) NULL ,
	budgetincome number(12,3) NULL ,
	imcomeindeed number(12,3) NULL ,
	planbegindate varchar2 (10)  NULL ,
	planbegintime varchar2 (5)  NULL ,
	planenddate varchar2 (10)  NULL ,
	planendtime varchar2 (5)  NULL ,
	truebegindate varchar2 (10)  NULL ,
	truebegintime varchar2 (5)  NULL ,
	trueenddate varchar2 (10)  NULL ,
	trueendtime varchar2 (5)  NULL ,
	planmanhour integer NULL ,
	truemanhour integer NULL ,
	picid integer NULL ,
	intro varchar2 (255)  NULL ,
	parentid integer NULL ,
	envaluedoc integer NULL ,
	confirmdoc integer NULL ,
	proposedoc integer NULL ,
	manager integer NULL ,
	department integer NULL ,
	creater integer NULL ,
	createdate varchar2 (10)  NULL ,
	createtime varchar2 (8)  NULL ,
	isprocessed smallint NULL ,
	processer integer NULL ,
	processdate varchar2 (10)  NULL ,
	processtime varchar2 (8)  NULL ,
	datefield1 varchar2 (10)  NULL ,
	datefield2 varchar2 (10)  NULL ,
	datefield3 varchar2 (10)  NULL ,
	datefield4 varchar2 (10)  NULL ,
	datefield5 varchar2 (10)  NULL ,
	numberfield1 float NULL ,
	numberfield2 float NULL ,
	numberfield3 float NULL ,
	numberfield4 float NULL ,
	numberfield5 float NULL ,
	textfield1 varchar2 (100)  NULL ,
	textfield2 varchar2 (100)  NULL ,
	textfield3 varchar2 (100)  NULL ,
	textfield4 varchar2 (100)  NULL ,
	textfield5 varchar2 (100)  NULL ,
	tinyintfield1 smallint NULL ,
	tinyintfield2 smallint NULL ,
	tinyintfield3 smallint NULL ,
	tinyintfield4 smallint NULL ,
	tinyintfield5 smallint NULL ,
	subcompanyid1 integer NULL 
)
/
create sequence Prj_ProjectInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_ProjectInfo_Trigger
before insert on Prj_ProjectInfo
for each row
begin
select Prj_ProjectInfo_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Prj_ProjectStatus (
	id integer not null  ,
	fullname varchar2 (50)  NULL ,
	description varchar2 (150)  NULL 
)
/
create sequence Prj_ProjectStatus_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_ProjectStatus_Trigger
before insert on Prj_ProjectStatus
for each row
begin
select Prj_ProjectStatus_id.nextval into :new.id from dual;
end;
/
CREATE TABLE Prj_ProjectType (
	id integer not null  ,
	fullname varchar2 (50)  NULL ,
	description varchar2 (150)  NULL ,
	wfid integer NULL 
)
/
create sequence Prj_ProjectType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_ProjectType_Trigger
before insert on Prj_ProjectType
for each row
begin
select Prj_ProjectType_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Prj_Request (
	id integer not null ,
	prjid integer NULL ,
	taskid integer NULL ,
	isactived smallint default 0,
	version smallint NULL ,
	requestid integer default 0 ,
	type smallint default 0
)
/
create sequence Prj_Request_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_Request_Trigger
before insert on Prj_Request
for each row
begin
select Prj_Request_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Prj_SearchMould (
	id integer  not null,
	mouldname varchar2 (200)  NULL ,
	userid integer NULL ,
	prjid integer NULL ,
	status varchar2 (60)  NULL ,
	prjtype varchar2 (60)  NULL ,
	worktype varchar2 (60)  NULL ,
	nameopt integer NULL ,
	name varchar2 (60)  NULL ,
	description varchar2 (250)  NULL ,
	customer integer NULL ,
	parent integer NULL ,
	securelevel integer NULL ,
	department integer NULL ,
	manager integer NULL ,
	member integer NULL 
)
/
create sequence Prj_SearchMould_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_SearchMould_Trigger
before insert on Prj_SearchMould
for each row
begin
select Prj_SearchMould_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Prj_ShareInfo (
	id integer not null,
	relateditemid integer NULL ,
	sharetype smallint NULL ,
	seclevel smallint NULL ,
	rolelevel smallint NULL ,
	sharelevel smallint default 0 ,
	userid integer NULL ,
	departmentid integer NULL ,
	roleid integer NULL ,
	foralluser smallint NULL ,
	crmid integer default 0 
)
/
create sequence Prj_ShareInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_ShareInfo_Trigger
before insert on Prj_ShareInfo
for each row
begin
select Prj_ShareInfo_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Prj_TaskInfo (
	id integer  not null,
	prjid integer NULL ,
	taskid integer NULL ,
	wbscoding varchar2 (20)  NULL ,
	subject varchar2 (80)  NULL ,
	version smallint NULL ,
	isactived smallint default 0 ,
	workday number(10, 1) default 0.0,
	begindate varchar2 (10)  NULL ,
	enddate varchar2 (10)  NULL ,
	content varchar2 (255)  NULL ,
	fixedcost number(10, 2) default 0.00,
	parentid integer default 0,
	parentids varchar2 (255)  NULL ,
	level_n smallint default 1 ,
	hrmid integer NULL ,
	parenthrmids varchar2 (255)  NULL ,
	isdelete smallint default 0 ,
	childnum integer default 0
)
/
create sequence Prj_TaskInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_TaskInfo_Trigger
before insert on Prj_TaskInfo
for each row
begin
select Prj_TaskInfo_id.nextval into :new.id from dual;
end;
/


CREATE TABLE Prj_TaskProcess (
	id integer NOT NULL ,
	prjid integer NULL ,
	taskid integer NULL ,
	isactived smallint default 0 ,
	version smallint NULL ,
	workday number(10, 1) default 0.0 ,
	begindate varchar2 (10)  NULL ,
	enddate varchar2 (10)  NULL ,
	content varchar2 (255)  NULL ,
	fixedcost number(10, 2) default 0.00 ,
	finish smallint default 0 ,
	wbscoding varchar2 (20)  NULL ,
	subject varchar2 (80)  NULL ,
	parentid integer default 0 ,
	parentids varchar2 (255)  NULL ,
	level_n smallint default 1 ,
	hrmid integer NULL ,
	parenthrmids varchar2 (255)  NULL ,
	isdelete smallint default 0 ,
	childnum integer default 0
)
/
create sequence Prj_TaskProcess_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_TaskProcess_Trigger
before insert on Prj_TaskProcess
for each row
begin
select Prj_TaskProcess_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Prj_Tool (
	id integer  not null,
	prjid integer NULL ,
	taskid integer NULL ,
	relateid integer  not null,
	version varchar2 (200)  NULL ,
	begindate varchar2 (10)  NULL ,
	enddate varchar2 (10)  NULL ,
	workday number(10, 1) default 0.0 ,
	cost number(10, 2) default 0.00
)
/
create sequence Prj_Tool_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_Tool_Trigger
before insert on Prj_Tool
for each row
begin
select Prj_Tool_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Prj_ToolProcess (
	id integer  ,
	prjid integer NULL ,
	taskid integer NULL ,
	relateid integer not null ,
	isactived smallint default 0,
	begindate varchar2 (10)  NULL ,
	enddate varchar2 (10)  NULL ,
	workday integer default 0.0 ,
	cost number(10, 1) default 0.0 
)
/
create sequence Prj_ToolProcess_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_ToolProcess_Trigger
before insert on Prj_ToolProcess
for each row
begin
select Prj_ToolProcess_id.nextval into :new.id from dual;
end;
/



CREATE TABLE Prj_ViewLog (
	projectid integer NULL ,
	type integer NULL ,
	modifydate varchar2 (10)  NULL ,
	modifytime varchar2 (8)  NULL ,
	modifier integer NULL ,
	clientip char (15)  NULL 
)
/

CREATE TABLE Prj_ViewLog1 (
	id integer not null ,
	viewer integer NULL ,
	viewdate char (10)  NULL ,
	viewtime char (8)  NULL ,
	ipaddress char (15)  NULL ,
	submitertype smallint NULL 
)
/

CREATE TABLE Prj_WorkType (
	id integer not null ,
	fullname varchar2 (50)  NULL ,
	description varchar2 (150)  NULL 
)
/
create sequence Prj_WorkType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_WorkType_Trigger
before insert on Prj_WorkType
for each row
begin
select Prj_WorkType_id.nextval into :new.id from dual;
end;
/

CREATE TABLE ProcedureInfo (
	id integer not null,
	procedurename varchar2 (100)  NULL ,
	proceduretabel varchar2 (200)  NULL ,
	procedurescript varchar2(4000)  NULL ,
	proceduredesc varchar2(4000)  NULL 
)
/
create sequence ProcedureInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger ProcedureInfo_Trigger
before insert on ProcedureInfo
for each row
begin
select ProcedureInfo_id.nextval into :new.id from dual;
end;
/

CREATE TABLE SequenceIndex (
	indexdesc varchar2 (40) unique ,
	currentid integer NULL 
)
/

CREATE TABLE SysFavourite (
	Resourceid integer NULL ,
	Adddate char (10)  NULL ,
	Addtime char (8)  NULL ,
	Pagename varchar2 (150)  NULL ,
	URL varchar2 (100)  NULL ,
	id integer not null 
)
/
create sequence SysFavourite_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger SysFavourite_Trigger
before insert on SysFavourite
for each row
begin
select SysFavourite_id.nextval into :new.id from dual;
end;
/

CREATE TABLE SysMaintenanceLog (
	id integer not null,
	relatedid integer not null ,
	relatedname varchar2 (200) not null   ,
	operatetype varchar2 (2)  not null ,
	operatedesc  varchar2(4000)  NULL ,
	operateitem varchar2 (3) not null  ,
	operateuserid integer not null ,
	operatedate char (10) not null  ,
	operatetime char (8)  not null ,
	clientaddress char (15)  NULL 
)
/
create sequence SysMaintenanceLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger SysMaintenanceLog_Trigger
before insert on SysMaintenanceLog
for each row
begin
select SysMaintenanceLog_id.nextval into :new.id from dual;
end;
/

CREATE TABLE SysRemindInfo (
	userid integer NULL ,
	usertype smallint NULL ,
	hascrmcontact smallint default 0,
	hasnewwf varchar2(4000) null,
	hasdealwf smallint default 0 ,
	hasendwf  varchar2(4000) NULL ,
	haspasstimenode smallint default 0,
	hasapprovedoc smallint default 0 ,
	hasdealdoc smallint default 0 ,
	hasnewemail smallint default 0
)
/



CREATE TABLE Sys_Slogan (                                  
slogan varchar2 (255)  null,                                   
speed smallint NULL ,                                      
fontcolor char (6)  null,                                      
backcolor char (6)  null                                     
)
/
   
CREATE TABLE SystemLog (
	id integer not null,
	createdate char (10)  NULL ,
	createtime char (7)  NULL ,
	classname varchar2 (30)  NULL ,
	sqlstr varchar2(4000)  NULL 
)
/
create sequence SystemLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger SystemLog_Trigger
before insert on SystemLog
for each row
begin
select SystemLog_id.nextval into :new.id from dual;
end;
/

CREATE TABLE SystemLogItem (
	itemid varchar2 (3)  unique ,
	lableid integer NULL ,
	itemdesc varchar2 (40)  NULL 
)
/


CREATE TABLE SystemRightDetail (
	id integer not null,
	rightdetailname varchar2 (100)  NULL ,
	rightdetail varchar2 (100)  NULL ,
	rightid integer NULL 
)
/


CREATE TABLE SystemRightGroups (
	id integer not null,
	rightgroupmark varchar2 (60)  NULL ,
	rightgroupname varchar2 (200)  NULL ,
	rightgroupremark varchar2 (255)  NULL 
)
/
create sequence SystemRightGroups_id                       
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger SystemRightGroups_Trigger        
before insert on SystemRightGroups                         
for each row                                               
begin                                                      
select SystemRightGroups_id.nextval INTO :new.id from dual;
end;
/  

CREATE TABLE SystemRightRoles (
	id integer not null,
	rightid integer NULL ,
	roleid integer NULL ,
	rolelevel char (1)  NULL 
)
/
create sequence SystemRightRoles_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger SystemRightRoles_Trigger
before insert on SystemRightRoles
for each row
begin
select SystemRightRoles_id.nextval into :new.id from dual;
end;
/


create table SystemRightToGroup(                           
id integer not null ,                     
groupid integer,                                           
rightid integer                                            
)
/
create sequence SystemRightToGroup_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger SystemRightToGroup_Trigger       
before insert on SystemRightToGroup                        
for each row                                               
begin                                                      
select SystemRightToGroup_id.nextval INTO :new.id from dual;
end;                                                       
/  

CREATE TABLE SystemRights (
	id integer NULL ,
	rightdesc varchar2 (300)  NULL ,
	righttype char (1)  NULL 
)
/

create table SystemRightsLanguage(                         
id integer null,						   
languageid integer null,					   
rightname varchar2(200),				   
rightdesc varchar2(200)				           
)
/

CREATE TABLE SystemSet (
	emailserver varchar2 (60)  NULL ,
	debugmode char (1)  NULL ,
	logleaveday smallint NULL 
)
/



CREATE TABLE Weather (
	id integer  NOT NULL ,
	thedate char (10)  NULL ,
	picid integer NULL ,
	thedesc varchar2 (100)  NULL ,
	temperature varchar2 (100)  NULL 
)
/
create sequence Weather_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger Weather_Trigger       
before insert on Weather                        
for each row                                               
begin                                                      
select Weather_id.nextval INTO :new.id from dual;
end;                                                       
/  


CREATE TABLE WorkflowReportShare (
	id integer  NOT NULL ,
	reportid integer NULL ,
	sharetype integer NULL ,
	seclevel smallint NULL ,
	rolelevel smallint NULL ,
	sharelevel smallint NULL ,
	userid integer NULL ,
	subcompanyid integer NULL ,
	departmentid integer NULL ,
	roleid integer NULL ,
	foralluser smallint NULL ,
	crmid integer NULL 
)
/
create sequence WorkflowReportShare_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger WorkflowReportShare_Trigger       
before insert on WorkflowReportShare                        
for each row                                               
begin                                                      
select WorkflowReportShare_id.nextval INTO :new.id from dual;
end;                                                       
/  

CREATE TABLE WorkflowReportShareDetail (
	reportid integer NULL ,
	userid integer NULL ,
	usertype integer NULL ,
	sharelevel integer NULL 
)
/

CREATE TABLE Workflow_Report (
	id integer not null,
	reportname varchar2 (100)  NULL ,
	reporttype integer NULL ,
	reportwfid integer NULL 
)
/
create sequence Workflow_Report_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger Workflow_Report_Trigger       
before insert on Workflow_Report                        
for each row                                               
begin                                                      
select Workflow_Report_id.nextval INTO :new.id from dual;
end;                                                       
/    


CREATE TABLE Workflow_ReportDspField (
	id integer not null ,
	reportid integer NULL ,
	fieldid integer NULL ,
	dsporder integer default 0 ,
	isstat char (1)  default '0' ,
	dborder char (1) null 
)
/
create sequence Workflow_ReportDspField_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger Workflow_ReportDspField_Tr     
before insert on Workflow_ReportDspField                        
for each row                                               
begin                                                      
select Workflow_ReportDspField_id.nextval INTO :new.id from dual;
end;                                                       
/   


CREATE TABLE Workflow_ReportType (
	id integer not null,
	typename varchar2 (60)  NULL ,
	typedesc varchar2 (250)  NULL ,
	typeorder integer default 0
)
/
create sequence Workflow_ReportType_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger Workflow_ReportType_Trigger     
before insert on Workflow_ReportType                        
for each row                                               
begin                                                      
select Workflow_ReportType_id.nextval INTO :new.id from dual;
end;                                                       
/  



CREATE TABLE bgyp (
	lx1 varchar2 (255)  NULL ,
	lx2 varchar2 (255)  NULL ,
	mc varchar2 (255)  NULL ,
	bh varchar2 (255)  NULL ,
	ggxh varchar2 (255)  NULL ,
	jg float NULL ,
	kc float NULL ,
	bz varchar2 (255)  NULL 
)
/


CREATE TABLE bgyp2 (
	lx1 varchar2 (255)  NULL ,
	lx2 varchar2 (255)  NULL ,
	mc varchar2 (255)  NULL ,
	gly varchar2 (50)  NULL ,
	bh varchar2 (255)  NULL ,
	ggxh varchar2 (255)  NULL ,
	jg float NULL ,
	kc float NULL ,
	bz varchar2 (255)  NULL 
)
/


CREATE TABLE bill_Approve (
	id integer  NOT NULL ,
	billid integer NULL ,
	requestid integer NULL ,
	approveid integer NULL ,
	approvetype integer NULL ,
	gopage varchar2 (200)  NULL ,
	manager integer NULL ,
	status char (1)  NULL ,
	needlawcheck char (1)  NULL ,
	president integer NULL 
)
/
create sequence bill_Approve_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_Approve_Trigger     
before insert on bill_Approve                        
for each row                                               
begin                                                      
select bill_Approve_id.nextval INTO :new.id from dual;
end;                                                       
/   


CREATE TABLE bill_BudgetDetail (
	departmentid integer NULL ,
	feeid integer NULL ,
	month integer NULL ,
	budget number(10, 3) NULL ,
	year integer NULL 
)
/


CREATE TABLE bill_CptAdjustDetail (
	id integer  not null,
	cptadjustid integer NULL ,
	cptid integer NULL ,
	number_n number(10, 3) NULL ,
	unitprice number(10, 3) NULL ,
	amount number(10, 3) NULL ,
	cptstatus integer NULL ,
	needdate varchar2 (10)  NULL ,
	purpose varchar2 (60)  NULL ,
	cptdesc varchar2 (60)  NULL ,
	capitalid integer default 0
)  
/
create sequence bill_CptAdjustDetail_id                     
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_CptAdjustDetail_Trigger     
before insert on bill_CptAdjustDetail                        
for each row                                               
begin                                                      
select bill_CptAdjustDetail_id.nextval INTO :new.id from dual;
end;                                                       
/   


CREATE TABLE bill_CptAdjustMain (
	id integer  NOT NULL ,
	departmentid integer NULL ,
	resourceid integer NULL ,
	olddepartmentid integer NULL ,
	relatecrm integer NULL ,
	relatedoc integer NULL ,
	relatecpt integer NULL ,
	relatereq integer NULL ,
	manager integer NULL ,
	totalamount number(10, 2) NULL ,
	groupid integer default 0 ,
	requestid integer default 0 ,
	realizedate varchar2 (10)  NULL 
)
/
create sequence bill_CptAdjustMain_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_CptAdjustMain_Trigger     
before insert on bill_CptAdjustMain                        
for each row                                               
begin                                                      
select bill_CptAdjustMain_id.nextval INTO :new.id from dual;
end;                                                       
/  


CREATE TABLE bill_CptApplyDetail (
	id integer not null ,
	cptapplyid integer NULL ,
	cpttype integer NULL ,
	cptid integer NULL ,
	number_n number(10, 3) NULL ,
	unitprice number(10, 3) NULL ,
	amount number(10, 3) NULL ,
	needdate varchar2 (10)  NULL ,
	purpose varchar2 (60)  NULL ,
	cptdesc varchar2 (60)  NULL ,
	capitalid integer default 0 
)
/
create sequence bill_CptApplyDetail_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_CptApplyDetail_Trigger     
before insert on bill_CptApplyDetail                        
for each row                                               
begin                                                      
select bill_CptApplyDetail_id.nextval INTO :new.id from dual;
end;                                                       
/  


CREATE TABLE bill_CptApplyMain (
	id integer  NOT NULL ,
	requestid integer NULL ,
	departmentid integer NULL ,
	resourceid integer NULL ,
	groupid integer NULL ,
	totalamount number(10, 3) NULL ,
	relatecrm integer NULL ,
	relatedoc integer NULL ,
	relatecpt integer NULL ,
	relatereq integer NULL ,
	manager integer NULL 
)
/

create sequence bill_CptApplyMain_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_CptApplyMain_Trigger     
before insert on bill_CptApplyMain                        
for each row                                               
begin                                                      
select bill_CptApplyMain_id.nextval INTO :new.id from dual;
end;                                                       
/  


CREATE TABLE bill_CptCarFee (
	id integer NOT NULL ,
	requestid integer NULL ,
	usedate varchar2 (10)  NULL ,
	driver integer NULL ,
	carno integer NULL ,
	oilfee number(10, 2) NULL ,
	bridgefee number(10, 2) NULL ,
	fixfee number(10, 2) NULL ,
	phonefee number(10, 2) NULL ,
	cleanfee number(10, 2) NULL ,
	remax varchar2 (255)  NULL 
)
/
create sequence bill_CptCarFee_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_CptCarFee_Trigger     
before insert on bill_CptCarFee                        
for each row                                               
begin                                                      
select bill_CptCarFee_id.nextval INTO :new.id from dual;
end;                                                       
/  

CREATE TABLE bill_CptCarFix (
	id integer  NOT NULL ,
	requestid integer default 0 ,
	usedate varchar2 (10)  NULL ,
	driver integer NULL ,
	carno integer default 0 ,
	fixfee number(10, 2) NULL ,
	remax varchar2 (255)  NULL 
)
/
create sequence bill_CptCarFix_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_CptCarFix_Trigger     
before insert on bill_CptCarFix                        
for each row                                               
begin                                                      
select bill_CptCarFix_id.nextval INTO :new.id from dual;
end;                                                       
/ 

CREATE TABLE bill_CptCarMantant (
	id integer  NOT NULL ,
	requestid integer default 0 ,
	usedate varchar2 (10)  NULL ,
	driver integer NULL ,
	carno integer default 0 ,
	mantantfee number(10, 2) NULL ,
	remax varchar2 (255)  NULL 
)
/
create sequence bill_CptCarMantant_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_CptCarMantant_Trigger     
before insert on bill_CptCarMantant                        
for each row                                               
begin                                                      
select bill_CptCarMantant_id.nextval INTO :new.id from dual;
end;                                                       
/ 


CREATE TABLE bill_CptCarOut (
	id integer  NOT NULL ,
	requestid integer NULL ,
	usedate varchar2 (10)  NULL ,
	driver integer NULL ,
	carno integer NULL ,
	begindate varchar2 (10)  NULL ,
	begintime varchar2 (5)  NULL ,
	enddate varchar2 (10)  NULL ,
	endtime varchar2 (5)  NULL ,
	frompos varchar2 (255)  NULL ,
	beginnumber number(10, 3) NULL ,
	endnumber number(10, 3) NULL ,
	number_n number(10, 3) NULL ,
	userid integer NULL ,
	userdepid integer NULL ,
	isotherplace integer default 0 
)
/
create sequence bill_CptCarOut_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_CptCarOut_Trigger     
before insert on bill_CptCarOut                        
for each row                                               
begin                                                      
select bill_CptCarOut_id.nextval INTO :new.id from dual;
end;                                                       
/ 

CREATE TABLE bill_CptCheckDetail (
	id integer  not null,
	cptcheckid integer NULL ,
	cptid integer NULL ,
	theorynumber number(10, 3) NULL ,
	realnumber number(10, 3) NULL ,
	price number(10, 3) NULL ,
	remark varchar2 (250)  NULL 
)
/
create sequence bill_CptCheckDetail_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_CptCheckDetail_Trigger     
before insert on bill_CptCheckDetail                        
for each row                                               
begin                                                      
select bill_CptCheckDetail_id.nextval INTO :new.id from dual;
end;                                                       
/  

CREATE TABLE bill_CptCheckMain (
	id integer  not null,
	departmentid integer NULL ,
	resourceid integer NULL ,
	checkresourceid2 integer NULL ,
	checkdate char (10)  NULL ,
	relatecrm integer NULL ,
	relatedoc integer NULL ,
	relatecpt integer NULL ,
	relatereq integer NULL ,
	assortment integer NULL ,
	groupid integer default 0 ,
	requestid integer default 0 
)
/
create sequence bill_CptCheckMain_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_CptCheckMain_Trigger     
before insert on bill_CptCheckMain                        
for each row                                               
begin                                                      
select bill_CptCheckMain_id.nextval INTO :new.id from dual;
end;                                                       
/  




CREATE TABLE bill_CptFetchDetail (
	id integer  NOT NULL ,
	cptfetchid integer NULL ,
	cptid integer NULL ,
	number_n integer NULL ,
	unitprice number(10, 2) NULL ,
	amount number(10, 2) NULL ,
	needdate varchar2 (10)  NULL ,
	purpose varchar2 (60)  NULL ,
	cptdesc varchar2 (60)  NULL ,
	capitalid integer NULL 
)
/
create sequence bill_CptFetchDetail_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_CptFetchDetail_Trigger     
before insert on bill_CptFetchDetail                        
for each row                                               
begin                                                      
select bill_CptFetchDetail_id.nextval INTO :new.id from dual;
end;                                                       
/ 


 
CREATE TABLE bill_CptFetchMain (
	id integer  not null ,
	departmentid integer NULL ,
	resourceid integer NULL ,
	relatecrm integer NULL ,
	relatedoc integer NULL ,
	relatecpt integer NULL ,
	relatereq integer NULL ,
	totalamount number(10, 3) NULL ,
	groupid integer default 0 ,
	requestid integer default 0,
	realizedate varchar2 (10)  NULL 
)
/
create sequence bill_CptFetchMain_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_CptFetchMain_Trigger     
before insert on bill_CptFetchMain                        
for each row                                               
begin                                                      
select bill_CptFetchMain_id.nextval INTO :new.id from dual;
end;                                                       
/  


CREATE TABLE bill_CptPlanDetail (
	id integer  not null ,
	cptplanid integer NULL ,
	cptid integer NULL ,
	number_n integer null,
	unitprice number(10, 2) NULL ,
	amount number(10, 2) NULL ,
	needdate varchar2 (10)  NULL ,
	purpose varchar2 (60)  NULL ,
	cptdesc varchar2 (60)  NULL 
)
/
create sequence bill_CptPlanDetail_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_CptPlanDetail_Trigger     
before insert on bill_CptPlanDetail                        
for each row                                               
begin                                                      
select bill_CptPlanDetail_id.nextval INTO :new.id from dual;
end;                                                       
/  

CREATE TABLE bill_CptPlanMain (
	id integer not null  ,
	departmentid integer NULL ,
	resourceid integer NULL ,
	totalamount number(10, 3) NULL ,
	relatecrm integer NULL ,
	relatedoc integer NULL ,
	groupid integer default 0 ,
	requestid integer default 0
)
/
create sequence bill_CptPlanMain_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_CptPlanMain_Trigger     
before insert on bill_CptPlanMain                        
for each row                                               
begin                                                      
select bill_CptPlanMain_id.nextval INTO :new.id from dual;
end;                                                       
/  

CREATE TABLE bill_CptRequireDetail (
	id integer  NOT NULL ,
	cptrequireid integer NULL ,
	cpttype integer NULL ,
	cptid integer NULL ,
	number_n integer NULL ,
	unitprice number(10, 2) NULL ,
	needdate varchar2 (10)  NULL ,
	purpose varchar2 (60)  NULL ,
	cptdesc varchar2 (60)  NULL ,
	buynumber integer NULL ,
	adjustnumber integer NULL ,
	fetchnumber integer NULL 
)
/
create sequence bill_CptRequireDetail_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_CptRequireDetail_Trigger     
before insert on bill_CptRequireDetail                        
for each row                                               
begin                                                      
select bill_CptRequireDetail_id.nextval INTO :new.id from dual;
end;                                                       
/  

CREATE TABLE bill_CptRequireMain (
	id integer  NOT NULL ,
	requestid integer NULL ,
	departmentid integer NULL ,
	resourceid integer NULL ,
	groupid integer NULL ,
	relatecrm integer NULL ,
	relatedoc integer NULL ,
	relatecpt integer NULL ,
	relatereq integer NULL ,
	buynumbers number(10, 3) NULL 
)
/
create sequence bill_CptRequireMain_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_CptRequireMain_Trigger     
before insert on bill_CptRequireMain                        
for each row                                               
begin                                                      
select bill_CptRequireMain_id.nextval INTO :new.id from dual;
end;                                                       
/  

CREATE TABLE bill_CptStockInDetail (
	id integer  NOT NULL ,
	cptstockinid integer NULL ,
	cptno varchar2 (50)  NULL ,
	cptid integer NULL ,
	cpttype varchar2 (80)  NULL ,
	plannumber integer NULL ,
	innumber integer NULL ,
	planprice number(10, 2) NULL ,
	inprice number(10, 2) NULL ,
	planamount number(10, 2) NULL ,
	inamount number(10, 2) NULL ,
	difprice number(10, 2) NULL ,
	capitalid integer default 0 
)
/
create sequence bill_CptStockInDetail_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_CptStockInDetail_Trigger     
before insert on bill_CptStockInDetail                        
for each row                                               
begin                                                      
select bill_CptStockInDetail_id.nextval INTO :new.id from dual;
end;                                                       
/  

CREATE TABLE bill_CptStockInMain (
	id integer  NOT NULL ,
	departmentid integer NULL ,
	resourceid integer NULL ,
	buyerid integer NULL ,
	checkerid integer NULL ,
	comefrom varchar2 (80)  NULL ,
	billnumber varchar2 (80)  NULL ,
	warehouse varchar2 (80)  NULL ,
	stockindate char (10)  NULL ,
	relatecrm integer NULL ,
	relatedoc integer NULL ,
	relatecpt integer NULL ,
	relatereq integer NULL ,
	groupid integer default 0 ,
	requestid integer default 0 ,
	realizedate varchar2 (10)  NULL 
)
/
create sequence bill_CptStockInMain_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_CptStockInMain_Trigger     
before insert on bill_CptStockInMain                        
for each row                                               
begin                                                      
select bill_CptStockInMain_id.nextval INTO :new.id from dual;
end;                                                       
/ 

CREATE TABLE bill_Discuss (
	id integer NOT NULL ,
	billid integer NULL ,
	requestid integer NULL ,
	resourceid integer NULL ,
	accepterid varchar2(4000) NULL ,
	subject varchar2 (255)  NULL ,
	isend char (1)  NULL ,
	projectid integer NULL ,
	crmid integer NULL ,
	relatedrequestid integer NULL ,
	alldoc varchar2(4000)  NULL ,
	status char (1)  NULL 
)
/
create sequence bill_Discuss_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_Discuss_Trigger     
before insert on bill_Discuss                        
for each row                                               
begin                                                      
select bill_Discuss_id.nextval INTO :new.id from dual;
end;                                                       
/ 
CREATE TABLE bill_HireResource (
	id integer not null ,
	billid integer NULL ,
	requestid integer NULL ,
	resourceid integer NULL ,
	departmentid integer NULL ,
	begindate char (10)  NULL ,
	jobtitle integer NULL ,
	jobcompetence varchar2(4000)  NULL ,
	jobdesc varchar2(4000)  NULL ,
	relateddoc integer NULL ,
	receiver integer NULL ,
	manager integer NULL ,
	cptgivetype char (1)  NULL ,
	status char (1)  NULL 
)
/
create sequence bill_HireResource_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_HireResource_Trigger     
before insert on bill_HireResource                        
for each row                                               
begin                                                      
select bill_HireResource_id.nextval INTO :new.id from dual;
end;                                                       
/

CREATE TABLE bill_HotelBook (
	id integer  NOT NULL ,
	billid integer NULL ,
	requestid integer NULL ,
	resourceid integer NULL ,
	departmentid integer NULL ,
	begindate char (10)  NULL ,
	enddate char (10)  NULL ,
	payterm integer NULL ,
	liveperson varchar2 (100)  NULL ,
	amount number(10, 3) NULL ,
	status char (1)  NULL ,
	reason varchar2(4000)  NULL ,
	relatedcrmid integer NULL ,
	relateddocid integer NULL ,
	relatedrequestid integer NULL ,
	livecompany varchar2 (200)  NULL 
)
/
create sequence bill_HotelBook_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_HotelBook_Trigger     
before insert on bill_HotelBook                        
for each row                                               
begin                                                      
select bill_HotelBook_id.nextval INTO :new.id from dual;
end;                                                       
/

CREATE TABLE bill_HotelBookDetail (
	id integer  NOT NULL ,
	bookid integer NULL ,
	hotelid integer NULL ,
	roomstyle varchar2 (50)  NULL ,
	roomsum integer NULL 
)
/
create sequence bill_HotelBookDetail_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_HotelBookDetail_Trigger     
before insert on bill_HotelBookDetail                        
for each row                                               
begin                                                      
select bill_HotelBookDetail_id.nextval INTO :new.id from dual;
end;                                                       
/
CREATE TABLE bill_HrmFinance (
	id integer NOT NULL ,
	resourceid integer NOT NULL ,
	requestid integer NULL ,
	billid integer NULL ,
	basictype integer NULL ,
	detailtype integer NULL ,
	amount number(10, 3) NULL ,
	crmid integer NULL ,
	projectid integer NULL ,
	docid integer NULL ,
	capitalid integer NULL ,
	departmentid integer NULL ,
	name varchar2 (50)  NULL ,
	description varchar2 (250)  NULL ,
	remark varchar2(4000)  NULL ,
	occurdate char (10)  NULL ,
	occurtime char (8)  NULL ,
	relatedrequestid integer NULL ,
	relatedresource varchar2 (250)  NULL ,
	accessory integer NULL ,
	debitledgeid integer NULL ,
	debitremark varchar2 (250)  NULL ,
	creditledgeid integer NULL ,
	creditremark varchar2 (250)  NULL ,
	currencyid integer NULL ,
	exchangerate varchar2 (20)  NULL ,
	status char (1)  NULL ,
	manager integer NULL ,
	isoverrule char (1)  NULL ,
	needapprove char (1)  NULL ,
	returndate char (10)  NULL ,
	isremind integer default 1 
)
/
create sequence bill_HrmFinance_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_HrmFinance_Trigger     
before insert on bill_HrmFinance                        
for each row                                               
begin                                                      
select bill_HrmFinance_id.nextval INTO :new.id from dual;
end;                                                       
/ 

CREATE TABLE bill_HrmTime (
	id integer NOT NULL ,
	resourceid integer NOT NULL ,
	requestid integer NULL ,
	billid integer NULL ,
	basictype integer NULL ,
	detailtype integer NULL ,
	begindate char (10)  NULL ,
	begintime char (8)  NULL ,
	enddate char (10)  NULL ,
	endtime char (8)  NULL ,
	name varchar2 (50)  NULL ,
	description varchar2 (255)  NULL ,
	remark varchar2(4000)  NULL ,
	totaldays integer NULL ,
	totalhours number(8, 3) NULL ,
	progress number(8, 3) NULL ,
	projectid integer NULL ,
	crmid integer NULL ,
	docid integer NULL ,
	relatedrequestid integer NULL ,
	status char (1)  NULL ,
	customizeint1 integer NULL ,
	customizeint2 integer NULL ,
	customizeint3 integer NULL ,
	customizefloat1 number(8, 3) NULL ,
	customizestr1 varchar2 (255)  NULL ,
	customizestr2 varchar2 (255)  NULL ,
	manager integer NULL ,
	departmentid integer NULL ,
	wakedate char (10)  NULL ,
	waketime char (8)  NULL ,
	isremind integer default 1 ,
	accepterid varchar2(4000)  NULL ,
	allrequest varchar2(4000)  NULL ,
	isopen integer NULL ,
	alldoc varchar2(4000)  NULL ,
	delaydate char (10)  NULL 
)
/
create sequence bill_HrmTime_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_HrmTime_Trigger     
before insert on bill_HrmTime                        
for each row                                               
begin                                                      
select bill_HrmTime_id.nextval INTO :new.id from dual;
end;                                                       
/ 

CREATE TABLE bill_LeaveJob (
	id integer not null ,
	billid integer NULL ,
	requestid integer NULL ,
	resourceid integer NULL ,
	departmentid integer NULL ,
	leavedate char (10)  NULL ,
	leavedesc varchar2(4000)  NULL ,
	relateddoc integer NULL ,
	receiver integer NULL ,
	manager integer NULL ,
	status char (1)  NULL 
)
/
create sequence bill_LeaveJob_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_LeaveJob_Trigger     
before insert on bill_LeaveJob                        
for each row                                               
begin                                                      
select bill_LeaveJob_id.nextval INTO :new.id from dual;
end;                                                       
/ 
CREATE TABLE bill_MailboxApply (
	id integer not null ,
	billid integer NULL ,
	requestid integer NULL ,
	resourceid integer NULL ,
	departmentid integer NULL ,
	reason varchar2(4000)  NULL ,
	mailid varchar2 (50)  NULL ,
	status char (1)  NULL,
	realid varchar2 (50)  NULL ,
	startdate char (10)  NULL ,
	passresource integer NULL 
)
/
create sequence bill_MailboxApply_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_MailboxApply_Trigger     
before insert on bill_MailboxApply                        
for each row                                               
begin                                                      
select bill_MailboxApply_id.nextval INTO :new.id from dual;
end;                                                       
/ 
CREATE TABLE bill_NameCard (
	id integer  NOT NULL ,
	billid integer NULL ,
	requestid integer NULL ,
	resourceid integer NULL ,
	departmentid integer NULL ,
	reason integer NULL ,
	printnum integer NULL ,
	printoption integer NULL ,
	status char (1)  NULL ,
	amountpercase number(10, 3) NULL ,
	totalamount number(10, 3) NULL ,
	printcompany integer NULL ,
	itemnumber varchar (50)  NULL ,
	getdate char (10)  NULL 
)
/
create sequence bill_NameCard_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_NameCard_Trigger     
before insert on bill_NameCard                        
for each row                                               
begin                                                      
select bill_NameCard_id.nextval INTO :new.id from dual;
end;                                                       
/

CREATE TABLE bill_NameCardinfo (
	resourceid integer NOT NULL ,
	cname varchar2 (50)  NULL ,
	cjobtitle varchar2 (50)  NULL ,
	cdepartment varchar2 (100)  NULL ,
	ename varchar2 (50)  NULL ,
	ejobtitle varchar2 (50)  NULL ,
	edepartment varchar2 (100)  NULL ,
	phone varchar2 (50)  NULL ,
	mobile varchar2 (50)  NULL ,
	email varchar2 (50)  NULL 
)
/

CREATE TABLE bill_TotalBudget (
	id integer not null,
	billid integer NULL ,
	requestid integer NULL ,
	resourceid integer NULL ,
	departmentid integer NULL ,
	target varchar2(4000)  NULL ,
	relateddoc integer NULL ,
	relatedrequest integer NULL ,
	manager integer NULL ,
	status char (1)  NULL 
)
/
create sequence bill_TotalBudget_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_TotalBudget_Trigger     
before insert on bill_TotalBudget                        
for each row                                               
begin                                                      
select bill_TotalBudget_id.nextval INTO :new.id from dual;
end;                                                       
/ 


CREATE TABLE bill_contract (
	id integer  NOT NULL ,
	contractno varchar2 (30)  NULL ,
	departmentid integer NULL ,
	costcenterid integer NULL ,
	resourceid integer NULL ,
	crmid integer NULL ,
	projectid integer NULL ,
	docid integer NULL ,
	defcurrencyid integer NULL ,
	currencyid integer NULL ,
	exchangerate number(10, 3) NULL ,
	defcountprice number(18, 3) NULL ,
	defcounttax number(18, 3) NULL ,
	countprice number(18, 3) NULL ,
	counttax number(18, 3) NULL ,
	contractremark varchar2(4000)  NULL ,
	datefield1 varchar2 (10)  NULL ,
	datefield2 varchar2 (10)  NULL ,
	datefield3 varchar2 (10)  NULL ,
	datefield4 varchar2 (10)  NULL ,
	datefield5 varchar2 (10)  NULL ,
	numberfield1 float NULL ,
	numberfield2 float NULL ,
	numberfield3 float NULL ,
	numberfield4 float NULL ,
	numberfield5 float NULL ,
	textfield1 varchar2 (100)  NULL ,
	textfield2 varchar2 (100)  NULL ,
	textfield3 varchar2 (100)  NULL ,
	textfield4 varchar2 (100)  NULL ,
	textfield5 varchar2 (100)  NULL ,
	tinyintfield1 smallint NULL ,
	tinyintfield2 smallint NULL ,
	tinyintfield3 smallint NULL ,
	tinyintfield4 smallint NULL ,
	tinyintfield5 smallint NULL 
)
/
create sequence bill_contract_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_contract_Trigger     
before insert on bill_contract                        
for each row                                               
begin                                                      
select bill_contract_id.nextval INTO :new.id from dual;
end;                                                       
/ 


CREATE TABLE bill_contractdetail (
	id integer  not null,
	contractid integer NULL ,
	assetid integer NULL ,
	batchmark varchar2 (20)  NULL ,
	number_n float NULL ,
	currencyid integer NULL ,
	defcurrencyid integer NULL ,
	exchangerate number(18, 3) NULL ,
	defunitprice number(18, 3) NULL ,
	unitprice number(18, 3) NULL ,
	taxrate integer NULL 
)
/
create sequence bill_contractdetail_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_contractdetail_Trigger     
before insert on bill_contractdetail                        
for each row                                               
begin                                                      
select bill_contractdetail_id.nextval INTO :new.id from dual;
end;                                                       
/ 
CREATE TABLE bill_itemusage (
	id integer  ,
	itemid integer NULL ,
	resourceid integer NULL ,
	departmentid integer NULL ,
	relateproj integer NULL ,
	relatecrm integer NULL ,
	begindate char (10)  NULL ,
	begintime char (8)  NULL ,
	enddate char (10)  NULL ,
	endtime char (8)  NULL ,
	info varchar2(4000)  NULL ,
	datefield1 varchar2 (10)  NULL ,
	datefield2 varchar2 (10)  NULL ,
	datefield3 varchar2 (10)  NULL ,
	datefield4 varchar2 (10)  NULL ,
	datefield5 varchar2 (10)  NULL ,
	numberfield1 float NULL ,
	numberfield2 float NULL ,
	numberfield3 float NULL ,
	numberfield4 float NULL ,
	numberfield5 float NULL ,
	textfield1 varchar2 (100)  NULL ,
	textfield2 varchar2 (100)  NULL ,
	textfield3 varchar2 (100)  NULL ,
	textfield4 varchar2 (100)  NULL ,
	textfield5 varchar2 (100)  NULL ,
	tinyintfield1 smallint NULL ,
	tinyintfield2 smallint NULL ,
	tinyintfield3 smallint NULL ,
	tinyintfield4 smallint NULL ,
	tinyintfield5 smallint NULL ,
	usestatus char (1)  NULL 
)
/
create sequence bill_itemusage_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_itemusage_Trigger     
before insert on bill_itemusage                        
for each row                                               
begin                                                      
select bill_itemusage_id.nextval INTO :new.id from dual;
end;                                                       
/ 
CREATE TABLE bill_monthinfodetail (
	id integer not null ,
	infoid integer NULL ,
	type integer NULL ,
	targetname varchar2 (250)  NULL ,
	targetresult varchar2(4000)  NULL ,
	forecastdate char (10)  NULL ,
	scale number(10, 3) NULL ,
	point smallint NULL 
)
/
create sequence bill_monthinfodetail_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_monthinfodetail_Trigger     
before insert on bill_monthinfodetail                        
for each row                                               
begin                                                      
select bill_monthinfodetail_id.nextval INTO :new.id from dual;
end;                                                       
/ 

CREATE TABLE bill_weekinfodetail (
	id integer not null ,
	infoid integer NULL ,
	type integer NULL ,
	workname varchar2 (250)  NULL ,
	workdesc varchar2(4000) NULL ,
	forecastdate char (10)  NULL 
)
/
create sequence bill_weekinfodetail_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_weekinfodetail_Trigger     
before insert on bill_weekinfodetail                        
for each row                                               
begin                                                      
select bill_weekinfodetail_id.nextval INTO :new.id from dual;
end;
/

CREATE TABLE bill_workinfo (
	id integer not null,
	billid integer NULL ,
	requestid integer NULL ,
	resourceid integer NULL ,
	departmentid integer NULL ,
	createdate char (10)  NULL ,
	thismonth integer NULL ,
	thisweek integer NULL ,
	analysis varchar2(4000)  NULL ,
	advice varchar2(4000)  NULL ,
	manager integer NULL ,
	seclevel integer NULL ,
	status char (1)  NULL ,
	mainid integer null
)
/
create sequence bill_workinfo_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger bill_workinfo_Trigger     
before insert on bill_workinfo                        
for each row                                               
begin                                                      
select bill_workinfo_id.nextval INTO :new.id from dual;
end;  
/

CREATE TABLE syslanguage (
	id integer NULL ,
	language varchar2 (30)  NULL ,
	encoding varchar2 (30)  NULL ,
	activable char (1)  NULL 
)
/

CREATE TABLE workflow_RequestUserDefault (
	userid integer NULL ,
	selectedworkflow varchar2(4000)  NULL ,
	isuserdefault char (1)  NULL 
)
/


CREATE TABLE workflow_SelectItem (
	fieldid integer NULL ,
	isbill integer NULL ,
	selectvalue integer NULL ,
	selectname varchar2 (250)  NULL 
)
/


CREATE TABLE workflow_StaticRpbase (
	id integer  NOT NULL ,
	reportid integer NULL ,
	name varchar2 (50)  NULL ,
	description varchar2 (250)  NULL ,
	pagename varchar2 (50)  NULL ,
	module integer NULL 
)
/
create sequence workflow_StaticRpbase_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger workflow_StaticRpbase_Trigger     
before insert on workflow_StaticRpbase                        
for each row                                               
begin                                                      
select workflow_StaticRpbase_id.nextval INTO :new.id from dual;
end;  
/

CREATE TABLE workflow_addinoperate (
	id integer not null ,
	objid integer NULL ,
	isnode integer NULL ,
	workflowid integer NULL ,
	fieldid integer NULL ,
	fieldop1id integer NULL ,
	fieldop2id integer NULL ,
	operation integer NULL ,
	customervalue varchar2 (255)  NULL ,
	rules integer NULL 
)
/
create sequence workflow_addinoperate_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger workflow_addinoperate_Trigger     
before insert on workflow_addinoperate                        
for each row                                               
begin                                                      
select workflow_addinoperate_id.nextval INTO :new.id from dual;
end;  
/
CREATE TABLE workflow_base (
	id integer  ,
	workflowname varchar2 (60)  NULL ,
	workflowdesc varchar2 (100)  NULL ,
	workflowtype integer NULL ,
	securelevel varchar2 (3)  NULL ,
	formid integer NULL ,
	userid integer NULL ,
	isbill char (1)  NULL ,
	iscust integer default 0,
	helpdocid integer default 0 ,
	isvalid char (1)  default 1 
)
/
create sequence workflow_base_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger workflow_base_Trigger     
before insert on workflow_base                        
for each row                                               
begin                                                      
select workflow_base_id.nextval INTO :new.id from dual;
end;  
/

CREATE TABLE workflow_bill (
	id integer not null ,
	namelabel integer NULL ,
	tablename varchar2 (60)  NULL ,
	createpage varchar2 (255)  NULL ,
	managepage varchar2 (255)  NULL ,
	viewpage varchar2 (255)  NULL ,
	detailtablename varchar2 (60)  NULL ,
	detailkeyfield varchar2 (60)  NULL 
)
/

CREATE TABLE workflow_billfield (
	id integer  not null,
	billid integer  ,
	fieldname varchar2 (60)  NULL ,
	fieldlabel integer NULL ,
	fielddbtype varchar2 (40)  NULL ,
	fieldhtmltype char (1)  NULL ,
	type integer NULL ,
	dsporder integer NULL ,
	viewtype integer default 0
)
/
create sequence workflow_billfield_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger workflow_billfield_Trigger     
before insert on workflow_billfield                        
for each row                                               
begin                                                      
select workflow_billfield_id.nextval INTO :new.id from dual;
end;  
/

CREATE TABLE workflow_browserurl (
	id integer not null ,
	labelid integer NULL ,
	fielddbtype varchar2 (40)  NULL ,
	browserurl varchar2 (255)  NULL ,
	tablename varchar2 (50)  NULL ,
	columname varchar2 (50)  NULL ,
	keycolumname varchar2 (50)  NULL ,
	linkurl varchar2 (255)  NULL 
)
/
create sequence workflow_browserurl_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger workflow_browserurl_Trigger     
before insert on workflow_browserurl                        
for each row                                               
begin                                                      
select workflow_browserurl_id.nextval INTO :new.id from dual;
end;  
/
CREATE TABLE workflow_createrlist (
	workflowid integer NULL ,
	userid integer NULL ,
	usertype integer NULL 
)
/

CREATE TABLE workflow_currentoperator (
	requestid integer  not null,
	userid integer NULL ,
	groupid integer NULL ,
	workflowid integer NULL ,
	workflowtype integer NULL ,
	isremark char (1) default 0 ,
	usertype integer default 0
)
/

CREATE TABLE workflow_fieldlable (
	formid integer not null  ,
	fieldid integer  not null,
	fieldlable varchar2 (100)  NULL ,
	langurageid integer NULL ,
	isdefault char (1)  NULL 
)
/

CREATE TABLE workflow_flownode (
	workflowid integer NULL ,
	nodeid integer NULL ,
	nodetype char (1)  NULL 
)
/


CREATE TABLE workflow_form (
	requestid integer NOT NULL ,
	billformid integer NULL ,
	billid integer NULL ,
	document integer NULL ,
	Customer integer NULL ,
	Project integer NULL ,
	resource_n integer NULL ,
	mutiresource varchar2(4000)  NULL ,
	remark varchar2(4000)  NULL ,
	begindate char (10)  NULL ,
	begintime char (5)  NULL ,
	enddate char (10)  NULL ,
	endtime char (5)  NULL ,
	totaltime number(10, 3) NULL ,
	totaldays integer NULL ,
	request integer NULL ,
	department integer NULL ,
	subject varchar2 (200)  NULL ,
	manager integer NULL ,
	amount number(10, 3) NULL ,
	relatmeeting integer null
)
/

CREATE TABLE workflow_formbase (
	id integer  not null,
	formname varchar2 (40)  NULL ,
	formdesc varchar2 (40)  NULL ,
	securelevel char (3)  NULL ,
	userid integer NULL ,
	formhtmlcode varchar2(4000)  NULL ,
	formdate char (10)  NULL 
)
/
create sequence workflow_formbase_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger workflow_formbase_Trigger     
before insert on workflow_formbase                        
for each row                                               
begin                                                      
select workflow_formbase_id.nextval INTO :new.id from dual;
end;  
/

CREATE TABLE workflow_formdict (
	id integer not null  ,
	fieldname varchar2 (40)  NULL ,
	fielddbtype varchar2 (40)  NULL ,
	fieldhtmltype char (1)  NULL ,
	type integer NULL 
)
/
create sequence workflow_formdict_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger workflow_formdict_Trigger     
before insert on workflow_formdict                        
for each row                                               
begin                                                      
select workflow_formdict_id.nextval INTO :new.id from dual;
end;  
/

CREATE TABLE workflow_formfield (
	formid integer  not null,
	fieldid integer  not null,
	fieldparameter varchar2 (100)  NULL ,
	needcheck char (1)  NULL ,
	checkscript varchar2 (150)  NULL ,
	ismultirows char (1)  NULL ,
	fieldorder integer default 0
)
/
CREATE TABLE workflow_groupdetail (
	id integer not null ,
	groupid integer NULL ,
	type integer NULL ,
	objid integer NULL ,
	level_n integer NULL 
)
/
create sequence workflow_groupdetail_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger workflow_groupdetail_Trigger     
before insert on workflow_groupdetail                        
for each row                                               
begin                                                      
select workflow_groupdetail_id.nextval INTO :new.id from dual;
end;  
/

CREATE TABLE workflow_nodebase (
	id integer not null ,
	nodename varchar2 (60)  NULL ,
	isstart char (1)  NULL ,
	isreject char (1)  NULL ,
	isreopen char (1)  NULL ,
	isend char (1)  NULL ,
	drawxpos integer default -1 ,
	drawypos integer default -1 ,
	totalgroups integer default 0 
)
/
create sequence workflow_nodebase_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger workflow_nodebase_Trigger     
before insert on workflow_nodebase                        
for each row                                               
begin                                                      
select workflow_nodebase_id.nextval INTO :new.id from dual;
end;  
/
CREATE TABLE workflow_nodeform (
	nodeid integer NULL ,
	fieldid integer NULL ,
	isview char (1)  NULL ,
	isedit char (1)  NULL ,
	ismandatory char (1)  NULL 
)
/

CREATE TABLE workflow_nodegroup (
	id integer  not null,
	nodeid integer NULL ,
	groupname varchar2 (60)  NULL ,
	canview integer default 0
)
/

CREATE TABLE workflow_nodelink (
	id integer  NOT NULL ,
	workflowid integer NULL ,
	nodeid integer NULL ,
	isreject char (1)  NULL ,
	condition varchar2 (200)  NULL ,
	linkname varchar2 (60)  NULL ,
	destnodeid integer NULL ,
	directionfrom integer default -1 ,
	directionto integer default -1  ,
	x1 integer default -1  ,
	y1 integer default -1  ,
	x2 integer default -1  ,
	y2 integer default -1  ,
	x3 integer default -1  ,
	y3 integer default -1  ,
	x4 integer default -1  ,
	y4 integer default -1  ,
	x5 integer default -1  ,
	y5 integer default -1  ,
	nodepasstime float default -1  
)
/
create sequence workflow_nodelink_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger workflow_nodelink_Trigger     
before insert on workflow_nodelink                        
for each row                                               
begin                                                      
select workflow_nodelink_id.nextval INTO :new.id from dual;
end;  
/
CREATE TABLE workflow_requestLog (
	requestid integer NULL ,
	workflowid integer NULL ,
	nodeid integer NULL ,
	logtype char (1)  NULL ,
	operatedate char (10)  NULL ,
	operatetime char (8)  NULL ,
	operator integer NULL ,
	remark varchar2(4000)  NULL ,
	clientip char (15)  NULL ,
	operatortype integer default 0 ,
	destnodeid integer default 0
)
/

CREATE TABLE workflow_requestViewLog (
	id integer not null ,
	viewer integer NULL ,
	viewdate char (10)  NULL ,
	viewtime char (8)  NULL ,
	ipaddress char (15)  NULL ,
	viewtype integer default 0 ,
	currentnodeid integer default 0 
)
/

CREATE TABLE workflow_requestbase (
	requestid integer NOT NULL ,
	workflowid integer NULL ,
	lastnodeid integer NULL ,
	lastnodetype char (1)  NULL ,
	currentnodeid integer NULL ,
	currentnodetype char (1)  NULL ,
	status varchar2 (50)  NULL ,
	passedgroups integer NULL ,
	totalgroups integer NULL ,
	requestname varchar2 (100)  NULL ,
	creater integer NULL ,
	createdate char (10)  NULL ,
	createtime char (8)  NULL ,
	lastoperator integer NULL ,
	lastoperatedate char (10)  NULL ,
	lastoperatetime char (8)  NULL ,
	deleted smallint default 0,
	creatertype integer default 0 ,
	lastoperatortype integer default 0 ,
	nodepasstime float default -1 ,
	nodelefttime float default -1 ,
	docids varchar2(4000)  NULL ,
	crmids varchar2(4000)  NULL ,
	hrmids varchar2(4000)  NULL ,
	prjids varchar2(4000)  NULL ,
	cptids varchar2(4000)  NULL ,
	requestlevel integer default 0 
)
/

CREATE TABLE workflow_requestsequence (
	requestid integer NULL 
)
/

CREATE TABLE workflow_sysworkflow (
	id integer NULL ,
	name varchar2 (250)  NULL ,
	workflowid integer NULL 
)
/

CREATE TABLE workflow_type (
	id integer  not null,
	typename varchar2 (60)  NULL ,
	typedesc varchar2 (100)  NULL ,
	dsporder integer default 0
)
/
create sequence workflow_type_id                      
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger workflow_type_Trigger     
before insert on workflow_type                        
for each row                                               
begin                                                      
select workflow_type_id.nextval INTO :new.id from dual;
end;  
/
CREATE TABLE wrktablename75045152 (
	requestid integer NOT NULL ,
	createdate char (10)  NULL ,
	createtime char (8)  NULL ,
	creater integer NULL ,
	creatertype integer NULL ,
	workflowid integer NULL ,
	requestname varchar2 (100)  NULL ,
	status varchar2 (50)  NULL 
)
/

ALTER TABLE Bill_HrmResourceAbsense  ADD 
	 CONSTRAINT PK_BillHrmResAbsense_id PRIMARY KEY
	(
		id
	)
/


ALTER TABLE CRM_ContactLog  ADD 
	CONSTRAINT PK_CRM_ContactLog_id PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE CRM_CustomerContacter  ADD 
	CONSTRAINT PK_CRM_CustomerContacter_id PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE CRM_CustomerInfo  ADD 
	CONSTRAINT PK_CRM_CustomerInfo_id PRIMARY KEY 
	(
		id
	)

/

ALTER TABLE CRM_ShareInfo  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE CptCapital  ADD 
	CONSTRAINT PK__CptCapital__302F0D3D PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE CptCapitalAssortment  ADD 
	CONSTRAINT PK_CptCapitalAssortment PRIMARY KEY 
	(
		id
	)
/
ALTER TABLE CptCapitalGroup  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE CptCapitalShareInfo  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE CptCapitalState  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE CptCapitalType  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE CptCheckStock  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE CptCheckStockList  ADD 
	 PRIMARY KEY 
	(
		id
	)
/
ALTER TABLE CptDepreMethod1  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE CptDepreMethod2  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE CptRelateWorkflow  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE CptSearchMould  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE CptUseLog  ADD 
	CONSTRAINT PK_CptUseLog_424DBD78 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE DocApproveRemark  ADD 
	 PRIMARY KEY 
	(
		id
	)
/

ALTER TABLE DocDetail  ADD 
	CONSTRAINT PK_DocDetail_32E0915F PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE DocDetailLog  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE DocFrontpage  ADD 
	 PRIMARY KEY 
	(
		id
	)
/
ALTER TABLE DocImageFile  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE DocMailMould  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE DocMainCategory  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE DocMould  ADD 
	 PRIMARY KEY 
	(
		id
	)
/
ALTER TABLE DocMouldFile  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE DocPicUpload  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE DocSearchMould  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE DocSecCategory  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE DocSecCategoryShare  ADD 
	 PRIMARY KEY 
	(
		id
	)
/
ALTER TABLE DocShare  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE DocSubCategory  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE DocType  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE FnaAccount  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE FnaAccountCostcenter  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE FnaAccountDepartment  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE FnaAccountList  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE FnaBudget  ADD 
	 PRIMARY KEY 
	(
		id
	)

/
ALTER TABLE FnaBudgetCostcenter  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE FnaBudgetDepartment  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE FnaBudgetDetail  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE FnaBudgetList  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE FnaBudgetModule  ADD 
	 PRIMARY KEY 
	(
		id
	)

/
ALTER TABLE FnaBudgetfeeType  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE FnaCurrency  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE FnaCurrencyExchange  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE FnaExpensefeeType  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE FnaIndicator  ADD 
	 PRIMARY KEY 
	(
		id
	)

/
ALTER TABLE FnaIndicatordetail  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE FnaLedger  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE FnaLedgerCategory  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE FnaTransaction  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE FnaTransactionDetail  ADD 
	 PRIMARY KEY 
	(
		id
	)
/
ALTER TABLE FnaYearsPeriods  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE FnaYearsPeriodsList  ADD 
	 PRIMARY KEY 
	(
		id
	)
/ 


ALTER TABLE HrmActivitiesCompetency  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmApplyRemark  ADD 
	 PRIMARY KEY 
	(
		id
	)

/
ALTER TABLE HrmBank  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmCareerApply  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmCareerApplyOtherInfo  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmCareerInvite  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmCareerWorkexp  ADD 
	 PRIMARY KEY 
	(
		id
	)

/
ALTER TABLE HrmCertification  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmCompetency  ADD 
	 PRIMARY KEY 
	(
		id
	)

/
ALTER TABLE HrmComponentStat  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmCostcenter  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  




ALTER TABLE HrmCostcenterSubCategory  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmCountry  ADD 
	 PRIMARY KEY 
	(
		id
	)

/
ALTER TABLE HrmDepartment  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmEducationInfo  ADD 
	CONSTRAINT PK__HrmEducationInfo__208CD6FA PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmFamilyInfo  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmJobActivities  ADD 
	 PRIMARY KEY 
	(
		id
	)

/
ALTER TABLE HrmJobCall  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmJobGroups  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmJobTitles  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmJobType  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmLanguageAbility  ADD 
	 PRIMARY KEY 
	(
		id
	)
/
ALTER TABLE HrmLocations  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmOtherInfoType  ADD 
	CONSTRAINT PK_HrmOtherInfoType_7D439ABD PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmPubHoliday  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmResource  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmResourceCompetency  ADD 
	 PRIMARY KEY 
	(
		id
	)

/
ALTER TABLE HrmResourceComponent  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmResourceOtherInfo  ADD 
	CONSTRAINT PK_HrmResourceOther_151B244E PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmResourceSkill  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmRewardsRecord  ADD 
	 PRIMARY KEY 
	(
		id
	)
/
ALTER TABLE HrmRewardsType  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmRoleMembers  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmRoles  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmSalaryComponent  ADD 
	 PRIMARY KEY 
	(
		id
	)

/
ALTER TABLE HrmSalaryComponentTypes  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmSchedule  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmScheduleDiff  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmSearchMould  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmSpeciality  ADD 
	 PRIMARY KEY 
	(
		id
	)
/

ALTER TABLE HrmSubCompany  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmTrainRecord  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmTrainType  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmUseKind  ADD 
	 PRIMARY KEY 
	(
		id
	) 
/

ALTER TABLE HrmWelfare  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmWorkResume  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HrmWorkResumeIn  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE HtmlLabelIndex  ADD 
	CONSTRAINT PK_HtmlLabelIndex_77BFCB91 PRIMARY KEY 
	(
		id
	) 
/
ALTER TABLE HtmlNoteIndex  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE ImageFile  ADD 
	 UNIQUE 
	(
		imagefileid
	)
/  


ALTER TABLE LgcAsset  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE LgcAssetAssortment  ADD 
	 PRIMARY KEY 
	(
		id
	)
/
ALTER TABLE LgcAssetCountry  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE LgcAssetCrm  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE LgcAssetPrice  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE LgcAssetRelationType  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE LgcAssetStock  ADD 
	 PRIMARY KEY 
	(
		id
	)
/
ALTER TABLE LgcAssetType  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE LgcAssetUnit  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE LgcCatalogs  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE LgcConfiguration  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE LgcCountType  ADD 
	 PRIMARY KEY 
	(
		id
	)
/
ALTER TABLE LgcPaymentType  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE LgcSearchMould  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE LgcStockInOut  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE LgcStockInOutDetail  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE LgcStockMode  ADD 
	 PRIMARY KEY 
	(
		id
	) 
/
ALTER TABLE LgcWarehouse  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE LgcWebShop  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE LgcWebShopDetail  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE LgcWebShopReceiveType  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE MailPassword  ADD 
	 PRIMARY KEY 
	(
		resourceid
	) 
/
ALTER TABLE MailResource  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE MailResourceFile  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE MailShare  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE MailUserGroup  ADD 
	 PRIMARY KEY 
	(
		mailgroupid
	)
/  


ALTER TABLE MeetingCaller  ADD 
	 PRIMARY KEY 
	(
		id
	) 
/
ALTER TABLE Prj_ProjectInfo  ADD 
	CONSTRAINT PK_Prj_ProjectInfo_id PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE Prj_ShareInfo  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE ProcedureInfo  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE SysFavourite  ADD 
	 PRIMARY KEY 
	(
		id
	)
/
ALTER TABLE SysMaintenanceLog  ADD 
	 PRIMARY KEY 
	(
		id
	)
/



ALTER TABLE SystemLog  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE SystemRightDetail  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE SystemRightGroups  ADD 
	 PRIMARY KEY 
	(
		id
	)
/
ALTER TABLE SystemRightRoles  ADD 
	 PRIMARY KEY 
	(
		id
	)
/



ALTER TABLE SystemRightToGroup  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE Weather  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE WorkflowReportShare  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE Workflow_Report  ADD 
	 PRIMARY KEY 
	(
		id
	)
/
ALTER TABLE Workflow_ReportDspField  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE Workflow_ReportType  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE bill_Approve  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE bill_Discuss  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE bill_HireResource  ADD 
	 PRIMARY KEY 
	(
		id
	)
/
ALTER TABLE bill_HotelBook  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE bill_HotelBookDetail  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE bill_HrmFinance  ADD 
	CONSTRAINT PK_bill_HrmFinance_450A2E92 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE bill_HrmTime  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE bill_LeaveJob  ADD 
	 PRIMARY KEY 
	(
		id
	) 
/
ALTER TABLE bill_MailboxApply  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE bill_NameCard  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE bill_NameCardinfo  ADD 
	 PRIMARY KEY 
	(
		resourceid
	)
/  


ALTER TABLE bill_TotalBudget  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE bill_monthinfodetail  ADD 
	CONSTRAINT PK_bill_monthinfodetail PRIMARY KEY 
	(
		id
	)
/
ALTER TABLE bill_weekinfodetail  ADD 
	CONSTRAINT PK_bill_weekinfodetail PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE bill_workinfo  ADD 
	CONSTRAINT PK_bill_workinfo_34157811 PRIMARY KEY 
	(
		id
	)
/  


ALTER TABLE workflow_addinoperate  ADD 
	 PRIMARY KEY 
	(
		id
	) 
/

CREATE    INDEX CptShareDetail_cptid_in ON CptShareDetail(cptid)
/ 


 CREATE    INDEX CrmShareDetail_crmid_in ON CrmShareDetail(crmid)
/ 


 CREATE    INDEX DocShareDetail_docid_in ON DocShareDetail(docid)
/ 


 CREATE    INDEX errormsginfo_indexid_in ON ErrorMsgInfo(indexid)
/ 


 CREATE    INDEX htmllabelinfo_indexid_in ON HtmlLabelInfo(indexid)
/ 


 CREATE    INDEX htmlnoteinfo_indexid_in ON HtmlNoteInfo(indexid)
/ 


 CREATE    INDEX PrjShareDetail_prjid_in ON PrjShareDetail(prjid)
/ 


 CREATE  INDEX IX_CRM_ContactLog_customerid ON CRM_ContactLog(customerid)
/ 


 CREATE  INDEX IX_CRM_ContactLog_resourceid ON CRM_ContactLog(resourceid)
/ 


 CREATE  INDEX IX_CRM_ContactLog_agentid ON CRM_ContactLog(agentid)
/ 


 CREATE  INDEX IX_CRM_ContactLog_contactdate ON CRM_ContactLog(contactdate, contacttime)
/ 


 CREATE  INDEX IX_CRM_CustomerAddress_custome ON CRM_CustomerAddress(customerid, typeid)
/ 


 CREATE  INDEX IX_CRM_CustomerContacter_custo ON CRM_CustomerContacter(customerid)  

/
 CREATE  INDEX IX_CRM_CustomerInfo_dept ON CRM_CustomerInfo(department)
/ 


 CREATE  INDEX IX_CRM_CustomerInfo_manager ON CRM_CustomerInfo(manager)
/ 


 CREATE  INDEX IX_CRM_CustomerInfo_type ON CRM_CustomerInfo(type)
/ 


 CREATE  INDEX IX_CRM_CustomerInfo_agent ON CRM_CustomerInfo(agent)
/ 


 CREATE  INDEX IX_CRM_CustomerInfo_sector ON CRM_CustomerInfo(sector)
/ 


 CREATE  INDEX IX_CRM_CustomerInfo_city ON CRM_CustomerInfo(city)
/ 


 CREATE  INDEX IX_CRM_CustomerInfo_status ON CRM_CustomerInfo(status)
/ 


 CREATE  INDEX IX_CRM_CustomerInfo_source ON CRM_CustomerInfo(source)  

/
 CREATE  INDEX IX_CRM_Customize_userid ON CRM_Customize(userid)
/ 


 CREATE  INDEX IX_CRM_CustomizeOption_id ON CRM_CustomizeOption(id)
/ 


 CREATE  INDEX IX_CRM_Log_customerid ON CRM_Log(customerid)
/ 


 CREATE  INDEX IX_CRM_Log_submitdate ON CRM_Log(submitdate, submittime)
/ 


 CREATE  INDEX IX_CRM_LoginLog_id ON CRM_LoginLog(id)
/ 


 CREATE  INDEX IX_CRM_LoginLog_logindate ON CRM_LoginLog(logindate, logintime)
/ 


 CREATE  INDEX IX_CRM_Modify_customerid ON CRM_Modify(customerid)
/ 


 CREATE  INDEX IX_CRM_Modify_modifydate ON CRM_Modify(modifydate, modifytime)
/ 


 CREATE  INDEX IX_CRM_SectorInfo_parentid ON CRM_SectorInfo(parentid)
/ 


 CREATE  INDEX IX_CRM_ShareInfo_relateitem ON CRM_ShareInfo(relateditemid)  

/
 CREATE  INDEX IX_CRM_ShareInfo_userid ON CRM_ShareInfo(userid)
/ 


 CREATE  INDEX IX_CRM_ShareInfo_dept ON CRM_ShareInfo(departmentid)
/ 


 CREATE  INDEX IX_CRM_ShareInfo_roleid ON CRM_ShareInfo(roleid)
/ 


 CREATE  INDEX IX_CRM_ViewLog1_id ON CRM_ViewLog1(id)
/ 


 CREATE  INDEX IX_CRM_ViewLog1_viewer ON CRM_ViewLog1(viewer)
/ 


 CREATE  INDEX IX_CRM_ViewLog1_viewdate ON CRM_ViewLog1(viewdate, viewtime)
/ 


 CREATE  INDEX docdetaillog_doc_in ON DocDetailLog(docid)
/ 


 CREATE  INDEX docdetaillog_operateuser_in ON DocDetailLog(operateuserid)  

/
 CREATE  INDEX docfrontpage_departmentid_in ON DocFrontpage(departmentid)
/ 


 CREATE  INDEX docfrontpage_linktype_in ON DocFrontpage(linktype)
/ 


 CREATE  INDEX docimagefile_docid_in ON DocImageFile(docid)
/ 


 CREATE  INDEX docsearchmoule_userid_in ON DocSearchMould(userid)
/ 


 CREATE  INDEX docseccategorytype_seccategory ON DocSecCategoryType(seccategoryid)
/ 


 CREATE  INDEX fnaaccount_periodsledgerid_in ON FnaAccount(tranperiods, ledgerid)
/ 


 CREATE  INDEX fnaaccountcostcenter_costcente ON FnaAccountCostcenter(costcenterid, ledgerid)
/ 


 CREATE  INDEX fnaaccountdepartment_departmen ON FnaAccountDepartment(departmentid, ledgerid)  

/
 CREATE  INDEX fnaaccountlist_periodsledgerid ON FnaAccountList(tranperiods, ledgerid)
/ 


 CREATE  INDEX fnaudget_budgetmoduleidyear_in ON FnaBudget(budgetmoduleid, budgetperiods)
/ 


 CREATE  INDEX fnabudgetdetail_budgetid_in ON FnaBudgetDetail(budgetid)
/ 


 CREATE  INDEX fnabudgetlist_periodsledgerid ON FnaBudgetList(budgetperiods, ledgerid)
/ 


 CREATE  INDEX fnatransaction_tranperiods_in ON FnaTransaction(tranperiods)
/ 


 CREATE  INDEX fnatransactiondetail_tranid_in ON FnaTransactionDetail(tranid)
/ 


 CREATE  INDEX fnayearsperiodslist_fnayear_in ON FnaYearsPeriodsList(fnayear)
/ 


 CREATE  INDEX hrmactivitiescompetency_jobact ON HrmActivitiesCompetency(jobactivityid)

/
 CREATE  INDEX hrmcareerworkexp_applyid_in ON HrmCareerWorkexp(applyid)
/ 


 CREATE  INDEX hrmcomponentstat_resourceid_in ON HrmComponentStat(resourceid)
/ 


 CREATE  INDEX hrmcostcenter_departmentid_in ON HrmCostcenter(departmentid)
/ 


 CREATE  INDEX hrmcostcentersubcategory_ccmai ON HrmCostcenterSubCategory(ccmaincategoryid)
/ 


 CREATE  INDEX hrmpubholiday_countryid_in ON HrmPubHoliday(countryid)
/ 


 CREATE  INDEX IX_HrmResource_manager ON HrmResource(managerid)
/ 


 CREATE  INDEX IX_HrmResource_dept ON HrmResource(departmentid)
/ 


 CREATE  INDEX hrmresourcecomponent_resourcei ON HrmResourceComponent(resourceid)  

/
 CREATE  INDEX hrmresourceskill_resourceid_in ON HrmResourceSkill(resourceid)
/ 


 CREATE  INDEX hrmrolemembers_roleid_in ON HrmRoleMembers(roleid)
/ 


 CREATE  INDEX hrmrolemembers_resourceid_in ON HrmRoleMembers(resourceid)
/ 


 CREATE  INDEX hrmSalarycomponentdetail_compo ON HrmSalaryComponentDetail(componentid)
/ 


 CREATE  INDEX hrmsubcompany_companyid_in ON HrmSubCompany(companyid)
/ 


 CREATE  INDEX lgcassetcountry_assetcountyid ON LgcAssetCountry(assetid, assetcountyid)
/ 


 CREATE  INDEX lgcstockinoutdetail_inoutid_in ON LgcStockInOutDetail(inoutid)  

/
 CREATE  INDEX MailResource_resourceid ON MailResource(resourceid)
/ 


 
 CREATE  INDEX IX_Prj_Log_projectid ON Prj_Log(projectid)
/ 


 CREATE  INDEX IX_Prj_Log_submiter ON Prj_Log(submiter)
/ 


 CREATE  INDEX IX_Prj_Log_submitdate ON Prj_Log(submitdate, submittime)
/ 


 CREATE  INDEX IX_Prj_Material_prjid ON Prj_Material(prjid, taskid)
/ 


 CREATE  INDEX IX_Prj_MaterialProcess_prjid ON Prj_MaterialProcess(prjid, taskid)
/ 


 CREATE  INDEX IX_Prj_Member_prjid ON Prj_Member(prjid, taskid)
/

 CREATE  INDEX IX_Prj_Member_relateid ON Prj_Member(relateid)
/ 


 CREATE  INDEX IX_Prj_MemberProcess_prjid ON Prj_MemberProcess(prjid, taskid)
/ 


 CREATE  INDEX IX_Prj_MemberProcess_relateid ON Prj_MemberProcess(relateid)
/ 


 CREATE  INDEX IX_Prj_Modify_projectid ON Prj_Modify(projectid)
/ 


 CREATE  INDEX IX_Prj_Modify_modifier ON Prj_Modify(modifier)
/ 


 CREATE  INDEX IX_Prj_Modify_modifydate ON Prj_Modify(modifydate, modifytime)
/ 


 CREATE  INDEX IX_Prj_ProjectInfo_manager ON Prj_ProjectInfo(manager)
/ 


 CREATE  INDEX IX_Prj_ProjectInfo_department ON Prj_ProjectInfo(department)  

/
 CREATE  INDEX IX_Prj_ProjectInfo_parentid ON Prj_ProjectInfo(parentid)
/ 


 CREATE  INDEX IX_Prj_ProjectInfo_prjtype ON Prj_ProjectInfo(prjtype)
/ 


 CREATE  INDEX IX_Prj_ProjectInfo_worktype ON Prj_ProjectInfo(worktype)
/ 


 CREATE  INDEX IX_Prj_ProjectInfo_status ON Prj_ProjectInfo(status)
/ 


 CREATE  INDEX IX_Prj_ShareInfo_relateitem ON Prj_ShareInfo(relateditemid)
/ 


 CREATE  INDEX IX_Prj_ShareInfo_userid ON Prj_ShareInfo (userid)
/


 CREATE  INDEX IX_Prj_ShareInfo_dept ON Prj_ShareInfo(departmentid)  

/
 CREATE  INDEX IX_Prj_ShareInfo_roleid ON Prj_ShareInfo(roleid)
/ 


 CREATE  INDEX IX_Prj_TaskInfo_version ON Prj_TaskInfo(prjid, version, level_n)
/ 


 CREATE  INDEX IX_Prj_TaskInfo_hrmid ON Prj_TaskInfo(prjid, hrmid)
/ 


 CREATE  INDEX IX_Prj_TaskInfo_parentids ON Prj_TaskInfo(prjid, parentids)
/ 


 CREATE  INDEX IX_Prj_TaskProcess_level ON Prj_TaskProcess(prjid, level_n)
/ 


 CREATE  INDEX IX_Prj_TaskProcess_hrmid ON Prj_TaskProcess(prjid, hrmid)
/ 


 CREATE  INDEX IX_Prj_TaskProcess_parentids ON Prj_TaskProcess(prjid, parentids)
/ 


 CREATE  INDEX IX_Prj_Tool_prjid ON Prj_Tool(prjid, taskid)
/ 


 CREATE  INDEX IX_Prj_Tool_relateid ON Prj_Tool(relateid)
/ 


 CREATE  INDEX IX_Prj_ToolProcess_prjid ON Prj_ToolProcess(prjid, taskid)
/ 


 CREATE  INDEX IX_Prj_ToolProcess_relateid ON Prj_ToolProcess(relateid)
/  


 CREATE  INDEX IX_Prj_ViewLog1_id ON Prj_ViewLog1(id)  

/
 CREATE  INDEX IX_Prj_ViewLog1_viewer ON Prj_ViewLog1(viewer)
/ 


 CREATE  INDEX IX_Prj_ViewLog1_viewdate ON Prj_ViewLog1(viewdate, viewtime)
/ 


 CREATE  INDEX systemrighttogroup_index ON SystemRightToGroup(groupid)
/ 


 CREATE  INDEX systemrightslanguage_index ON SystemRightsLanguage(id)
/ 


 CREATE  INDEX Workflow_ReportDspField_report ON Workflow_ReportDspField(reportid) 

/


/* 工作流编号 */

alter table workflow_base add needmark char(1) default '0' 
/
alter table workflow_requestbase add requestmark varchar2(30) 
/

create table workflow_requestmark (
markdate  char(10)  primary key ,
requestmark integer 
) 

/

/*人力资源招聘*/

alter table HrmCareerApply add NumberId varchar(30)
/


create table hrmshare
(
hrmid integer,
applyid integer
)
/

alter table bill_HrmFinance add realamount number(10,3)
/

alter table Bill_ExpenseDetail add realfeesum number(10, 2) 
 
/

CREATE  INDEX MailResourceFile_mailid ON MailResourceFile(mailid) 
/