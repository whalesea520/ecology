alter table CptCapitalType add typecode varchar(100)
go
alter table hrmsubcompany add subcompanycode varchar(100)
go
alter table hrmdepartment add departmentcode varchar(100)
go

create table cptcapitalequipment(
id int identity,
cptid int,
equipmentname varchar(100),
equipmentspec varchar(100),
equipmentsum  int,
equipmentpower varchar(100),
equipmentvoltage varchar(100)
)

create table cptcapitalparts(
id int identity,
cptid int,
partsname varchar(100),
partsspec varchar(100),
partssum  int,
partsweight varchar(100),
partssize varchar(100)
)

create table cptcapitalcodeseq(
id int identity,
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
go

create table cptcode(
id int identity,
isuse int,
subcompanyflow varchar(10),
departmentflow varchar(10),
capitalgroupflow varchar(10),
capitaltypeflow varchar(10),
buydateflow varchar(10),
Warehousingflow varchar(10),
startcodenum int
)
go

create table cptcodeset(
   id int identity,
   codeid int,
   showname varchar(10),
   showtype int,
   value varchar(100),
   codeorder int
)
go

insert into cptcode(isuse,subcompanyflow,departmentflow,capitalgroupflow,capitaltypeflow,buydateflow,Warehousingflow,startcodenum) values(0,0,0,0,0,'0|1','0|1',1)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'18729',2,'',1)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22289',1,0,2)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22290',1,0,3)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'20344',1,0,4)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22291',1,0,5)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22292',1,0,6)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22293',1,0,7)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22294',1,0,8)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22295',1,0,9)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22296',1,0,10)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22297',1,0,11)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'18811',2,'',12)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'20571',2,'',13)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'20572',2,'',14)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'20573',2,'',15)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'20574',2,'',16)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'20575',2,'',17)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'20770',2,'',18)
go
insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'20771',2,'',19)
go


alter table Base_FreeField add docff01name varchar(100)
go
alter table Base_FreeField add docff01use int
go
alter table Base_FreeField add docff02name varchar(100)
go
alter table Base_FreeField add docff02use int
go
alter table Base_FreeField add docff03name varchar(100)
go
alter table Base_FreeField add docff03use int
go
alter table Base_FreeField add docff04name varchar(100)
go
alter table Base_FreeField add docff04use int
go
alter table Base_FreeField add docff05name varchar(100)
go
alter table Base_FreeField add docff05use int
go


alter table Base_FreeField add depff01name varchar(100)
go
alter table Base_FreeField add depff01use int
go
alter table Base_FreeField add depff02name varchar(100)
go
alter table Base_FreeField add depff02use int
go
alter table Base_FreeField add depff03name varchar(100)
go
alter table Base_FreeField add depff03use int
go
alter table Base_FreeField add depff04name varchar(100)
go
alter table Base_FreeField add depff04use int
go
alter table Base_FreeField add depff05name varchar(100)
go
alter table Base_FreeField add depff05use int
go


alter table Base_FreeField add crmff01name varchar(100)
go
alter table Base_FreeField add crmff01use int
go
alter table Base_FreeField add crmff02name varchar(100)
go
alter table Base_FreeField add crmff02use int
go
alter table Base_FreeField add crmff03name varchar(100)
go
alter table Base_FreeField add crmff03use int
go
alter table Base_FreeField add crmff04name varchar(100)
go
alter table Base_FreeField add crmff04use int
go
alter table Base_FreeField add crmff05name varchar(100)
go
alter table Base_FreeField add crmff05use int
go


alter table Base_FreeField add reqff01name varchar(100)
go
alter table Base_FreeField add reqff01use int
go
alter table Base_FreeField add reqff02name varchar(100)
go
alter table Base_FreeField add reqff02use int
go
alter table Base_FreeField add reqff03name varchar(100)
go
alter table Base_FreeField add reqff03use int
go
alter table Base_FreeField add reqff04name varchar(100)
go
alter table Base_FreeField add reqff04use int
go
alter table Base_FreeField add reqff05name varchar(100)
go
alter table Base_FreeField add reqff05use int
go


