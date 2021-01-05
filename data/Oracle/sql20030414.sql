/*改动说明：contactinfo text,*/
CREATE or REPLACE PROCEDURE CRM_ContactLog_Update 
(id_1 	integer,
contacterid_1 	integer, 
resourceid_1 	integer,
agentid_1 	integer, 
contactway_1 	integer,
ispassive_1 	smallint,
subject_1 	varchar2, 
contacttype_1 	integer,
contactdate_1 	varchar2,
contacttime_1 	varchar2,
enddate_1 	varchar2,
endtime_1 	varchar2, 
contactinfo_1 varchar2, 
documentid_1 	integer, 
isfinished_1 smallint, 
 flag out integer  , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 ) 
AS 
begin
UPDATE CRM_ContactLog  
SET  
contacterid	 = contacterid_1,
resourceid	 = resourceid_1,
agentid	 = agentid_1,
contactway	 = contactway_1,
ispassive	 = ispassive_1,
subject	 = subject_1,
contacttype	 = contacttype_1,
contactdate	 = contactdate_1,
contacttime	 = contacttime_1,
enddate	 = enddate_1,
endtime	 = endtime_1,
contactinfo	 = contactinfo_1,
documentid	 = documentid_1, 
isfinished	 = isfinished_1  
WHERE ( id	 = id_1); 
end;
/


alter table CRM_Contract modify(docId varchar2(100))
/


CREATE or REPLACE PROCEDURE CRM_Contract_Insert 
	(name_1  varchar2   ,
	 typeId_1  integer  ,	
	 docId_1  varchar2   ,
	 price_1  number  ,
	 crmId_1  integer  ,
	 contacterId_1  integer  ,
	 startDate_1  char   ,
	 endDate_1  char  ,
	 manager_1  integer  ,
	 status_1  integer  ,
	 isRemind_1  integer  ,
	 remindDay_1  integer  ,
	 creater_1  integer  ,
	 createDate_1  char    ,
	 createTime_1  char  ,
	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
 ) 
AS 
begin
INSERT INTO CRM_Contract 
	 (name , 
	 typeId , 
	 docId , price , crmId ,
	 contacterId , startDate , 
	 endDate , manager , status , 
	 isRemind , remindDay , creater , createDate , createTime)  
VALUES 
	( name_1,
	 typeId_1,
	 docId_1, price_1 , crmId_1 ,
	 contacterId_1 , startDate_1 , 
	 endDate_1 , manager_1 , status_1 ,
	 isRemind_1 , remindDay_1 , 
	 creater_1 , createDate_1 , createTime_1);
open thecursor for
select  * from(select * from CRM_Contract order by id desc ) WHERE rownum =1;
end;
/


CREATE or REPLACE PROCEDURE CRM_Contract_Update 
	(id_1 	integer ,
	 name_1  varchar2   ,
	 typeId_1  integer  ,	
	 docId_1  varchar2   ,
	 price_1  number  ,
	 crmId_1  integer  ,
	 contacterId_1  integer  ,
	 startDate_1  char    ,
	 endDate_1  char    ,
	 manager_1  integer  ,
	 status_1  integer  ,
	 isRemind_1  integer  ,
	 remindDay_1  integer  ,
	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
 ) 

AS
begin
UPDATE CRM_Contract 
SET name = name_1, typeId = typeId_1 , docId = docId_1 , 
price = price_1 , crmId = crmId_1 , contacterId = contacterId_1 , startDate = startDate_1 ,
endDate = endDate_1 , manager = manager_1 , status = status_1 , isRemind = isRemind_1 ,
remindDay = remindDay_1  where id = id_1;
end;
/



CREATE or REPLACE PROCEDURE CptCapital_Duplicate 
	(capitalid_1 	integer,
	flag out integer  , 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
 ) 
 AS 
maxid integer;
begin
INSERT INTO CptCapital 
(mark,
name,
barcode,
startdate,
enddate,
seclevel,
departmentid,
costcenterid,
resourceid,
crmid,
sptcount,
currencyid ,
capitalcost,
startprice,
depreendprice,
capitalspec,
capitallevel,
manufacturer,
manudate,
capitaltypeid,
capitalgroupid,
unitid,
capitalnum,
currentnum,
replacecapitalid,
version,
itemid,
remark,
capitalimageid,
depremethod1,
depremethod2,
deprestartdate,
depreenddate,
customerid,
attribute,
stateid,
location,
usedhours,
datefield1,
datefield2,
datefield3,
datefield4,
datefield5,
numberfield1,
numberfield2,
numberfield3,
numberfield4,
numberfield5,
textfield1,
textfield2,
textfield3,
textfield4,
textfield5,
tinyintfield1,
tinyintfield2,
tinyintfield3,
tinyintfield4,
tinyintfield5,
createrid,
createdate,
createtime,
lastmoderid,
lastmoddate,
lastmodtime,
isdata,
datatype,
relatewfid)
select 
mark,
name,
barcode,
startdate,
enddate	,
seclevel,
departmentid,
costcenterid,
resourceid,
crmid,
sptcount,
currencyid ,
capitalcost,
startprice,
depreendprice,
capitalspec,
capitallevel,
manufacturer,
manudate,
capitaltypeid,
capitalgroupid,
unitid,
capitalnum,
currentnum,
replacecapitalid,
version,
itemid,
remark,
capitalimageid,
depremethod1,
depremethod2,
deprestartdate,
depreenddate,
customerid,
attribute,
stateid,
location,
usedhours,
datefield1,
datefield2,
datefield3,
datefield4,
datefield5,
numberfield1,
numberfield2,
numberfield3,
numberfield4,
numberfield5,
textfield1,
textfield2,
textfield3,
textfield4,
textfield5,
tinyintfield1,
tinyintfield2,
tinyintfield3,
tinyintfield4,
tinyintfield5,
createrid,
createdate,
createtime,
lastmoderid,
lastmoddate,
lastmodtime,
isdata,
datatype,
relatewfid
 from CptCapital
where id = capitalid_1;
select  max(id) INTO maxid  from CptCapital;
update CptCapital set capitalnum = 0 where id = maxid;
open thecursor for
select maxid from dual;
end;
/




CREATE TABLE Exchange_Info (
	id integer NOT NULL ,
	sortid integer NULL ,
	name varchar2(200)  NULL ,
	remark varchar2(4000)  NULL ,
	creater integer NULL ,
	createDate char (10)  NULL ,
	createTime char (10)  NULL,
	type_n  char(2) null,
	docids varchar2(600) null
)
/
create sequence Exchange_Info_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Exchange_Info_Trigger
before insert on Exchange_Info
for each row
begin
select Exchange_Info_id.nextval INTO :new.id from dual;
end;
/


