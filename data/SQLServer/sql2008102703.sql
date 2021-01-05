create table Sys_tabledict
(
id int NOT NULL IDENTITY (1, 1),
tablename varchar(30) NULL,
tabledesc varchar(100) NULL,
tabledescen varchar(100) NULL,
tabletype int NULL,
modetype int NULL,
memo varchar(200) NULL
)
GO

create table Sys_fielddict
(
tabledictid int NOT NULL,
fieldname varchar(30) NULL,
fielddesc varchar(100) NULL,
fielddescen varchar(100) NULL,
fielddbtype varchar(40) NULL,
fieldhtmltype char(1) NULL,
type int NULL,
dsporder int NULL
)
GO

alter table Workflow_DataInput_table
add FormId varchar(100)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('HrmResource','人力资源','human resource',0,1,'人力资源')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'lastname','人员名称','name','varchar(60)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'birthday','生日','birthday','char(10)',3,2,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'nationality','国家','nationality','int',1,2,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'telephone','电话','telephone','varchar(60)',1,1,4) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'mobile','手机','mobilephone','varchar(60)',1,1,5) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'mobilecall','其它号码','other telephone','varchar(60)',1,1,6) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'email','电子邮件','email','varchar(60)',1,1,7) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'locationid','工作地点','location','int',1,2,8) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'workroom','办公室','office room','varchar(60)',1,1,9) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'homeaddress','家庭住址','home address','varchar(100)',1,1,10) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'startdate','合同开始日期','beginning date of contract','char(10)',3,2,11) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'enddate','合同结束日期','ending date of contract','char(10)',3,2,12) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'jobtitle','岗位','post','int',1,2,13) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'jobactivitydesc','职责描述','description of activity','varchar(200)',1,1,14) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'joblevel','职级','level','int',1,2,15) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'seclevel','安全级别','security level','int',1,2,16) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'departmentid','部门','department','int',3,4,17) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'subcompanyid1','分部','subcompany','int',3,42,18) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'managerid','经理','manager','int',3,1,19) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'assistantid','助理','assistant','int',3,1,20) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'bankid1','银行','bankid1','int',1,2,21) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'accountid1','帐号','account','varchar(100)',1,1,22) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'createrid','创建人','creater','int',3,1,23) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'createdate','创建日期','create date','char(10)',3,2,24) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'lastmodid','最后修改人','the last modifyer','int',3,1,25) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'lastmoddate','最后修改日期','the date of last modifing','char(10)',3,2,26) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'lastlogindate','最后登陆日期','the date of last login','char(10)',3,2,27) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'certificatenum','身份证号码','identity card no.','varchar(60)',1,1,28) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'nativeplace','籍贯','native place','varchar(100)',1,1,29) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'educationlevel','学历','education','varchar(100)',1,2,30) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'bememberdate','入团时间','the date of join the group','char(10)',3,2,31) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'bepartydate','入党时间','the date of join the party','char(10)',3,2,32) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'workcode','编号','code','varchar(60)',1,1,33) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'regresidentplace','户口','regresidentplace','varchar(60)',1,1,34) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'residentplace','居住地','residentplace','varchar(60)',1,1,35) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'policy','政治面貌','policy','varchar(30)',1,1,36) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'degree','学位','degree','varchar(30)',1,1,37) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'height','身高','height','varchar(10)',1,1,38) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'jobcall','职称','the title of a technical post','int',1,2,39) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'accumfundaccount','公积金帐号','accumfundaccount','varchar(30)',1,1,40) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'birthplace','出生地','hometown','varchar(60)',1,1,41) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'folk','民族','folk','varchar(30)',1,1,42) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'residentphone','居住地电话','home phone','varchar(60)',1,1,43) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'residentpostcode','居住地邮编','post code','varchar(60)',1,1,44) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'extphone','分机','extension phone','varchar(50)',1,1,45) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'fax','传真','fax','varchar(60)',1,1,46) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'weight','体重','weight','int',1,2,47) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'tempresidentnumber','暂住证号码','tempresidentnumber','varchar(60)',1,1,48) 
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'probationenddate','试用期结束日期','the end date of probationership','char(10)',3,2,49) 
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('HrmCountry','国家','country',0,1,'国家')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(2,'countryname','国家名称','countryname','varchar(60)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(2,'countrydesc','国家描述','description of country','varchar(200)',1,1,2)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('HrmLocations','工作地点','location',0,1,'工作地点')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(3,'locationname','工作地点名称','locationname','varchar(200)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(3,'locationdesc','工作地点描述','description of location','varchar(200)',1,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(3,'address1','工作地址1','address1','varchar(200)',1,1,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(3,'address2','工作地址2','address2','varchar(200)',1,1,4)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(3,'locationcity','工作地点所在城市','city of location','int',3,58,5)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(3,'postcode','邮编','post code','varchar(20)',1,1,6)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(3,'countryid','工作地点所在国家','country of location','int',1,2,7)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(3,'telephone','电话','telephone','varchar(60)',1,1,8)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(3,'fax','传真','fax','varchar(60)',1,1,9)

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('HrmJobTitles','岗位表','post table',0,1,'岗位信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(4,'jobtitlemark','职位标识','mark of post','varchar(60)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(4,'jobtitlename','职位描述','description of post','varchar(200)',1,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(4,'jobtitleremark','备注','remark','text',2,0,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(4,'jobactivityid','所属职责id','job activity id','int',1,2,4)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(4,'jobdepartmentid','所属部门id','job department id','int',3,4,5)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(4,'jobresponsibility','岗位职责','responsibility','varchar(200)',1,1,6)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(4,'jobcompetency','岗位要求','competency','varchar(200)',1,1,7)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(4,'jobdoc','相关文档','document','int',1,2,8)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('HrmDepartment','部门','department',0,1,'部门信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(5,'departmentmark','部门标识','mark of department','varchar(60)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(5,'departmentname','部门描述','description of department','varchar(200)',1,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(5,'subcompanyid1','所属分部id','subcompany','int',3,42,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(5,'supdepid','上级部门id','super department id','int',3,4,4)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('HrmSubCompany','分部','SubCompany',0,1,'分部信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(6,'subcompanyname','分部简称','name of subcompany','varchar(200)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(6,'subcompanydesc','分部描述','description of subcompany','varchar(200)',1,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(6,'companyid1','所属总部id','company','int',1,2,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(6,'supsubcomid','上级分部id','super subcompany','int',3,42,4)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('HrmBank','银行','bank',0,1,'银行信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(7,'bankname','银行名称','name of bank','varchar(60)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(7,'bankdesc','银行描述','description of bank','varchar(200)',1,1,2)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('HrmEducationInfo','教育情况表','education information',0,1,'教育情况表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(8,'school','学校','school','varchar(100)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(8,'speciality','专业','speciality','varchar(60)',1,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(8,'studydesc','详细描述','particular description','text',2,0,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(8,'startdate','开始时间','startdate','varchar(10)',3,2,4)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(8,'enddate','结束时间','enddate','varchar(10)',3,2,5)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('HrmJobCall','职称表','the titles of all technical post',0,1,'职称表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(9,'name','职称名称','name','varchar(60)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(9,'description','职称描述','description','varchar(60)',1,1,2)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('HrmCity','城市表','City',0,1,'城市表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(10,'cityname','城市名称','name of city','varchar(60)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(10,'citylongitude','城市经度','longitude of city','numeric(8,3)',1,3,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(10,'citylatitude','城市纬度','latitude of city','numeric(8,3)',1,3,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(10,'provinceid','省份id','province','int',1,2,4)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(10,'countryid','国家id','country','int',1,2,5)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('HrmProvince','省份表','Province',0,1,'省份表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(11,'provincename','省份名称','name of province','varchar(60)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(11,'provincedesc','省份描述','description of province','varchar(200)',1,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(11,'countryid','国家id','country','int',1,2,3)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('HrmJobActivities','职责表','Job Activities',0,1,'职责表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(12,'jobactivitymark','职责标识','mark of activity','varchar(60)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(12,'jobactivityname','职责描述','description of activity','varchar(200)',1,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(12,'jobgroupid','工作类型','work type','int',1,2,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(12,'joblevelfrom','最低职级','lowest level','int',1,2,4)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(12,'joblevelto','最高职级','highest level','int',1,2,5)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('HrmJobGroups','职务类型表','Activitie type',0,1,'职务类型表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(13,'jobgroupname','工作类型描述','description of work type','varchar(200)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(13,'jobgroupremark','工作类型标识','remark of work type','text',2,0,2)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('HrmSpeciality','专业表','Speciality',0,1,'专业表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(14,'name','专业名称','speciality name','varchar(60)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(14,'description','专业描述','speciality description','varchar(60)',1,1,2)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('DocDetail','文档信息表','document information',0,2,'文档信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'maincategory','文档主目录','main category','int',1,2,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'subcategory','文档分目录','subcategory','int',1,2,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'seccategory','文档子目录','subdirectory','int',1,2,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docsubject','文档标题','document subject','varchar(200)',1,1,4)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'doccontent','文档内容','document content','text',2,0,5)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'hrmresid','文档中选择的人力资源','humen resource','int',3,1,6)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'crmid','文档中选择的客户','customer resource','int',3,1,7)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'projectid','文档中选择的项目','project','int',3,8,8)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'doccreaterid','文档创建者','document creater','int',3,1,9)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docdepartmentid','文档创建者所在部门','department of document creater','int',3,4,10)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'doccreatedate','文档创建日期','create date of document','char(10)',3,2,11)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'doccreatetime','文档创建时间','create time of document','char(8)',3,19,12)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'doclastmoduserid','文档最后修改者','document latest modifyer','int',3,1,13)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'doclastmoddate','文档最后修改日期','the date of latest modifying','char(10)',3,2,14)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'doclastmodtime','文档最后修改时间','the time of latest modifying','char(8)',3,19,15)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docapproveuserid','文档审批者','document approver','int',3,1,16)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docapprovedate','文档审批日期','the date of approving','char(10)',3,2,17)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docapprovetime','文档审批时间','the time of approving','char(8)',3,19,18)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docarchiveuserid','文档归档者','document archiver','int',3,1,19)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docarchivedate','文档归档日期','the date of archiving','char(10)',3,2,20)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docarchivetime','文档归档时间','the time of archiving','char(8)',3,19,21)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'ownerid','文档拥有者','document owner','int',3,1,22)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'keyword','关键字','keyword','varchar(255)',1,1,23)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'accessorycount','附件数量','count of accessory','int',1,2,24)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'replaydoccount','回复文档的数量','count of replay','int',1,2,25)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docno','文档归档号','document archive no.','varchar(100)',1,1,26)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'countMark','打分次数','count of marking','int',1,2,27)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'sumMark','总分数','sum of marking','int',1,2,28)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'sumReadCount','浏览量','count of reading','int',1,2,29)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'doccode','文档编号','document code','varchar(200)',1,1,30)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docedition','文档版本','document edition','int',1,2,31)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'maindoc','文档版本','main document','int',3,9,32)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docvaliduserid','生效操作人','the people who making document valid','int',3,1,33)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docvaliddate','生效日期','the date of validation','char(10)',3,2,34)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docvalidtime','生效时间','the time of validation','char(8)',3,19,35)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docpubuserid','发布操作人','document publisher','int',3,1,36)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docpubdate','发布日期','the date of publishing','char(10)',3,2,37)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docpubtime','发布时间','the time of publishing','char(8)',3,19,38)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docreopenuserid','重新打开操作人','the people who reopen the document','int',3,1,39)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docreopendate','重新打开日期','the date of reopenning','char(10)',3,2,40)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docreopentime','重新打开时间','the time of reopenning','char(8)',3,19,41)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docinvaluserid','失效操作人','the people who making document invalid','int',3,1,42)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docinvaldate','失效日期','the date of invalidation','char(10)',3,2,43)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'docinvaltime','失效时间','the time of invalidation','char(8)',3,19,44)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'doccanceluserid','作废操作人','the people who making document blank out','int',3,1,45)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'doccanceldate','作废日期','the date of blanking out','char(10)',3,2,46)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'doccanceltime','作废时间','the time of blanking out','char(8)',3,19,47)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'checkOutUserId','签出用户','the people who check out the document','int',3,1,48)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'checkOutDate','签出日期','the date of checking out','char(10)',3,2,49)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'checkOutTime','签出时间','the time of checking out','char(8)',3,19,50)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'invalidationdate','失效日期','the date of invalidation','char(10)',3,2,51)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'canPrintedNum','可打印份数','total count of printing','int',1,2,52)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'hasPrintedNum','已打印份数','printed count','int',1,2,53)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('DocMainCategory','文档主目录信息表','document main category information',0,2,'文档主目录信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(16,'categoryname','文档主目录描述','name of main category','varchar(200)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(16,'coder','文档主目录编码','code of main category','varchar(20)',1,1,2)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('DocSubCategory','文档分目录信息表','document sub category information',0,2,'文档分目录信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(17,'maincategoryid','文档主目录','main category','int',1,2,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(17,'categoryname','文档分目录描述','name of subcategory','varchar(200)',1,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(17,'coder','文档分目录编码','code','varchar(20)',1,1,3)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('DocSecCategory','文档子目录信息表','document subdirectory information',0,2,'文档子目录信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(18,'categoryname','文档子目录描述','name of subdirectory','varchar(200)',1,1,1)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('CRM_CustomerInfo','客户信息表','customer information',0,3,'客户信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'name','客户名称','name of customer','varchar(50)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'engname','客户英文名称','english name of customer','varchar(50)',1,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'address1','地址1','address1','varchar(250)',1,1,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'address2','地址2','address2','varchar(250)',1,1,4)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'address3','地址3','address3','varchar(250)',1,1,5)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'zipcode','邮编','zip code','varchar(10)',1,1,6)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'city','城市','city','int',3,58,7)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'country','国家','country','int',1,2,8)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'province','省份','province','int',1,2,9)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'county','县','county','varchar(50)',1,1,10)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'phone','联系电话','phone','varchar(50)',1,1,11)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'fax','传真','fax','varchar(50)',1,1,12)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'email','电子邮箱','email','varchar(150)',1,1,13)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'website','网址','website','varchar(150)',1,1,14)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'source','联系方式','contact way','int',1,2,15)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'sector','行业部门','sector','int',1,2,16)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'manager','管理人','manager','int',3,1,17)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'manager','管理人','manager','int',3,7,18)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'parentid','上一级客户','parent customer','int',3,7,19)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'department','部门','department','int',3,4,20)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'documentid','相关文档','related document','int',3,9,21)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'size_n','规模','size','int',3,62,22)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'type','类型','type','int',3,60,23)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'typebegin','起始日期','begin date','char(10)',3,2,24)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'description','客户描述','description','int',3,61,25)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'status','客户状态','status','int',1,2,26)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'createdate','创建日期','create date','char(10)',3,2,27)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'introductionDocid','背景资料','introduction','int',3,9,28)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'evaluation','客户价值','evaluation','int',1,2,29)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'CreditAmount','信用金额额度','credit amount','decimal(15,3)',1,3,30)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'CreditTime','信用期间','CreditTime','int',1,2,31)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'bankName','开户银行','name of bank','varchar(200)',1,1,32)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'accountName','开户银行','name of account','varchar(40)',1,1,33)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'accounts','银行帐号','account','varchar(200)',1,1,34)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'crmcode','客户编码','code of customer','varchar(100)',1,1,35)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('CRM_ContactWay','客户联系方式表','contact way with customer',0,3,'客户联系方式表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(20,'fullname','联系方法名称','name of contract way','varchar(50)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(20,'description','联系方法描述','description of contract way','varchar(150)',1,1,2)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('CRM_SectorInfo','客户区域信息表','customer sector information',0,3,'客户区域信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(21,'fullname','名称','name','varchar(50)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(21,'description','描述','description','varchar(150)',1,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(21,'parentid','上一级行业','parent sector','int',1,2,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(21,'seclevel','行业级别','sector level','int',1,2,4)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('CRM_CustomerSize','客户规模表','company size',0,3,'客户规模表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(22,'fullname','规模','size','varchar(50)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(22,'description','描述','description','varchar(150)',1,1,2)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('CRM_CustomerType','客户类型表','customer type',0,3,'客户类型表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(23,'fullname','名称','name','varchar(50)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(23,'description','描述','description','varchar(150)',1,1,2)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('CRM_CustomerDesc','客户描述表','customer description',0,3,'客户描述表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(24,'fullname','名称','name','varchar(50)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(24,'description','描述','description','varchar(150)',1,1,2)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('CRM_CustomerStatus','客户状态表','customer status',0,3,'客户状态表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(25,'fullname','名称','name','varchar(50)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(25,'description','描述','description','varchar(150)',1,1,2)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('CRM_Evaluation_Level','客户价值表','customer evaluation',0,3,'客户价值表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(26,'name','名称','name','varchar(50)',1,1,1)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('Prj_ProjectInfo','项目信息表','project information',0,4,'客户信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'name','项目名称','name of project','varchar(50)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'description','项目描述','description of project','varchar(2000)',1,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'prjtype','项目类型','type of project','int',3,138,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'worktype','工作类型','type of work','int',3,139,4)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'securelevel','安全级别','securety level','int',1,2,5)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'status','项目状态','project status','int',1,2,6)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'planbegindate','预计开始日期','begin date','char(10)',3,2,7)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'planbegintime','预计开始时间','begin time','char(5)',3,19,8)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'planenddate','预计结束日期','end date','char(10)',3,2,9)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'planendtime','预计结束时间','end time','char(5)',3,19,10)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'truebegindate','实际开始日期','begin date','char(10)',3,2,11)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'truebegintime','实际开始时间','begin time','char(5)',3,19,12)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'trueenddate','实际结束日期','end date','char(10)',3,2,13)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'trueendtime','实际结束时间','end time','char(5)',3,19,14)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'planmanhour','预计工时','expecting man-hour','int',1,2,15)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'truemanhour','实际工时','actual man-hour','int',1,2,16)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'parentid','上级项目','parent project','int',3,8,17)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'envaluedoc','评价书','envalue document','int',3,9,18)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'confirmdoc','确认书','confirm document','int',3,9,19)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'proposedoc','建议书','propose document','int',3,9,20)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'manager','项目经理','manager of project','int',3,1,21)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'department','项目部门','department of project','int',3,4,22)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'creater','项目创建人','creater of project','int',3,1,23)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'createdate','创建日期','create date of project','char(10)',3,2,24)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'createtime','创建时间','create time of project','char(8)',3,19,25)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'subcompanyid1','项目分部','subcompany of project','int',3,42,26)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'proCode','项目编码','code of project','varchar(50)',1,1,27)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'factBeginDate','实际开始日期','actualily begin date of project','char(10)',3,2,28)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'factEndDate','实际结束日期','actualily end time of project','char(8)',3,19,29)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('Prj_ProjectType','项目类型表','project type information',0,4,'项目类型表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(28,'fullname','项目类型名称','name of project type','varchar(50)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(28,'description','项目类型描述','description of project type','varchar(150)',1,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(28,'protypecode','项目类型编码','code of project type','varchar(50)',1,1,3)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('Prj_WorkType','工作类型表','work type information',0,4,'工作类型表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(29,'fullname','工作类型名称','name of work type','varchar(50)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(29,'description','工作类型描述','description of work type','varchar(150)',1,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(29,'protypecode','工作类型编码','code of work type','varchar(50)',1,1,3)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('Prj_ProjectStatus','项目状态表','project status',0,4,'项目状态表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(30,'fullname','项目状态名称','name of project status','varchar(50)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(30,'description','项目状态描述','description of project status','varchar(150)',1,1,2)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('CptCapital','资产信息表','capital information',0,5,'资产信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'mark','编号','mark','varchar(60)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'name','名称','name','varchar(60)',1,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'startdate','生效日','valid date','char(10)',3,2,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'enddate','生效日','invalid date','char(10)',3,2,4)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'seclevel','安全级别','security level','int',1,2,5)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'departmentid','部门','department','int',3,4,6)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'resourceid','人力资源','humen resource','int',3,4,7)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'crmid','客户','customer','int',3,7,8)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'currencyid','币种','currency','int',3,12,9)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'capitalcost','成本','cost of capital','decimal(15,3)',1,3,10)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'startprice','开始价格','original price','decimal(15,3)',1,3,11)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'depreendprice','折旧底价','price of depreciation','decimal(15,3)',1,3,12)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'capitalspec','规格型号','model of capital','varchar(60)',1,1,13)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'capitallevel','资产等级','level of capital','varchar(30)',1,1,14)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'manufacturer','制造厂商','manufacture facturer','varchar(100)',1,1,15)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'manudate','出厂日期','factory date','char(10)',3,2,16)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'capitaltypeid','出厂日期','type of capital','int',1,2,17)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'capitalgroupid','资产组','group of capital','int',3,25,18)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'unitid','计量单位','unit','int',1,2,19)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'capitalnum','数量','amount of capital','decimal(18,1)',1,3,20)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'currentnum','当前数量','current amount of capital','int',1,2,21)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'version','版本','version','varchar(60)',1,1,22)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'remark','备注','remark','text',2,0,23)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'replacecapitalid','替代','replace capital','int',3,23,24)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'customerid','供应商','providing customer','int',1,2,25)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'location','存放地点','location','varchar(100)',1,1,26)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'usedhours','使用的小时数','used hours','decimal(18,3)',1,3,27)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'createrid','创建者','creater','int',3,1,28)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'createdate','创建日期','create date','char(10)',3,2,29)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'createtime','创建时间','create time','char(8)',3,19,30)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'lastmoderid','最后修改者','last moderfyer','int',3,1,31)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'lastmoddate','修改日期','date of last modifying','char(10)',3,2,32)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'lastmodtime','修改时间','time of last modifying','char(8)',3,19,33)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'fnamark','财务编号','financial mark','varchar(60)',1,1,34)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'alertnum','资产库存预警数','lowest stock number','int',1,2,35)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'invoice','发票号码','invoice no.','varchar(80)',1,1,36)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'StockInDate','入库日期','date of stocking in','char(10)',3,2,37)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'SelectDate','购置日期','date of purchase','char(10)',3,2,38)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('CptCapitalType','资产类型表','capital type information',0,5,'资产类型表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(32,'name','名称','name','varchar(60)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(32,'description','描述','description','varchar(200)',1,1,2)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('CptCapitalAssortment','资产组表','capital group information',0,5,'资产组表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(33,'assortmentname','名称','assortment name','varchar(60)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(33,'assortmentremark','备注','assortment remark','text',2,0,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(33,'supassortmentid','上级资产组','super assortment','int',3,25,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(33,'subassortmentcount','下级资产组个数','count of subordinate assortment','int',1,2,4)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(33,'capitalcount','资产资料个数','count of capital','int',1,2,5)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(33,'assortmentmark','编号','code of assortment','varchar(30)',1,1,6)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('LgcAssetUnit','计量单位表','unit information',0,5,'计量单位表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(34,'unitname','名称','unit name','varchar(60)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(34,'unitdesc','描述','unit description','varchar(200)',1,1,2)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('Meeting','会议信息表','meeting information',0,7,'会议信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'meetingtype','会议类型','meeting type','varchar(60)',1,2,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'name','会议名称','meeting name','varchar(255)',1,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'caller','召集人','caller','int',3,1,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'contacter','联系人','contacter','int',3,1,4)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'begindate','开始日期','begindate','char(10)',3,2,5)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'begintime','开始时间','begintime','char(8)',3,19,6)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'enddate','结束日期','enddate','char(10)',3,2,7)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'endtime','结束时间','endtime','char(8)',3,19,8)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'desc_n','备注','description','varchar(4000)',1,1,9)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'creater','创建人','creater','int',3,1,10)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'createdate','创建日期','createdate','char(10)',3,2,11)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'createtime','创建时间','createtime','char(8)',3,19,12)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'approver','审批人','approver','int',3,1,13)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'approvedate','审批日期','date of approving','char(10)',3,2,14)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'approvetime','审批时间','time of approving','char(8)',3,19,15)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'decision','决议概述','decision','text',2,0,16)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'decisiondate','决议日期','date of decision','char(10)',1,2,17)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'decisiontime','决议时间','time of decision','char(8)',1,19,18)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'decisionhrmid','决议人','people of decision','int',3,1,19)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'projectid','相关项目','project','int',3,8,20)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'totalmember','应到人数','total members','int',1,2,21)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'address','会议地点','address','int',3,87,22)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'addressdesc','会议地址','description of address','varchar(255)',1,1,23)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'customizeAddress','自定义会议地点','customize address','varchar(400)',1,1,24)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'canceldate','撤消日期','cancel date','char(10)',3,2,25)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'canceltime','撤消时间','cancel time','char(8)',3,19,26)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('Meeting_Type','会议类型表','meeting type information',0,7,'会议类型表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(36,'name','类型名称','name','varchar(255)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(36,'desc_n','类型描述','description','varchar(255)',1,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(36,'subcompanyid','所属分部','subcompanyid','int',3,42,3)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('MeetingRoom','会议室表','meeting rooms',0,7,'会议室表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(37,'name','会议室名称','name of meetingroom','varchar(100)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(37,'roomdesc','会议室描述','description of meetingroom','varchar(100)',1,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(37,'hrmid','会议室负责人','principal of meetingroom','int',3,1,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(37,'subcompanyid','所属分部','subcompany of meetingroom','int',3,42,4)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('FnaCurrency','币种信息表','currency information',0,6,'币种信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(38,'currencyname','币种名称','name of currency','varchar(60)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(38,'currencydesc','币种名称','description of currency','varchar(200)',1,1,2)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('FnaBudgetfeeType','预算科目信息表','subjects of budget',0,6,'预算科目信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(39,'name','预算科目名称','name of subject','varchar(50)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(39,'description','预算科目描述','description of subject','varchar(250)',1,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(39,'supsubject','父级科目','super subject','int',1,2,3)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('CRM_Contract','合同信息表','contract information',0,3,'合同信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(40,'name','合同名称','name of contract','varchar(100)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(40,'typeId','合同性质','type of contract','int',1,2,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(40,'price','合同金额','total money of contract','decimal(17,2)',1,3,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(40,'crmId','相关客户','customer','int',3,7,4)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(40,'contacterId','联系人','contacter','int',3,1,5)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(40,'startDate','开始时间','begin date','char(10)',3,2,6)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(40,'endDate','结束时间','end date','char(10)',3,2,7)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(40,'manager','负责人','manager','int',3,1,8)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(40,'creater','创建人','creater','int',3,1,9)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(40,'createDate','创建日期','create date','char(10)',3,2,10)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(40,'createTime','创建时间','create time','char(10)',3,19,11)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(40,'projid','相关项目','related project','int',3,8,12)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(40,'department','部门','department','int',3,4,13)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(40,'subcompanyid1','分部','subcompany','int',3,42,14)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(40,'sellChanceId','销售机会','chance to sell','int',1,2,15)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('CRM_ContractType','合同性质表','contract type information',0,3,'合同性质表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(41,'name','合同性质名称','name of contract type','varchar(100)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(41,'contractdesc','合同性质描述','description of contract type','varchar(200)',1,1,2)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('CRM_SellChance','销售机会信息表','information of chance to sell',0,3,'销售机会信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(42,'subject','主题','subject','varchar(50)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(42,'creater','创建者','creater','int',3,1,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(42,'customerid','客户','customer','int',3,7,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(42,'sellstatusid','销售状态','sell status','int',1,2,4)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(42,'predate','销售预期','plan date to sell','char(10)',3,2,5)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(42,'preyield','预期收益','plan income','decimal(18,2)',1,3,6)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(42,'currencyid','币种','currencyid','int',3,12,7)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(42,'probability','销售预测','probability','decimal(8,2)',1,3,8)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(42,'createdate','创建日期','createdate','char(10)',3,2,9)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(42,'createtime','创建时间','createtime','char(8)',3,19,10)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(42,'content','主题','content','text',2,0,11)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(42,'approver','审批人','approver','int',3,1,12)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(42,'approvedate','审批日期','approve date','char(10)',3,2,13)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(42,'approvetime','审批时间','approve time','char(10)',3,19,14)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(42,'departmentId','客户经理部门','department','int',3,4,15)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(42,'subCompanyId','客户经理分部','subcompany','int',3,42,16)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('CRM_SellStatus','销售状态信息表','information of status to sell',0,3,'销售状态信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(43,'fullname','名称','name','varchar(50)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(43,'description','描述','description','varchar(150)',1,1,2)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('CRM_ContractProduct','客户合同产品目录信息表','products of contract',0,3,'客户合同产品目录信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(44,'contractId','合同','contract','int',1,2,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(44,'productId','产品','product','int',1,2,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(44,'unitId','单位','unit','int',1,2,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(44,'number_n','交货数量','numbers of consignment','decimal(10,2)',1,3,4)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(44,'price','单价','price of product','decimal(17,2)',1,3,5)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(44,'currencyId','货币','currency','int',3,12,6)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(44,'depreciation','折扣','depreciation','int',1,2,7)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(44,'sumPrice','总额','total prices','decimal(17,2)',1,3,8)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(44,'planDate','交货日期','plan date of consignment','char(10)',3,2,9)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(44,'factnumber_n','实际交货数量','true numbers of consignment','int',1,2,10)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(44,'factDate','实际交货日期','true date of consignment','char(10)',3,2,11)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(44,'lasttotelprice','最终总价','final totel price','decimal(18,4)',1,3,12)
GO

insert into Sys_tabledict(tablename,tabledesc,tabledescen,tabletype,modetype,memo) values('LgcAssetCountry','产品信息表','products information',0,3,'产品信息表')
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(45,'assetname','产品名称','name of product','varchar(60)',1,1,1)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(45,'startdate','开始日期','startdate','char(10)',3,2,2)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(45,'enddate','结束时间','enddate','char(10)',3,2,3)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(45,'departmentid','部门','department','int',3,4,4)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(45,'resourceid','人力资源','humen resource','int',3,1,5)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(45,'assetremark','产品说明','remark of product','text',2,0,6)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(45,'currencyid','币种','currency','int',3,12,7)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(45,'salesprice','销售价格','price of product','decimal(18,3)',1,3,8)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(45,'costprice','成本价格','cost of product','decimal(18,3)',1,3,9)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(45,'createrid','创建者','creater','int',3,1,10)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(45,'createdate','创建日期','create date','char(10)',3,2,11)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(45,'lastmoderid','最后修改者','last modifyer','int',3,1,12)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(45,'lastmoddate','最后修改日期','last modifying date','char(10)',3,2,13)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(1,'id','人员id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(2,'id','国家id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(3,'id','工作地点id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(4,'id','岗位id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(5,'id','部门id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(6,'id','分部id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(7,'id','银行id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(8,'id','教育情况id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(9,'id','职称id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(10,'id','城市id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(11,'id','省份id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(12,'id','职责id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(13,'id','职务类型id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(14,'id','专业id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(15,'id','文档id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(16,'id','文档主目录id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(17,'id','文档分目录id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(18,'id','文档子目录id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(19,'id','客户id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(20,'id','客户联系方式id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(21,'id','客户区域id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(22,'id','客户规模id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(23,'id','客户类型id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(24,'id','客户描述id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(25,'id','客户状态id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(26,'id','客户价值id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(27,'id','项目id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(28,'id','项目类型id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(29,'id','工作类型id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(30,'id','项目状态id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(31,'id','资产id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(32,'id','资产类型id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(33,'id','资产组id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(34,'id','计量单位id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(35,'id','会议id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(36,'id','会议类型id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(37,'id','会议室id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(38,'id','币种id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(39,'id','预算科目id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(40,'id','合同id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(41,'id','合同性质id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(42,'id','销售机会id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(43,'id','销售状态id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(44,'id','客户合同产品目录id','key','int',1,2,0)
GO
insert into Sys_fielddict(tabledictid,fieldname,fielddesc,fielddescen,fielddbtype,fieldhtmltype,type,dsporder) values(45,'id','产品id','key','int',1,2,0)
GO
