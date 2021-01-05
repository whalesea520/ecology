insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3046,'合同种类查看','HrmContractTypeView:View',384)
/

insert into HrmLocations (locationname,locationdesc,address1,address2,locationcity,postcode,countryid,telephone,fax) values ('default','default','default','default',1,'000000',1,'86-10-00000000','86-10-000000')
/


insert into HrmJobCall(name,description)values('default','default')
/


insert into HrmTrainType(name,description,typecontent,typeaim,typedocurl,typetesturl,typeoperator)values('default','default','default','default','1','1','1')
/

insert into HrmTrainLayout(layoutname,typeid,layoutstartdate,layoutenddate,layoutcontent,layoutaim,layouttestdate,layoutassessor)values('default',1,'0000-00-00','0000-00-00','default','default','0000-00-00','1')
/

insert into HrmTrainResource(name,type_n,fare,time,memo)values('default',1,'1000$/hour','3 day','default')
/

update HrmScheduleDiff set diffname='事假',diffdesc='事假' where id = 2
/

insert into HrmScheduleDiff (diffname, diffdesc,difftype,difftime, mindifftime, workflowid,salaryable,counttype,countnum,salaryitem,diffremark,color)
values('病假','病假',1,0,0,1,'',0,0,1,'','00ffee')
/

CREATE TABLE CRM_T_ShareInfo (
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
	crmid integer NULL 
) 
/
create sequence CRM_T_ShareInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_T_ShareInfo_Trigger
before insert on CRM_T_ShareInfo
for each row
begin
select CRM_T_ShareInfo_id.nextval into :new.id from dual;
end;
/



