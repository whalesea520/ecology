drop table workflow_form
GO

CREATE TABLE workflow_form (
	requestid int NOT NULL ,
	billformid int NULL ,
	billid int NULL ,
	totaltime decimal(10, 3) NULL ,
	department int NULL ,
	relatedcustomer int NULL ,
	relatedresource int NULL ,
	relateddocument int NULL ,
	relatedrequest int NULL ,
	userdepartment int NULL ,
	startrailwaystation int NULL ,
	subject varchar (200)  ,
	hotellevel int NULL ,
	integer1 int NULL ,
	desc1 varchar (100)  ,
	desc2 varchar (100)  ,
	desc3 varchar (100)  ,
	desc4 varchar (100)  ,
	desc5 varchar (100)  ,
	desc6 varchar (100)  ,
	desc7 varchar (100)  ,
	integer2 int NULL ,
	reception_important int NULL ,
	check2 char (1)  ,
	check3 char (1)  ,
	check4 char (1)  ,
	textvalue1 text  ,
	textvalue2 text  ,
	textvalue3 text  ,
	textvalue4 text  ,
	textvalue5 text  ,
	textvalue6 text  ,
	textvalue7 text  ,
	softwaregetway int NULL ,
	decimalvalue1 decimal(10, 3) NULL ,
	decimalvalue2 decimal(10, 3) NULL ,
	manager int NULL ,
	jobtitle int NULL ,
	jobtitle2 int NULL ,
	document int NULL ,
	Customer int NULL ,
	Project int NULL ,
	resource_n int NULL ,
	item int NULL ,
	request int NULL ,
	mutiresource text  ,
	muticustomer text  ,
	remark text  ,
	description varchar (100)  ,
	begindate char (10)  ,
	begintime char (5)  ,
	enddate char (10)  ,
	endtime char (5)  ,
	totaldays int NULL ,
	check1 char (1)  ,
	amount decimal(10, 3) NULL ,
	startairport int NULL ,
	airways int NULL ,
	payoptions int NULL ,
	expresstype int NULL ,
	jtgj int NULL ,
	absencetype int NULL ,
	zc int NULL ,
	zczl int NULL ,
	fwcp int NULL ,
	muticareer text  ,
	date1 char (10)  ,
	date2 char (10)  ,
	date3 char (10)  ,
	date4 char (10)  ,
	date5 char (10)  ,
	date6 char (10)  ,
	time1 char (5)  ,
	time2 char (5)  ,
	time3 char (5)  ,
	time4 char (5)  ,
	time5 char (5)  ,
	time6 char (5)  ,
	resource1 int NULL ,
	date_n char (10)  ,
	relatmeeting int NULL ,
	itservice int NULL ,
	cplx int NULL ,
	gzlx int NULL  
) 
GO

CREATE TABLE license (
	companyname varchar (100)  ,
	license varchar (100)  ,
	hrmnum int ,
	expiredate varchar (10),
	cversion varchar (10)
) 
GO

insert into license(companyname,license,hrmnum,expiredate,cversion) values('Company Type 1','no',10000,'9999-01-01','2.0')
GO

insert into SystemRightRoles (rightid,roleid,rolelevel) values (120,4,'1')
GO
insert into SystemRightRoles (rightid,roleid,rolelevel) values (121,4,'1')
GO
insert into SystemRightToGroup (groupid,rightid) values (3,120)
GO
insert into SystemRightToGroup (groupid,rightid) values (3,121)
GO


insert into HrmRoles (rolesmark,rolesname,docid) values ('总经理','总经理',0)
GO
insert into HrmRoles (rolesmark,rolesname,docid) values ('财务经理','财务经理',0)
GO
insert into HrmRoles (rolesmark,rolesname,docid) values ('出纳','出纳',0)
GO
insert into HrmRoles (rolesmark,rolesname,docid) values ('资产管理员','资产管理员',0)
GO
insert into HrmRoles (rolesmark,rolesname,docid) values ('信息管理员','信息管理员',0)
GO
insert into HrmRoles (rolesmark,rolesname,docid) values ('信息经理','信息经理',0)
GO
insert into HrmRoles (rolesmark,rolesname,docid) values ('行政助理','行政助理',0)
GO
insert into HrmRoles (rolesmark,rolesname,docid) values ('行政经理','行政经理',0)
GO
insert into HrmRoles (rolesmark,rolesname,docid) values ('公章管理员','公章管理员',0)
GO
insert into HrmRoles (rolesmark,rolesname,docid) values ('人事经理','人事经理',0)
GO
insert into HrmRoles (rolesmark,rolesname,docid) values ('人事助理','人事助理',0)
GO

update HrmRoleMembers set resourceid = '1' where id='1'
GO
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (12,1,'2')
GO
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (13,2,'2')
GO
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (14,2,'2')
GO
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (15,2,'2')
GO
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (16,2,'2')
GO
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (17,2,'2')
GO
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (18,2,'2')
GO
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (19,2,'2')
GO
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (20,2,'2')
GO
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (21,2,'2')
GO
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (22,2,'2')
GO






insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (27,0,0,'事假')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (27,0,1,'病假')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (27,0,2,'婚假')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (27,0,3,'丧假')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (27,0,5,'产假')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (27,0,7,'年休假')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (27,0,4,'工伤假')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (27,0,6,'奖励假')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (31,0,0,'公司支付')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (31,0,1,'自己垫付')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (32,0,0,'重要')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (32,0,1,'一般')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (33,0,0,'网络下载（共享软件）')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (33,0,1,'公司软件')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (33,0,2,'外部购买')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (69,0,0,'浦东机场')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (69,0,1,'虹桥机场')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (71,0,0,'新客站')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (71,0,2,'南站')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (71,0,1,'西站')
GO



insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (72,0,0,'五星级')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (72,0,1,'四星级')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (72,0,2,'三星级')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (72,0,3,'二星级')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (72,0,4,'一星级')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (72,0,5,'普通')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (73,0,0,'EMS')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (73,0,1,'快递')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (75,0,1,'火车')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (75,0,0,'汽车')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (75,0,2,'飞机')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (78,0,0,'CMS')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (78,0,1,'Web Design')
GO


insert into workflow_formdict (fieldname,fielddbtype,fieldhtmltype,type) values ('itservice','int','5',0)
GO
insert into workflow_formdict (fieldname,fielddbtype,fieldhtmltype,type) values ('cplx','int','5',1)
GO
insert into workflow_formdict (fieldname,fielddbtype,fieldhtmltype,type) values ('gzlx','int','5',1)
GO


insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (79,0,1,'软件使用')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (79,0,0,'技术支持')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (79,0,2,'设备更新')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (80,0,0,'火车票')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (80,0,1,'汽车票')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (81,0,0,'业务章')
GO
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (81,0,1,'公司章')
GO





/* 2003 年 3 月 22日 为系统优化 */
alter table hrmresource add managerstr varchar(200)
GO

create NONCLUSTERED INDEX docdetail_res_in on DocDetail(doccreaterid)
GO
create NONCLUSTERED INDEX docdetail_dep_in on DocDetail(docdepartmentid)
GO
create NONCLUSTERED INDEX hrmdepartment_sub_in on HrmDepartment(subcompanyid1)
GO

/* 2003 年 3 月 25日 为邮件系统 */
alter table SystemSet add defmailuser varchar(100) 
GO
alter table SystemSet add defmailpassword varchar(100) 
GO



/* 2003 年 3 月 22日 为系统优化 */
alter PROCEDURE HrmResource_Insert 
 (@resourceid int,
@loginid_1 	varchar(60), 
@password_2 	varchar(100), 
@firstname_3 	varchar(60),
@lastname_4 	varchar(60), 
@aliasname_5 	varchar(60), 
@titleid_6 	int,
 @sex_8 	char(1), 
@birthday_9 	char(10),
 @nationality_10 	int, 
@defaultlanguage_11 	int, 
@systemlanguage_12 	int, 
@maritalstatus_13 	char(1), 
@marrydate_14 	char(10), 
@telephone_15 	varchar(60), 
@mobile_16 	varchar(60), 
@mobilecall_17 	varchar(60), 
@email_18 	varchar(60), 
@countryid_19 	int, 
@locationid_20 	int, 
@workroom_21 	varchar(60), 
@homeaddress_22 	varchar(100), 
@homepostcode_23 	varchar(20),
 @homephone_24 	varchar(60), 
@resourcetype_25 	char(1), 
@startdate_26 	char(10),
 @enddate_27 	char(10), 
@contractdate_28 	char(10),
 @jobtitle_29 	int, 
@jobgroup_30 	int,
 @jobactivity_31 	int,
 @jobactivitydesc_32 	varchar(200), 
@joblevel_33 	tinyint, 
@seclevel_34 	tinyint,
 @departmentid_35 	int,
 @subcompanyid1_36 	int, 
@subcompanyid2_37 	int,
 @subcompanyid3_38 	int, 
@subcompanyid4_39 	int, 
@costcenterid_40 	int, 
@managerid_41 	int, 
@assistantid_42 	int, 
@purchaselimit_43 	decimal,
@currencyid_44 	int, 
@bankid1_45 	int, 
@accountid1_46 	varchar(100), 
@bankid2_47 	int, 
@accountid2_48 	varchar(100), 
@securityno_49 	varchar(100),
 @creditcard_50 	varchar(100), 
@expirydate_51 	char(10), 
@resourceimageid_52 	int, 
@createrid_53 	int, 
@createdate_54 	char(10), 
@lastmodid_55 	int, 
@lastmoddate_56 	char(10), 
@datefield1 	varchar(10),
 @datefield2 	varchar(10),
 @datefield3 	varchar(10),
 @datefield4 	varchar(10),
 @datefield5 	varchar(10),
 @numberfield1 	float,
 @numberfield2 	float,
 @numberfield3 	float,
 @numberfield4 	float,
 @numberfield5 	float,
 @textfield1 	varchar(100), 
@textfield2 	varchar(100), 
@textfield3 	varchar(100), 
@textfield4 	varchar(100), 
@textfield5 	varchar(100), 
@tinyintfield1 tinyint, 
@tinyintfield2 tinyint, 
@tinyintfield3 tinyint,
 @tinyintfield4 tinyint, 
@tinyintfield5 tinyint, 
@certificatecategory	varchar(30),			
@certificatenum		varchar(60),			
@nativeplace		varchar(100),			
@educationlevel		char(1),			
@bememberdate		char(10),			
@bepartydate		char(10),		
@bedemocracydate		char(10),			
@regresidentplace	varchar(60),				
@healthinfo		char(1),			
@residentplace		varchar(60),			
@policy			varchar(30),			
@degree			varchar(30),			
@height			varchar(10),		
@homepage		varchar(100),			
@train			text,				
@worktype		varchar(60),			
@usekind			int,				
@workcode		varchar(60),			
@contractbegintime	char(10),			
@jobright		varchar(100),	
@jobcall			int,		
@jobtype			int,	
@accumfundaccount	varchar(30),	
@birthplace		varchar(60),
@folk			varchar(30),
@residentphone		varchar(60),
@residentpostcode	varchar(60),
@extphone       	varchar(50),
@flag                             integer output, 
@msg                             varchar(80) output)  
AS if @titleid_6=0 set @titleid_6 = null
 if @nationality_10=0 set @nationality_10 = null 
if @defaultlanguage_11=0 set @defaultlanguage_11 = null if @systemlanguage_12 = 0 set @systemlanguage_12 = null if @countryid_19 = 0 set @countryid_19 = null if @locationid_20 = 0 set @locationid_20 = null if @jobtitle_29 = 0 set @jobtitle_29 = null if @jobgroup_30 = 0 set @jobgroup_30 = null if @jobactivity_31 = 0 set @jobactivity_31 = null if @departmentid_35 = 0 set @departmentid_35 = null if @subcompanyid1_36 = 0 set @subcompanyid1_36 = null if @subcompanyid2_37 = 0 set @subcompanyid2_37 = null if @subcompanyid3_38 = 0 set @subcompanyid3_38 = null if @subcompanyid4_39 = 0 set @subcompanyid4_39 = null if @costcenterid_40 = 0 set @costcenterid_40 = null if @managerid_41 = 0 set @managerid_41 = null if @assistantid_42 = 0 set @assistantid_42 = null if @currencyid_44 = 0 set @currencyid_44 = null if @bankid1_45 = 0 set @bankid1_45 = null 
if @bankid2_47 = 0 set @bankid2_47 = null 
if @usekind = 0 set @usekind = null 
if @jobcall = 0 set @jobcall = null 
if @jobtype = 0 set @jobtype = null 

declare @count   int , @managerstr_1 varchar(200)