/***
*销售机会相关交流 type_n=CS 
*客户相关交流    type_n=CC
*客户联系相关交流 type_n=CT
*合同的相关交流	type_n=CH
*项目的相关交流   type_n=PP
*任务的相关交流	type_n=PT
*
*
*/

CREATE or REPLACE PROCEDURE ExchangeInfo_Insert 
	(sortid_1 integer  ,
	 name_1  varchar2   ,
	 remark_1 varchar2  ,
	 creater_1  integer  ,
	 createDate_1  char   ,
	 createTime_1  char  ,
	 type_n_1 char,
	 docids_1 varchar2,
	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
 ) 
AS 
begin
INSERT INTO Exchange_Info 
	 (sortid ,
	 name , 
	 remark , 
	 creater , createDate , createTime,type_n,docids) 
 
VALUES 
	(sortid_1 ,
	 name_1,
	 remark_1,
	 creater_1 , createDate_1 , createTime_1,type_n_1,docids_1);
end;
/


CREATE or REPLACE PROCEDURE ExchangeInfo_SelectBID
	(sortid_1 integer ,
	 type_n_1 char,
	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
 )

AS
begin
open thecursor for
SELECT * FROM Exchange_Info where sortid = sortid_1 AND type_n=type_n_1 order by id desc;
end;
/


/*成功、失败关键因数*/
CREATE TABLE CRM_Successfactor (
	id integer  NOT NULL ,
	fullname varchar2 (50)  NULL ,
	description varchar2 (150)  NULL 
)
/
create sequence CRM_Successfactor_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_Successfactor_Trigger
before insert on CRM_Successfactor
for each row
begin
select CRM_Successfactor_id.nextval INTO :new.id from dual;
end;
/


 CREATE or REPLACE PROCEDURE CRM_Successfactor_SelectAll 
 (	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
 )
 AS
 begin
 open thecursor for
 SELECT * FROM CRM_Successfactor;
end;
/

 CREATE or REPLACE PROCEDURE CRM_Successfactor_Insert 
 (fullname_1 	varchar2, 
 description_1 	varchar2, 
 flag out integer  , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 )
 AS 
 begin
 INSERT INTO 
 CRM_Successfactor 
 ( fullname, description) 
 VALUES ( fullname_1, description_1) ;
end;
/



 CREATE or REPLACE PROCEDURE CRM_Successfactor_SelectByID 
 (
	id_1 	integer, 
	flag out integer  , 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
 ) 
 AS 
 begin
 open thecursor for
 SELECT * FROM CRM_Successfactor
 WHERE ( id	 = id_1) ; 
end;
/



 CREATE or REPLACE PROCEDURE CRM_Successfactor_Update 
 (id_1	 	integer, 
 fullname_1 	varchar2,
 description_1 	varchar2,  
 flag out integer  , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 )
AS 
begin
UPDATE CRM_Successfactor  
SET  fullname	 = fullname_1,
description	 = description_1
WHERE ( id	 = id_1)   ;
end;
/





CREATE or REPLACE PROCEDURE CRM_Successfactor_Delete 
(id_1 	integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
AS
begin
DELETE CRM_Successfactor  WHERE ( id	 = id_1); 
end;
/

/*====*/

CREATE TABLE CRM_Failfactor (
	id integer NOT NULL ,
	fullname varchar2 (50)  NULL ,
	description varchar2 (150)  NULL 
)
/
create sequence CRM_Failfactor_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_Failfactor_Trigger
before insert on CRM_Failfactor
for each row
begin
select CRM_Failfactor_id.nextval INTO :new.id from dual;
end;
/



 CREATE or REPLACE PROCEDURE CRM_Failfactor_SelectAll 
 (	 flag out integer  , 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
 )
 AS
 begin
 open thecursor for
 SELECT * FROM CRM_Failfactor;
end;
/



 CREATE or REPLACE PROCEDURE CRM_Failfactor_Insert 
 (fullname_1 	varchar2, 
 description_1 	varchar2, 
 flag out integer  , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 ) 
 AS 
 begin
 INSERT INTO 
 CRM_Failfactor 
 ( fullname, description) 
 VALUES ( fullname_1, description_1) ;
end;
/



 CREATE or REPLACE PROCEDURE CRM_Failfactor_SelectByID 
 (id_1 	integer, 
 flag out integer  , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 ) 
 AS 
 begin
 open thecursor for
 SELECT * FROM CRM_Failfactor
 WHERE ( id	 = id_1);  
end;
/

 CREATE or REPLACE PROCEDURE CRM_Failfactor_Update 
 (id_1	 	integer, 
 fullname_1 	varchar2,
 description_1 	varchar2,  
 flag out integer  , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 )
AS 
begin
UPDATE CRM_Failfactor  
SET  fullname	 = fullname_1,
description	 = description_1
WHERE ( id	 = id_1);   
end;
/




CREATE or REPLACE PROCEDURE CRM_Failfactor_Delete 
(id_1 	integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
DELETE CRM_Failfactor  WHERE ( id	 = id_1); 
end;
/
 /*成功、失败关键因数==end*/


 insert into HtmlLabelInfo (indexid,labelname,languageid) values (2228,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2228,'项目状态：正常',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2228,'项目状态：正常')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2229,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2229,'项目状态：延期',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2229,'项目状态：延期')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2230,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2230,'项目状态：完成',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2230,'项目状态：完成')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2231,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2231,'项目状态：冻结',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2231,'项目状态：冻结')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2232,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2232,'里程碑任务',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2232,'里程碑任务')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2233,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2233,'前置任务',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2233,'前置任务')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2234,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2234,'进度审批状态',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2234,'进度审批状态')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2235,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2235,'未批准',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2235,'未批准')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2236,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2236,'已经审批',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2236,'已经审批')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2237,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2237,'进度图表',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2237,'进度图表')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2238,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2238,'工作流/文档',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2238,'工作流/文档')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2239,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2239,'监控类型',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2239,'监控类型')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2240,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2240,'任务说明',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2240,'任务说明')
/


insert into HtmlLabelInfo (indexid,labelname,languageid) values (2241,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2241,'全部选中',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2241,'全部选中')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2242,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2242,'待审批',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2242,'待审批')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2243,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2243,'立项批准',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2243,'立项批准')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2244,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2244,'延期',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2244,'延期')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2245,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2245,'无效',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2245,'无效') 
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2246,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2246,'有效',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2246,'有效')
/


insert into HtmlLabelInfo (indexid,labelname,languageid) values (2247,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2247,'销售预期',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2247,'销售预期')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2248,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2248,'预期收益',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2248,'预期收益')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2249,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2249,'可能性',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2249,'可能性')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2250,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2250,'销售状态',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2250,'销售状态')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2251,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2251,'查看：相关交流',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2251,'查看：相关交流')
/

