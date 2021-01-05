CREATE TABLE CRM_CustomerTypePersonal
	(
	userId          INT NULL,
	mainType        INT NULL,
	subType         INT NULL
	)
/

CREATE TABLE CRM_Exchange_Info(
   sortid      INT NULL,
   type_n    CHAR (2) NULL,
   readDate  CHAR (10) NULL,
   readTime  CHAR (10) NULL,
   recentId INT NULL,
   userid INT NULL
)
/

CREATE TABLE crm_selectitem
	(
	fieldid     INT NOT NULL,
	selectvalue INT NOT NULL,
	selectname  VARCHAR (250) NULL,
	fieldorder  INT NOT NULL,
	isdel INT
	)
/

Delete from MainMenuInfo where id=241
/

Delete from MainMenuInfo where id=345
/

Delete from MainMenuInfo where id=245
/

UPDATE MainMenuInfo SET linkAddress = '/CRM/report/CRMContactLogRpFrame.jsp' WHERE id = 237
/

UPDATE MainMenuInfo SET linkAddress = '/CRM/sellchance/SellChanceReportFrame.jsp' WHERE id = 330
/

UPDATE MainMenuInfo SET linkAddress = '/CRM/sellchance/SellStatusRpSumFrame.jsp' WHERE id = 332
/

UPDATE MainMenuInfo SET linkAddress = '/CRM/sellchance/SuccessRpSumFrame.jsp' WHERE id = 333
/

UPDATE MainMenuInfo SET linkAddress = '/CRM/sellchance/FailureRpSumFrame.jsp' WHERE id = 334
/

UPDATE MainMenuInfo SET linkAddress = '/CRM/sellchance/SellTimeRpSumFrame.jsp' WHERE id = 335
/

UPDATE MainMenuInfo SET linkAddress = '/CRM/report/CRMModifyLogRpFrame.jsp' WHERE id = 346
/

UPDATE MainMenuInfo SET linkAddress = '/CRM/report/CRMViewLogRpFrame.jsp' WHERE id = 347
/


alter table CRM_CustomerContacter add projectrole varchar(100)
/
alter table CRM_CustomerContacter add attitude varchar(50)
/
alter table CRM_SellChance add selltype int
/
alter table WorkPlan add sellchanceid int
/
alter table WorkPlan add contacterid int
/
alter table CRM_CustomerContacter add attention varchar(200)
/

alter table CRM_ContacterTitle add orderkey int 
/
alter table CRM_AddressType add orderkey int
/
alter table CRM_ContactWay add orderkey int
/
alter table CRM_CustomerSize add orderkey int
/
alter table CRM_CustomerDesc add orderkey int
/
alter table CRM_CustomerStatus add orderkey int
/
alter table CRM_CustomerStatus add usname varchar (300)
/
alter table CRM_CustomerStatus add cnname varchar (300)
/
alter table CRM_CustomerStatus add twname varchar (300)
/
alter table CRM_Evaluation_Level add orderkey int
/
alter table CRM_Evaluation add orderkey int
/
alter table CRM_Successfactor add orderkey int
/
alter table CRM_Failfactor add orderkey int
/
alter table CRM_CustomerCredit add currencytype int
/
alter table CRM_CreditInfo add orderkey int
/
alter table CRM_TradeInfo add orderkey int
/
alter table CRM_ContractType add orderkey int
/
alter table CRM_CustomerType add orderkey int
/
alter table CRM_SectorInfo add orderkey int
/