alter table cptcapital add docff01name varchar(4000)
go
alter table cptcapital add docff02name varchar(4000)
go
alter table cptcapital add docff03name varchar(4000)
go
alter table cptcapital add docff04name varchar(4000)
go
alter table cptcapital add docff05name varchar(4000)
go

alter table cptcapital add depff01name varchar(4000)
go
alter table cptcapital add depff02name varchar(4000)
go
alter table cptcapital add depff03name varchar(4000)
go
alter table cptcapital add depff04name varchar(4000)
go
alter table cptcapital add depff05name varchar(4000)
go

alter table cptcapital add crmff01name varchar(4000)
go
alter table cptcapital add crmff02name varchar(4000)
go
alter table cptcapital add crmff03name varchar(4000)
go
alter table cptcapital add crmff04name varchar(4000)
go
alter table cptcapital add crmff05name varchar(4000)
go

alter table cptcapital add reqff01name varchar(4000)
go
alter table cptcapital add reqff02name varchar(4000)
go
alter table cptcapital add reqff03name varchar(4000)
go
alter table cptcapital add reqff04name varchar(4000)
go
alter table cptcapital add reqff05name varchar(4000)
go

update Base_FreeField set docff01name = 'doc1',docff02name = 'doc2',docff03name = 'doc3',docff04name = 'doc4',docff05name = 'doc5',docff01use = 0,docff02use = 0,docff03use = 0,docff04use = 0,docff05use = 0,depff01name = 'department1',depff02name = 'department2',depff03name = 'department3',depff04name = 'department4',depff05name = 'department5',depff01use = 0,depff02use = 0,depff03use = 0,depff04use = 0,depff05use = 0,crmff01name = 'crm1',crmff02name = 'crm2',crmff03name = 'crm3',crmff04name = 'crm4',crmff05name = 'crm5',crmff01use = 0,crmff02use = 0,crmff03use = 0,crmff04use = 0,crmff05use = 0,reqff01name = 'request1',reqff02name = 'request2',reqff03name = 'request3',reqff04name = 'request4',reqff05name = 'request5',reqff01use = 0,reqff02use = 0,reqff03use = 0,reqff04use = 0,reqff05use = 0 where tablename = 'cp'
go

alter table cptcapital add blongsubcompany int
go
alter table cptcapital add blongdepartment int
go
alter table cptcapital add issupervision int
go
alter table cptcapital add amountpay decimal(18,2)
go
alter table cptcapital add purchasestate int
go
alter table cptcapital add contractno varchar(100)
go


insert into CptCapitalModifyField (field,name) values (56,'doc1')
go
insert into CptCapitalModifyField (field,name) values (57,'doc2')
go
insert into CptCapitalModifyField (field,name) values (58,'doc3')
go
insert into CptCapitalModifyField (field,name) values (59,'doc4')
go
insert into CptCapitalModifyField (field,name) values (60,'doc5')
go

insert into CptCapitalModifyField (field,name) values (61,'department1')
go
insert into CptCapitalModifyField (field,name) values (62,'department2')
go
insert into CptCapitalModifyField (field,name) values (63,'department3')
go
insert into CptCapitalModifyField (field,name) values (64,'department4')
go
insert into CptCapitalModifyField (field,name) values (65,'department5')
go

insert into CptCapitalModifyField (field,name) values (66,'crm1')
go
insert into CptCapitalModifyField (field,name) values (67,'crm2')
go
insert into CptCapitalModifyField (field,name) values (68,'crm3')
go
insert into CptCapitalModifyField (field,name) values (69,'crm4')
go
insert into CptCapitalModifyField (field,name) values (70,'crm5')
go