alter table HrmStatusHistory add 
  isdispose integer default(0)
/

create table HrmTrainResource 
(id integer  not null,
 name varchar2(60) null,
 type_n integer null,
 /*1、外部；0、内部 */
 fare varchar2(200) null,
 time varchar2(200) null,
 memo varchar2(4000) null)
/
create sequence HrmTrainResource_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmTrainResource_Trigger
before insert on HrmTrainResource
for each row
begin
select HrmTrainResource_id.nextval INTO :new.id from dual;
end;
/


create table HrmTrainDay
(id integer  not null,
 trainid integer null,
 traindate char(10) null,
 daytraincontent varchar2(4000) null,
 daytrainaim  varchar2(4000) null,
 daytraineffect  varchar2(4000) null,
 daytrainplain  varchar2(4000) null)
/
create sequence HrmTrainDay_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmTrainDay_Trigger
before insert on HrmTrainDay
for each row
begin
select HrmTrainDay_id.nextval INTO :new.id from dual;
end;
/


create table HrmTrainActor
(id integer  not null,
 resourceid integer null,
 traindayid integer null,
 isattend integer default(0)
 /*1、参加；0、未参加*/)
/
create sequence HrmTrainActor_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmTrainActor_Trigger
before insert on HrmTrainActor
for each row
begin
select HrmTrainActor_id.nextval INTO :new.id from dual;
end;
/

create table HrmTrainTest
(id integer not null,
 trainid integer null,
 resourceid integer null,
 testdate char(10) null,
 result integer null,
 /*0、不及格；1、及格；2、良好；3、优秀*/
 explain varchar2(4000) null,
 testerid integer null)
/
create sequence HrmTrainTest_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmTrainTest_Trigger
before insert on HrmTrainTest
for each row
begin
select HrmTrainTest_id.nextval INTO :new.id from dual;
end;
/

create table HrmTrainAssess
(id integer not null,
 trainid integer null,
 resourceid integer null,
 assessdate char(10) null,
 implement integer null,
 /*0、极差；1、差；2、一般；3、好；4、很好*/
 explain varchar2(4000) null)
/
create sequence HrmTrainAssess_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmTrainAssess_Trigger
before insert on HrmTrainAssess
for each row
begin
select HrmTrainAssess_id.nextval INTO :new.id from dual;
end;
/


create table HrmTrainPlanRange
(id integer  not null,
 planid integer null,
 type_n integer null,
 /*0、所有人；1、部门；2、职务；3、岗位；4、人力资源*/
 resourceid int)
/
create sequence HrmTrainPlanRange_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmTrainPlanRange_Trigger
before insert on HrmTrainPlanRange
for each row
begin
select HrmTrainPlanRange_id.nextval INTO :new.id from dual;
end;
/


create table HrmUseDemand
(id integer  not null,
 demandjobtitle integer null,
 demandnum integer null,
 demandkind integer null,
 leastedulevel integer null,
 demandregdate char(10) null,
 otherrequest varchar2(4000) null,
 refermandid integer null,
 referdate char(10) null,
 status integer default(0),
 /*0：尚未满足；1：正在招聘；2：已经满足；3：无用;4:失效*/
 createkind int default(0)
 /*0：工作流；1：页面维护*/)
/
create sequence HrmUseDemand_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmUseDemand_Trigger
before insert on HrmUseDemand
for each row
begin
select HrmUseDemand_id.nextval INTO :new.id from dual;
end;
/


create table HrmCareerPlan
(id integer not null,
topic varchar2(200) null,
principalid integer null,
informmanid integer null,
emailmould integer null,
startdate char(10) null,
budget float null,
budgettype integer null,
memo varchar2(4000) null,
enddate char(10) null,
fare float null,
faretype integer null,
advice varchar2(4000) null)
/
create sequence HrmCareerPlan_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmCareerPlan_Trigger
before insert on HrmCareerPlan
for each row
begin
select HrmCareerPlan_id.nextval INTO :new.id from dual;
end;
/

create table HrmCareerPlanStep
(id integer  not null,
 planid integer null,
 stepname varchar2(200) null,
 stepstartdate char(10) null,
 stependdate char(10) null)
/
create sequence HrmCareerPlanStep_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmCareerPlanStep_Trigger
before insert on HrmCareerPlanStep
for each row
begin
select HrmCareerPlanStep_id.nextval INTO :new.id from dual;
end;
/

