
alter table CptCapitalType add typecode varchar2(100)
/
alter table hrmsubcompany add subcompanycode varchar2(100)
/
alter table hrmdepartment add departmentcode varchar2(100)
/

create table cptcapitalequipment(
id int not null,
cptid int,
equipmentname varchar2(100),
equipmentspec varchar2(100),
equipmentsum  int,
equipmentpower varchar2(100),
equipmentvoltage varchar2(100)
)
/
create sequence cptcapitalequipment_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger cptcapitalequipment_Trigger
before insert on cptcapitalequipment
for each row
begin
select cptcapitalequipment_id.nextval into :new.id from dual;
end;
/

create table cptcapitalparts(
id int not null,
cptid int,
partsname varchar2(100),
partsspec varchar2(100),
partssum  int,
partsweight varchar2(100),
partssize varchar2(100)
)
/
create sequence cptcapitalparts_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger cptcapitalparts_Trigger
before insert on cptcapitalparts
for each row
begin
select cptcapitalparts_id.nextval into :new.id from dual;
end;
/

create table cptcapitalcodeseq(
id int not null,
sequenceid int,
subcompanyid int,
departmentid int,
capitalgroupid int,
capitaltypeid int,
buydateyear int,
buydatemonth int,
buydateday int,
warehouseyear int,
warehousemonth int,
warehouseday int
)
/
create sequence cptcapitalcodeseq_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger cptcapitalcodeseq_Trigger
before insert on cptcapitalcodeseq
for each row
begin
select cptcapitalcodeseq_id.nextval into :new.id from dual;
end;
/

create table cptcode(
id int not null,
isuse int,
subcompanyflow varchar2(10),
departmentflow varchar2(10),
capitalgroupflow varchar2(10),
capitaltypeflow varchar2(10),
buydateflow varchar2(10),
Warehousingflow varchar2(10),
startcodenum int
)
/
create sequence cptcode_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger cptcode_Trigger
before insert on cptcode
for each row
begin
select cptcode_id.nextval into :new.id from dual;
end;
/

create table cptcodeset(
   id int not null,
   codeid int,
   showname varchar2(10),
   showtype int,
   value varchar2(100),
   codeorder int
)
/
create sequence cptcodeset_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger cptcodeset_Trigger
before insert on cptcodeset
for each row
begin
select cptcodeset_id.nextval into :new.id from dual;
end;
/

insert into cptcode(isuse,subcompanyflow,departmentflow,capitalgroupflow,capitaltypeflow,buydateflow,Warehousingflow,startcodenum) values(0,0,0,0,0,'0|1','0|1',1)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'18729',2,'',1)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22289',1,0,2)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22290',1,0,3)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'20344',1,0,4)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22291',1,0,5)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22292',1,0,6)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22293',1,0,7)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22294',1,0,8)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22295',1,0,9)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22296',1,0,10)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22297',1,0,11)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'18811',2,'',12)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'20571',2,'',13)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'20572',2,'',14)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'20573',2,'',15)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'20574',2,'',16)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'20575',2,'',17)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'20770',2,'',18)
/
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'20771',2,'',19)
/


alter table Base_FreeField add docff01name varchar2(100)
/
alter table Base_FreeField add docff01use int
/
alter table Base_FreeField add docff02name varchar2(100)
/
alter table Base_FreeField add docff02use int
/
alter table Base_FreeField add docff03name varchar2(100)
/
alter table Base_FreeField add docff03use int
/
alter table Base_FreeField add docff04name varchar2(100)
/
alter table Base_FreeField add docff04use int
/
alter table Base_FreeField add docff05name varchar2(100)
/
alter table Base_FreeField add docff05use int
/


alter table Base_FreeField add depff01name varchar2(100)
/
alter table Base_FreeField add depff01use int
/
alter table Base_FreeField add depff02name varchar2(100)
/
alter table Base_FreeField add depff02use int
/
alter table Base_FreeField add depff03name varchar2(100)
/
alter table Base_FreeField add depff03use int
/
alter table Base_FreeField add depff04name varchar2(100)
/
alter table Base_FreeField add depff04use int
/
alter table Base_FreeField add depff05name varchar2(100)
/
alter table Base_FreeField add depff05use int
/