insert into CptCapitalModifyField (field,name) values (71,'request1')
go
insert into CptCapitalModifyField (field,name) values (72,'request2')
go
insert into CptCapitalModifyField (field,name) values (73,'request3')
go
insert into CptCapitalModifyField (field,name) values (74,'request4')
go
insert into CptCapitalModifyField (field,name) values (75,'request5')
go

create table CptSearchDefinition(
id int identity,
fieldname varchar(50),
isconditionstitle int,
istitle int,
isconditions int,
isseniorconditions int,	
displayorder varchar(10)
)
go

alter table cptcapital add equipmentpower varchar(100)
go

update mainmenuinfo set linkAddress='/cpt/capital/CptCapMain_frm.jsp',labelid = 22315 where id=172
go

update LeftMenuInfo set linkAddress='/cpt/capital/CptCapMain_frm.jsp',labelid = 22315  where id=56
go

update mainmenuinfo set linkAddress='/cpt/report/CptRpCapGroupSum_frm.jsp' where id=252
go

update mainmenuinfo set linkAddress='/cpt/report/CptRpCapResSum_frm.jsp' where id=253
go

update mainmenuinfo set linkAddress='/cpt/report/CptRpCapDepSum_frm.jsp' where id=254
go

update mainmenuinfo set linkAddress='/cpt/report/CptRpCapitalStateSum_frm.jsp' where id=255
go

update mainmenuinfo set linkAddress='/cpt/report/CptRpCapital_frm.jsp' where id=256
go

update mainmenuinfo set linkAddress='/cpt/report/CptRpCapitalFlow_frm.jsp' where id=257
go

update mainmenuinfo set linkAddress='/cpt/capital/CptCapMod_frm.jsp' where id=183
go

ALTER PROCEDURE SystemSet_DftSCUpdate
(
	@dftsubcomid int ,
	@flag int output , 
	@msg varchar(80) output
) 
AS 

UPDATE MeetingRoom 
SET subcompanyId = @dftsubcomid 
WHERE subcompanyId IS null 
OR subcompanyId = 0 
OR subcompanyId = -1 
OR subcompanyid NOT IN (SELECT id FROM hrmSubcompany)

UPDATE Meeting_Type 
SET subcompanyId = @dftsubcomid 
WHERE subcompanyId IS null 
OR subcompanyId = 0 
OR subcompanyId = -1 
OR subcompanyid NOT IN (SELECT id FROM hrmSubcompany)


update HrmRoles 
set subcompanyid=@dftsubcomid 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany)

update workflow_formdict 
set subcompanyid=@dftsubcomid 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany)

update workflow_formdictdetail 
set subcompanyid=@dftsubcomid 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany)

update workflow_formbase 
set subcompanyid=@dftsubcomid 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany)

update workflow_base 
set subcompanyid=@dftsubcomid 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany)

update HrmContractTemplet 
set subcompanyid=@dftsubcomid 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany)

update HrmContractType 
set subcompanyid=@dftsubcomid 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany)

update cptcapital 
set blongsubcompany=@dftsubcomid 
where blongsubcompany is null or blongsubcompany=0 or blongsubcompany=-1 
or blongsubcompany not in (select id from hrmsubcompany)
GO