CREATE or REPLACE PROCEDURE HrmResource_DepUpdate
(id_1 integer,
 departmentid_2 integer,
 joblevel_3 integer,
 costcenterid_4 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
update HrmResource set
  departmentid = departmentid_2,
  joblevel = joblevel_3,
  costcenterid = costcenterid_4
where
  id = id_1;
end;
/


CREATE or REPLACE PROCEDURE HrmTrainType_Insert
(name_2 varchar2,
 description_3 varchar2,
 typecontent_4 varchar2 ,
 typeaim_5 varchar2 ,
 typedocurl_6 varchar2 ,
 typetesturl_7 varchar2 ,
 typeoperator_8 varchar2 ,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT into HrmTrainType
( name,
  description ,
  typecontent ,
  typeaim ,
  typedocurl ,
  typetesturl,
  typeoperator)
VALUES
( name_2,
  description_3,
  typecontent_4,
  typeaim_5,
  typedocurl_6,
  typetesturl_7,
  typeoperator_8);
end;
/

CREATE or REPLACE PROCEDURE HrmTrainLayout_Insert
(layoutname_1 varchar2,
 typeid_2 integer,
 layoutstartdate_3 char,
 layoutenddate_4 char,
 layoutcontent_5 varchar2,
 layoutaim_6 varchar2,
 layouttestdate_7 char,
 layoutassessor_8 varchar2,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
insert into HrmTrainLayout
 (layoutname ,
 typeid ,
 layoutstartdate ,
 layoutenddate,
 layoutcontent,
 layoutaim,
 layouttestdate,
 layoutassessor
)
values
(layoutname_1 ,
 typeid_2 ,
 layoutstartdate_3 ,
 layoutenddate_4 ,
 layoutcontent_5 ,
 layoutaim_6 ,
 layouttestdate_7 ,
 layoutassessor_8 
 );
end;
/

CREATE or REPLACE PROCEDURE TrainLayoutAssess_Insert
(layoutid_1 integer,
 assessorid_2 integer,
 assessdate_3 char,
 implement_4 char,
 explain_5 varchar2,
 advice_6 varchar2,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as
begin
insert into HrmTrainLayoutAssess
(layoutid,
 assessorid,
 assessdate,
 implement,
 explain,
 advice)
values
(layoutid_1,
 assessorid_2,
 assessdate_3,
 implement_4,
 explain_5,
 advice_6);
end;
/


CREATE or REPLACE PROCEDURE HrmTrainPlan_Insert
(planname_1 varchar2,
 layoutid_2 integer,
 planorganizer_3 varchar2,
 planstartdate_4 char,
 planenddate_5 char,
 plancontent_6 varchar2,
 planaim_7 varchar2,
 planaddress_8 varchar2,
 planresource_9 varchar2,
 planactor_10 varchar2,
 planbudget_11 float,
 planbudgettype_12 char,
 openrange_13 varchar2,
 createrid_14 integer,
 createdate_15 char,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as
begin
insert into HrmTrainPlan 
 (planname,
 layoutid ,
 planorganizer,
 planstartdate,
 planenddate,
 plancontent,
 planaim,
 planaddress,
 planresource,
 planactor,
 planbudget,
 planbudgettype,
 openrange,
 createrid,
 createdate)
values
(planname_1,
 layoutid_2,
 planorganizer_3,
 planstartdate_4,
 planenddate_5,
 plancontent_6,
 planaim_7,
 planaddress_8,
 planresource_9,
 planactor_10,
 planbudget_11,
 planbudgettype_12,
 openrange_13,
 createrid_14,
 createdate_15);
end;
/


CREATE or REPLACE PROCEDURE HrmTrainRes_Insert
(name_1 varchar2 ,
 type_2 integer,
 fare_3 varchar2,
 time_4 varchar2,
 memo_5 varchar2,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as
begin
insert into HrmTrainResource 
(name,
 type_n,
 fare,
 time,
 memo)
values
(name_1,
 type_2,
 fare_3,
 time_4,
 memo_5);
end;
/


CREATE or REPLACE PROCEDURE HrmTrainRes_Update
(name_1 varchar2 ,
 type_2 integer,
 fare_3 varchar2,
 time_4 varchar2,
 memo_5 varchar2,
 id_6 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
update HrmTrainResource set
name = name_1,
 type_n = type_2,
 fare = fare_3,
 time = time_4,
 memo = memo_5
 where 
 id = id_6;
end;
/


CREATE or REPLACE PROCEDURE HrmTrainRes_Delete
(id_1 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
delete HrmTrainResource 
where 
 id = id_1;
end;
/


CREATE or REPLACE PROCEDURE HrmTrain_Insert
(name_1 varchar2,
 planid_2 integer,
 organizer_3 varchar2,
 startdate_4 char,
 enddate_5 char,
 content_6 varchar2,
 aim_7 varchar2,
 address_8 varchar2,
 resource_n_9 varchar2, 
 createrid_10 integer,
 testdate_11 char,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
insert into HrmTrain
(name,
 planid,
 organizer,
 startdate,
 enddate,
 content,
 aim,
 address,
 resource_n, 
 createrid,
 testdate)
values
(name_1,
 planid_2,
 organizer_3,
 startdate_4,
 enddate_5,
 content_6,
 aim_7,
 address_8,
 resource_n_9, 
 createrid_10,
 testdate_11);
 open thecursor for
 select max(id) from HrmTrainDay;
end;
/


CREATE or REPLACE PROCEDURE HrmTrain_Update
(name_1 varchar2,
 planid_2 integer,
 organizer_3 varchar2,
 startdate_4 char,
 enddate_5 char,
 content_6 varchar2,
 aim_7 varchar2,
 address_8 varchar2,
 resource_n_9 varchar2, 
 testdate_10 char,
 id_11 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
update HrmTrain set
 name      = name_1,
 planid    = planid_2,
 organizer = organizer_3,
 startdate = startdate_4,
 enddate   = enddate_5,
 content   = content_6,
 aim       = aim_7,
 address   = address_8,
 resource_n= resource_n_9, 
 testdate  = testdate_10
where
 id = id_11;
end;
/


CREATE or REPLACE PROCEDURE HrmTrain_Delete
(id_1 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
delete HrmTrain 
where
 id = id_1;
end;
/


CREATE or REPLACE PROCEDURE HrmTrainDay_Insert
(trainid_1 integer,
 day_2 char,
 content_3 varchar2,
 aim_4 varchar2,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as
begin
insert into HrmTrainDay
(trainid,
 traindate,
 daytraincontent,
 daytrainaim)
values
(trainid_1,
 day_2,
 content_3,
 aim_4);
 open thecursor for
select max(id) from HrmTrainDay;
end;
/


CREATE or REPLACE PROCEDURE HrmTrainActor_Insert
(traindayid_1 integer,
 resourceid_2 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
insert into HrmTrainActor
(traindayid,
 resourceid)
values
(traindayid_1,
 resourceid_2);
end;
/


CREATE or REPLACE PROCEDURE HrmTrainDay_Update
(day_1 char,
 content_2 varchar2,
 aim_3 varchar2,
 effect_4 varchar2,
 plain_5 varchar2,
 id_6 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as
begin
update HrmTrainDay set
 traindate = day_1,
 daytraincontent =content_2 ,
 daytrainaim = aim_3,
 daytraineffect = effect_4,
 daytrainplain = plain_5
where
 id = id_6;
end;
/

CREATE or REPLACE PROCEDURE HrmTrainActor_Update
(traindayid_1 integer,
 resourceid_2 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as
begin
update HrmTrainActor 
set
 isattend = 1
where
 traindayid = traindayid_1 and resourceid = resourceid_2;
end;
/


CREATE or REPLACE PROCEDURE HrmTrainActor_UpdateReset
(traindayid_1 integer, 
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
update HrmTrainActor 
set
 isattend = 0
where
 traindayid = traindayid_1;
end;
/


CREATE or REPLACE PROCEDURE HrmTrainDay_Delete
(id_1 integer, 
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as
begin
delete HrmTrainDay 
where
 id = id_1;
delete HrmTrainActor
where
 traindayid = id_1;
end;
/


CREATE or REPLACE PROCEDURE HrmTrainTest_Insert
(trainid_1 integer,
 resourceid_2 integer,
 testdate_3 char,
 result_4 integer,
 explain_5 varchar2,
 testerid_6 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as
begin
insert into HrmTrainTest
(trainid,
 resourceid,
 testdate,
 result,
 explain,
 testerid)
values
(trainid_1 ,
 resourceid_2,
 testdate_3,
 result_4 ,
 explain_5,
 testerid_6);
end;
/


CREATE or REPLACE PROCEDURE HrmTrainAssess_Insert
(trainid_1 integer,
 resourceid_2 integer,
 testdate_3 char,
 result_4 integer,
 explain_5 varchar2, 
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
insert into HrmTrainAssess
(trainid,
 resourceid,
 assessdate,
 implement,
 explain)
values
(trainid_1 ,
 resourceid_2,
 testdate_3,
 result_4 ,
 explain_5);
end;
/


CREATE or REPLACE PROCEDURE HrmTrainAssess_Update
(trainid_1 integer,
 resourceid_2 integer,
 testdate_3 char,
 result_4 integer,
 explain_5 varchar2,
 id_6 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as
begin
update HrmTrainAssess set
 trainid    = trainid_1,
 resourceid = resourceid_2,
 assessdate = testdate_3,
 implement  = result_4,
 explain    = explain_5
where
 id = id_6;
end;
/


CREATE or REPLACE PROCEDURE HrmTrain_Finish
(id_1 integer,
 summarizer_2 integer,
 summarizedate_3 char,
 fare_4 float,
 faretype_5 integer,
 advice_6 varchar2,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
update HrmTrain set
 summarizer = summarizer_2,
 summarizedate = summarizedate_3,
 fare = fare_4,
 faretype = faretype_5,
 advice = advice_6
where
 id = id_1;
end;
/


CREATE or REPLACE PROCEDURE HrmTrainPlanRange_Insert
(planid_1 integer,
 type_2 integer,
 resourceid_3 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
insert into HrmTrainPlanRange
(planid,
 type_n,
 resourceid)
values
(planid_1,
 type_2,
 resourceid_3);
update HrmTrainPlan set openrange = 1 
where 
 id = planid_1;
end;
/


CREATE or REPLACE PROCEDURE HrmTrainPlanRange_Delete
(id_1 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
delete from HrmTrainPlanRange
where 
 id = id_1;
end;
/


insert into SystemRights (id, rightdesc,righttype) 
  values (370,'培训规划维护',3) 
/
insert into SystemRightRoles(rightid,roleid,rolelevel)
  values(370,4,1)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3000,'培训规划添加','HrmTrainLayoutAdd:Add',370)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3001,'培训规划编辑','HrmTrainLayoutEdit:Edit',370)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3002,'培训规划删除','HrmTrainLayoutDelete:Delete',370)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3003,'培训规划日志','HrmTrainLayout:Log',370)
/

insert into SystemRights (id, rightdesc,righttype) 
  values (371,'培训安排维护',3) 
/
insert into SystemRightRoles(rightid,roleid,rolelevel)
  values(371,4,1)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3004,'培训安排添加','HrmTrainPlanAdd:Add',371)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3005,'培训安排编辑','HrmTrainPlanEdit:Edit',371)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3006,'培训安排删除','HrmTrainPlanDelete:Delete',371)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3007,'培训安排日志','HrmTrainPlan:Log',371)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3018,'培训安排查看','HrmTrainPlan:View',371)
/

insert into SystemRights (id, rightdesc,righttype) 
  values (372,'培训资源维护',3) 
/
insert into SystemRightRoles(rightid,roleid,rolelevel)
  values(372,4,1)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3008,'培训资源添加','HrmTrainResourceAdd:Add',372)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3009,'培训资源编辑','HrmTrainResourceEdit:Edit',372)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3010,'培训资源删除','HrmTrainResourceDelete:Delete',372)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3011,'培训资源日志','HrmTrainResource:Log',372)
/

insert into SystemRights (id, rightdesc,righttype) 
  values (373,'培训活动维护',3) 
/
insert into SystemRightRoles(rightid,roleid,rolelevel)
  values(373,4,1)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3013,'培训活动添加','HrmTrainAdd:Add',373)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3014,'培训活动编辑','HrmTrainEdit:Edit',373)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3015,'培训活动删除','HrmTrainDelete:Delete',373)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3016,'培训活动日志','HrmTrain:Log',373)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3017,'培训活动查看','HrmTrain:View',373)
/

insert into HtmlLabelIndex (id,indexdesc) values (6101,'规划')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6101,'规划',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6101,'Layout',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6102,'考评')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6102,'考评',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6102,'Assess',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6103,'安排')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6103,'安排',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6103,'Plan',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6104,'公开范围')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6104,'公开范围',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6104,'OpenRange',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6105,'资源')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6105,'资源',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6105,'Resource',8)
/