/*判断是否有重复登录名*/
select @count=count(*) from HrmResource where loginid = @loginid_1
if @count<>0
begin
select -1
return
end

select @managerstr_1 = managerstr from hrmresource where id = @managerid_41
if @managerstr_1 is null  set @managerstr_1 = ''
set @managerstr_1 = @managerstr_1 + convert(varchar(5),@managerid_41) + ','

 INSERT INTO HrmResource (id,loginid, 
password, firstname, lastname, aliasname, titleid, sex, birthday, nationality, 
defaultlanguage, systemlanguage, maritalstatus, marrydate, telephone, mobile, mobilecall, email, countryid, locationid,
 workroom, homeaddress, homepostcode, homephone, resourcetype, startdate, enddate, contractdate, jobtitle, jobgroup, 
jobactivity, jobactivitydesc, joblevel, seclevel, departmentid, subcompanyid1, subcompanyid2, subcompanyid3, subcompanyid4,
 costcenterid, managerid, assistantid, purchaselimit, currencyid, bankid1, accountid1, bankid2, accountid2, securityno,
 creditcard, expirydate, resourceimageid, createrid, createdate, lastmodid, lastmoddate, datefield1, datefield2, datefield3,
datefield4, datefield5, numberfield1, numberfield2, numberfield3, numberfield4, numberfield5, textfield1, textfield2, textfield3,
 textfield4, textfield5, tinyintfield1, tinyintfield2, tinyintfield3, tinyintfield4, tinyintfield5,
certificatecategory,		
certificatenum,				
nativeplace,					
educationlevel,					
bememberdate,					
bepartydate,			
bedemocracydate,				
regresidentplace,				
healthinfo,		
residentplace,						
policy,						
degree,						
height,				
homepage,				
train,						
worktype,			
usekind,							
workcode,					
contractbegintime,				
jobright,		
jobcall,		
jobtype,	
accumfundaccount,
birthplace,
folk,
residentphone,
residentpostcode,
extphone,
managerstr)
VALUES ( @resourceid,@loginid_1, @password_2, @firstname_3, @lastname_4, @aliasname_5, @titleid_6, @sex_8,
 @birthday_9, @nationality_10, @defaultlanguage_11, @systemlanguage_12, @maritalstatus_13, @marrydate_14, 
@telephone_15, @mobile_16, @mobilecall_17, @email_18, @countryid_19, @locationid_20, @workroom_21, @homeaddress_22,
 @homepostcode_23, @homephone_24, @resourcetype_25, @startdate_26, @enddate_27, @contractdate_28, @jobtitle_29, @jobgroup_30, 
@jobactivity_31, @jobactivitydesc_32, @joblevel_33, @seclevel_34, @departmentid_35, @subcompanyid1_36, @subcompanyid2_37, 
@subcompanyid3_38, @subcompanyid4_39, @costcenterid_40, @managerid_41, @assistantid_42, @purchaselimit_43, @currencyid_44, 
@bankid1_45, @accountid1_46, @bankid2_47, @accountid2_48, @securityno_49, @creditcard_50, @expirydate_51, @resourceimageid_52,
 @createrid_53, @createdate_54, @lastmodid_55, @lastmoddate_56, @datefield1, @datefield2, @datefield3, @datefield4, 
@datefield5, @numberfield1, @numberfield2, @numberfield3, @numberfield4, @numberfield5, @textfield1, @textfield2, @textfield3, 
@textfield4, @textfield5, @tinyintfield1, @tinyintfield2, @tinyintfield3, @tinyintfield4, @tinyintfield5,
@certificatecategory,		
@certificatenum,				
@nativeplace,					
@educationlevel,					
@bememberdate,					
@bepartydate,			
@bedemocracydate,				
@regresidentplace,				
@healthinfo,		
@residentplace,						
@policy,						
@degree,						
@height,				
@homepage,				
@train,						
@worktype,			
@usekind,							
@workcode,					
@contractbegintime,				
@jobright,		
@jobcall,		
@jobtype,	
@accumfundaccount,
@birthplace,
@folk,
@residentphone,
@residentpostcode,
@extphone,
@managerstr_1
)  

SELECT max(id) FROM HrmResource  if @@error<>0 begin set @flag=1 set @msg='插入人力资源信息失败' return end else begin set @flag=0 set @msg='插入人力资源信息成功' return end
GO



alter PROCEDURE HrmResource_Update 
 (@id_1 	int, @loginid_2 	varchar(60), @password_3 	varchar(100), @firstname_4 	varchar(60), @lastname_5 	varchar(60), @aliasname_6 	varchar(60), @titleid_7 	int, @sex_9 	char(1), @birthday_10 	char(10), @nationality_11 	int, @defaultlanguage_12 	int, @systemlanguage_13 	int, @maritalstatus_14 	char(1), @marrydate_15 	char(10), @telephone_16 	varchar(60), @mobile_17 	varchar(60), @mobilecall_18 	varchar(60), @email_19 	varchar(60), @countryid_20 	int, @locationid_21 	int, @workroom_22 	varchar(60), @homeaddress_23 	varchar(100), @homepostcode_24 	varchar(20), @homephone_25 	varchar(60), @resourcetype_26 	char(1), @startdate_27 	char(10), @enddate_28 	char(10), @contractdate_29 	char(10), @jobtitle_30 	int, @jobgroup_31 	int, @jobactivity_32 	int, @jobactivitydesc_33 	varchar(200), @joblevel_34 	tinyint, @seclevel_35 	tinyint, @departmentid_36 	int, @subcompanyid1_37 	int, @subcompanyid2_38 	int, @subcompanyid3_39 	int, @subcompanyid4_40 	int, @costcenterid_41 	int, @managerid_42 	int, @assistantid_43 	int, @purchaselimit_44 	decimal, @currencyid_45 	int, @bankid1_46 	int, @accountid1_47 	varchar(100), @bankid2_48 	int, @accountid2_49 	varchar(100), @securityno_50 	varchar(100), @creditcard_51 	varchar(100), @expirydate_52 	char(10), @resourceimageid_53 	int, @lastmodid_54 	int, @lastmoddate_55 	char(10), @datefield1 	varchar(10), @datefield2 	varchar(10), @datefield3 	varchar(10), @datefield4 	varchar(10), @datefield5 	varchar(10), @numberfield1 	float, @numberfield2 	float, @numberfield3 	float, @numberfield4 	float, @numberfield5 	float, @textfield1 	varchar(100), @textfield2 	varchar(100), @textfield3 	varchar(100), @textfield4 	varchar(100), @textfield5 	varchar(100), @tinyintfield1 	tinyint, @tinyintfield2 	tinyint, @tinyintfield3 	tinyint, @tinyintfield4 	tinyint, @tinyintfield5 	tinyint, 
@certificatecategory	varchar(30),			
@certificatenum		varchar(60),			
@nativeplace		varchar(100),			
@educationlevel		char(1),			
@bememberdate		char(10),			
@bepartydate		char(10),		
@bedemocracydate		char(10),			
@regresidentplace	varchar(60),			
@healthinfo		char(1),			
@residentplace		varchar(60),			
@policy			varchar(30),			
@degree			varchar(30),			
@height			varchar(10),		
@homepage		varchar(100),			
@train			text,				
@worktype		varchar(60),			
@usekind			int,				
@workcode		varchar(60),			
@contractbegintime	char(10),			
@jobright		varchar(100),			
@jobcall			int,				
@jobtype			int,			
@accumfundaccount	varchar(30),	
@birthplace		varchar(60),
@folk			varchar(30),
@residentphone		varchar(60),
@residentpostcode	varchar(60),
@extphone		varchar(50),
@flag                             integer output, @msg                             varchar(80) output) 