alter table Base_FreeField add crmff01name varchar2(100)
/
alter table Base_FreeField add crmff01use int
/
alter table Base_FreeField add crmff02name varchar2(100)
/
alter table Base_FreeField add crmff02use int
/
alter table Base_FreeField add crmff03name varchar2(100)
/
alter table Base_FreeField add crmff03use int
/
alter table Base_FreeField add crmff04name varchar2(100)
/
alter table Base_FreeField add crmff04use int
/
alter table Base_FreeField add crmff05name varchar2(100)
/
alter table Base_FreeField add crmff05use int
/


alter table Base_FreeField add reqff01name varchar2(100)
/
alter table Base_FreeField add reqff01use int
/
alter table Base_FreeField add reqff02name varchar2(100)
/
alter table Base_FreeField add reqff02use int
/
alter table Base_FreeField add reqff03name varchar2(100)
/
alter table Base_FreeField add reqff03use int
/
alter table Base_FreeField add reqff04name varchar2(100)
/
alter table Base_FreeField add reqff04use int
/
alter table Base_FreeField add reqff05name varchar2(100)
/
alter table Base_FreeField add reqff05use int
/

alter table cptcapital add docff01name varchar2(4000)
/
alter table cptcapital add docff02name varchar2(4000)
/
alter table cptcapital add docff03name varchar2(4000)
/
alter table cptcapital add docff04name varchar2(4000)
/
alter table cptcapital add docff05name varchar2(4000)
/

alter table cptcapital add depff01name varchar2(4000)
/
alter table cptcapital add depff02name varchar2(4000)
/
alter table cptcapital add depff03name varchar2(4000)
/
alter table cptcapital add depff04name varchar2(4000)
/
alter table cptcapital add depff05name varchar2(4000)
/

alter table cptcapital add crmff01name varchar2(4000)
/
alter table cptcapital add crmff02name varchar2(4000)
/
alter table cptcapital add crmff03name varchar2(4000)
/
alter table cptcapital add crmff04name varchar2(4000)
/
alter table cptcapital add crmff05name varchar2(4000)
/

alter table cptcapital add reqff01name varchar2(4000)
/
alter table cptcapital add reqff02name varchar2(4000)
/
alter table cptcapital add reqff03name varchar2(4000)
/
alter table cptcapital add reqff04name varchar2(4000)
/
alter table cptcapital add reqff05name varchar2(4000)
/

update Base_FreeField set docff01name = 'doc1',docff02name = 'doc2',docff03name = 'doc3',docff04name = 'doc4',docff05name = 'doc5',docff01use = 0,docff02use = 0,docff03use = 0,docff04use = 0,docff05use = 0,depff01name = 'department1',depff02name = 'department2',depff03name = 'department3',depff04name = 'department4',depff05name = 'department5',depff01use = 0,depff02use = 0,depff03use = 0,depff04use = 0,depff05use = 0,crmff01name = 'crm1',crmff02name = 'crm2',crmff03name = 'crm3',crmff04name = 'crm4',crmff05name = 'crm5',crmff01use = 0,crmff02use = 0,crmff03use = 0,crmff04use = 0,crmff05use = 0,reqff01name = 'request1',reqff02name = 'request2',reqff03name = 'request3',reqff04name = 'request4',reqff05name = 'request5',reqff01use = 0,reqff02use = 0,reqff03use = 0,reqff04use = 0,reqff05use = 0 where tablename = 'cp'
/

alter table cptcapital add blongsubcompany int
/
alter table cptcapital add blongdepartment int
/
alter table cptcapital add issupervision int
/
alter table cptcapital add amountpay decimal(18,2)
/
alter table cptcapital add purchasestate int
/
alter table cptcapital add contractno varchar2(100)
/



insert into CptCapitalModifyField (field,name) values (56,'doc1')
/
insert into CptCapitalModifyField (field,name) values (57,'doc2')
/
insert into CptCapitalModifyField (field,name) values (58,'doc3')
/
insert into CptCapitalModifyField (field,name) values (59,'doc4')
/
insert into CptCapitalModifyField (field,name) values (60,'doc5')
/

insert into CptCapitalModifyField (field,name) values (61,'department1')
/
insert into CptCapitalModifyField (field,name) values (62,'department2')
/
insert into CptCapitalModifyField (field,name) values (63,'department3')
/
insert into CptCapitalModifyField (field,name) values (64,'department4')
/
insert into CptCapitalModifyField (field,name) values (65,'department5')
/

insert into CptCapitalModifyField (field,name) values (66,'crm1')
/
insert into CptCapitalModifyField (field,name) values (67,'crm2')
/
insert into CptCapitalModifyField (field,name) values (68,'crm3')
/
insert into CptCapitalModifyField (field,name) values (69,'crm4')
/
insert into CptCapitalModifyField (field,name) values (70,'crm5')
/