delete from CptSearchDefinition
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('isdata','1','1','1','0','0.0')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('mark','1','1','1','0','0.0')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('fnamark','1','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('name','1','1','1','0','0.0')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('barcode','1','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('startdate','1','0','1','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('enddate','1','0','1','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('departmentid','1','1','1','0','0.0')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('resourceid','1','1','1','0','0.0')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('blongsubcompany','0','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('blongdepartment','1','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('sptcount','1','1','0','0','0.0')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('relatewfid','0','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('capitalspec','1','1','1','1','0.0')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('capitallevel','1','0','1','1','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('manufacturer','1','0','1','1','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('manudate','1','0','1','1','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('capitaltypeid','1','0','1','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('capitalgroupid','1','1','1','0','0.0')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('customerid','1','0','1','1','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('attribute','1','0','1','1','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('stateid','1','1','1','1','0.0')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('unitid','1','0','1','1','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('location','0','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('StockInDate','1','0','1','1','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('capitalnum','1','0','1','1','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('isinner','1','0','1','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('replacecapitalid','1','0','1','1','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('version','0','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('SelectDate','1','0','1','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('contractno','1','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('currencyid','1','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('startprice','0','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('Invoice','0','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('depreyear','1','1','0','0','0.0')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('deprerate','1','1','0','0','0.0')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('deprestartdate','1','0','1','1','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('issupervision','1','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('amountpay','0','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('purchasestate','0','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('datefield1','0','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('numberfield1','0','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('textfield1','0','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('tinyintfield1','1','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('docff01name','0','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('docff02name','0','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('depff01name','0','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('depff02name','0','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('crmff01name','0','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('crmff02name','0','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('reqff01name','0','0','0','0','')
go
insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder) values ('reqff02name','0','0','0','0','')
go
 
alter table CptStockInDetail add contractno varchar(100)
go

alter    PROCEDURE CptCapital_Duplicate (
@capitalid 	int,
@customerid	int,
@price		decimal,
@capitalspec	varchar(60),
@location	varchar(100),
@invoice	varchar(80),
@StockInDate	char(10),
@SelectDate	char(10),
@flag integer output,
@msg varchar(80) output)
AS 
declare @maxid int

INSERT INTO [CptCapital] 
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
relatewfid,
invoice,
StockInDate,
depreyear,
deprerate,
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
SelectDate)  

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
@price,
depreendprice,
@capitalspec,
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
@customerid,
attribute,
stateid,
@location,
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
@invoice,
@StockInDate,
depreyear,
deprerate,
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
@SelectDate    
from CptCapital
where id = @capitalid

select @maxid = max(id)  from CptCapital
update CptCapital set capitalnum = 0 where id = @maxid
select @maxid

GO

alter table CptSearchMould add fnamark varchar(100)
go
alter table CptSearchMould add barcode varchar(100)
go
alter table CptSearchMould add blongdepartment varchar(10)
go
alter table CptSearchMould add sptcount varchar(10)
go
alter table CptSearchMould add relatewfid varchar(1000)
go
alter table CptSearchMould add SelectDate varchar(10)
go
alter table CptSearchMould add SelectDate1 varchar(10)
go
alter table CptSearchMould add contractno varchar(100)
go
alter table CptSearchMould add Invoice varchar(100)
go
alter table CptSearchMould add depreyear varchar(10)
go
alter table CptSearchMould add deprerate varchar(10)
go
alter table CptSearchMould add issupervision varchar(10)
go
alter table CptSearchMould add amountpay varchar(30)
go
alter table CptSearchMould add amountpay1 varchar(30)
go
alter table CptSearchMould add depreyear1 varchar(10)
go
alter table CptSearchMould add deprerate1 varchar(10)
go
alter table CptSearchMould add purchasestate varchar(10)
go

alter table CptSearchMould add datafield1 varchar(10)
go
alter table CptSearchMould add datafield11 varchar(10)
go
alter table CptSearchMould add datafield2 varchar(10)
go
alter table CptSearchMould add datafield22 varchar(10)
go
alter table CptSearchMould add datafield3 varchar(10)
go
alter table CptSearchMould add datafield33 varchar(10)
go
alter table CptSearchMould add datafield4 varchar(10)
go
alter table CptSearchMould add datafield44 varchar(10)
go
alter table CptSearchMould add datafield5 varchar(10)
go
alter table CptSearchMould add datafield55 varchar(10)
go

alter table CptSearchMould add numberfield1 varchar(20)
go
alter table CptSearchMould add numberfield11 varchar(20)
go
alter table CptSearchMould add numberfield2 varchar(20)
go
alter table CptSearchMould add numberfield22 varchar(20)
go
alter table CptSearchMould add numberfield3 varchar(20)
go
alter table CptSearchMould add numberfield33 varchar(20)
go
alter table CptSearchMould add numberfield4 varchar(20)
go
alter table CptSearchMould add numberfield44 varchar(20)
go
alter table CptSearchMould add numberfield5 varchar(20)
go
alter table CptSearchMould add numberfield55 varchar(20)
go

alter table CptSearchMould add textfield1 varchar(1000)
go
alter table CptSearchMould add textfield2 varchar(1000)
go
alter table CptSearchMould add textfield3 varchar(1000)
go
alter table CptSearchMould add textfield4 varchar(1000)
go
alter table CptSearchMould add textfield5 varchar(1000)
go

alter table CptSearchMould add tinyintfield1 varchar(10)
go
alter table CptSearchMould add tinyintfield2 varchar(10)
go
alter table CptSearchMould add tinyintfield3 varchar(10)
go
alter table CptSearchMould add tinyintfield4 varchar(10)
go
alter table CptSearchMould add tinyintfield5 varchar(10)
go

alter table CptSearchMould add docff01name varchar(1000)
go
alter table CptSearchMould add docff02name varchar(1000)
go
alter table CptSearchMould add docff03name varchar(1000)
go
alter table CptSearchMould add docff04name varchar(1000)
go
alter table CptSearchMould add docff05name varchar(1000)
go

alter table CptSearchMould add depff01name varchar(1000)
go
alter table CptSearchMould add depff02name varchar(1000)
go
alter table CptSearchMould add depff03name varchar(1000)
go
alter table CptSearchMould add depff04name varchar(1000)
go
alter table CptSearchMould add depff05name varchar(1000)
go

alter table CptSearchMould add crmff01name varchar(1000)
go
alter table CptSearchMould add crmff02name varchar(1000)
go
alter table CptSearchMould add crmff03name varchar(1000)
go
alter table CptSearchMould add crmff04name varchar(1000)
go
alter table CptSearchMould add crmff05name varchar(1000)
go

alter table CptSearchMould add reqff01name varchar(1000)
go
alter table CptSearchMould add reqff02name varchar(1000)
go
alter table CptSearchMould add reqff03name varchar(1000)
go
alter table CptSearchMould add reqff04name varchar(1000)
go
alter table CptSearchMould add reqff05name varchar(1000)
go

alter table CptSearchDefinition add mouldid int
go
update CptSearchDefinition set mouldid = -1
go

ALTER table  CptUseLog  ADD resourceid varchar(60)
go

ALTER table  CptUseLog  ADD mendperioddate varchar(60)
go

update MainMenuInfo set labelid  = 22459 where id  = 182
go


/*资产流程新增:资产维修*/ alter PROCEDURE CptUseLogMend_Insert (@capitalid_1 	[int], @usedate_2 	[char](10), @usedeptid_3 	[int], @useresourceid_4 	[int], @usecount_5 	[int], @useaddress_6 	[varchar](200), @userequest_7 	[int], @maintaincompany_8 	[varchar](100), @fee_9 	[decimal](18,3), @usestatus_10 	[varchar](2), @remark_11 	[text], @resourceid_12 [varchar](60),@mendperioddate_13 [varchar](60),@flag integer output, @msg varchar(80) output)  AS  INSERT INTO [CptUseLog] ( [capitalid], [usedate], [usedeptid], [useresourceid], [usecount], [useaddress], [userequest], [maintaincompany], [fee], [usestatus], [remark],[resourceid],[mendperioddate])  VALUES ( @capitalid_1, @usedate_2, @usedeptid_3, @useresourceid_4, @usecount_5, @useaddress_6, @userequest_7, @maintaincompany_8, @fee_9, '4', @remark_11,@resourceid_12,@mendperioddate_13)  Update CptCapital Set stateid = @usestatus_10 where id = @capitalid_1 

GO