AS if @titleid_7=0 set @titleid_7 = null if @nationality_11=0 set @nationality_11 = null if @defaultlanguage_12=0 set @defaultlanguage_12 = null if @systemlanguage_13 = 0 set @systemlanguage_13 = null if @countryid_20 = 0 set @countryid_20 = null if @locationid_21 = 0 set @locationid_21 = null if @jobtitle_30 = 0 set @jobtitle_30 = null if @jobgroup_31 = 0 set @jobgroup_31 = null if @jobactivity_32 = 0 set @jobactivity_32 = null if @departmentid_36 = 0 set @departmentid_36 = null if @subcompanyid1_37 = 0 set @subcompanyid1_37 = null if @subcompanyid2_38 = 0 set @subcompanyid2_38 = null if @subcompanyid3_39 = 0 set @subcompanyid3_39 = null if @subcompanyid4_40 = 0 set @subcompanyid4_40 = null if @costcenterid_41 = 0 set @costcenterid_41 = null if @managerid_42 = 0 set @managerid_42 = null if @assistantid_43 = 0 set @assistantid_43 = null if @currencyid_45 = 0 set @currencyid_45 = null if @bankid1_46 = 0 set @bankid1_46 = null
if @bankid2_48 = 0 set @bankid2_48 = null 
if @usekind = 0 set @usekind = null 
if @jobcall = 0 set @jobcall = null 
if @jobtype = 0 set @jobtype = null 

/*判断是否有重复登录名*/
declare @count int
select @count=count(*) from HrmResource where loginid = @loginid_2 and id<>@id_1
if @count<>0
begin
select -1
return
end

declare @managerstr_1 varchar(200)

select @managerstr_1 = managerstr from hrmresource where id = @managerid_42
if @managerstr_1 is null  set @managerstr_1 = ''
set @managerstr_1 = @managerstr_1 + convert(varchar(5),@managerid_42) + ','

if @password_3 != '0'
 UPDATE HrmResource  SET  loginid	 = @loginid_2, password	 = @password_3, firstname	 = @firstname_4, lastname	 = @lastname_5, aliasname	 = @aliasname_6, titleid	 = @titleid_7, sex	 = @sex_9, birthday	 = @birthday_10, nationality	 = @nationality_11, defaultlanguage	 = @defaultlanguage_12, systemlanguage	 = @systemlanguage_13, maritalstatus	 = @maritalstatus_14, marrydate	 = @marrydate_15, telephone	 = @telephone_16, mobile	 = @mobile_17, mobilecall	 = @mobilecall_18, email	 = @email_19, countryid	 = @countryid_20, locationid	 = @locationid_21, workroom	 = @workroom_22, homeaddress	 = @homeaddress_23, homepostcode	 = @homepostcode_24, homephone	 = @homephone_25, resourcetype	 = @resourcetype_26, startdate	 = @startdate_27, enddate	 = @enddate_28, contractdate	 = @contractdate_29, jobtitle	 = @jobtitle_30, jobgroup	 = @jobgroup_31, jobactivity	 = @jobactivity_32, jobactivitydesc	 = @jobactivitydesc_33, joblevel	 = @joblevel_34, seclevel	 = @seclevel_35, departmentid	 = @departmentid_36, subcompanyid1	 = @subcompanyid1_37, subcompanyid2	 = @subcompanyid2_38, subcompanyid3	 = @subcompanyid3_39, subcompanyid4	 = @subcompanyid4_40, costcenterid	 = @costcenterid_41, managerid	 = @managerid_42, assistantid	 = @assistantid_43, purchaselimit	 = @purchaselimit_44, currencyid	 = @currencyid_45, bankid1	 = @bankid1_46, accountid1	 = @accountid1_47, bankid2	 = @bankid2_48, accountid2	 = @accountid2_49, securityno	 = @securityno_50, creditcard	 = @creditcard_51, expirydate	 = @expirydate_52, resourceimageid	 = @resourceimageid_53, lastmodid	 = @lastmodid_54, lastmoddate	 = @lastmoddate_55 , datefield1	 = @datefield1, datefield2	 = @datefield2, datefield3	 = @datefield3, datefield4	 = @datefield4, datefield5	 = @datefield5, numberfield1	 = @numberfield1, numberfield2	 = @numberfield2, numberfield3	 = @numberfield3, numberfield4	 = @numberfield4, numberfield5	 = @numberfield5, textfield1	 = @textfield1, textfield2	 = @textfield2, textfield3	 = @textfield3, textfield4	 = @textfield4, textfield5	 = @textfield5, tinyintfield1	 = @tinyintfield1, tinyintfield2	 = @tinyintfield2, tinyintfield3	 = @tinyintfield3, tinyintfield4	 = @tinyintfield4, 