insert into CptCapitalModifyField (field,name) values (71,'request1')
/
insert into CptCapitalModifyField (field,name) values (72,'request2')
/
insert into CptCapitalModifyField (field,name) values (73,'request3')
/
insert into CptCapitalModifyField (field,name) values (74,'request4')
/
insert into CptCapitalModifyField (field,name) values (75,'request5')
/

create table CptSearchDefinition(
id int not null,
fieldname varchar2(50),
isconditionstitle int,
istitle int,
isconditions int,
isseniorconditions int,	
displayorder varchar2(10)
)
/

create sequence CptSearchDefinition_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CptSearchDefinition_Trigger
before insert on CptSearchDefinition
for each row
begin
select CptSearchDefinition_id.nextval into :new.id from dual;
end;
/

alter table cptcapital add equipmentpower varchar2(100)
/

update mainmenuinfo set linkAddress='/cpt/capital/CptCapMain_frm.jsp',labelid  = 22315 where id=172
/

update LeftMenuInfo set linkAddress='/cpt/capital/CptCapMain_frm.jsp',labelid  = 22315  where id=56
/

update mainmenuinfo set linkAddress='/cpt/report/CptRpCapGroupSum_frm.jsp' where id=252
/

update mainmenuinfo set linkAddress='/cpt/report/CptRpCapResSum_frm.jsp' where id=253
/

update mainmenuinfo set linkAddress='/cpt/report/CptRpCapDepSum_frm.jsp' where id=254
/

update mainmenuinfo set linkAddress='/cpt/report/CptRpCapitalStateSum_frm.jsp' where id=255
/

update mainmenuinfo set linkAddress='/cpt/report/CptRpCapital_frm.jsp' where id=256
/

update mainmenuinfo set linkAddress='/cpt/report/CptRpCapitalFlow_frm.jsp' where id=257
/

update mainmenuinfo set linkAddress='/cpt/capital/CptCapMod_frm.jsp' where id=183
/

create or replace PROCEDURE SystemSet_DftSCUpdate
(
	dftsubcomid_1 integer ,
	flag out integer  , 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin

UPDATE MeetingRoom 
SET subcompanyId = dftsubcomid_1 
WHERE subcompanyId IS null 
OR subcompanyId = 0 
OR subcompanyId = -1 
OR subcompanyid NOT IN (SELECT id FROM hrmSubcompany);

UPDATE Meeting_Type 
SET subcompanyId = dftsubcomid_1 
WHERE subcompanyId IS null 
OR subcompanyId = 0 
OR subcompanyId = -1 
OR subcompanyid NOT IN (SELECT id FROM hrmSubcompany);


update HrmRoles 
set subcompanyid=dftsubcomid_1 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany);

update workflow_formdict 
set subcompanyid=dftsubcomid_1 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany);

update workflow_formdictdetail 
set subcompanyid=dftsubcomid_1 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany);

update workflow_formbase 
set subcompanyid=dftsubcomid_1 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany);

update workflow_base 
set subcompanyid=dftsubcomid_1 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany);

update HrmContractTemplet 
set subcompanyid=dftsubcomid_1 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany);

update HrmContractType 
set subcompanyid=dftsubcomid_1 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany);

update cptcapital 
set blongsubcompany=dftsubcomid_1 
where blongsubcompany is null or blongsubcompany=0 or blongsubcompany=-1 
or blongsubcompany not in (select id from hrmsubcompany);
end;
/