CREATE OR REPLACE PROCEDURE CRM_CustomerStatus_Update (
id_1 	integer, 
fullname_1 	varchar2, 
description_1 	varchar2, 
cnname_1 varchar2,
usname_1 varchar2,
twname_1 varchar2,
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
AS begin UPDATE 
CRM_CustomerStatus SET fullname	 = fullname_1, description	 = description_1 ,cnname=cnname_1,usname=usname_1,twname=twname_1 WHERE ( id	 = id_1); end;
/

CREATE OR REPLACE PROCEDURE CRM_CustomerCredit_Insert (
CreditAmount_1  number  , 
CreditTime_1  integer  , 
currencytype_1 integer,
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
AS begin INSERT INTO 
CRM_CustomerCredit (CreditAmount,CreditTime,currencytype) VALUES(CreditAmount_1, CreditTime_1,currencytype_1); end;
/


delete from MainMenuInfo where id=158
/
delete from MainMenuInfo where id=159
/
delete from MainMenuInfo where id=139
/
delete from MainMenuInfo where id=134
/
delete from MainMenuInfo where id=135
/
delete from MainMenuInfo where id=362
/
delete from MainMenuInfo where id=363
/
delete from MainMenuInfo where id=151
/

CREATE TABLE CRM_CustomerDefinField(
	id int NOT NULL,
	fieldname varchar(60) NULL,
	fieldlabel varchar (2000) NULL,
	fielddbtype varchar(40) NULL,
	fieldhtmltype char(1) NULL,
	selectid int NULL,
	type int NULL,
	viewtype int NULL,
	usetable varchar(50) NULL,
	textheight int NULL,
	imgwidth int NULL,
	imgheight int NULL,
	dsporder decimal(15, 2) NULL,
	isopen char(1) NULL,
	ismust char(1) NULL,
	places int NULL,
	candel char(1) NULL
)
/
create sequence CRM_CustomerDefinField_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger CRM_CustomerDefinField_id_tri
before insert on CRM_CustomerDefinField
for each row
begin
select CRM_CustomerDefinField_id.nextval into :new.id from dual;
end;
/

CREATE table CRM_Common_Attention (
   id                   int                  ,
   operatetype          int                  null,
   objid                int                  null,
   operator             int                  null,
   operatedate          char(10)             null,
   operatetime          char(8)              null,
   constraint PK_CRM_COMMON_ATTENTION primary key (id)
)
/
create sequence CRM_Common_Attention_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger CRM_Common_Attention_id_tri
before insert on CRM_Common_Attention
for each row
begin
select CRM_Common_Attention_id.nextval into :new.id from dual;
end;
/

ALTER TABLE CRM_CustomerContacter ADD  imcode varchar(50)
/

ALTER TABLE CRM_CustomerContacter ADD  status int
/

ALTER TABLE CRM_CustomerContacter ADD  isneedcontact int
/

CREATE OR REPLACE TRIGGER TASK_CRM_LOG after insert  or  delete on WorkPlan for each row 
DECLARE 
var_userid integer; 
var_workdate CHAR(10); 
var_taskid integer; 
var_logid integer; 
var_type integer;  
begin if inserting then BEGIN 
var_userid:=:new.createrid; 
var_workdate:=:new.createdate; 
var_taskid:=:new.crmid; 
var_logid:=:new.id; 
var_type:=:new.type_n; 
if var_type=3 then 
INSERT INTO task_operateLog (userid,workdate,tasktype,taskid,logid,createdate,createtime,logtype) 
SELECT var_userid ,var_workdate,9,var_taskid ,var_logid,to_char(sysdate,'yyyy-mm-dd'),to_char(sysdate,'hh24:mi:ss'),1
FROM CRM_CustomerInfo WHERE ',' ||var_taskid||',' LIKE '%,'||to_char(id)||',%';
end if; 
END; end if;if deleting then var_userid:=:old.createrid; var_taskid:=:old.crmid; var_type:=:old.type_n; if var_type=3 then DELETE FROM task_operateLog WHERE userid=var_userid AND tasktype=9 AND taskid=var_taskid; end if; end if; end;
/
delete from CRM_CustomerDefinField
/
insert into CRM_CustomerDefinField
(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield1',dff01name,'char(10)','3','2','0','1','CRM_CustomerInfo',dff01use,'n' from Base_FreeField where 
tablename='c1' 
and (dff01use='1'
or ((select count(*) c from CRM_CustomerInfo where datefield1 <>'' and datefield1 is not null) >0))
/

insert into CRM_CustomerDefinField
(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield2',dff02name,'char(10)','3','2','0','1','CRM_CustomerInfo',dff02use,'n' from Base_FreeField where 

tablename='c1' 
and (dff02use='1'
or ((select count(*) c from CRM_CustomerInfo where datefield2 <>'' and datefield2 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield3',dff03name,'char(10)','3','2','0','1','CRM_CustomerInfo',dff03use,'n' from Base_FreeField where 

tablename='c1' 
and (dff03use='1'
or ((select count(*) c from CRM_CustomerInfo where datefield3 <>'' and datefield3 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield4',dff04name,'char(10)','3','2','0','1','CRM_CustomerInfo',dff04use,'n' from Base_FreeField where 

tablename='c1' 
and (dff04use='1'
or ((select count(*) c from CRM_CustomerInfo where datefield4 <>'' and datefield4 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield5',dff05name,'char(10)','3','2','0','1','CRM_CustomerInfo',dff05use,'n' from Base_FreeField where 

tablename='c1' 
and (dff05use='1'
or ((select count(*) c from CRM_CustomerInfo where datefield5 <>'' and datefield5 is not null) >0))
/
insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield1',nff01name,'decimal(15,4)','1','3','0','1','CRM_CustomerInfo',nff01use,'n' from Base_FreeField where 

tablename='c1' 
and (nff01use='1'
or ((select count(*) c from CRM_CustomerInfo where numberfield1 <>'' and numberfield1 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield2',nff02name,'decimal(15,4)','1','3','0','1','CRM_CustomerInfo',nff02use,'n' from Base_FreeField where 

tablename='c1' 
and (nff02use='1'
or ((select count(*) c from CRM_CustomerInfo where numberfield2 <>'' and numberfield2 is not null) >0))
/
insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield3',nff03name,'decimal(15,4)','1','3','0','1','CRM_CustomerInfo',nff03use,'n' from Base_FreeField where 
tablename='c1' and (nff03use='1' or ((select count(*) c from CRM_CustomerInfo where numberfield3 <>'' and numberfield3 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield4',nff04name,'decimal(15,4)','1','3','0','1','CRM_CustomerInfo',nff04use,'n' from Base_FreeField where 

tablename='c1' 
and (nff04use='1'
or ((select count(*) c from CRM_CustomerInfo where numberfield4 <>'' and numberfield4 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield5',nff05name,'decimal(15,4)','1','3','0','1','CRM_CustomerInfo',nff05use,'n' from Base_FreeField where 

tablename='c1' 
and (nff05use='1'
or ((select count(*) c from CRM_CustomerInfo where numberfield5 <>'' and numberfield5 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield1',tff01name,'varchar(100)','1','1','0','1','CRM_CustomerInfo',tff01use,'n' from Base_FreeField where 

tablename='c1' 
and (tff01use='1'
or ((select count(*) c from CRM_CustomerInfo where textfield1 <>'' and textfield1 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield2',tff02name,'varchar(100)','1','1','0','1','CRM_CustomerInfo',tff02use,'n' from Base_FreeField where 

tablename='c1' 
and (tff02use='1'
or ((select count(*) c from CRM_CustomerInfo where textfield2 <>'' and textfield2 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield3',tff03name,'varchar(100)','1','1','0','1','CRM_CustomerInfo',tff03use,'n' from Base_FreeField where 

tablename='c1' 
and (tff03use='1'
or ((select count(*) c from CRM_CustomerInfo where textfield3 <>'' and textfield3 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield4',tff04name,'varchar(100)','1','1','0','1','CRM_CustomerInfo',tff04use,'n' from Base_FreeField where 

tablename='c1' 
and (tff04use='1'
or ((select count(*) c from CRM_CustomerInfo where textfield4 <>'' and textfield4 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield5',tff05name,'varchar(100)','1','1','0','1','CRM_CustomerInfo',tff05use,'n' from Base_FreeField where 

tablename='c1' 
and (tff05use='1'
or ((select count(*) c from CRM_CustomerInfo where textfield5 <>'' and textfield5 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield1',bff01name,'char(1)','4','1','0','1','CRM_CustomerInfo',bff01use,'n' from Base_FreeField where 

tablename='c1' 
and (bff01use='1'
or ((select count(*) c from CRM_CustomerInfo where tinyintfield1 <>'' and tinyintfield1 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield2',bff02name,'char(1)','4','1','0','1','CRM_CustomerInfo',bff02use,'n' from Base_FreeField where 

tablename='c1' 
and (bff02use='1'
or ((select count(*) c from CRM_CustomerInfo where tinyintfield2 <>'' and tinyintfield2 is not null) >0))
/
insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield3',bff03name,'char(1)','4','1','0','1','CRM_CustomerInfo',bff03use,'n' from Base_FreeField where 

tablename='c1' 
and (bff03use='1'
or ((select count(*) c from CRM_CustomerInfo where tinyintfield3 <>'' and tinyintfield3 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield4',bff04name,'char(1)','4','1','0','1','CRM_CustomerInfo',bff04use,'n' from Base_FreeField where 

tablename='c1' 
and (bff04use='1'
or ((select count(*) c from CRM_CustomerInfo where tinyintfield4 <>'' and tinyintfield4 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield5',bff05name,'char(1)','4','1','0','1','CRM_CustomerInfo',bff05use,'n' from Base_FreeField where 

tablename='c1' 
and (bff05use='1'
or ((select count(*) c from CRM_CustomerInfo where tinyintfield5 <>'' and tinyintfield5 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield1',dff01name,'char(10)','3','2','0','1','CRM_CustomerContacter',dff01use,'n' from Base_FreeField where 

tablename='c2' 
and (dff01use='1'
or ((select count(*) c from CRM_CustomerContacter where datefield1 <>'' and datefield1 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield2',dff02name,'char(10)','3','2','0','1','CRM_CustomerContacter',dff02use,'n' from Base_FreeField where 

tablename='c2' 
and (dff02use='1'
or ((select count(*) c from CRM_CustomerContacter where datefield2 <>'' and datefield2 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield3',dff03name,'char(10)','3','2','0','1','CRM_CustomerContacter',dff03use,'n' from Base_FreeField where 

tablename='c2' 
and (dff03use='1'
or ((select count(*) c from CRM_CustomerContacter where datefield3 <>'' and datefield3 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield4',dff04name,'char(10)','3','2','0','1','CRM_CustomerContacter',dff04use,'n' from Base_FreeField where 

tablename='c2' 
and (dff04use='1'
or ((select count(*) c from CRM_CustomerContacter where datefield4 <>'' and datefield4 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield5',dff05name,'char(10)','3','2','0','1','CRM_CustomerContacter',dff05use,'n' from Base_FreeField where 

tablename='c2' 
and (dff05use='1'
or ((select count(*) c from CRM_CustomerContacter where datefield5 <>'' and datefield5 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield1',nff01name,'decimal(15,4)','1','3','0','1','CRM_CustomerContacter',nff01use,'n' from Base_FreeField 

where tablename='c2' 
and (nff01use='1'
or ((select count(*) c from CRM_CustomerContacter where numberfield1 <>'' and numberfield1 is not null) >0))
/
insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield2',nff02name,'decimal(15,4)','1','3','0','1','CRM_CustomerContacter',nff02use,'n' from Base_FreeField 

where tablename='c2' 
and (nff02use='1'
or ((select count(*) c from CRM_CustomerContacter where numberfield2 <>'' and numberfield2 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield3',nff03name,'decimal(15,4)','1','3','0','1','CRM_CustomerContacter',nff03use,'n' from Base_FreeField 

where tablename='c2' 
and (nff03use='1'
or ((select count(*) c from CRM_CustomerContacter where numberfield3 <>'' and numberfield3 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield4',nff04name,'decimal(15,4)','1','3','0','1','CRM_CustomerContacter',nff04use,'n' from Base_FreeField 

where tablename='c2' 
and (nff04use='1'
or ((select count(*) c from CRM_CustomerContacter where numberfield4 <>'' and numberfield4 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield5',nff05name,'decimal(15,4)','1','3','0','1','CRM_CustomerContacter',nff05use,'n' from Base_FreeField 

where tablename='c2' 
and (nff05use='1'
or ((select count(*) c from CRM_CustomerContacter where numberfield5 <>'' and numberfield5 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield1',tff01name,'varchar(100)','1','1','0','1','CRM_CustomerContacter',tff01use,'n' from Base_FreeField where 

tablename='c2' 
and (tff01use='1'
or ((select count(*) c from CRM_CustomerContacter where textfield1 <>'' and textfield1 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield2',tff02name,'varchar(100)','1','1','0','1','CRM_CustomerContacter',tff02use,'n' from Base_FreeField where 

tablename='c2' 
and (tff02use='1'
or ((select count(*) c from CRM_CustomerContacter where textfield2 <>'' and textfield2 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield3',tff03name,'varchar(100)','1','1','0','1','CRM_CustomerContacter',tff03use,'n' from Base_FreeField where 

tablename='c2' 
and (tff03use='1'
or ((select count(*) c from CRM_CustomerContacter where textfield3 <>'' and textfield3 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield4',tff04name,'varchar(100)','1','1','0','1','CRM_CustomerContacter',tff04use,'n' from Base_FreeField where 

tablename='c2' 
and (tff04use='1'
or ((select count(*) c from CRM_CustomerContacter where textfield4 <>'' and textfield4 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield5',tff05name,'varchar(100)','1','1','0','1','CRM_CustomerContacter',tff05use,'n' from Base_FreeField where 

tablename='c2' 
and (tff05use='1'
or ((select count(*) c from CRM_CustomerContacter where textfield5 <>'' and textfield5 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield1',bff01name,'char(1)','4','1','0','1','CRM_CustomerContacter',bff01use,'n' from Base_FreeField where 

tablename='c2' 
and (bff01use='1'
or ((select count(*) c from CRM_CustomerContacter where tinyintfield1 <>'' and tinyintfield1 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield2',bff02name,'char(1)','4','1','0','1','CRM_CustomerContacter',bff02use,'n' from Base_FreeField where 

tablename='c2' 
and (bff02use='1'
or ((select count(*) c from CRM_CustomerContacter where tinyintfield2 <>'' and tinyintfield2 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield3',bff03name,'char(1)','4','1','0','1','CRM_CustomerContacter',bff03use,'n' from Base_FreeField where 

tablename='c2' 
and (bff03use='1'
or ((select count(*) c from CRM_CustomerContacter where tinyintfield3 <>'' and tinyintfield3 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield4',bff04name,'char(1)','4','1','0','1','CRM_CustomerContacter',bff04use,'n' from Base_FreeField where 

tablename='c2' 
and (bff04use='1'
or ((select count(*) c from CRM_CustomerContacter where tinyintfield4 <>'' and tinyintfield4 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield5',bff05name,'char(1)','4','1','0','1','CRM_CustomerContacter',bff05use,'n' from Base_FreeField where 

tablename='c2' 
and (bff05use='1'
or ((select count(*) c from CRM_CustomerContacter where tinyintfield5 <>'' and tinyintfield5 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield1',dff01name,'char(10)','3','2','0','1','CRM_CustomerAddress',dff01use,'n' from Base_FreeField where 

tablename='c3' 
and (dff01use='1'
or ((select count(*) c from CRM_CustomerAddress where datefield1 <>'' and datefield1 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield2',dff02name,'char(10)','3','2','0','1','CRM_CustomerAddress',dff02use,'n' from Base_FreeField where 

tablename='c3' 
and (dff02use='1'
or ((select count(*) c from CRM_CustomerAddress where datefield2 <>'' and datefield2 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield3',dff03name,'char(10)','3','2','0','1','CRM_CustomerAddress',dff03use,'n' from Base_FreeField where 

tablename='c3' 
and (dff03use='1'
or ((select count(*) c from CRM_CustomerAddress where datefield3 <>'' and datefield3 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield4',dff04name,'char(10)','3','2','0','1','CRM_CustomerAddress',dff04use,'n' from Base_FreeField where 

tablename='c3' 
and (dff04use='1'
or ((select count(*) c from CRM_CustomerAddress where datefield4 <>'' and datefield4 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'datefield5',dff05name,'char(10)','3','2','0','1','CRM_CustomerAddress',dff05use,'n' from Base_FreeField where 

tablename='c3' 
and (dff05use='1'
or ((select count(*) c from CRM_CustomerAddress where datefield5 <>'' and datefield5 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield1',nff01name,'decimal(15,4)','1','3','0','1','CRM_CustomerAddress',nff01use,'n' from Base_FreeField 

where tablename='c3' 
and (nff01use='1'
or ((select count(*) c from CRM_CustomerAddress where numberfield1 <>'' and numberfield1 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield2',nff02name,'decimal(15,4)','1','3','0','1','CRM_CustomerAddress',nff02use,'n' from Base_FreeField 

where tablename='c3' 
and (nff02use='1'
or ((select count(*) c from CRM_CustomerAddress where numberfield2 <>'' and numberfield2 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield3',nff03name,'decimal(15,4)','1','3','0','1','CRM_CustomerAddress',nff03use,'n' from Base_FreeField 

where tablename='c3' 
and (nff03use='1'
or ((select count(*) c from CRM_CustomerAddress where numberfield3 <>'' and numberfield3 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield4',nff04name,'decimal(15,4)','1','3','0','1','CRM_CustomerAddress',nff04use,'n' from Base_FreeField 

where tablename='c3' 
and (nff04use='1'
or ((select count(*) c from CRM_CustomerAddress where numberfield4 <>'' and numberfield4 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'numberfield5',nff05name,'decimal(15,4)','1','3','0','1','CRM_CustomerAddress',nff05use,'n' from Base_FreeField 

where tablename='c3' 
and (nff05use='1'
or ((select count(*) c from CRM_CustomerAddress where numberfield5 <>'' and numberfield5 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield1',tff01name,'varchar(100)','1','1','0','1','CRM_CustomerAddress',tff01use,'n' from Base_FreeField where 

tablename='c3' 
and (tff01use='1'
or ((select count(*) c from CRM_CustomerAddress where textfield1 <>'' and textfield1 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield2',tff02name,'varchar(100)','1','1','0','1','CRM_CustomerAddress',tff02use,'n' from Base_FreeField where 

tablename='c3' 
and (tff02use='1'
or ((select count(*) c from CRM_CustomerAddress where textfield2 <>'' and textfield2 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield3',tff03name,'varchar(100)','1','1','0','1','CRM_CustomerAddress',tff03use,'n' from Base_FreeField where 

tablename='c3' 
and (tff03use='1'
or ((select count(*) c from CRM_CustomerAddress where textfield3 <>'' and textfield3 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield4',tff04name,'varchar(100)','1','1','0','1','CRM_CustomerAddress',tff04use,'n' from Base_FreeField where 

tablename='c3' 
and (tff04use='1'
or ((select count(*) c from CRM_CustomerAddress where textfield4 <>'' and textfield4 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'textfield5',tff05name,'varchar(100)','1','1','0','1','CRM_CustomerAddress',tff05use,'n' from Base_FreeField where 

tablename='c3' 
and (tff05use='1'
or ((select count(*) c from CRM_CustomerAddress where textfield5 <>'' and textfield5 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield1',bff01name,'char(1)','4','1','0','1','CRM_CustomerAddress',bff01use,'n' from Base_FreeField where 

tablename='c3' 
and (bff01use='1'
or ((select count(*) c from CRM_CustomerAddress where tinyintfield1 <>'' and tinyintfield1 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield2',bff02name,'char(1)','4','1','0','1','CRM_CustomerAddress',bff02use,'n' from Base_FreeField where 

tablename='c3' 
and (bff02use='1'
or ((select count(*) c from CRM_CustomerAddress where tinyintfield2 <>'' and tinyintfield2 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield3',bff03name,'char(1)','4','1','0','1','CRM_CustomerAddress',bff03use,'n' from Base_FreeField where 

tablename='c3' 
and (bff03use='1'
or ((select count(*) c from CRM_CustomerAddress where tinyintfield3 <>'' and tinyintfield3 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield4',bff04name,'char(1)','4','1','0','1','CRM_CustomerAddress',bff04use,'n' from Base_FreeField where 

tablename='c3' 
and (bff04use='1'
or ((select count(*) c from CRM_CustomerAddress where tinyintfield4 <>'' and tinyintfield4 is not null) >0))
/

insert into CRM_CustomerDefinField

(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel)
select 'tinyintfield5',bff05name,'char(1)','4','1','0','1','CRM_CustomerAddress',bff05use,'n' from Base_FreeField where 

tablename='c3' 
and (bff05use='1'
or ((select count(*) c from CRM_CustomerAddress where tinyintfield5 <>'' and tinyintfield5 is not null) >0))
/