insert into HtmlLabelIndex (id,indexdesc) values (6106,'考核')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6106,'考核',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6106,'Test',8)
/

CREATE or REPLACE PROCEDURE HrmUseDemand_Update
(jobtitle_1 integer,
 status_2 integer,
 demandnum_3 integer,
 demandkind_4 integer,
 leaseedulevel_5 integer,
 date_6 char,
 otherrequest_7 varchar2,
 id_8 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
update HrmUseDemand set
 demandjobtitle = jobtitle_1,
 status = status_2,
 demandnum = demandnum_3,
 demandkind = demandkind_4,
 leastedulevel = leaseedulevel_5,
 demandregdate = date_6,
 otherrequest = otherrequest_7
where
 id = id_8;
end;
/


CREATE or REPLACE PROCEDURE HrmUseDemand_Insert
	(demandjobtitle_1 	integer,
	 demandnum_2 	integer,
	 demandkind_3 	integer,
	 leastedulevel_4 	integer,
	 demandregdate_5 	char,
	 otherrequest_6 	varchar2,
	 refermandid_7 	integer,
	 referdate_8 	char,
	 createkind_9 	integer,
	flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
AS
begin
INSERT INTO HrmUseDemand
	 (demandjobtitle,
	 demandnum,
	 demandkind,
	 leastedulevel,
	 demandregdate,
	 otherrequest,
	 refermandid,
	 referdate,
	 createkind) 
VALUES 
	(demandjobtitle_1,
	 demandnum_2,
	 demandkind_3,
	 leastedulevel_4,
	 demandregdate_5,
	 otherrequest_6,
	 refermandid_7,
	 referdate_8,
	 createkind_9);
end;
/


CREATE or REPLACE PROCEDURE HrmUseDemand_Delete
(id_1 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
delete HrmUseDemand 
where
 id = id_1;
end;
/


CREATE or REPLACE PROCEDURE HrmUseDemand_Close
(id_1 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
update HrmUseDemand set
  status = 4
where
 id = id_1;
end;
/



CREATE or REPLACE PROCEDURE HrmCareerPlan_Update
	(id_1 	integer,
	 topic_2 	varchar2,
	 principalid_3 	integer,
	 informmanid_4 	integer,
	 emailmould_5 	integer,
	 startdate_6 	char,
	 budget_7 	float,
	 budgettype_8 	integer,
	 memo_9 	varchar,
	flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 

AS 
begin
UPDATE HrmCareerPlan 

SET      topic	 = topic_2,
	 principalid	 = principalid_3,
	 informmanid	 = informmanid_4,
	 emailmould	 = emailmould_5,
	 startdate	 = startdate_6,
	 budget	 = budget_7,
	 budgettype	 = budgettype_8,
	 memo	 = memo_9 

WHERE 
	( id	 = id_1);
end;
/



CREATE or REPLACE PROCEDURE HrmCareerPlan_Insert
	(topic_1 	varchar2,
	 principalid_2 	integer,
	 informmanid_3 	integer,
	 emailmould_4 	integer,
	 startdate_5 	char,
	 budget_6 	float,
	 budgettype_7 	integer,
	 memo_8 	varchar2,
	flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
INSERT INTO HrmCareerPlan 
	 ( topic,
	 principalid,
	 informmanid,
	 emailmould,
	 startdate,
	 budget,
	 budgettype,
	 memo) 
 
VALUES 
	(topic_1,
	 principalid_2,
	 informmanid_3,
	 emailmould_4,
	 startdate_5,
	 budget_6,
	 budgettype_7,
	 memo_8);
open thecursor for
select max(id) from HrmCareerPlan	;
end;
/





CREATE or REPLACE PROCEDURE HrmCareerPlan_Delete
	(id_1 	integer,
	flag out integer  , 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)

AS 
begin
DELETE HrmCareerPlan 

WHERE 
	( id	 = id_1);
delete HrmCareerPlanStep 
where 
  planid = id_1;
end;
/



CREATE or REPLACE PROCEDURE HrmCareerPlanStep_Insert
	(planid_1 	integer,
	 stepname_2 	varchar2,
	 stepstartdate_3 	char,
	 stependdate_4 	char,
	flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 

AS
begin
INSERT INTO HrmCareerPlanStep 
	 (planid,
	 stepname,
	 stepstartdate,
	 stependdate) 
 
VALUES 
	( planid_1,
	 stepname_2,
	 stepstartdate_3,
	 stependdate_4);
end;
/



CREATE or REPLACE PROCEDURE HrmCareerPlan_Finish
	(id_1 	integer,
	 enddate_2 	char,
	 fare_3 	float,
	 faretype_4 	integer,
	 advice_5 	varchar,
	flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 

AS
begin
UPDATE HrmCareerPlan 

SET      enddate	 = enddate_2,
	 fare	         = fare_3,
	 faretype	 = faretype_4,
	 advice	 = advice_5 

WHERE 
	( id	 = id_1);
end;
/


alter table FnaBudgetfeeType add
  feeperiod  integer     /* 预算的周期 1: 每月 2: 每季 3: 每半年 4: 每年 */
/
  alter table FnaBudgetfeeType add
  feetype integer			/* 1: 支出 2: 收入 3:成本*/
/ 
  alter table FnaBudgetfeeType add
  agreegap integer          /* 允许的偏差 */
/


create table FnaBudgetInfo (
id  integer   not null,			/*id*/
budgetyears          char(4),					        /*预算年度*/
budgetdepartmentid     integer ,	                        /*所属部门id*/
budgetstatus           integer ,
/*预算处理状态
0:打开
1:批准
*/
createrid            integer ,					/*生成者id*/
createdate           char(10) ,					/*生成日期*/
approverid           integer ,					/*批准者id*/
approverdate         char(10)					/*批准日期*/
)
/
create sequence FnaBudgetInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaBudgetInfo_Trigger
before insert on FnaBudgetInfo
for each row
begin
select FnaBudgetInfo_id.nextval INTO :new.id from dual;
end;
/

ALTER TABLE FnaBudgetInfo  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  



create table FnaBudgetInfoDetail (
id  integer  not null,			/*id*/
budgetinfoid           integer,                         /*预算id*/
budgetperiods          integer,					        /*预算期间数*/
budgetstartdate   char(10) ,                        /*预算开始日期*/
budgetenddate     char(10) ,                        /*预算结束日期*/
budgettypeid          integer  ,				        /*预算类型id*/
budgetresourceid       integer  ,				        /*对应人力资源id*/
budgetcrmid	           integer  ,			            /*对应CRM id*/
budgetprojectid	       integer  ,				        /*对应项目id*/
budgetaccount     number(18,2) ,			        /*金额*/
budgetremark           varchar2(250) 		        /*备注*/
)
/
create sequence FnaBudgetInfoDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaBudgetInfoDetail_Trigger
before insert on FnaBudgetInfoDetail
for each row
begin
select FnaBudgetInfoDetail_id.nextval into :new.id from dual;
end;
/

ALTER TABLE FnaBudgetInfoDetail  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  



create  INDEX FnaBID_budgetinfoid_in on FnaBudgetInfoDetail(budgetinfoid)
/

create table FnaBudgetCheckDetail (
id  integer  not null,			/*id*/
budgetinfoid           integer,                         /*预算id*/
budgetperiods          integer,					        /*预算期间数*/
budgetstartdate   char(10) ,                        /*预算开始日期*/
budgetenddate     char(10) ,                        /*预算结束日期*/
budgettypeid          integer  ,				        /*预算类型id*/
budgetaccount     number(18,2) ,			        /*金额*/
budgetremark           varchar(250) 		        /*备注*/
)
/
create sequence FnaBudgetCheckDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FnaBudgetCheckDetail_Trigger
before insert on FnaBudgetCheckDetail
for each row
begin
select FnaBudgetCheckDetail_id.nextval into :new.id from dual;
end;
/

ALTER TABLE FnaBudgetCheckDetail  ADD 
	 PRIMARY KEY 
	(
		id
	)
/  


create  INDEX FnaBID_budgetcheckid_in on FnaBudgetCheckDetail(budgetinfoid)
/

CREATE or REPLACE PROCEDURE DocUserCategory_InsertByUser 
	(
	userid_1	integer, 
	usertype_1 char,
	flag out integer  , 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
as 
			mainid_1	integer;
			subid_1	integer;
			secid_1	integer;
			seclevel_1	smallint;
			crmtype_1	integer;

begin
	delete from DocUserCategory where userid=userid_1 and usertype=usertype_1;
			
	if usertype_1 ='0' then
		
			for all_cursor in(
			select distinct t1.id t1id from docseccategory t1,hrmresource t2,hrmrolemembers t5
			where t1.cusertype='0' and t2.id=userid_1 
			and(( t2.seclevel>=t1.cuserseclevel) 
			or( t2.seclevel >= t1.cdepseclevel1 and t2.departmentid=t1.cdepartmentid1) 
			or( t2.seclevel >= t1.cdepseclevel2 and t2.departmentid=t1.cdepartmentid2) 
			or( t5.roleid=t1.croleid1 and t5.rolelevel=t1.crolelevel1 and t2.id=t5.resourceid )
			or( t5.roleid=t1.croleid2 and t5.rolelevel=t1.crolelevel2 and t2.id=t5.resourceid )
			or( t5.roleid=t1.croleid3 and t5.rolelevel=t1.crolelevel3 and t2.id=t5.resourceid ))
			)
			loop
				secid_1 := all_cursor.t1id;
				select  subcategoryid INTO subid_1 from docseccategory where id=secid_1;
				select  maincategoryid INTO mainid_1 from docsubcategory where id=subid_1;
				insert into  docusercategory (secid,mainid,subid,userid,usertype)
				values (secid_1,mainid_1,subid_1,userid_1,usertype_1);
			end loop;		
	else	
			
			select type,seclevel INTO crmtype_1,seclevel_1 from crm_customerinfo where id=userid_1 ;
			for all_cursor IN (	select id from DocSecCategory 
			where cusertype=crmtype_1 and cuserseclevel<=seclevel_1)
			loop
				secid_1 := all_cursor.id;
				select subcategoryid INTO subid_1 from docseccategory where id=secid_1;
				select maincategoryid INTO mainid_1 from docsubcategory where id=subid_1;
				insert into  docusercategory (secid,mainid,subid,userid,usertype)
				values (secid_1,mainid_1,subid_1,userid_1,usertype_1);
			end loop;
	end if;
end;
/


CREATE or REPLACE PROCEDURE HrmDepartment_Select 
(

flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
AS
begin 
open thecursor for
select * from HrmDepartment ;
end;
/


CREATE or REPLACE PROCEDURE FnaBudgetfeeType_Insert
(
	name_1	varchar2,
	feeperiod_1	integer,
	feetype_1	integer,
	agreegap_1	integer,
	description_1	varchar2,
	flag out integer  , 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
	insert into fnaBudgetfeetype (name,feeperiod,feetype,agreegap,description) 
    values (name_1,feeperiod_1,feetype_1,agreegap_1,description_1);
end;
/


CREATE or REPLACE PROCEDURE FnaBudgetfeeType_Update 
(
	id_1		integer,
	name_1	varchar2,
    feeperiod_1	integer,
    feetype_1	integer,
    agreegap_1	integer,
	description_1	varchar2,
	flag out integer  , 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
	update fnaBudgetfeetype set name=name_1,feeperiod=feeperiod_1,feetype=feetype_1
    ,agreegap=agreegap_1,description=description_1 where id=id_1;
end;
/


CREATE or REPLACE PROCEDURE FnaBudgetInfo_Insert
	(budgetyears_1 	char,
	 budgetdepartmentid_2 	integer,
	 budgetstatus_3 	integer,
	 createrid_4 	integer,
	 createdate_5 	char,
	flag out integer  , 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)

AS 
begin
INSERT INTO FnaBudgetInfo 
	 ( budgetyears,
	 budgetdepartmentid,
	 budgetstatus,
	 createrid,
	 createdate) 
 
VALUES 
	( budgetyears_1,
	 budgetdepartmentid_2,
	 budgetstatus_3,
	 createrid_4,
	 createdate_5);
open thecursor for
select max(id) from FnaBudgetInfo;
end;
/


CREATE or REPLACE PROCEDURE FnaBudgetInfo_Update
	(id_1 	integer,
	 approverid_2 	integer,
	 approverdate_3 	char,
	flag out integer  , 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)

AS
begin
UPDATE FnaBudgetInfo 

SET  budgetstatus = '1' ,
     approverid	 = approverid_2,
	 approverdate	 = approverdate_3 

WHERE 
	( id	 = id_1);
end;
/



CREATE or REPLACE PROCEDURE FnaBudgetInfoDetail_Insert
	(budgetinfoid_1 	integer,
	 budgetperiods_2 	integer,
	 budgetstartdate_3 	char,
	 budgetenddate_4 	char,
	 budgettypeid_5 	integer,
	 budgetresourceid_6 	integer,
	 budgetcrmid_7 	integer,
	 budgetprojectid_8 	integer,
	 budgetaccount_9 	number,
	 budgetremark_10 	varchar2,
	flag out integer  , 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)

AS 
begin
INSERT INTO FnaBudgetInfoDetail 
	 ( budgetinfoid,
	 budgetperiods,
	 budgetstartdate,
	 budgetenddate,
	 budgettypeid,
	 budgetresourceid,
	 budgetcrmid,
	 budgetprojectid,
	 budgetaccount,
	 budgetremark) 
 
VALUES 
	( budgetinfoid_1,
	 budgetperiods_2,
	 budgetstartdate_3,
	 budgetenddate_4,
	 budgettypeid_5,
	 budgetresourceid_6,
	 budgetcrmid_7,
	 budgetprojectid_8,
	 budgetaccount_9,
	 budgetremark_10);
end;
/


CREATE or REPLACE PROCEDURE FnaBudgetInfoDetail_Delete
	(budgetinfoid_1 	integer,
    budgettypeid_2 	integer,
	flag out integer  , 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)

AS 
begin
DELETE FnaBudgetInfoDetail 

WHERE 
	( budgetinfoid	 = budgetinfoid_1 and budgettypeid = budgettypeid_2);
end;
/






CREATE or REPLACE PROCEDURE FnaBudgetCheckDetail_Delete
	(budgetinfoid_1 	integer,
	flag out integer  , 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)

AS
begin
DELETE FnaBudgetCheckDetail 

WHERE 
	( budgetinfoid	 = budgetinfoid_1);
end;
/


CREATE or REPLACE PROCEDURE FnaBudgetCheckDetail_Insert
	(budgetinfoid_1 	integer,
	 budgetperiods_2 	integer,
	 budgetstartdate_3 	char,
	 budgetenddate_4 	char,
	 budgettypeid_5 	integer,
	 budgetaccount_9 	number,
	 budgetremark_10 	varchar2,
	flag out integer  , 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)

AS
begin
INSERT INTO FnaBudgetCheckDetail 
	 ( budgetinfoid,
	 budgetperiods,
	 budgetstartdate,
	 budgetenddate,
	 budgettypeid,
	 budgetaccount,
	 budgetremark) 
 
VALUES 
	( budgetinfoid_1,
	 budgetperiods_2,
	 budgetstartdate_3,
	 budgetenddate_4,
	 budgettypeid_5,
	 budgetaccount_9,
	 budgetremark_10);
end;
/



CREATE or REPLACE TRIGGER Tri_U_workflow_createlist 
after  update  ON  HrmResource
FOR each row
Declare workflowid integer;
	type_1 integer;
 	objid integer;
	level_n integer;
	userid integer;
    olddepartmentid_1 integer;
    departmentid_1 integer;
    oldseclevel_1	 integer;
    seclevel_1	 integer;
    countdelete   integer;
begin

olddepartmentid_1 := :old.departmentid;
oldseclevel_1 := :old.seclevel;
departmentid_1 := :new.departmentid;
seclevel_1 := :new.seclevel;




/* 如果部门和安全级别信息被修改(在新建的时候这两个信息肯定被修改) */
  

if ( departmentid_1 <>olddepartmentid_1 or  seclevel_1 <> oldseclevel_1 or oldseclevel_1 is null)    then  


    delete from workflow_createrlist ;

    for all_cursor IN (select workflowid,type,objid,level_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid)
	loop
		workflowid := all_cursor.workflowid;
		type_1 := all_cursor.type;
		objid := all_cursor.objid;
		level_n := all_cursor.level_n;
		if type_1=1 then	
			for detail_cursor IN (select id from HrmResource where departmentid = objid and seclevel >= level_n)
			loop
			userid := detail_cursor.id;
			insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,userid,'0');
			end loop;
		end if;
		if type_1=2 then
			for detail_cursor IN (SELECT resourceid   id FROM HrmRoleMembers where roleid =  objid and rolelevel >=level_n)
			loop
			userid := detail_cursor.id;
			insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,userid,'0');
			end loop;
		end if;
		if type_1=3 then
		insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,objid,'0');
		end if;
		 if type_1=4 then
		 insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,'-1',level_n) ;
		 end if;
		 if type_1=20 then
			for detail_cursor IN (select id  from CRM_CustomerInfo where  seclevel >= level_n and type = objid	)
			loop
			userid := detail_cursor.id;
			insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,userid,'1');
			end loop;
		 end if;
		if type_1=21 then
			for detail_cursor IN ( select id  from CRM_CustomerInfo where  seclevel >= level_n and status = objid	)
			loop 
			userid := detail_cursor.id;
			insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,userid,'1');
			end loop;
		end if;

		if type_1=22 then
			for detail_cursor IN (select id  from CRM_CustomerInfo where  seclevel >= level_n and department = objid		)
			loop
			userid :=detail_cursor.id;
			insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,userid,'1');
			end loop;
		end if;
		if type_1=25 then
		insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,'-2',level_n) ;
		end if;
		if type_1=30 then
		for detail_cursor IN (select id from HrmResource where subcompanyid1 = objid and seclevel >= level_n)
			loop
			userid :=detail_cursor.id;
			insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,userid,'0');
			end loop;
		end if;

	end loop; 
end if;
end ;
/


/* 2003-04-15 建立奖惩种类表 */

CREATE TABLE HrmAwardType (
	id integer  NOT NULL ,
	name varchar2 (60)  NULL ,
	awardtype char (1)  NULL ,
	description varchar2(200) NULL ,
	transact varchar2(200) 
) 
/
create sequence HrmAwardType_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmAwardType_Trigger
before insert on HrmAwardType
for each row
begin
select HrmAwardType_id.nextval into :new.id from dual;
end;
/


/* 2003-04-16 建立奖惩记录表 */
CREATE TABLE HrmAwardInfo (
	id integer  NOT NULL  ,
	rptitle varchar2 (60)  NULL ,
	resourseid integer   NULL ,
	rptypeid integer NULL ,
	rpdate char(10)  NULL ,
	rpexplain varchar2 (200) NULL,
	rptransact varchar2 (200) NULL
) 
/
create sequence HrmAwardInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmAwardInfo_Trigger
before insert on LgcAsset
for each row
begin
select HrmAwardInfo_id.nextval into :new.id from dual;
end;
/


/* 2003-4-16建立奖惩种类存储过程 */
CREATE or REPLACE PROCEDURE HrmAwardType_Insert
(name_2 varchar2,
 awardtype_3 char,
 description_4 varchar2,
 transact_5 varchar2,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
AS
begin
insert into HrmAwardType (name,awardtype,description,transact) values (name_2,awardtype_3,
description_4, transact_5);
end;
/

/* 2003-4-16建立奖惩管理存储过程 */
CREATE or REPLACE PROCEDURE HrmAwardInfo_Insert
(rptitle_2 varchar2,
 resourseid_3 integer,
 rptypeid_4 integer,
 rpdate_5 char,
 rpexplain_6 varchar2,
 rptransact_7 varchar2,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
 AS
 begin
    insert into HrmAwardInfo (rptitle,resourseid,rptypeid,rpdate,rpexplain,rptransact) values (rptitle_2,resourseid_3,rptypeid_4,rpdate_5,rpexplain_6,rptransact_7);
 end;
/


 /*2003-4-17*/
  CREATE or REPLACE PROCEDURE HrmAwardType_SByid
(id_1 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
 as
 begin
 open thecursor for
 select * from HrmAwardType where id= id_1;
end;
/




 /*2003-4-17修改奖惩种类存储过程*/
CREATE or REPLACE PROCEDURE HrmAwardType_Update
(id_1 integer,
 name_2 varchar2,
 awardtype_3 char,
 description_4 varchar2,
 transact_5 varchar2,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
AS
begin
UPDATE HrmAwardType set
name = name_2,
awardtype = awardtype_3,
description = description_4,
transact= transact_5
WHERE
 id = id_1;
end;
/


/*2003-4-17删除一条奖惩种类*/
CREATE or REPLACE PROCEDURE HrmAwardType_Delete
(id_1 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as
begin
delete HrmAwardType where id = id_1;
end;
/


  /*2003-4-18*/
CREATE or REPLACE PROCEDURE HrmAwardInfo_SByid
(id_1 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
AS
begin 
open thecursor for
 select * from HrmAwardInfo where id= id_1;
end;
/


/*2003-4-18修改奖惩管理存储过程*/
CREATE or REPLACE PROCEDURE HrmAwardInfo_Update
(id_1 integer,
 rptitle_2 varchar2,
 resourseid_3 integer,
 rptypeid_4 integer,
 rpdate_5 char,
 rpexplain_6 varchar2,
 rptransact_7 varchar2,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin
UPDATE HrmAwardInfo set
rptitle = rptitle_2,
resourseid = resourseid_3,
rptypeid = rptypeid_4,
rpdate = rpdate_5,
rpexplain = rpexplain_6,
rptransact = rptransact_7
WHERE
 id = id_1;
end;
/


/*2003-4-18删除一条奖惩管理*/
CREATE or REPLACE PROCEDURE HrmAwardInfo_Delete
(id_1 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
AS
begin
DELETE HrmAwardInfo WHERE id = id_1;
end;
/


/*2003年4月15日 建立了一个新的标签*/
insert into HtmlLabelIndex (id,indexdesc) values (6099,'奖惩种类')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6099,'奖惩种类',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6099,'',8)
/

/*2003年4月16日 建立了一个新的标签*/

insert into HtmlLabelIndex (id,indexdesc) values (6100,'奖惩管理')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6100,'奖惩管理',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6100,'',8)
/ 