tinyintfield5	 = @tinyintfield5 ,
certificatecategory = @certificatecategory,			
certificatenum	= @certificatenum,			
nativeplace = @nativeplace,		
educationlevel = @educationlevel,			
bememberdate = @bememberdate,			
bepartydate = @bepartydate,
bedemocracydate = @bedemocracydate,			
regresidentplace = @regresidentplace,				
healthinfo = @healthinfo,			
residentplace = @residentplace,			
policy = @policy,		
degree = @degree,	
height = @height,
homepage = @homepage,			
train = @train,				
worktype = @worktype,			
usekind	= @usekind,				
workcode = @workcode,			
contractbegintime = @contractbegintime,		
jobright = @jobright,			
jobcall	= @jobcall,				
jobtype	= @jobtype,			
accumfundaccount = @accumfundaccount,
birthplace = @birthplace,
folk = @folk,
residentphone = @residentphone,
residentpostcode = @residentpostcode,
extphone = @extphone,
managerstr = @managerstr_1 
WHERE ( id	 = @id_1) 

else 
UPDATE HrmResource  SET  loginid	 = @loginid_2, firstname	 = @firstname_4, lastname	 = @lastname_5, aliasname	 = @aliasname_6, titleid	 = @titleid_7, sex	 = @sex_9, birthday	 = @birthday_10, nationality	 = @nationality_11, defaultlanguage	 = @defaultlanguage_12, systemlanguage	 = @systemlanguage_13, maritalstatus	 = @maritalstatus_14, marrydate	 = @marrydate_15, telephone	 = @telephone_16, mobile	 = @mobile_17, mobilecall	 = @mobilecall_18, email	 = @email_19, countryid	 = @countryid_20, locationid	 = @locationid_21, workroom	 = @workroom_22, homeaddress	 = @homeaddress_23, homepostcode	 = @homepostcode_24, homephone	 = @homephone_25, resourcetype	 = @resourcetype_26, startdate	 = @startdate_27, enddate	 = @enddate_28, contractdate	 = @contractdate_29, jobtitle	 = @jobtitle_30, jobgroup	 = @jobgroup_31, jobactivity	 = @jobactivity_32, jobactivitydesc	 = @jobactivitydesc_33, joblevel	 = @joblevel_34, seclevel	 = @seclevel_35, departmentid	 = @departmentid_36, subcompanyid1	 = @subcompanyid1_37, subcompanyid2	 = @subcompanyid2_38, subcompanyid3	 = @subcompanyid3_39, subcompanyid4	 = @subcompanyid4_40, costcenterid	 = @costcenterid_41, managerid	 = @managerid_42, assistantid	 = @assistantid_43, purchaselimit	 = @purchaselimit_44, currencyid	 = @currencyid_45, bankid1	 = @bankid1_46, accountid1	 = @accountid1_47, bankid2	 = @bankid2_48, accountid2	 = @accountid2_49, securityno	 = @securityno_50, creditcard	 = @creditcard_51, expirydate	 = @expirydate_52, resourceimageid	 = @resourceimageid_53, lastmodid	 = @lastmodid_54, lastmoddate	 = @lastmoddate_55 , datefield1	 = @datefield1, datefield2	 = @datefield2, datefield3	 = @datefield3, datefield4	 = @datefield4, datefield5	 = @datefield5, numberfield1	 = @numberfield1, numberfield2	 = @numberfield2, numberfield3	 = @numberfield3, numberfield4	 = @numberfield4, numberfield5	 = @numberfield5, textfield1	 = @textfield1, textfield2	 = @textfield2, textfield3	 = @textfield3, textfield4	 = @textfield4, textfield5	 = @textfield5, tinyintfield1	 = @tinyintfield1, tinyintfield2	 = @tinyintfield2, tinyintfield3	 = @tinyintfield3, tinyintfield4	 = @tinyintfield4, 
tinyintfield5	 = @tinyintfield5 ,
certificatecategory = @certificatecategory,			
certificatenum	= @certificatenum,			
nativeplace = @nativeplace,		
educationlevel = @educationlevel,			
bememberdate = @bememberdate,			
bepartydate = @bepartydate,
bedemocracydate = @bedemocracydate,			
regresidentplace = @regresidentplace,				
healthinfo = @healthinfo,			
residentplace = @residentplace,			
policy = @policy,		
degree = @degree,	
height = @height,
homepage = @homepage,			
train = @train,				
worktype = @worktype,			
usekind	= @usekind,				
workcode = @workcode,			
contractbegintime = @contractbegintime,		
jobright = @jobright,			
jobcall	= @jobcall,				
jobtype	= @jobtype,			
accumfundaccount = @accumfundaccount,
birthplace = @birthplace,
folk = @folk,
residentphone = @residentphone,
residentpostcode = @residentpostcode,
extphone = @extphone,
managerstr = @managerstr_1  
WHERE ( id	 = @id_1) 

 if @@error<>0 begin set @flag=1 set @msg='修改人力资源信息失败' return end else begin set @flag=0 set @msg='修改人力资源信息成功' return end

select 1
GO


/* 2003 年 3 月 25日 为邮件系统 */

alter PROCEDURE SystemSet_Update 
 (@emailserver  varchar(60) , 
  @debugmode   char(1) , 
  @logleaveday  tinyint ,
  @defmailuser_1  varchar(60) ,
  @defmailpassword_1  varchar(60) ,
  @flag int output, 
  @msg varchar(80) output) 
AS 
update SystemSet set emailserver=@emailserver , debugmode=@debugmode,logleaveday=@logleaveday ,
                     defmailuser=@defmailuser_1 , defmailpassword=@defmailpassword_1 
GO



/* 对于角色表的更新 */
create TRIGGER Tri_Update_HrmRoleMembersShare ON HrmRoleMembers WITH ENCRYPTION
FOR INSERT, UPDATE, DELETE
AS
Declare @roleid_1 int,
        @resourceid_1 int,
        @oldrolelevel_1 char(1),
        @rolelevel_1 char(1),
        @docid_1	 int,
	    @crmid_1	 int,
	    @prjid_1	 int,
	    @cptid_1	 int,
        @sharelevel_1  int,
        @departmentid_1 int,
	    @subcompanyid_1 int,
        @seclevel_1	 int,
        @countrec      int,
        @countdelete   int,
        @countinsert   int
        
/* 某一个人加入一个角色或者在角色中的级别升高进行处理,这两种情况都是增加了共享的范围,不需要删除
原有共享信息,只需要判定增加的部分, 对于在角色中级别的降低或者删除某一个成员,只能删除全部共享细节,从作人力资源一个
人的部门或者安全级别改变的操作 */

select @countdelete = count(*) from deleted
select @countinsert = count(*) from inserted
select @oldrolelevel_1 = rolelevel from deleted
if @countinsert > 0 
    select @roleid_1 = roleid , @resourceid_1 = resourceid, @rolelevel_1 = rolelevel from inserted