delete from CptSearchDefinition
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('isdata','1','1','1','0','0.0')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('mark','1','1','1','0','0.0')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('fnamark','1','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('name','1','1','1','0','0.0')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('barcode','1','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('startdate','1','0','1','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('enddate','1','0','1','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('departmentid','1','1','1','0','0.0')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('resourceid','1','1','1','0','0.0')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('blongsubcompany','0','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('blongdepartment','1','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('sptcount','1','1','0','0','0.0')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('relatewfid','0','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('capitalspec','1','1','1','1','0.0')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('capitallevel','1','0','1','1','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('manufacturer','1','0','1','1','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('manudate','1','0','1','1','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('capitaltypeid','1','0','1','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('capitalgroupid','1','1','1','0','0.0')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('customerid','1','0','1','1','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('attribute','1','0','1','1','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('stateid','1','1','1','1','0.0')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('unitid','1','0','1','1','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('location','0','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('StockInDate','1','0','1','1','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('capitalnum','1','0','1','1','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('isinner','1','0','1','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('replacecapitalid','1','0','1','1','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('version','0','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('SelectDate','1','0','1','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('contractno','1','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('currencyid','1','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('startprice','0','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('Invoice','0','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('depreyear','1','1','0','0','0.0')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('deprerate','1','1','0','0','0.0')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('deprestartdate','1','0','1','1','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('issupervision','1','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('amountpay','0','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('purchasestate','0','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('datefield1','0','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('numberfield1','0','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('textfield1','0','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('tinyintfield1','1','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('docff01name','0','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('docff02name','0','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('depff01name','0','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('depff02name','0','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('crmff01name','0','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('crmff02name','0','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('reqff01name','0','0','0','0','')
/
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('reqff02name','0','0','0','0','')
/
 
alter table CptStockInDetail add contractno varchar2(100)
/

CREATE OR REPLACE PROCEDURE CptCapital_Duplicate (
capitalid_1 	integer,
customerid_1	integer,
price_1			number,
capitalspec_1	varchar2,
location_1		varchar2,
invoice_1		varchar2,
StockInDate_1	char,
SelectDate_1 char,
flag out integer  ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) AS 
maxid integer; 
begin 
    INSERT INTO CptCapital (
    mark,
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
    relatewfid,
	invoice,
	StockInDate,
	depreyear,
	issupervision, 
	amountpay, 
	purchasestate, 
	docff01name,
	docff02name,
	docff03name,
	docff04name,
	docff05name,
	depff01name,
	depff02name,
	depff03name,
	depff04name,
	depff05name,
	crmff01name,
	crmff02name,
	crmff03name,
	crmff04name,
	crmff05name,
	reqff01name,
	reqff02name,
	reqff03name,
	reqff04name,
	reqff05name,
	SelectDate,
	deprerate)  
    
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
    price_1,
    depreendprice,
    capitalspec_1,
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
    customerid_1,
    attribute,
    stateid,
    location_1,
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
    relatewfid,
	invoice_1,
	StockInDate_1,
	depreyear,
	issupervision, 
	amountpay, 
	purchasestate, 
	docff01name,
	docff02name,
	docff03name,
	docff04name,
	docff05name,
	depff01name,
	depff02name,
	depff03name,
	depff04name,
	depff05name,
	crmff01name,
	crmff02name,
	crmff03name,
	crmff04name,
	crmff05name,
	reqff01name,
	reqff02name,
	reqff03name,
	reqff04name,
	reqff05name,
	SelectDate_1,
	deprerate    	
    from CptCapital 
    where id = capitalid_1; 
    
    select  max(id) INTO maxid  from CptCapital; 
    update CptCapital set capitalnum = 0 where id = maxid; 
    open thecursor for 
        select maxid from dual; 
end;
/

alter table CptSearchMould add fnamark varchar2(100)
/
alter table CptSearchMould add barcode varchar2(100)
/
alter table CptSearchMould add blongdepartment varchar2(10)
/
alter table CptSearchMould add sptcount varchar2(10)
/
alter table CptSearchMould add relatewfid varchar2(1000)
/
alter table CptSearchMould add SelectDate varchar2(10)
/
alter table CptSearchMould add SelectDate1 varchar2(10)
/
alter table CptSearchMould add contractno varchar2(100)
/
alter table CptSearchMould add Invoice varchar2(100)
/
alter table CptSearchMould add depreyear varchar2(10)
/
alter table CptSearchMould add deprerate varchar2(10)
/
alter table CptSearchMould add issupervision varchar2(10)
/
alter table CptSearchMould add amountpay varchar2(30)
/
alter table CptSearchMould add amountpay1 varchar2(30)
/
alter table CptSearchMould add depreyear1 varchar2(10)
/
alter table CptSearchMould add deprerate1 varchar2(10)
/
alter table CptSearchMould add purchasestate varchar2(10)
/

alter table CptSearchMould add datafield1 varchar2(10)
/
alter table CptSearchMould add datafield11 varchar2(10)
/
alter table CptSearchMould add datafield2 varchar2(10)
/
alter table CptSearchMould add datafield22 varchar2(10)
/
alter table CptSearchMould add datafield3 varchar2(10)
/
alter table CptSearchMould add datafield33 varchar2(10)
/
alter table CptSearchMould add datafield4 varchar2(10)
/
alter table CptSearchMould add datafield44 varchar2(10)
/
alter table CptSearchMould add datafield5 varchar2(10)
/
alter table CptSearchMould add datafield55 varchar2(10)
/

alter table CptSearchMould add numberfield1 varchar2(20)
/
alter table CptSearchMould add numberfield11 varchar2(20)
/
alter table CptSearchMould add numberfield2 varchar2(20)
/
alter table CptSearchMould add numberfield22 varchar2(20)
/
alter table CptSearchMould add numberfield3 varchar2(20)
/
alter table CptSearchMould add numberfield33 varchar2(20)
/
alter table CptSearchMould add numberfield4 varchar2(20)
/
alter table CptSearchMould add numberfield44 varchar2(20)
/
alter table CptSearchMould add numberfield5 varchar2(20)
/
alter table CptSearchMould add numberfield55 varchar2(20)
/

alter table CptSearchMould add textfield1 varchar2(1000)
/
alter table CptSearchMould add textfield2 varchar2(1000)
/
alter table CptSearchMould add textfield3 varchar2(1000)
/
alter table CptSearchMould add textfield4 varchar2(1000)
/
alter table CptSearchMould add textfield5 varchar2(1000)
/

alter table CptSearchMould add tinyintfield1 varchar2(10)
/
alter table CptSearchMould add tinyintfield2 varchar2(10)
/
alter table CptSearchMould add tinyintfield3 varchar2(10)
/
alter table CptSearchMould add tinyintfield4 varchar2(10)
/
alter table CptSearchMould add tinyintfield5 varchar2(10)
/

alter table CptSearchMould add docff01name varchar2(1000)
/
alter table CptSearchMould add docff02name varchar2(1000)
/
alter table CptSearchMould add docff03name varchar2(1000)
/
alter table CptSearchMould add docff04name varchar2(1000)
/
alter table CptSearchMould add docff05name varchar2(1000)
/

alter table CptSearchMould add depff01name varchar2(1000)
/
alter table CptSearchMould add depff02name varchar2(1000)
/
alter table CptSearchMould add depff03name varchar2(1000)
/
alter table CptSearchMould add depff04name varchar2(1000)
/
alter table CptSearchMould add depff05name varchar2(1000)
/

alter table CptSearchMould add crmff01name varchar2(1000)
/
alter table CptSearchMould add crmff02name varchar2(1000)
/
alter table CptSearchMould add crmff03name varchar2(1000)
/
alter table CptSearchMould add crmff04name varchar2(1000)
/
alter table CptSearchMould add crmff05name varchar2(1000)
/

alter table CptSearchMould add reqff01name varchar2(1000)
/
alter table CptSearchMould add reqff02name varchar2(1000)
/
alter table CptSearchMould add reqff03name varchar2(1000)
/
alter table CptSearchMould add reqff04name varchar2(1000)
/
alter table CptSearchMould add reqff05name varchar2(1000)
/
alter table CptSearchDefinition add mouldid int
/
update CptSearchDefinition set mouldid = -1
/

ALTER table  CptUseLog  ADD resourceid varchar(60)
/
ALTER table  CptUseLog  ADD mendperioddate varchar(60)
/
update MainMenuInfo set labelid  = 22459 where id  = 182
/

CREATE or replace PROCEDURE CptUseLogMend_Insert
	(
     capitalid_1 	integer,
	 usedate_2 	char,
	 usedeptid_3 	integer,
	 useresourceid_4 	integer,
	 usecount_5 	integer,
	 useaddress_6 	varchar2,
	 userequest_7 	integer,
	 maintaincompany_8 	varchar2,
	 fee_9 	decimal,
	 usestatus_10 	varchar2,
	 remark_11 	varchar2,
	 resourceid_12 	varchar2,
	 mendperioddate_13 	varchar2,
	 flag  out integer,
	 msg  out varchar2,
     thecursor IN OUT cursor_define.weavercursor
     )
AS
begin
      INSERT INTO CptUseLog 
         (
         capitalid,
         usedate,
         usedeptid,
         useresourceid,
         usecount,
         useaddress,
         userequest,
         maintaincompany,
         fee,
         usestatus,
         remark,
		 resourceid,
		 mendperioddate) 
     
    VALUES 
        (         
         capitalid_1,
         usedate_2,
         usedeptid_3,
         useresourceid_4,
         usecount_5,
         useaddress_6,
         userequest_7,
         maintaincompany_8,
         fee_9,
         '4',
         remark_11,
	     resourceid_12,
         mendperioddate_13) ;

    Update CptCapital Set stateid = usestatus_10  where id = capitalid_1 ;


end;
/