CREATE or REPLACE PROCEDURE CRM_T_ShareInfo_SbyRelateid 
(
relateditemid_1 integer , 
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS
BEGIN
open thecursor for
select * from CRM_T_ShareInfo where ( relateditemid = relateditemid_1 ) order by sharetype ;
end;
/

CREATE or REPLACE PROCEDURE CRM_T_ShareInfo_Delete 
(id_1 integer, 
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS
begin
DELETE from CRM_T_ShareInfo  WHERE ( id = id_1);
end;
/



CREATE or REPLACE PROCEDURE CRM_T_ShareInfo_Insert
(
relateditemid_1 integer, 
sharetype_1 smallint,
seclevel_1  smallint,
rolelevel_1 smallint,
sharelevel_1 smallint,
userid_1 integer,
departmentid_1 integer, 
roleid_1 integer,
foralluser_1 smallint,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
begin
INSERT INTO CRM_T_ShareInfo 
( relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser ) 
VALUES
( relateditemid_1 , sharetype_1 , seclevel_1 , rolelevel_1 , sharelevel_1, userid_1, departmentid_1, roleid_1, foralluser_1  ) ;
end;
/


CREATE or REPLACE PROCEDURE CRM_T_ShareInfo_SID
(id_1 integer ,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS 
begin 
open thecursor for
select * from CRM_T_ShareInfo where (id = id_1 ); 
end;
/



CREATE or REPLACE PROCEDURE CRM_ShareInfo_Update
(
typeid_1 integer , 
customerid_1 integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
		theid_1 integer;
		relateditemid_1 integer;
		sharetype_1 smallint ;
		seclevel_1 smallint  ;
		rolelevel_1 smallint  ;
		sharelevel_1 smallint  ;
		userid_1 integer  ;
		departmentid_1 integer  ;
		roleid_1 integer  ;
		foralluser_1 smallint  ;
		crmid_1 integer;  
begin
	for all_cursor IN (select id from CRM_T_ShareInfo WHERE relateditemid = typeid_1)
	loop
		theid_1 := all_cursor.id;
		select   sharetype, seclevel , rolelevel, sharelevel, userid, departmentid, roleid, foralluser, crmid 
		INTO sharetype_1,seclevel_1,rolelevel_1,sharelevel_1,userid_1,departmentid_1,roleid_1,foralluser_1,
		crmid_1 from CRM_T_ShareInfo WHERE id = theid_1;
		insert INTO  CRM_ShareInfo (relateditemid ,	sharetype  ,seclevel ,rolelevel  ,sharelevel,userid
		,departmentid ,	roleid,	foralluser ,crmid ) 			values(customerid_1,sharetype_1,seclevel_1,rolelevel_1,sharelevel_1,userid_1,departmentid_1,			roleid_1,foralluser_1,crmid_1) ;
	end loop;
end;
/


 


/*项目类型的共享*/
 CREATE TABLE Prj_T_ShareInfo (
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
	crmid integer NULL 
) 
/
create sequence Prj_T_ShareInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_T_ShareInfo_Trigger
before insert on Prj_T_ShareInfo
for each row
begin
select Prj_T_ShareInfo_id.nextval into :new.id from dual;
end;
/

	 

CREATE or REPLACE PROCEDURE Prj_T_ShareInfo_SbyRelateid 
(
relateditemid integer , 
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS
begin
open thecursor for
select * from Prj_T_ShareInfo where ( relateditemid = relateditemid ) order by sharetype; 
end;
/


CREATE or REPLACE PROCEDURE Prj_T_ShareInfo_Delete 
(id_1 integer, flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
begin
DELETE from Prj_T_ShareInfo  WHERE ( id = id_1);
end;
/







CREATE or REPLACE PROCEDURE Prj_T_ShareInfo_Insert
(
relateditemid_1 integer, 
sharetype_1 smallint,
seclevel_1  smallint,
rolelevel_1 smallint,
sharelevel_1 smallint,
userid_1 integer,
departmentid_1 integer, 
roleid_1 integer,
foralluser_1 smallint,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
begin
INSERT INTO Prj_T_ShareInfo 
( relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser ) 
VALUES
( relateditemid_1 , sharetype_1 , seclevel_1 , rolelevel_1 , sharelevel_1, userid_1, departmentid_1, roleid_1, foralluser_1  ) ;
end;
/


CREATE or REPLACE PROCEDURE Prj_T_ShareInfo_SID
(id_1 integer ,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS 
begin
open thecursor for
select * from Prj_T_ShareInfo where (id = id_1 ); 
end;
/
	 

CREATE or REPLACE PROCEDURE Prj_ShareInfo_Update
(
typeid_1 integer , 
customerid_1 integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
		theid_1 integer;
		relateditemid_1 integer;
		sharetype_1 smallint ;
		seclevel_1 smallint  ;
		rolelevel_1 smallint  ;
		sharelevel_1 smallint  ;
		userid_1 integer  ;
		departmentid_1 integer  ;
		roleid_1 integer  ;
		foralluser_1 smallint  ;
		crmid_1 integer;  
begin
	for all_cursor IN (select id from Prj_T_ShareInfo WHERE relateditemid = typeid_1)
	loop
		theid_1 := all_cursor.id;
		select   sharetype, seclevel , rolelevel, sharelevel, userid, departmentid, roleid, foralluser, crmid 
		INTO sharetype_1,seclevel_1,rolelevel_1,sharelevel_1,userid_1,departmentid_1,roleid_1,foralluser_1,
		crmid_1 from Prj_T_ShareInfo WHERE id = theid_1;
		insert INTO  Prj_ShareInfo (relateditemid ,	sharetype  ,seclevel ,rolelevel  ,sharelevel,userid
		,departmentid ,	roleid,	foralluser ,crmid ) 			values(customerid_1,sharetype_1,seclevel_1,rolelevel_1,sharelevel_1,userid_1,departmentid_1,			roleid_1,foralluser_1,crmid_1) ;
	end loop;
end;
/


CREATE TABLE Bill_crmcontract (
	id integer  NOT NULL  ,
	resource_n integer   NULL ,
	depid integer NULL ,
	contractid integer NULL ,
	typeid integer NULL ,
	docids varchar2(255) NULL,
	price number(10, 2) NULL ,
	startdate  char(10) NULL,
	enddate  char(10) NULL,
	crmid	integer NULL ,
	prjid	integer NULL ,
	approvids  varchar2 (255) NULL,
	requestid  integer
) 
/
create sequence Bill_crmcontract_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Bill_crmcontract_Trigger
before insert on Bill_crmcontract
for each row
begin
select Bill_crmcontract_id.nextval into :new.id from dual;
end;
/


CREATE OR REPLACE PROCEDURE CRM_ContractProduct_DelAll
	(contractId_1 	integer ,
	 IdStr_1 	varchar2 ,	
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )
AS 
begin
DELETE CRM_ContractProduct 
WHERE 
	( contractId	 = contractId_1 and id not in(IdStr_1) );
end;
/

CREATE OR REPLACE PROCEDURE CRM_ContractPayMethod_DelAll
	(contractId_1 	integer ,
	 IdStr_1 	varchar2 ,	
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )
AS 
begin
DELETE CRM_ContractPayMethod 
WHERE 
	( contractId	 = contractId_1 and id not in(IdStr_1));
end;
/



CREATE or REPLACE PROCEDURE CRM_ContractProduct_Update1
	(
	 id_1 	integer ,	
	 productId_1  integer  ,
	 unitId_1  integer  ,
	 currencyId_1  integer  ,	 
	 price_1  number  ,	 
	 depreciation_1  integer  ,
	 number_n_1  integer  ,
	 sumPrice_1  number ,
	 planDate_1  char    ,
	 isRemind_1  integer  ,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )

AS 
begin
UPDATE CRM_ContractProduct SET 
	 productId = productId_1 , 
	 unitId = unitId_1, 
	 currencyId = currencyId_1,
	 price = price_1, 
	 depreciation = depreciation_1,
	 number_n = number_n_1 , 
	 sumPrice = sumPrice_1, 
	 planDate = planDate_1 ,
	 isRemind = isRemind_1 where id = id_1 ;
end;
/


CREATE or REPLACE PROCEDURE CRM_ContractPayMethod_Update1
	(
	 id_1 	integer ,	
	 prjName_1  varchar2   ,
	 typeId_1  integer  ,
	 feetypeid_1 integer  ,
	 payPrice_1  number  ,
	 payDate_1  char    ,
	 qualification_1 varchar2 ,
	 isRemind_1  integer  ,	
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )

AS 
begin
UPDATE CRM_ContractPayMethod SET 
	 prjName = prjName_1 , 
	 typeId = typeId_1, 
	 feetypeid = feetypeid_1,
	 payPrice = payPrice_1, 
	 payDate = payDate_1,
	 qualification = qualification_1 , 
	 isRemind = isRemind_1 where id = id_1 ;
end;
/


CREATE OR REPLACE PROCEDURE CRM_ContractProduct_Select
	(contractId_1 integer ,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )
AS
begin
open thecursor for
SELECT * FROM CRM_ContractProduct where contractId = contractId_1 order by id ;
end;
/


CREATE OR REPLACE PROCEDURE CRM_ContractPayMethod_Select
	(contractId_1 integer ,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
begin
open thecursor for
SELECT * FROM CRM_ContractPayMethod  where contractId = contractId_1 order by id ;
end;
/


insert into HtmlLabelIndex (id,indexdesc) values (6160	,'业务合同')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6160,'业务合同',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6160,'',8)
/
insert into HtmlLabelIndex (id,indexdesc) values (6161	,'相关合同')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6161,'相关合同',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6161,'',8)
/
insert into HtmlLabelIndex (id,indexdesc) values (6162	,'合同文档')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6162,'合同文档',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6162,'',8)
/
insert into HtmlLabelIndex (id,indexdesc) values (6163	,'多文档')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6163,'多文档',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6163,'',8)
/
insert into HtmlLabelIndex (id,indexdesc) values (6164	,'会签人')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6164,'会签人',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6164,'',8)
/

/* 工作流浏览框 */
INSERT INTO workflow_browserurl (labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 6160,'integer','/systeminfo/BrowserMain.jsp?url=/CRM/data/ContractBrowser.jsp?status=0','CRM_Contract','name','id','/CRM/data/ContractView.jsp?id=')
/
INSERT INTO workflow_browserurl (labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 6083,'integer','/systeminfo/BrowserMain.jsp?url=/CRM/data/ContractTypeBrowser.jsp','CRM_ContractType','name','id','/CRM/Maint/CRMContractTypeList.jsp?id=')
/
INSERT INTO workflow_browserurl (labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 6163,'varchar2(4000)','/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp','DocDetail','docsubject','id','/docs/docs/DocDsp.jsp?isrequest=1&id=')
/

/* 客户合同 */ 
INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield) VALUES(49,6160,'Bill_crmcontract','BillHrmCrmContractAdd.jsp','BillHrmCrmContractManage.jsp','','','') 
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (49,'resource_n',368,'integer',3,1,1,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (49,'depid',6141,'integer',3,4,2,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (49,'contractid',6161,'integer',3,35,4,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (49,'typeid',6083,'integer',3,36,5,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (49,'docids',6162,'varchar2(255)',3,37,6,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (49,'price',6146,'number(10,2)',1,3,7,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (49,'startdate',740,'char(10)',3,2,8,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (49,'enddate',741,'char(10)',3,2,9,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (49,'crmid',783,'integer',3,7,10,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (49,'prjid',782,'integer',3,8,11,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (49,'approvids',6164,'varchar2(255)',3,17,3,0)
/

insert into HtmlLabelIndex (id,indexdesc) values (6165	,'租用个数')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6165,'租用个数',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6165,'',8)
/

Update workflow_browserurl  set browserurl = '/systeminfo/BrowserMain.jsp?url=/hrm/train/trainplan/HrmTrainPlanBrowser.jsp' where id = 32
/

Update workflow_billfield  set fieldlabel = 6165 where billid = 15 and id = 179
/


/*工资项目福利税率表(福利)*/
create table  HrmSalaryWelfarerate (
id	integer NOT NULL ,
itemid  integer ,                           /*工资项目id*/
cityid  integer ,                           /*城市id*/
personwelfarerate   integer ,               /*个人费率id*/
companywelfarerate  integer                /*公司费率*/
)
/
create sequence HrmSalaryWelfarerate_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSalaryWelfarerate_Tri
before insert on HrmSalaryWelfarerate
for each row
begin
select HrmSalaryWelfarerate_id.nextval into :new.id from dual;
end;
/
ALTER TABLE HrmSalaryWelfarerate  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


create  INDEX HrmSalaryWelfarerate_in on HrmSalaryWelfarerate(itemid)
/

create  INDEX HrmSalaryRank_in on HrmSalaryRank(itemid)
/

create  INDEX HrmSalaryTaxbench_in on HrmSalaryTaxbench(itemid)
/

create  INDEX HrmSalaryTaxrate_in on HrmSalaryTaxrate(benchid)
/

CREATE or REPLACE PROCEDURE HrmSalaryWelfarerate_Insert
    (itemid_1 	integer,
     cityid_2 	integer,
     personwelfarerate_3 	integer,
     companywelfarerate_4 	integer,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )
AS
begin
INSERT INTO HrmSalaryWelfarerate 
	 ( itemid,
	 cityid,
	 personwelfarerate,
	 companywelfarerate) 
 
VALUES 
	( itemid_1,
	 cityid_2,
	 personwelfarerate_3,
	 companywelfarerate_4);
end;
/

CREATE or REPLACE PROCEDURE HrmSalaryWelfarerate_Delete
	(id_1 	integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS 
begin
DELETE HrmSalaryWelfarerate 

WHERE 
	( id	 = id_1);
end;
/


CREATE OR REPLACE PROCEDURE HrmSalaryItem_Update
	(id_1 	integer,
	 itemname_2 	varchar2,
	 itemcode_3 	varchar2,
	 itemtype_4 	char,
	 personwelfarerate_5 	integer,
	 companywelfarerate_6 	integer,
	 taxrelateitem_7 	integer,
	 amountecp_8 	varchar2,
	 feetype_9 	integer,
	 isshow_10 	char,
	 showorder_11 	integer,
	 ishistory_12 	char ,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )

AS 
	olditemtype_1 char(1) ;
	benchid_1 integer;
begin
select   itemtype INTO olditemtype_1 from HrmSalaryItem where id = id_1 ;
UPDATE HrmSalaryItem 
SET  itemname	 = itemname_2,
	 itemcode	 = itemcode_3,
	 itemtype	 = itemtype_4,
	 personwelfarerate	 = personwelfarerate_5,
	 companywelfarerate	 = companywelfarerate_6,
	 taxrelateitem	 = taxrelateitem_7,
	 amountecp	 = amountecp_8,
	 feetype	 = feetype_9,
	 isshow	 = isshow_10,
	 showorder	 = showorder_11,
	 ishistory	 = ishistory_12 

WHERE 
	( id	 = id_1);


if olditemtype_1 = '1' then
    delete from HrmSalaryRank where itemid = id_1;
	end if;
if olditemtype_1 = '2' then
    delete from HrmSalaryRank where itemid = id_1;
    delete from HrmSalaryWelfarerate where itemid = id_1;
end if;
if olditemtype_1 = '3' then

    for benchid_cursor IN (select id from HrmSalaryTaxbench where itemid = id_1 )
	loop
		benchid_1 := benchid_cursor.id;
        delete from HrmSalaryTaxrate where benchid = benchid_1;
        delete from HrmSalaryTaxbench where id = benchid_1;
	end loop; 
end if;
end;
/


CREATE OR REPLACE PROCEDURE HrmSalaryItem_Delete
	(id_1 	integer ,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
	olditemtype_1 char(1) ;
	benchid_1 integer;
begin
select  itemtype INTO olditemtype_1 from HrmSalaryItem where id = id_1; 
DELETE HrmSalaryItem WHERE ( id	 = id_1);

if olditemtype_1 = '1' then
    delete from HrmSalaryRank where itemid = id_1 ;
	end if;
if olditemtype_1 = '2' then
    delete from HrmSalaryRank where itemid = id_1 ;
    delete from HrmSalaryWelfarerate where itemid = id_1 ;
end if;
if olditemtype_1 = '3' then

    for benchid_cursor IN (select id from HrmSalaryTaxbench where itemid = id_1 )
	loop
		benchid_1 := benchid_cursor.id;
        delete from HrmSalaryTaxrate where benchid = benchid_1;
        delete from HrmSalaryTaxbench where id = benchid_1;
	end loop;
end if;
end;
/



/*工作流基础数据－开始*/

drop table workflow_addinoperate
/

drop table workflow_base
/

drop table workflow_fieldlable
/

drop table workflow_flownode
/

drop table workflow_formbase
/

drop table workflow_formfield
/

drop table workflow_groupdetail
/

drop table workflow_nodebase
/

drop table workflow_nodeform
/

drop table workflow_nodegroup
/

drop table workflow_nodelink
/

drop table workflow_type
/

drop sequence workflow_addinoperate_id
/
CREATE TABLE workflow_addinoperate (
	id integer  NOT NULL ,
	objid integer NULL ,
	isnode integer NULL ,
	workflowid integer NULL ,
	fieldid integer NULL ,
	fieldop1id integer NULL ,
	fieldop2id integer NULL ,
	operation integer NULL ,
	customervalue varchar2(255)  NULL ,
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
select workflow_addinoperate_id.nextval into :new.id from dual;
end;
/


drop sequence workflow_base_id
/
CREATE TABLE workflow_base (
	id integer NOT NULL ,
	workflowname varchar2 (60)  NULL ,
	workflowdesc varchar2 (100)  NULL ,
	workflowtype integer NULL ,
	securelevel varchar2 (3)  NULL ,
	formid integer NULL ,
	userid integer NULL ,
	isbill char (1)  NULL ,
	iscust integer NULL ,
	helpdocid integer NULL ,
	isvalid char (1)  NULL ,
	needmark char (1)  NULL 
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
select workflow_base_id.nextval into :new.id from dual;
end;
/

CREATE TABLE workflow_fieldlable (
	formid integer NOT NULL ,
	fieldid integer NOT NULL ,
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
drop sequence workflow_formbase_id
/
CREATE TABLE workflow_formbase (
	id integer NOT NULL ,
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
select workflow_formbase_id.nextval into :new.id from dual;
end;
/

CREATE TABLE workflow_formfield (
	formid integer NOT NULL ,
	fieldid integer NOT NULL ,
	fieldparameter varchar2 (100)  NULL ,
	needcheck char (1)  NULL ,
	checkscript varchar2 (150)  NULL ,
	ismultirows char (1)  NULL ,
	fieldorder integer NULL 
) 
/

drop sequence workflow_groupdetail_id
/
CREATE TABLE workflow_groupdetail (
	id integer  NOT NULL ,
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
select workflow_groupdetail_id.nextval into :new.id from dual;
end;
/

drop sequence workflow_nodebase_id
/
CREATE TABLE workflow_nodebase (
	id integer NOT NULL ,
	nodename varchar2 (60)  NULL ,
	isstart char (1)  NULL ,
	isreject char (1)  NULL ,
	isreopen char (1)  NULL ,
	isend char (1)  NULL ,
	drawxpos integer NULL ,
	drawypos integer NULL ,
	totalgroups integer NULL 
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
select workflow_nodebase_id.nextval into :new.id from dual;
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
	id integer NOT NULL ,
	nodeid integer NULL ,
	groupname varchar2 (60)  NULL ,
	canview integer NULL 
) 
/

drop sequence workflow_nodelink_id
/
CREATE TABLE workflow_nodelink (
	id integer  NOT NULL ,
	workflowid integer NULL ,
	nodeid integer NULL ,
	isreject char (1)  NULL ,
	condition varchar2 (200)  NULL ,
	linkname varchar2 (60)  NULL ,
	destnodeid integer NULL ,
	directionfrom integer NULL ,
	directionto integer NULL ,
	x1 integer NULL ,
	y1 integer NULL ,
	x2 integer NULL ,
	y2 integer NULL ,
	x3 integer NULL ,
	y3 integer NULL ,
	x4 integer NULL ,
	y4 integer NULL ,
	x5 integer NULL ,
	y5 integer NULL ,
	nodepasstime float NULL 
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
select workflow_nodelink_id.nextval into :new.id from dual;
end;
/

drop sequence workflow_type_id
/
CREATE TABLE workflow_type (
	id integer  NOT NULL ,
	typename varchar2 (60)  NULL ,
	typedesc varchar2 (100)  NULL ,
	dsporder integer NULL 
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
select workflow_type_id.nextval into :new.id from dual;
end;
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (1,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (1,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (1,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (1,4,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (1,5,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (1,18,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (1,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (2,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (2,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (2,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (2,4,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (2,5,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (2,18,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (2,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (3,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (3,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (3,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (3,4,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (3,5,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (3,18,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (3,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (4,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (4,5,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (4,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (4,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (4,8,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (4,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (4,10,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (4,165,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (4,166,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (4,167,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (4,168,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (4,181,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (4,182,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (4,183,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (4,184,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (4,185,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (4,186,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (5,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (5,5,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (5,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (5,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (5,8,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (5,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (5,10,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (5,165,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (5,166,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (5,167,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (5,168,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (5,181,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (5,182,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (5,183,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (5,184,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (5,185,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (5,186,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (6,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (6,5,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (6,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (6,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (6,8,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (6,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (6,10,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (6,165,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (6,166,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (6,167,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (6,168,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (6,181,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (6,182,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (6,183,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (6,184,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (6,185,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (6,186,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (7,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (7,5,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (7,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (7,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (7,8,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (7,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (7,10,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (7,165,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (7,166,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (7,167,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (7,168,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (7,181,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (7,182,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (7,183,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (7,184,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (7,185,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (7,186,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (8,360,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (8,361,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (8,362,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (8,365,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (9,360,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (9,361,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (9,362,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (9,365,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (10,360,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (10,361,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (10,362,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (10,365,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (11,1,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (11,2,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (11,3,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (11,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (11,6,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (11,12,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (11,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (12,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (12,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (12,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (12,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (12,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (12,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (12,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (13,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (13,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (13,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (13,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (13,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (13,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (13,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (14,1,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (14,2,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (14,3,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (14,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (14,5,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (14,6,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (14,12,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (14,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (15,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (15,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (15,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (15,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (15,5,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (15,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (15,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (15,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (16,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (16,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (16,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (16,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (16,5,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (16,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (16,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (16,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (17,227,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (17,228,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (17,229,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (17,230,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (17,231,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (17,232,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (17,233,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (18,227,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (18,228,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (18,229,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (18,230,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (18,231,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (18,232,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (18,233,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (19,227,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (19,228,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (19,229,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (19,230,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (19,231,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (19,232,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (19,233,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (20,227,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (20,228,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (20,229,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (20,230,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (20,231,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (20,232,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (20,233,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (21,187,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (21,188,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (21,189,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (22,187,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (22,188,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (22,189,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (23,187,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (23,188,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (23,189,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (24,187,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (24,188,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (24,189,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (25,1,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (25,2,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (25,3,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (25,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (25,5,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (25,6,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (25,7,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (25,8,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (25,9,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (25,10,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (25,12,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (25,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (26,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (26,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (26,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (26,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (26,5,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (26,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (26,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (26,8,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (26,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (26,10,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (26,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (26,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (27,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (27,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (27,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (27,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (27,5,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (27,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (27,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (27,8,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (27,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (27,10,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (27,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (27,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (28,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (28,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (28,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (28,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (28,5,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (28,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (28,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (28,8,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (28,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (28,10,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (28,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (28,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (29,1,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (29,2,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (29,3,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (29,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (29,5,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (29,6,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (29,7,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (29,8,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (29,9,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (29,10,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (29,12,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (29,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (30,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (30,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (30,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (30,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (30,5,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (30,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (30,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (30,8,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (30,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (30,10,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (30,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (30,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (31,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (31,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (31,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (31,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (31,5,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (31,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (31,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (31,8,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (31,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (31,10,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (31,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (31,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (32,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (32,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (32,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (32,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (32,5,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (32,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (32,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (32,8,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (32,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (32,10,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (32,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (32,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (33,1,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (33,2,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (33,3,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (33,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (33,6,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (33,7,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (33,9,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (33,12,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (33,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (33,17,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (33,34,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (33,35,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (33,54,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (33,75,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (34,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (34,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (34,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (34,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (34,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (34,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (34,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (34,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (34,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (34,17,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (34,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (34,35,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (34,54,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (34,75,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (35,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (35,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (35,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (35,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (35,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (35,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (35,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (35,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (35,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (35,17,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (35,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (35,35,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (35,54,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (35,75,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (36,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (36,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (36,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (36,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (36,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (36,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (36,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (36,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (36,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (36,17,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (36,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (36,35,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (36,54,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (36,75,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (37,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (37,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (37,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (37,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (37,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (37,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (37,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (37,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (37,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (37,17,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (37,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (37,35,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (37,54,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (37,75,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (38,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (38,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (38,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (38,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (38,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (38,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (38,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (38,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (38,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (38,17,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (38,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (38,35,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (38,54,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (38,75,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (39,55,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (39,60,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (39,61,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (39,62,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (39,140,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (39,141,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (39,142,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (39,336,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (39,337,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (39,338,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (39,339,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (39,343,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (40,55,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (40,60,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (40,61,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (40,62,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (40,140,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (40,141,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (40,142,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (40,336,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (40,337,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (40,338,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (40,339,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (40,343,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (41,55,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (41,60,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (41,61,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (41,62,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (41,140,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (41,141,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (41,142,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (41,336,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (41,337,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (41,338,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (41,339,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (41,343,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (42,55,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (42,60,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (42,61,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (42,62,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (42,140,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (42,141,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (42,142,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (42,336,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (42,337,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (42,338,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (42,339,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (42,343,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (43,55,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (43,60,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (43,61,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (43,62,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (43,140,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (43,141,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (43,142,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (43,336,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (43,337,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (43,338,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (43,339,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (43,343,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (44,55,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (44,60,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (44,61,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (44,62,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (44,140,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (44,141,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (44,142,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (44,336,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (44,337,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (44,338,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (44,339,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (44,343,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,63,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,64,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,65,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,66,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,67,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,68,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,69,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,70,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,71,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,74,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,75,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,78,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,79,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,163,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,164,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,169,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,330,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,366,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,367,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,368,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,369,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (45,370,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,63,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,64,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,65,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,66,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,67,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,68,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,69,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,70,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,71,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,74,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,75,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,78,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,79,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,163,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,164,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,169,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,330,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,366,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,367,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,368,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,369,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (46,370,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,63,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,64,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,65,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,66,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,67,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,68,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,69,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,70,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,71,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,74,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,75,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,78,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,79,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,163,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,164,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,169,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,330,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,366,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,367,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,368,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,369,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (47,370,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,63,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,64,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,65,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,66,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,67,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,68,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,69,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,70,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,71,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,74,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,75,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,78,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,79,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,163,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,164,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,169,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,330,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,366,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,367,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,368,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,369,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (48,370,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,63,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,64,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,65,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,66,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,67,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,68,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,69,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,70,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,71,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,74,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,75,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,78,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,79,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,163,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,164,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,169,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,330,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,366,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,367,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,368,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,369,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (49,370,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (50,143,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (50,300,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (50,301,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (50,302,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (50,303,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (50,340,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (50,341,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (51,143,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (51,300,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (51,301,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (51,302,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (51,303,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (51,340,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (51,341,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (52,143,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (52,300,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (52,301,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (52,302,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (52,303,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (52,340,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (52,341,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (53,143,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (53,300,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (53,301,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (53,302,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (53,303,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (53,340,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (53,341,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (54,1,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (54,2,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (54,3,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (54,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (54,6,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (54,12,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (54,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (54,17,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (54,60,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (55,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (55,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (55,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (55,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (55,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (55,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (55,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (55,17,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (55,60,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (56,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (56,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (56,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (56,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (56,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (56,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (56,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (56,17,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (56,60,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (57,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (57,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (57,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (57,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (57,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (57,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (57,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (57,17,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (57,60,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (58,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (58,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (58,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (58,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (58,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (58,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (58,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (58,17,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (58,60,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (59,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (59,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (59,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (59,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (59,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (59,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (59,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (59,17,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (59,60,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (60,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (60,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (60,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (60,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (60,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (60,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (60,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (60,17,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (60,60,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (61,1,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (61,2,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (61,3,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (61,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (61,6,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (61,7,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (61,8,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (61,12,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (61,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (61,34,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (61,35,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (61,36,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (62,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (62,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (62,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (62,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (62,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (62,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (62,8,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (62,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (62,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (62,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (62,35,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (62,36,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (63,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (63,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (63,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (63,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (63,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (63,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (63,8,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (63,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (63,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (63,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (63,35,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (63,36,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (64,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (64,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (64,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (64,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (64,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (64,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (64,8,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (64,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (64,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (64,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (64,35,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (64,36,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (65,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (65,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (65,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (65,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (65,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (65,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (65,8,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (65,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (65,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (65,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (65,35,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (65,36,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (66,1,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (66,2,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (66,3,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (66,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (66,6,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (66,7,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (66,8,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (66,12,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (66,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (66,34,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (66,80,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (67,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (67,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (67,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (67,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (67,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (67,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (67,8,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (67,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (67,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (67,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (67,80,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (68,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (68,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (68,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (68,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (68,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (68,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (68,8,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (68,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (68,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (68,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (68,80,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (69,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (69,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (69,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (69,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (69,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (69,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (69,8,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (69,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (69,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (69,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (69,80,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (70,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (70,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (70,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (70,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (70,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (70,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (70,8,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (70,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (70,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (70,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (70,80,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (71,1,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (71,2,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (71,3,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (71,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (71,6,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (71,7,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (71,12,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (71,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (71,60,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (72,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (72,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (72,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (72,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (72,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (72,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (72,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (72,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (72,60,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (73,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (73,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (73,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (73,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (73,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (73,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (73,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (73,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (73,60,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (74,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (74,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (74,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (74,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (74,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (74,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (74,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (74,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (74,60,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (75,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (75,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (75,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (75,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (75,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (75,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (75,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (75,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (75,60,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (76,1,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (76,2,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (76,3,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (76,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (76,6,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (76,12,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (76,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (76,34,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (76,35,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (76,36,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (76,81,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (77,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (77,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (77,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (77,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (77,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (77,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (77,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (77,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (77,35,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (77,36,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (77,81,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (78,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (78,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (78,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (78,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (78,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (78,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (78,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (78,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (78,35,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (78,36,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (78,81,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (79,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (79,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (79,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (79,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (79,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (79,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (79,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (79,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (79,35,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (79,36,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (79,81,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (80,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (80,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (80,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (80,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (80,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (80,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (80,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (80,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (80,35,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (80,36,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (80,81,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (81,144,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (81,145,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (81,304,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (81,305,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (81,306,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (81,307,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (81,308,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (81,309,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (81,310,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (81,342,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (82,144,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (82,145,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (82,304,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (82,305,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (82,306,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (82,307,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (82,308,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (82,309,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (82,310,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (82,342,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (83,144,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (83,145,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (83,304,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (83,305,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (83,306,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (83,307,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (83,308,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (83,309,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (83,310,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (83,342,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (84,144,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (84,145,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (84,304,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (84,305,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (84,306,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (84,307,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (84,308,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (84,309,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (84,310,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (84,342,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (85,1,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (85,2,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (85,3,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (85,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (85,6,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (85,7,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (85,9,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (85,12,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (85,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (85,34,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (86,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (86,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (86,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (86,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (86,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (86,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (86,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (86,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (86,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (86,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (87,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (87,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (87,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (87,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (87,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (87,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (87,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (87,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (87,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (87,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (88,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (88,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (88,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (88,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (88,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (88,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (88,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (88,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (88,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (88,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (89,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (89,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (89,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (89,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (89,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (89,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (89,9,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (89,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (89,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (89,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (90,404,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (90,405,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (90,406,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (90,407,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (90,408,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (90,409,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (90,410,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (91,404,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (91,405,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (91,406,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (91,407,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (91,408,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (91,409,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (91,410,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (92,404,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (92,405,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (92,406,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (92,407,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (92,408,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (92,409,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (92,410,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (93,404,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (93,405,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (93,406,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (93,407,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (93,408,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (93,409,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (93,410,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (94,404,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (94,405,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (94,406,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (94,407,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (94,408,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (94,409,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (94,410,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (95,371,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (95,372,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (95,373,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (95,374,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (95,375,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (95,376,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (96,371,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (96,372,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (96,373,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (96,374,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (96,375,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (96,376,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (97,371,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (97,372,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (97,373,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (97,374,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (97,375,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (97,376,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (98,371,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (98,372,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (98,373,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (98,374,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (98,375,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (98,376,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (99,411,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (99,412,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (99,413,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (99,414,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (100,411,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (100,412,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (100,413,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (100,414,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (101,411,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (101,412,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (101,413,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (101,414,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (102,411,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (102,412,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (102,413,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (102,414,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (103,377,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (103,378,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (103,379,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (103,380,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (103,381,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (103,382,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (103,383,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (103,384,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (104,377,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (104,378,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (104,379,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (104,380,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (104,381,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (104,382,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (104,383,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (104,384,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (105,377,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (105,378,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (105,379,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (105,380,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (105,381,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (105,382,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (105,383,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (105,384,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (106,377,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (106,378,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (106,379,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (106,380,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (106,381,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (106,382,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (106,383,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (106,384,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (107,385,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (107,386,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (107,387,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (107,388,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (108,385,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (108,386,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (108,387,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (108,388,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (109,385,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (109,386,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (109,387,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (109,388,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (110,385,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (110,386,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (110,387,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (110,388,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (111,389,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (111,390,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (111,391,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (112,389,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (112,390,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (112,391,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (113,389,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (113,390,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (113,391,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (114,389,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (114,390,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (114,391,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (115,392,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (115,393,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (115,394,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (115,395,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (115,396,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (115,397,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (115,415,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (116,392,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (116,393,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (116,394,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (116,395,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (116,396,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (116,397,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (116,415,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (117,392,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (117,393,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (117,394,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (117,395,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (117,396,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (117,397,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (117,415,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (118,398,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (118,399,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (118,400,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (118,401,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (118,402,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (118,403,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (118,416,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (119,398,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (119,399,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (119,400,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (119,401,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (119,402,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (119,403,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (119,416,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (120,398,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (120,399,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (120,400,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (120,401,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (120,402,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (120,403,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (120,416,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (121,1,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (121,2,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (121,3,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (121,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (121,6,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (121,12,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (121,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (121,17,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (122,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (122,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (122,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (122,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (122,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (122,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (122,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (122,17,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (123,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (123,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (123,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (123,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (123,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (123,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (123,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (123,17,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (124,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (124,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (124,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (124,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (124,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (124,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (124,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (124,17,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (125,1,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (125,2,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (125,3,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (125,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (125,6,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (125,12,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (125,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (125,34,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (125,54,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (126,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (126,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (126,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (126,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (126,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (126,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (126,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (126,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (126,54,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (127,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (127,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (127,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (127,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (127,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (127,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (127,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (127,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (127,54,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (128,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (128,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (128,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (128,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (128,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (128,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (128,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (128,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (128,54,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (129,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (129,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (129,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (129,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (129,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (129,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (129,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (129,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (129,54,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (130,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (130,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (130,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (130,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (130,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (130,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (130,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (130,34,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (130,54,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (131,292,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (131,293,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (131,294,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (131,295,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (131,363,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (131,364,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (132,292,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (132,293,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (132,294,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (132,295,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (132,363,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (132,364,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (133,292,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (133,293,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (133,294,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (133,295,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (133,363,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (133,364,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (134,1,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (134,2,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (134,3,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (134,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (134,5,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (134,6,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (134,7,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (134,12,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (134,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (135,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (135,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (135,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (135,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (135,5,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (135,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (135,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (135,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (135,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (136,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (136,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (136,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (136,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (136,5,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (136,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (136,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (136,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (136,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (137,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (137,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (137,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (137,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (137,5,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (137,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (137,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (137,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (137,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (138,1,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (138,2,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (138,3,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (138,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (138,5,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (138,6,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (138,7,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (138,12,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (138,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (139,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (139,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (139,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (139,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (139,5,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (139,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (139,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (139,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (139,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (140,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (140,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (140,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (140,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (140,5,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (140,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (140,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (140,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (140,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (141,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (141,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (141,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (141,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (141,5,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (141,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (141,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (141,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (141,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (142,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (142,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (142,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (142,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (142,5,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (142,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (142,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (142,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (142,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (143,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (143,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (143,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (143,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (143,5,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (143,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (143,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (143,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (143,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (144,1,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (144,2,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (144,3,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (144,4,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (144,5,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (144,6,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (144,7,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (144,12,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (144,13,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (145,417,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (145,418,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (145,419,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (145,420,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (145,421,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (145,422,'1','1','1')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (145,423,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (145,424,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (145,425,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (145,426,'1','1','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (145,427,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (146,417,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (146,418,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (146,419,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (146,420,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (146,421,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (146,422,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (146,423,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (146,424,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (146,425,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (146,426,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (146,427,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (147,417,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (147,418,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (147,419,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (147,420,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (147,421,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (147,422,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (147,423,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (147,424,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (147,425,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (147,426,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (147,427,'0','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (148,417,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (148,418,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (148,419,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (148,420,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (148,421,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (148,422,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (148,423,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (148,424,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (148,425,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (148,426,'1','0','0')
/
insert into workflow_nodeform (nodeid,fieldid,isview,isedit,ismandatory) values (148,427,'0','0','0')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (1,1,'相关文档',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (1,2,'相关客户',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (1,3,'相关项目',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (1,4,'申请人',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (1,5,'通知对象',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (1,6,'通知内容',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (1,7,'开始日期',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (1,8,'开始时间',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (1,9,'结束日期',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (1,10,'结束时间',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (1,12,'相关请求',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (1,13,'部门',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (2,1,'相关文档',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (2,2,'相关客户',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (2,3,'相关项目',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (2,4,'请示人',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (2,6,'请示内容',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (2,12,'相关流程',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (2,13,'请示人部门',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (3,1,'相关文档',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (3,2,'相关客户',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (3,3,'相关项目',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (3,4,'留言人',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (3,5,'被留言人',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (3,6,'留言内容',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (3,12,'相关流程',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (3,13,'部门',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (4,1,'相关文档',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (4,2,'相关客户',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (4,3,'相关项目',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (4,4,'申请人',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (4,6,'事由',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (4,7,'预计出差时间',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (4,9,'预计返回时间',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (4,12,'相关流程',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (4,13,'申请人部门',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (4,17,'借款金额',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (4,34,'同行人',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (4,35,'目的地和线路',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (4,54,'出差人数',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (4,75,'交通工具',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (5,1,'相关文档',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (5,2,'相关客户',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (5,3,'相关项目',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (5,4,'申请人',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (5,6,'服务需求描述',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (5,12,'相关流程',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (5,13,'申请人部门',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (5,17,'费用',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (5,60,'解决方案',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (6,1,'相关文档',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (6,2,'相关客户',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (6,3,'相关项目',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (6,4,'申请人',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (6,6,'申请事由',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (6,7,'机票日期',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (6,8,'机票时间',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (6,12,'相关流程',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (6,13,'申请人部门',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (6,34,'乘坐人',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (6,35,'身份证号',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (6,36,'目的地',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (7,1,'相关文档',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (7,2,'相关客户',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (7,3,'相关项目',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (7,4,'申请人',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (7,6,'申请事由',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (7,7,'车票日期',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (7,8,'车票时间',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (7,12,'相关流程',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (7,13,'申请部门',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (7,34,'目的地',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (7,80,'车票类型',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (8,1,'相关文档',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (8,2,'相关客户',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (8,3,'相关项目',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (8,4,'申请人',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (8,6,'申请原因',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (8,7,'需要时间',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (8,12,'相关流程',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (8,13,'申请人部门',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (8,60,'礼品说明',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (9,1,'相关文档',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (9,2,'相关客户',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (9,3,'相关项目',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (9,4,'申请人',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (9,6,'使用原因',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (9,12,'相关流程',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (9,13,'申请人部门',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (9,34,'受函单位',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (9,35,'函件名称',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (9,36,'函件编号',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (9,81,'公章类型',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (10,1,'相关文档',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (10,2,'相关客户',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (10,3,'相关项目',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (10,4,'申请人',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (10,6,'预定说明',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (10,7,'预计入住日期',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (10,9,'预计退房日期',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (10,12,'相关流程',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (10,13,'申请部门',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (10,34,'住宿人',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (11,1,'相关客户',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (11,2,'相关文档',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (11,3,'相关流程',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (11,4,'申请人',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (11,6,'维修说明',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (11,12,'相关项目',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (11,13,'申请人部门',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (11,17,'预计费用',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (12,1,'相关文档',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (12,2,'相关客户',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (12,3,'相关项目',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (12,4,'申请人',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (12,5,'指点查阅人',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (12,6,'文件概要',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (12,7,'文件日期',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (12,12,'相关流程',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (12,13,'申请人部门',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (13,1,'相关文档',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (13,2,'相关客户',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (13,3,'相关项目',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (13,4,'申请人',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (13,6,'需求说明',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (13,12,'相关流程',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (13,13,'申请人部门',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (13,34,'资产说明',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (13,54,'数量',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (14,1,'相关文档',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (14,2,'相关客户',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (14,3,'相关项目',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (14,4,'执行者',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (14,5,'提醒者',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (14,18,'相关会议',7,'1')
/
insert into workflow_fieldlable (formid,fieldid,fieldlable,langurageid,isdefault) values (14,6,'备注',7,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (1,1,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (1,2,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (1,3,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (2,4,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (2,5,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (2,6,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (2,7,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (3,8,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (3,9,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (3,10,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (4,11,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (4,12,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (4,13,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (5,14,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (5,15,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (5,16,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (6,17,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (6,18,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (6,19,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (6,20,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (7,21,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (7,22,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (7,23,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (7,24,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (8,25,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (8,26,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (8,27,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (8,28,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (9,29,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (9,30,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (9,31,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (9,32,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (10,33,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (10,34,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (10,35,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (10,36,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (10,37,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (10,38,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (11,39,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (11,40,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (11,41,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (11,42,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (11,43,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (11,44,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (12,45,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (12,46,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (12,47,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (12,48,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (12,49,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (13,50,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (13,51,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (13,52,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (13,53,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (14,54,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (14,55,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (14,56,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (14,57,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (14,58,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (14,59,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (14,60,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (15,61,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (15,62,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (15,63,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (15,64,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (15,65,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (16,66,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (16,67,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (16,68,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (16,69,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (16,70,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (17,71,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (17,72,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (17,73,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (17,74,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (17,75,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (18,76,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (18,77,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (18,78,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (18,79,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (18,80,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (19,81,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (19,82,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (19,83,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (19,84,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (20,85,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (20,86,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (20,87,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (20,88,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (20,89,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (21,90,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (21,91,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (21,92,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (21,93,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (21,94,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (22,95,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (22,96,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (22,97,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (22,98,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (23,103,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (23,104,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (23,105,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (23,106,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (24,107,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (24,108,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (24,109,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (24,110,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (25,111,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (25,112,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (25,113,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (25,114,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (26,99,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (26,100,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (26,101,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (26,102,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (27,115,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (27,116,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (27,117,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (28,118,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (28,119,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (28,120,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (29,121,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (29,122,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (29,123,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (29,124,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (30,125,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (30,126,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (30,127,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (30,128,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (30,129,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (30,130,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (31,131,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (31,132,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (31,133,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (32,134,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (32,135,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (32,136,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (32,137,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (33,138,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (33,139,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (33,140,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (33,141,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (33,142,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (33,143,'2')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (33,144,'3')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (34,145,'0')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (34,146,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (34,147,'1')
/
insert into workflow_flownode (workflowid,nodeid,nodetype) values (34,148,'3')
/
insert into workflow_formbase (formname,formdesc,securelevel,formhtmlcode,formdate) values ('通知表单','通知表单','','','')
/
insert into workflow_formbase (formname,formdesc,securelevel,formhtmlcode,formdate) values ('请示批复','请示批复','','','')
/
insert into workflow_formbase (formname,formdesc,securelevel,formhtmlcode,formdate) values ('留言','留言','','','')
/
insert into workflow_formbase (formname,formdesc,securelevel,formhtmlcode,formdate) values ('出差申请','出差申请','','','')
/
insert into workflow_formbase (formname,formdesc,securelevel,formhtmlcode,formdate) values ('IT服务单','IT服务单','','','')
/
insert into workflow_formbase (formname,formdesc,securelevel,formhtmlcode,formdate) values ('机票申请','机票申请','','','')
/
insert into workflow_formbase (formname,formdesc,securelevel,formhtmlcode,formdate) values ('汽车火车票申请','汽车火车票申请','','','')
/
insert into workflow_formbase (formname,formdesc,securelevel,formhtmlcode,formdate) values ('礼品申请','礼品申请','','','')
/
insert into workflow_formbase (formname,formdesc,securelevel,formhtmlcode,formdate) values ('公章申请','公章申请','','','')
/
insert into workflow_formbase (formname,formdesc,securelevel,formhtmlcode,formdate) values ('宾馆预定','宾馆预定','','','')
/
insert into workflow_formbase (formname,formdesc,securelevel,formhtmlcode,formdate) values ('维修申请单','维修申请单','','','')
/
insert into workflow_formbase (formname,formdesc,securelevel,formhtmlcode,formdate) values ('公文表单','公文表单','','','')
/
insert into workflow_formbase (formname,formdesc,securelevel,formhtmlcode,formdate) values ('资产需求','资产需求','','','')
/
insert into workflow_formbase (formname,formdesc,securelevel,formhtmlcode,formdate) values ('系统默认提醒表单','系统默认提醒表单','','','')
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (1,1,'','','','',10)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (1,2,'','','','',8)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (1,3,'','','','',9)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (1,4,'','','','',0)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (1,5,'','','','',6)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (1,6,'','','','',7)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (1,7,'','','','',2)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (1,8,'','','','',3)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (1,9,'','','','',4)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (1,10,'','','','',5)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (1,12,'','','','',11)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (1,13,'','','','',1)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (2,1,'','','','',3)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (2,2,'','','','',4)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (2,3,'','','','',5)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (2,4,'','','','',0)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (2,6,'','','','',2)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (2,12,'','','','',6)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (2,13,'','','','',1)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (3,1,'','','','',4)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (3,2,'','','','',5)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (3,3,'','','','',6)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (3,4,'','','','',0)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (3,5,'','','','',3)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (3,6,'','','','',2)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (3,12,'','','','',7)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (3,13,'','','','',1)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (4,1,'','','','',10)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (4,2,'','','','',11)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (4,3,'','','','',12)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (4,4,'','','','',0)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (4,6,'','','','',5)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (4,7,'','','','',3)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (4,9,'','','','',4)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (4,12,'','','','',13)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (4,13,'','','','',1)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (4,17,'','','','',6)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (4,34,'','','','',8)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (4,35,'','','','',9)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (4,54,'','','','',7)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (4,75,'','','','',2)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (5,1,'','','','',5)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (5,2,'','','','',6)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (5,3,'','','','',7)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (5,4,'','','','',0)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (5,6,'','','','',2)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (5,12,'','','','',8)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (5,13,'','','','',1)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (5,17,'','','','',4)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (5,60,'','','','',3)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (6,1,'','','','',8)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (6,2,'','','','',9)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (6,3,'','','','',10)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (6,4,'','','','',0)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (6,6,'','','','',7)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (6,7,'','','','',5)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (6,8,'','','','',6)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (6,12,'','','','',11)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (6,13,'','','','',1)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (6,34,'','','','',2)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (6,35,'','','','',3)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (6,36,'','','','',4)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (7,1,'','','','',7)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (7,2,'','','','',8)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (7,3,'','','','',9)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (7,4,'','','','',0)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (7,6,'','','','',6)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (7,7,'','','','',3)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (7,8,'','','','',4)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (7,12,'','','','',10)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (7,13,'','','','',1)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (7,34,'','','','',5)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (7,80,'','','','',2)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (8,1,'','','','',5)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (8,2,'','','','',6)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (8,3,'','','','',7)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (8,4,'','','','',0)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (8,6,'','','','',2)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (8,7,'','','','',4)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (8,12,'','','','',8)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (8,13,'','','','',1)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (8,60,'','','','',3)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (9,1,'','','','',7)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (9,2,'','','','',8)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (9,3,'','','','',9)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (9,4,'','','','',0)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (9,6,'','','','',6)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (9,12,'','','','',10)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (9,13,'','','','',1)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (9,34,'','','','',3)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (9,35,'','','','',4)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (9,36,'','','','',5)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (9,81,'','','','',2)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (10,1,'','','','',6)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (10,2,'','','','',7)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (10,3,'','','','',8)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (10,4,'','','','',0)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (10,6,'','','','',5)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (10,7,'','','','',2)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (10,9,'','','','',3)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (10,12,'','','','',9)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (10,13,'','','','',1)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (10,34,'','','','',4)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (11,1,'','','','',4)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (11,2,'','','','',5)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (11,3,'','','','',6)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (11,4,'','','','',0)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (11,6,'','','','',2)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (11,12,'','','','',7)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (11,13,'','','','',1)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (11,17,'','','','',3)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (12,1,'','','','',5)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (12,2,'','','','',6)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (12,3,'','','','',7)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (12,4,'','','','',0)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (12,5,'','','','',4)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (12,6,'','','','',3)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (12,7,'','','','',2)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (12,12,'','','','',8)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (12,13,'','','','',1)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (13,1,'','','','',5)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (13,2,'','','','',6)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (13,3,'','','','',7)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (13,4,'','','','',0)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (13,6,'','','','',4)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (13,12,'','','','',8)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (13,13,'','','','',1)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (13,34,'','','','',2)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (13,54,'','','','',3)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (14,1,'','','','',0)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (14,2,'','','','',1)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (14,3,'','','','',2)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (14,4,'','','','',3)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (14,5,'','','','',4)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (14,18,'','','','',5)
/
insert into workflow_formfield (formid,fieldid,fieldparameter,needcheck,checkscript,ismultirows,fieldorder) values (14,6,'','','','',6)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (1,5,5,1)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (2,5,4,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (3,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (4,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (5,5,165,1)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (6,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (6,5,165,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (7,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (8,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (8,5,361,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (9,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (10,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (11,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (12,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (13,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (14,5,5,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (15,5,5,1)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (16,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (17,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (18,2,12,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (19,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (19,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (20,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (21,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (22,2,12,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (23,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (23,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (24,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (25,2,12,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (26,5,5,1)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (27,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (27,5,5,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (28,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (29,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (30,5,5,1)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (31,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (31,5,5,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (32,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (33,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (34,2,12,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (35,2,13,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (36,2,14,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (37,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (38,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (39,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (40,2,12,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (41,2,14,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (42,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (43,2,13,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (44,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (45,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (46,2,12,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (47,2,14,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (48,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (49,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (50,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (51,2,16,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (52,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (53,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (54,2,17,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (55,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (56,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (57,2,16,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (58,2,16,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (59,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (60,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (61,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (62,2,18,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (63,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (64,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (65,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (66,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (67,2,18,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (68,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (69,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (70,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (71,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (72,2,19,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (73,2,18,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (74,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (75,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (76,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (77,2,12,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (78,2,20,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (79,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (80,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (81,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (82,2,18,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (83,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (84,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (85,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (86,2,19,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (87,2,18,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (88,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (89,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (90,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (91,2,21,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (92,2,12,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (93,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (94,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (95,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (96,2,21,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (97,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (98,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (99,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (100,2,21,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (101,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (102,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (103,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (104,2,21,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (105,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (106,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (107,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (108,2,21,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (109,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (110,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (111,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (112,2,21,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (113,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (114,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (115,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (116,2,22,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (117,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (118,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (119,2,22,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (120,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (121,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (122,2,15,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (123,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (124,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (125,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (126,2,12,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (127,2,15,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (128,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (129,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (130,2,19,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (131,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (132,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (133,2,18,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (134,5,5,1)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (135,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (136,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (137,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (138,2,19,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (139,2,19,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (140,5,5,1)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (141,2,18,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (142,17,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (143,4,0,10)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (144,18,0,0)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (145,2,12,2)
/
insert into workflow_groupdetail (groupid,type,objid,level_n) values (146,17,0,0)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('系统创建','1','0','0','0',70,66)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('提醒','0','0','1','0',230,66)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('执行','0','0','0','1',391,66)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('创建工作安排','1','0','0','0',70,50)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('创建人确认','0','1','1','0',410,50)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('执行工作安排','0','0','1','0',240,50)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',580,50)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('提出讨论','1','0','0','0',70,70)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('展开讨论','0','0','1','0',229,70)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('结束讨论','0','0','0','1',403,70)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('提交请示批复','1','0','0','0',73,67)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('经理答复','0','0','1','0',232,67)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',395,67)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写留言','1','0','0','0',70,68)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('查看留言','0','0','1','0',233,68)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',398,68)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写小结','1','0','0','0',70,82)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('部门经理批复','0','1','1','0',231,82)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('总经理审批','0','1','1','0',397,82)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('小结归档','0','0','0','1',559,82)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写小结','1','0','0','0',69,81)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('部门经理批复','0','1','1','0',231,81)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('总经理审批','0','1','1','0',401,81)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('小结归档','0','0','0','1',571,81)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('创建通知内容并提交','1','0','0','0',70,78)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('总经理批准发布','0','1','1','0',241,78)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('通知接受人查看','0','0','1','0',407,78)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',580,78)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('创建通知','1','0','0','0',71,79)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('经理审批','0','1','1','0',232,79)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('接受人查看','0','0','1','0',397,79)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',562,79)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('提交出差申请','1','0','0','0',67,92)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('经理审批','0','1','1','0',245,92)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('总经理审批','0','1','1','0',424,92)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('财务经理审批','0','1','1','0',596,92)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('出纳付款','0','0','1','0',596,204)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',423,204)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('提交申请单','1','0','0','0',79,87)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('部门经理审批','0','1','1','0',243,87)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('总经理审批','0','1','1','0',592,87)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('出纳付款','0','0','1','0',592,207)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',425,207)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('财务经理审批','0','1','1','0',415,87)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('提交报销单','1','0','0','0',73,81)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('部门经理审批','0','1','1','0',232,81)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('总经理审批','0','1','1','0',392,81)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('出纳付款','0','0','1','0',554,81)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',708,81)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',72,81)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('经理审批','0','1','1','0',232,81)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('信息管理员处理','0','0','1','0',395,81)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',559,81)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',77,93)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('信息经理审批','0','1','1','0',417,93)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('经理审批','0','1','1','0',588,93)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('申请人确认','0','0','1','0',417,216)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('信息管理员解答','0','0','1','0',245,93)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('信息管理员处理','0','0','1','0',588,216)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',246,216)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',76,84)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('经理审批','0','1','1','0',253,84)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('行政助理处理','0','0','1','0',426,84)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('申请人确认','0','0','1','0',594,84)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',594,202)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',71,91)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('经理审批','0','1','1','0',237,91)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('行政助理处理','0','0','1','0',394,91)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('申请人确认','0','0','1','0',554,91)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',718,91)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',71,99)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('经理审批','0','1','1','0',233,99)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('行政经理审批','0','1','1','0',395,99)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('行政助理处理','0','0','1','0',559,99)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',721,99)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',70,97)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('经理审批','0','1','1','0',231,97)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('总经理审批','0','1','1','0',391,97)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('公章管理员','0','0','1','0',553,97)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',717,97)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',69,85)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('经理审批','0','1','1','0',231,85)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('行政助理处理','0','0','1','0',395,85)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',558,85)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',73,97)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('经理审批','0','1','1','0',233,97)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('行政经理审批','0','1','1','0',395,97)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('行政助理处理','0','0','1','0',555,97)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',715,97)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',77,93)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('部门经理审批','0','1','1','0',241,93)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('人事经理审批','0','1','1','0',402,93)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('总经理审批','0','1','1','0',561,93)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',722,93)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',73,89)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('部门经理审批','0','1','1','0',241,89)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('人事经理审批','0','1','1','0',410,89)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',578,89)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',66,94)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('部门经理审批','0','1','1','0',219,94)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('人事经理审批','0','1','1','0',374,94)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',529,94)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',77,90)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('部门经理审批','0','1','1','0',246,90)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('人事经理审批','0','1','1','0',411,90)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',576,90)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',82,87)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('部门经理审批','0','1','1','0',251,87)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('人事经理审批','0','1','1','0',421,87)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',587,87)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',76,94)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('部门经理审批','0','1','1','0',247,94)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('人事经理审批','0','1','1','0',418,94)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',584,94)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',75,77)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('部门经理审批','0','1','1','0',242,77)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('人事助理备案','0','0','0','1',410,77)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',88,82)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('部门经理审批','0','1','1','0',257,82)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('人事助理备案','0','0','0','1',422,82)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',75,95)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('经理审批','0','1','1','0',247,95)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('资产管理员处理','0','0','1','0',412,95)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',582,95)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',79,97)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('经理审批','0','1','1','0',242,97)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('总经理审批','0','1','1','0',405,97)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('资产管理员处理','0','0','1','0',571,97)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('申请人确认','0','0','1','0',571,214)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',406,214)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('系统触发','1','0','0','0',74,85)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('新闻审批','0','1','1','0',244,85)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',410,85)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写收文单','1','0','0','0',70,50)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('行政助理处理','0','0','1','0',240,50)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('查阅人查看','0','0','1','0',410,50)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',580,50)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写申请单','1','0','0','0',77,105)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('经理审批','0','1','1','0',246,105)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('行政经理审核','0','1','1','0',416,105)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('行政经理批阅','0','1','1','0',578,222)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('会签人会签','0','0','1','0',578,105)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('行政助理发文','0','0','1','0',418,222)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',247,222)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('填写合同','1','0','0','0',78,98)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('部门经理审批','0','1','1','0',251,98)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('总经理审批','0','1','1','0',415,98)
/
insert into workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos) values ('归档','0','0','0','1',581,98)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (1,2,'提醒',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (2,3,'执行',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (3,4,'所有人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (4,5,'创建人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (5,6,'执行人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (6,7,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (7,8,'所有人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (8,9,'讨论人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (9,10,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (10,11,'所有人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (11,12,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (12,13,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (13,14,'所有人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (14,16,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (15,15,'被留言人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (16,17,'所有人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (17,18,'部门经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (18,19,'总经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (19,20,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (20,21,'所有人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (21,22,'部门经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (22,23,'总经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (23,24,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (24,25,'创建人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (25,26,'总经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (26,27,'接受人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (27,28,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (28,29,'所有人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (29,30,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (30,31,'接收人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (31,32,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (32,33,'所有人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (33,34,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (34,35,'总经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (35,36,'财务经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (36,37,'出纳',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (37,38,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (38,39,'申请人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (39,40,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (40,41,'总经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (41,42,'出纳',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (42,43,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (43,44,'财务经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (44,45,'所有人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (45,46,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (46,47,'总经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (47,48,'出纳',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (48,49,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (49,50,'所有人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (50,51,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (51,52,'信息管理员',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (52,53,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (53,54,'所有人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (54,55,'信息经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (55,56,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (56,57,'创建人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (57,58,'信息管理员',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (58,59,'信息管理员',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (59,60,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (60,61,'所有人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (61,62,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (62,63,'行政助理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (63,64,'创建人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (64,65,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (65,66,'所有人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (66,67,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (67,68,'行政助理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (68,69,'创建人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (69,70,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (70,71,'所有人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (71,72,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (72,73,'行政经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (73,74,'行政助理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (74,75,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (75,76,'所有人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (76,77,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (77,78,'总经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (78,79,'公章管理员',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (79,80,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (80,81,'所有人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (81,82,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (82,83,'行政助理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (83,84,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (84,85,'所有人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (85,86,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (86,87,'行政经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (87,88,'行政助理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (88,89,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (89,90,'申请人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (90,91,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (91,92,'人事经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (92,93,'总经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (93,94,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (94,95,'申请人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (95,96,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (96,97,'人事经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (97,98,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (98,99,'申请人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (99,100,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (100,101,'人事经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (101,102,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (102,103,'申请人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (103,104,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (104,105,'人事经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (105,106,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (106,107,'申请人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (107,108,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (108,109,'人事经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (109,110,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (110,111,'申请人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (111,112,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (112,113,'人事经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (113,114,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (114,115,'申请人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (115,116,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (116,117,'备案',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (117,118,'申请人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (118,119,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (119,120,'人事助理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (120,121,'申请人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (121,122,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (122,123,'资产管理员',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (123,124,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (124,125,'申请人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (125,126,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (126,127,'总经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (127,128,'资产管理员',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (128,129,'创建人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (129,130,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (130,132,'审批人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (131,133,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (132,134,'申请人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (133,135,'行政助理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (134,136,'查阅人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (135,137,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (136,138,'申请人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (137,139,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (138,140,'行政经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (139,141,'行政经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (140,142,'会签',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (141,143,'发文',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (142,144,'归档',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (143,145,'申请人',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (144,146,'经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (145,147,'总经理',1)
/
insert into workflow_nodegroup (id,nodeid,groupname,canview) values (146,148,'归档',1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (1,1,' ','','提醒',2,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (1,2,' ','','执行',3,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (2,4,' ','','执行工作安排',6,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (2,5,' ','','完成',7,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (2,5,'1','','退回/申请延期',6,7,1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (2,6,' ','','创建人确认',5,15,9,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (4,11,' ','','提交经理批复',12,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (4,12,' ','','归档',13,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (5,14,' ','','提交留言',15,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (5,15,' ','','归档',16,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (6,17,' ','','提交经理审批',18,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (6,18,'1','','经理退回',17,11,13,201,24,100,24,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (6,18,' ','','经理批准',19,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (6,19,' ','','总经理退回',17,12,11,397,12,40,12,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (6,19,'1','','总经理批准',20,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (7,21,' ','','提交经理审批',22,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (7,22,' ','','经理审批通过',23,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (7,22,'1','','经理审批退回',21,12,13,231,22,99,22,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (7,23,' ','','总经理审批通过',24,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (7,23,'1','','总经理审批退回',21,12,11,401,15,39,15,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (8,25,' ','','提交审批',26,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (8,26,' ','','总经理批准',27,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (8,26,'1','','总经理退回',25,12,12,241,16,70,16,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (8,27,' ','','归档',28,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (9,29,' ','','提交审批',30,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (9,30,'1','','经理退回',29,12,12,232,19,71,19,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (9,30,' ','','经理批准',31,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (9,31,' ','','归档',32,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (11,39,' ','','提交经理审批',40,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (11,40,'1','','经理退回',39,12,13,243,31,109,31,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (11,40,' ','','经理批准',44,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (11,41,'1','','总经理退回',39,12,11,592,16,49,16,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (11,41,' ','','总经理批准',42,4,12,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (11,44,'1','','财务经理退回',39,12,12,415,23,79,23,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (11,44,' ',' (amount <1000 ) ','财务经理批准',41,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (11,44,' ',' (amount >=1000 ) ','财务经理批准',42,4,11,415,143,562,143,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (12,45,' ','','提交报销单',46,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (12,46,'1','','部门经理退回',45,12,13,232,25,103,25,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (12,46,' ','','部门经理批准',47,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (12,47,'1','','总经理退回',45,12,11,392,16,43,16,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (12,47,' ','','总经理批准',48,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (12,48,' ','','归档',49,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (13,50,' ','','提交申请单',51,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (13,51,'1','','经理退回',50,12,12,232,18,72,18,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (13,51,' ','','经理批准',52,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (13,52,' ','','归档',53,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (14,54,' ','','提交申请单',58,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (14,58,' ',' (amount >0 ) ','信息管理员处理',55,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (14,58,' ',' (amount <=0 ) ','信息管理员处理',57,4,12,245,153,417,153,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (14,55,'1','','信息经理退回',54,12,13,417,30,107,30,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (14,55,' ','','信息经理批准',56,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (14,56,'1','','经理退回',54,12,12,588,21,77,21,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (14,56,' ','','经理批准',59,4,12,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (14,59,' ','','信息管理员处理',57,8,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (14,57,' ','','归档',60,8,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (15,61,' ','','提交申请单',62,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (15,62,'1','','经理退回',61,12,12,253,18,76,18,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (15,62,' ','','经理批准',63,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (15,63,' ','','申请人确认',64,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (15,64,' ','','归档',65,4,12,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (16,66,' ','','提交申请单',67,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (16,67,'1','','经理退回',66,12,12,237,30,71,30,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (16,67,' ','','经理批准',68,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (16,68,' ','','行政助理处理',69,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (16,69,' ','','归档',70,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (17,71,' ','','提交申请单',72,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (17,72,'1','','经理退回',71,12,13,233,34,101,34,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (17,72,' ','','经理批准',73,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (17,73,'1','','行政经理退回',71,12,11,395,22,41,22,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (17,73,' ','','行政经理批准',74,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (17,74,' ','','归档',75,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (18,76,' ','','提交申请',77,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (18,77,'1','','经理退回',76,12,13,231,34,100,34,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (18,77,' ',' (gzlx =1 ) ','经理批准',78,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (18,77,' ',' (gzlx =0 ) ','经理批准',79,4,4,231,154,553,154,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (18,78,'1','','总经理退回',76,11,11,361,26,40,26,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (18,78,' ','','总经理批准',79,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (18,79,' ','','归档',80,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (19,81,' ','','提交申请单',82,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (19,82,'1','','经理退回',81,11,12,201,29,69,29,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (19,82,' ','','经理批准',83,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (19,83,' ','','归档',84,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (20,85,' ','','提交经理审批',86,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (20,86,'1','','经理退回',85,12,13,233,39,103,39,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (20,86,' ','','经理批准',87,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (20,87,'1','','行政经理退回',85,12,11,395,27,43,27,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (20,87,' ','','行政经理批准',88,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (20,88,' ','','归档',89,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (21,90,' ','','提交申请单',91,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (21,91,'1','','经理退回',90,12,13,241,33,107,33,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (21,91,' ','','经理批准',92,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (21,92,'1','','人事经理退回',90,12,12,402,25,173,25,77,25,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (21,92,' ','','人事经理批准',93,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (21,93,'1','','总经理退回',90,12,11,561,14,47,14,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (21,93,' ','','归档',94,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (22,95,' ','','提交经理审批',96,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (22,96,'1','','经理退回',95,12,13,241,33,103,33,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (22,96,' ','','经理批准',97,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (22,97,'1','','人事经理退回',95,12,11,410,24,43,24,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (22,97,' ','','人事经理批准',98,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (26,99,' ','','提交审批',100,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (26,100,'1','','经理退回',99,12,13,219,34,96,34,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (26,100,' ','','经理批准',101,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (26,101,'1','','人事经理退回',99,12,11,374,26,36,26,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (26,101,' ','','人事经理批准',102,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (23,103,' ','','提交审批',104,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (23,104,'1','','部门经理退回',103,12,13,246,33,107,33,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (23,104,' ','','部门经理批准',105,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (23,105,'1','','人事经理退回',103,12,11,411,20,47,20,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (23,105,' ','','人事经理批准',106,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (24,107,' ','','提交审批',108,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (24,108,'1','','经理退回',107,12,13,251,23,112,23,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (24,108,' ','','经理批准',109,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (24,109,'1','','人事经理退回',107,12,11,422,13,52,13,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (24,109,' ','','人事经理批准',110,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (25,111,' ','','提交申请',112,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (25,112,'1','','经理退回',111,12,13,247,32,106,32,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (25,112,' ','','经理批准',113,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (25,113,'1','','人事经理退回',111,12,11,418,19,46,19,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (25,113,' ','','人事经理批准',114,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (27,115,' ','','提交申请单',116,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (27,116,'1','','经理退回',115,12,12,242,19,75,19,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (27,116,' ','','备案',117,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (28,118,' ','','提交申请单',119,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (28,119,'1','','经理退回',118,12,12,257,19,88,19,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (28,119,' ','','经理批准',120,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (29,121,' ','','提交申请单',122,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (29,122,' ','','经理批准',123,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (29,122,'1','','经理退回',121,12,12,247,30,75,30,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (29,123,' ','','归档',124,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (30,125,' ','','提交申请单',126,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (30,126,'1','','经理退回',125,12,13,242,36,109,36,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (30,126,' ','','经理批准',127,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (30,127,'1','','总经理退回',125,12,11,405,27,49,27,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (30,127,' ','','总经理批准',128,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (30,128,' ','','申请人确认',129,4,12,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (30,129,' ','','归档',130,8,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (31,131,' ','','系统触发',132,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (31,132,'1','','退回',131,12,12,244,24,74,24,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (31,132,' ','','批准',133,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (32,134,' ','','提交申请',135,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (32,135,' ','','查阅人查看',136,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (32,136,' ','','归档',137,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (3,8,' ','','展开讨论',9,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (3,9,' ',' (isend=''1'' ) ','结束讨论',10,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (3,9,' ',' (isend<>''1'' ) ','继续讨论',9,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (33,138,' ','','提交申请单',139,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (33,139,'1','','经理退回',138,12,13,246,46,107,46,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (33,139,' ','','经理批准',140,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (33,140,'1','','行政经理退回',138,12,11,416,39,47,39,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (33,140,' ','','行政经理批准',142,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (33,142,' ','','会签完成',141,4,12,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (33,141,'1','','行政经理退回',138,11,4,548,162,77,162,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (33,141,' ','','行政经理批准',143,8,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (33,143,' ','','归档',144,8,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (34,145,' ','','提交审批',146,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (34,146,'1','','经理退回',145,12,13,251,39,108,39,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (34,146,' ','','经理批准',147,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (34,147,'1','','总经理退回',145,12,11,415,29,48,29,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (34,147,' ','','总经理批准',148,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (10,33,' ','','提交审批',34,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (10,34,'1','','经理退回',33,12,13,245,36,97,36,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (10,34,' ',' (amount <=0 ) ','经理批准',38,4,12,245,147,423,147,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (10,34,' ',' (amount >0 ) ','经理批准',35,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (10,35,'1','','总经理退回',33,12,12,424,27,67,27,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (10,35,' ','','总经理批准',36,0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (10,36,' ','','财务经理批准',37,4,12,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (10,36,'1','','财务经理退回',33,12,11,596,17,37,17,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (10,37,' ','','归档',38,8,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_nodelink (workflowid,nodeid,isreject,condition,linkname,destnodeid,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,nodepasstime) values (11,42,' ','','归档',43,8,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
/
insert into workflow_type (typename,typedesc,dsporder) values ('系统默认工作流','系统默认工作流',0)
/
insert into workflow_type (typename,typedesc,dsporder) values ('日常工作','日常工作',0)
/
insert into workflow_type (typename,typedesc,dsporder) values ('总结和计划','总结和计划',0)
/
insert into workflow_type (typename,typedesc,dsporder) values ('通知','通知',0)
/
insert into workflow_type (typename,typedesc,dsporder) values ('费用相关','费用相关',0)
/
insert into workflow_type (typename,typedesc,dsporder) values ('服务支持','服务支持',12)
/
insert into workflow_type (typename,typedesc,dsporder) values ('人事管理','人事管理',0)
/
insert into workflow_type (typename,typedesc,dsporder) values ('资产管理','资产管理',0)
/
insert into workflow_type (typename,typedesc,dsporder) values ('公文管理','公文管理',0)
/
insert into workflow_type (typename,typedesc,dsporder) values ('合同管理','合同管理',0)
/
insert into workflow_type (typename,typedesc,dsporder) values ('考勤相关','考勤相关',0)
/
insert into workflow_type (typename,typedesc,dsporder) values ('文档审批','文档审批',0)
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('系统提醒工作流','系统自动触发的提醒工作流程',1,'',14,'0',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('工作安排','工作安排',2,'',6,'1',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('讨论沟通','讨论沟通',2,'',38,'1',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('请示与批复','请示与批复',2,'',2,'0',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('留言','留言',2,'',3,'0',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('月工作总结与计划','月工作总结与计划',3,'',21,'1',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('周工作小结与计划','周工作小结与计划',3,'',17,'1',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('公司通知','公司通知',4,'',1,'0',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('部门通知','部门通知',4,'',1,'0',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('出差申请','出差申请',5,'',4,'0',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('借款申请','借款申请',5,'',13,'1',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('费用报销','费用报销',5,'',7,'1',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('电子邮箱申请','电子邮箱申请',6,'',29,'1',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('IT服务','IT服务',6,'',5,'0',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('机票申请','机票申请',6,'',6,'0',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('汽车火车票申请','汽车火车票申请',6,'',7,'0',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('礼品申请','礼品申请',6,'',8,'0',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('公章使用申请','公章使用申请',6,'',9,'0',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('名片印制','名片印制',6,'',30,'1',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('宾馆预定','宾馆预定',6,'',10,'0',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('用工需求','用工需求',7,'',47,'1',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('奖惩申请','奖惩申请',7,'',39,'1',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('职位调整','职位调整',7,'',40,'1',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('离职申请','离职申请',7,'',41,'1',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('转正申请','转正申请',7,'',42,'1',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('培训申请','培训申请',7,'',48,'1',0,0,' ',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('加班申请','加班申请',11,'',45,'1',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('请假','请假',11,'',46,'1',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('设备维修申请','设备维修申请',8,'',11,'0',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('资产需求','资产需求',8,'',13,'0',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('新闻审批','新闻文档审批',12,'',28,'1',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('公司收文','公司收文',9,'',12,'0',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('公司发文','公司发文',9,'',12,'0',0,0,'1',' ')
/
insert into workflow_base (workflowname,workflowdesc,workflowtype,securelevel,formid,isbill,iscust,helpdocid,isvalid,needmark) values ('业务合同审批','业务合同审批',10,'',49,'1',0,0,'1',' ')
/

update hrmresource set status = 1 , managerstr = '1,' where id=1
/
update hrmresource set status = 1 , managerstr = '1,' where id=2
/
update hrmresource set locationid =1 
/
update hrmresource set seclevel=seclevel+1
/

insert into HtmlLabelIndex (id,indexdesc) values (6141	,'申请部门')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6141,'申请部门',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6141,'',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6146	,'合同金额')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6146,'合同金额',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6146,'',8)
/


alter table workflow_form modify( document varchar2(200) )
/

alter table workflow_form modify( relateddocument varchar2(200) )
/

update workflow_formdict set fielddbtype='varchar2(200)', type =37 where fieldname = 'document' 
/

update workflow_formdict set fielddbtype='varchar2(200)', type =37 where fieldname = 'relateddocument' 
/

update workflow_bill set createpage='', managepage='',viewpage='' where id = 13
/

insert into HtmlLabelIndex (id,indexdesc) values (6117,'考核项目')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6117,'考核项目',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6117,'',8)
/


insert into HtmlLabelIndex (id,indexdesc) values (6118,'考核种类')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6118,'考核种类',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6118,'',8)
/

create or replace trigger bill_HrmFinance_Trigger     
before insert on bill_HrmFinance                        
for each row                                               
begin                                                      
select bill_HrmFinance_id.nextval INTO :new.id from dual;
select 0 INTO :new.resourceid from dual;
end;                                                       
/ 