else 
    select @roleid_1 = roleid , @resourceid_1 = resourceid, @rolelevel_1 = rolelevel from deleted

if ( @countinsert >0 and ( @countdelete = 0 or @rolelevel_1  > @oldrolelevel_1 ) )     
begin
    select @departmentid_1 = departmentid , @subcompanyid_1 = subcompanyid1 , @seclevel_1 = seclevel 
    from hrmresource where id = @resourceid_1 
    if @departmentid_1 is null   set @departmentid_1 = 0
    if @subcompanyid_1 is null   set @subcompanyid_1 = 0

    if @rolelevel_1 = '2'       /* 新的角色级别为总部级 */
    begin 

	/* ------- DOC 部分 ------- */

        declare sharedocid_cursor cursor for
        select distinct docid , sharelevel from DocShare where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open sharedocid_cursor 
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(docid) from docsharedetail where docid = @docid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into docsharedetail values(@docid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update docsharedetail set sharelevel = 2 where docid=@docid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        end 
        close sharedocid_cursor deallocate sharedocid_cursor

	/* ------- CRM 部分 ------- */

	declare sharecrmid_cursor cursor for
        select distinct relateditemid , sharelevel from CRM_ShareInfo where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open sharecrmid_cursor 
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CrmShareDetail values(@crmid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CrmShareDetail set sharelevel = 2 where crmid=@crmid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        end 
        close sharecrmid_cursor deallocate sharecrmid_cursor


	/* ------- PROJ 部分 ------- */

	declare shareprjid_cursor cursor for
        select distinct relateditemid , sharelevel from Prj_ShareInfo where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open shareprjid_cursor 
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into PrjShareDetail values(@prjid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update PrjShareDetail set sharelevel = 2 where prjid=@prjid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor


	/* ------- CPT 部分 ------- */

	declare sharecptid_cursor cursor for
        select distinct relateditemid , sharelevel from CptCapitalShareInfo where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open sharecptid_cursor 
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CptShareDetail values(@cptid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CptShareDetail set sharelevel = 2 where cptid=@cptid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor


    end
    else if @rolelevel_1 = '1'          /* 新的角色级别为分部级 */
    begin

	/* ------- DOC 部分 ------- */
        declare sharedocid_cursor cursor for
        select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2 , hrmdepartment  t4 where t1.id=t2.docid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= @subcompanyid_1
        open sharedocid_cursor 
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(docid) from docsharedetail where docid = @docid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into docsharedetail values(@docid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update docsharedetail set sharelevel = 2 where docid=@docid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        end 
        close sharedocid_cursor deallocate sharedocid_cursor


	/* ------- CRM 部分 ------- */
       declare sharecrmid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department = t4.id and t4.subcompanyid1= @subcompanyid_1
        open sharecrmid_cursor 
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CrmShareDetail values(@crmid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CrmShareDetail set sharelevel = 2 where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        end 
        close sharecrmid_cursor deallocate sharecrmid_cursor

	/* ------- PRJ 部分 ------- */

	declare shareprjid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department=t4.id and t4.subcompanyid1= @subcompanyid_1
        open shareprjid_cursor 
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into PrjShareDetail values(@prjid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update PrjShareDetail set sharelevel = 2 where prjid=@prjid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor

	/* ------- CPT 部分 ------- */

	declare sharecptid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.departmentid=t4.id and t4.subcompanyid1= @subcompanyid_1
        open sharecptid_cursor 
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CptShareDetail values(@cptid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CptShareDetail set sharelevel = 2 where cptid=@cptid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor


    end
    else if @rolelevel_1 = '0'          /* 为新建时候设定级别为部门级 */
    begin

        /* ------- DOC 部分 ------- */

	declare sharedocid_cursor cursor for
        select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2 where t1.id=t2.docid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.docdepartmentid= @departmentid_1
        open sharedocid_cursor 
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(docid) from docsharedetail where docid = @docid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into docsharedetail values(@docid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update docsharedetail set sharelevel = 2 where docid=@docid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        end 
        close sharedocid_cursor deallocate sharedocid_cursor
	
	/* ------- CRM 部分 ------- */

	declare sharecrmid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department = @departmentid_1
        open sharecrmid_cursor 
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CrmShareDetail values(@crmid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CrmShareDetail set sharelevel = 2 where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        end 
        close sharecrmid_cursor deallocate sharecrmid_cursor

	/* ------- PRJ 部分 ------- */

	declare shareprjid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department= @departmentid_1
        open shareprjid_cursor 
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into PrjShareDetail values(@prjid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update PrjShareDetail set sharelevel = 2 where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor

	/* ------- CPT 部分 ------- */

	declare sharecptid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.departmentid= @departmentid_1
        open sharecptid_cursor 
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CptShareDetail values(@cptid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CptShareDetail set sharelevel = 2 where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor

    end
end
else if ( @countdelete > 0 and ( @countinsert = 0 or @rolelevel_1  < @oldrolelevel_1 ) ) /* 当为删除或者级别降低 */
begin
    select @departmentid_1 = departmentid , @subcompanyid_1 = subcompanyid1 , @seclevel_1 = seclevel 
    from hrmresource where id = @resourceid_1 
    if @departmentid_1 is null   set @departmentid_1 = 0
    if @subcompanyid_1 is null   set @subcompanyid_1 = 0
	
    /* 删除原有的该人的所有文档共享信息 */
	delete from DocShareDetail where userid = @resourceid_1 and usertype = 1

    /* 定义临时表变量 */
    Declare @temptablevalue  table(docid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevalue 中 */
    /*  自己创建的或者是 owner 的文章可以编辑 */
    declare docid_cursor cursor for
    select distinct id from DocDetail where ( doccreaterid = @resourceid_1 or ownerid = @resourceid_1 ) and usertype= '1'
    open docid_cursor 
    fetch next from docid_cursor into @docid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevalue values(@docid_1, 2)
        fetch next from docid_cursor into @docid_1
    end
    close docid_cursor deallocate docid_cursor


    /* 自己下级的文档 */
    /* 查找下级 */
    declare @managerstr_11 varchar(200) 
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subdocid_cursor cursor for
    select distinct id from DocDetail where ( doccreaterid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) or ownerid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) ) and usertype= '1'
    open subdocid_cursor 
    fetch next from subdocid_cursor into @docid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1
        if @countrec = 0  insert into @temptablevalue values(@docid_1, 1)
        fetch next from subdocid_cursor into @docid_1
    end
    close subdocid_cursor deallocate subdocid_cursor
         


    /* 由文档的共享获得的权利 , 将共享分成两个部分, 角色共享一个部分.其它一个部分,否则查询太慢*/
    declare sharedocid_cursor cursor for
    select distinct docid , sharelevel from DocShare  where  (foralluser=1 and seclevel<= @seclevel_1 )  or ( userid= @resourceid_1 ) or (departmentid= @departmentid_1 and seclevel<= @seclevel_1 )
    open sharedocid_cursor 
    fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalue values(@docid_1, @sharelevel_1)
        end
        else if @sharelevel_1 = 2  
        begin
            update @temptablevalue set sharelevel = 2 where docid=@docid_1 /* 共享是可以编辑, 则都修改原有记录    */   
        end
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    end 
    close sharedocid_cursor deallocate sharedocid_cursor

    declare sharedocid_cursor cursor for
    select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2,  HrmRoleMembers  t3 , hrmdepartment t4 where t1.id=t2.docid and t3.resourceid= @resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= @seclevel_1 and ( (t2.rolelevel=0  and t1.docdepartmentid= @departmentid_1 ) or (t2.rolelevel=1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= @subcompanyid_1 ) or (t3.rolelevel=2) )
    open sharedocid_cursor 
    fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalue values(@docid_1, @sharelevel_1)
        end
        else if @sharelevel_1 = 2  
        begin
            update @temptablevalue set sharelevel = 2 where docid=@docid_1 /* 共享是可以编辑, 则都修改原有记录    */   
        end
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    end 
    close sharedocid_cursor deallocate sharedocid_cursor

    /* 将临时表中的数据写入共享表 */
    declare alldocid_cursor cursor for
    select * from @temptablevalue
    open alldocid_cursor 
    fetch next from alldocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into docsharedetail values(@docid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from alldocid_cursor into @docid_1 , @sharelevel_1
    end
    close alldocid_cursor deallocate alldocid_cursor

    /* ------- CRM  部分 ------- */


    /* 删除原有的该人的所有客户共享信息 */
	delete from CrmShareDetail where userid = @resourceid_1 and usertype = 1

    /* 定义临时表变量 */
    Declare @temptablevaluecrm  table(crmid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluecrm 中 */
    /*  自己是 manager 的客户 2 */
    declare crmid_cursor cursor for
    select id from CRM_CustomerInfo where manager = @resourceid_1 
    open crmid_cursor 
    fetch next from crmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluecrm values(@crmid_1, 2)
        fetch next from crmid_cursor into @crmid_1
    end
    close crmid_cursor deallocate crmid_cursor


    /* 自己下级的客户 3 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcrmid_cursor cursor for
    select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcrmid_cursor 
    fetch next from subcrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 3)
        fetch next from subcrmid_cursor into @crmid_1
    end
    close subcrmid_cursor deallocate subcrmid_cursor
 
    /* 作为crm管理员能看到的客户 */
    declare rolecrmid_cursor cursor for
   select distinct t1.id from CRM_CustomerInfo  t1, hrmrolemembers  t2  where t2.roleid=8 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open rolecrmid_cursor 
    fetch next from rolecrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 4)
        fetch next from rolecrmid_cursor into @crmid_1
    end
    close rolecrmid_cursor deallocate rolecrmid_cursor	 


    /* 由客户的共享获得的权利 1 2 */
    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid = @departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor



    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department = @departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor


    /* 将临时表中的数据写入共享表 */
    declare allcrmid_cursor cursor for
    select * from @temptablevaluecrm
    open allcrmid_cursor 
    fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(@crmid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    end
    close allcrmid_cursor deallocate allcrmid_cursor



    /* ------- PROJ 部分 ------- */

    /* 定义临时表变量 */
    Declare @temptablevaluePrj  table(prjid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluePrj 中 */
    /*  自己的项目2 */
    declare prjid_cursor cursor for
    select id from Prj_ProjectInfo where manager = @resourceid_1 
    open prjid_cursor 
    fetch next from prjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluePrj values(@prjid_1, 2)
        fetch next from prjid_cursor into @prjid_1
    end
    close prjid_cursor deallocate prjid_cursor


    /* 自己下级的项目3 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subprjid_cursor cursor for
    select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subprjid_cursor 
    fetch next from subprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1
        if @countrec = 0  insert into @temptablevaluePrj values(@prjid_1, 3)
        fetch next from subprjid_cursor into @prjid_1
    end
    close subprjid_cursor deallocate subprjid_cursor
 
    /* 作为项目管理员能看到的项目4 */
    declare roleprjid_cursor cursor for
   select distinct t1.id from Prj_ProjectInfo  t1, hrmrolemembers  t2  where t2.roleid=9 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open roleprjid_cursor 
    fetch next from roleprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1
        if @countrec = 0  insert into @temptablevaluePrj values(@prjid_1, 4)
        fetch next from roleprjid_cursor into @prjid_1
    end
    close roleprjid_cursor deallocate roleprjid_cursor	 


    /* 由项目的共享获得的权利 1 2 */
    declare shareprjid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open shareprjid_cursor 
    fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, @sharelevel_1)
        end
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    end 
    close shareprjid_cursor deallocate shareprjid_cursor


    declare shareprjid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and  t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department=@departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open shareprjid_cursor 
    fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, @sharelevel_1)
        end
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    end 
    close shareprjid_cursor deallocate shareprjid_cursor



    /* 项目成员5 (内部用户) */
    declare inuserprjid_cursor cursor for
    SELECT distinct t2.id FROM Prj_TaskProcess  t1,Prj_ProjectInfo  t2 WHERE  t1.hrmid =@resourceid_1 and t2.id=t1.prjid and t1.isdelete<>'1' and t2.isblock='1' 

    
    open inuserprjid_cursor 
    fetch next from inuserprjid_cursor into @prjid_1 
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, 5)
        end
        fetch next from inuserprjid_cursor into @prjid_1
    end 
    close inuserprjid_cursor deallocate inuserprjid_cursor


    /* 删除原有的与该人员相关的所有项目权 */
    delete from PrjShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allprjid_cursor cursor for
    select * from @temptablevaluePrj
    open allprjid_cursor 
    fetch next from allprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(@prjid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allprjid_cursor into @prjid_1 , @sharelevel_1
    end
    close allprjid_cursor deallocate allprjid_cursor


    /* ------- CPT 部分 ------- */

    /* 定义临时表变量 */
    Declare @temptablevalueCpt  table(cptid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevalueCpt 中 */
    /*  自己的资产2 */
    declare cptid_cursor cursor for
    select id from CptCapital where resourceid = @resourceid_1 
    open cptid_cursor 
    fetch next from cptid_cursor into @cptid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevalueCpt values(@cptid_1, 2)
        fetch next from cptid_cursor into @cptid_1
    end
    close cptid_cursor deallocate cptid_cursor


    /* 自己下级的资产1 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcptid_cursor cursor for
    select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcptid_cursor 
    fetch next from subcptid_cursor into @cptid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1
        if @countrec = 0  insert into @temptablevalueCpt values(@cptid_1, 1)
        fetch next from subcptid_cursor into @cptid_1
    end
    close subcptid_cursor deallocate subcptid_cursor
 
   
    /* 由资产的共享获得的权利 1 2 */
    declare sharecptid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecptid_cursor 
    fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@cptid_1, @sharelevel_1)
        end
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    end 
    close sharecptid_cursor deallocate sharecptid_cursor


    declare sharecptid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= @resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= @seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= @departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= @subcompanyid_1 ) or (t3.rolelevel=2) )
    open sharecptid_cursor 
    fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalueCpt values(@cptid_1, @sharelevel_1)
        end       
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    end 
    close sharecptid_cursor deallocate sharecptid_cursor
    


    /* 删除原有的与该人员相关的所有资产权 */
    delete from CptShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allcptid_cursor cursor for
    select * from @temptablevaluePrj
    open allcptid_cursor 
    fetch next from allcptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(@cptid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allcptid_cursor into @cptid_1 , @sharelevel_1
    end
    close allcptid_cursor deallocate allcptid_cursor

end        /* 结束角色删除或者级别降低的处理 */
go



/* 人力资源表涉及请求的创建 */
drop TRIGGER Tri_U_workflow_createlist
GO

CREATE TRIGGER Tri_U_workflow_createlist ON HrmResource WITH ENCRYPTION
FOR INSERT, UPDATE, DELETE 
AS
Declare @workflowid int,
	@type int,
 	@objid int,
	@level_n int,
	@userid int,
    @olddepartmentid_1 int,
    @departmentid_1 int,
    @oldseclevel_1	 int,
    @seclevel_1	 int,
    @countdelete   int,
	@all_cursor cursor,
	@detail_cursor cursor

select @countdelete = count(*) from deleted
select @olddepartmentid_1 = departmentid, @oldseclevel_1 = seclevel from deleted
select @departmentid_1 = departmentid, @seclevel_1 = seclevel from inserted

/* 如果部门和安全级别信息被修改(在新建的时候这两个信息肯定被修改) */
if ( @countdelete = 0 or @departmentid_1 <>@olddepartmentid_1 or  @seclevel_1 <> @oldseclevel_1 )     
begin

    delete from workflow_createrlist

    SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR				
    select workflowid,type,objid,level_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid

    OPEN @all_cursor 
    FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n
    WHILE @@FETCH_STATUS = 0 
    begin 
        if @type=1 
        begin
            SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
            select id from HrmResource where departmentid = @objid and seclevel >= @level_n

            OPEN @detail_cursor 
            FETCH NEXT FROM @detail_cursor INTO @userid
            WHILE @@FETCH_STATUS = 0 
            begin 
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'0')
                FETCH NEXT FROM @detail_cursor INTO @userid
            end 
            CLOSE @detail_cursor
            DEALLOCATE @detail_cursor  
        end
        else if @type=2
        begin
            SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
            SELECT resourceid as id FROM HrmRoleMembers where roleid =  @objid and rolelevel >=@level_n

            OPEN @detail_cursor 
            FETCH NEXT FROM @detail_cursor INTO @userid
            WHILE @@FETCH_STATUS = 0 
            begin 
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'0')
                FETCH NEXT FROM @detail_cursor INTO @userid
            end 
            CLOSE @detail_cursor
            DEALLOCATE @detail_cursor  
        end
        else if @type=3
        begin
            insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@objid,'0')
        end
        else if @type=4
        begin
            insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,'-1',@level_n) 
        end
        else if @type=20
        begin
            SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR	
            select id  from CRM_CustomerInfo where  seclevel >= @level_n and type = @objid			

            OPEN @detail_cursor 
            FETCH NEXT FROM @detail_cursor INTO @userid
            WHILE @@FETCH_STATUS = 0 
            begin 
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'1')
                FETCH NEXT FROM @detail_cursor INTO @userid
            end 
            CLOSE @detail_cursor
            DEALLOCATE @detail_cursor  
        end
        else if @type=21
        begin
            SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR	
            select id  from CRM_CustomerInfo where  seclevel >= @level_n and status = @objid			

            OPEN @detail_cursor 
            FETCH NEXT FROM @detail_cursor INTO @userid
            WHILE @@FETCH_STATUS = 0 
            begin 
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'1')
                FETCH NEXT FROM @detail_cursor INTO @userid
            end 
            CLOSE @detail_cursor
            DEALLOCATE @detail_cursor  
        end
        else if @type=22
        begin
            SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR	
            select id  from CRM_CustomerInfo where  seclevel >= @level_n and department = @objid			

            OPEN @detail_cursor 
            FETCH NEXT FROM @detail_cursor INTO @userid
            WHILE @@FETCH_STATUS = 0 
            begin 
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'1')
                FETCH NEXT FROM @detail_cursor INTO @userid
            end 
            CLOSE @detail_cursor
            DEALLOCATE @detail_cursor  
        end
        else if @type=25
        begin
            insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,'-2',@level_n) 
        end
        else if @type=30
        begin
            SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
            select id from HrmResource where subcompanyid1 = @objid and seclevel >= @level_n

            OPEN @detail_cursor 
            FETCH NEXT FROM @detail_cursor INTO @userid
            WHILE @@FETCH_STATUS = 0 
            begin 
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'0')
                FETCH NEXT FROM @detail_cursor INTO @userid
            end 
            CLOSE @detail_cursor
            DEALLOCATE @detail_cursor
        end
        FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n
    end 
    CLOSE @all_cursor 
    DEALLOCATE @all_cursor  
end
go





update HrmResource set loginid='gmanager',lastname='gmanager',aliasname='gmanager' where id='1'
GO

update HrmResource set managerid='1', managerstr='1,'
GO