drop table workflow_form
/

CREATE TABLE workflow_form (
	requestid integer NOT NULL ,
	billformid integer NULL ,
	billid integer NULL ,
	totaltime number(10, 3) NULL ,
	department integer NULL ,
	relatedcustomer integer NULL ,
	relatedresource integer NULL ,
	relateddocument integer NULL ,
	relatedrequest integer NULL ,
	userdepartment integer NULL ,
	startrailwaystation integer NULL ,
	subject varchar2 (200)  ,
	hotellevel integer NULL ,
	integer1 integer NULL ,
	desc1 varchar2 (100)  ,
	desc2 varchar2 (100)  ,
	desc3 varchar2 (100)  ,
	desc4 varchar2 (100)  ,
	desc5 varchar2 (100)  ,
	desc6 varchar2 (100)  ,
	desc7 varchar2 (100)  ,
	integer2 integer NULL ,
	reception_important integer NULL ,
	check2 char (1)  ,
	check3 char (1)  ,
	check4 char (1)  ,
	textvalue1 varchar2(4000)  ,
	textvalue2 varchar2(4000)  ,
	textvalue3 varchar2(4000)  ,
	textvalue4 varchar2(4000)  ,
	textvalue5 varchar2(4000)  ,
	textvalue6 varchar2(4000)  ,
	textvalue7 varchar2(4000)  ,
	softwaregetway integer NULL ,
	decimalvalue1 number(10, 3) NULL ,
	decimalvalue2 number(10, 3) NULL ,
	manager integer NULL ,
	jobtitle integer NULL ,
	jobtitle2 integer NULL ,
	document integer NULL ,
	Customer integer NULL ,
	Project integer NULL ,
	resource_n integer NULL ,
	item integer NULL ,
	request integer NULL ,
	mutiresource varchar2(4000)  ,
	muticustomer varchar2(4000)  ,
	remark varchar2(4000)  ,
	description varchar2 (100)  ,
	begindate char (10)  ,
	begintime char (5)  ,
	enddate char (10)  ,
	endtime char (5)  ,
	totaldays integer NULL ,
	check1 char (1)  ,
	amount number(10, 3) NULL ,
	startairport integer NULL ,
	airways integer NULL ,
	payoptions integer NULL ,
	expresstype integer NULL ,
	jtgj integer NULL ,
	absencetype integer NULL ,
	zc integer NULL ,
	zczl integer NULL ,
	fwcp integer NULL ,
	muticareer varchar2(4000)  ,
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
	resource1 integer NULL ,
	date_n char (10)  ,
	relatmeeting integer NULL ,
	itservice integer NULL ,
	cplx integer NULL ,
	gzlx integer NULL  
) 
/

CREATE TABLE license (
	companyname varchar2 (100)  ,
	license varchar2 (100)  ,
	hrmnum integer ,
	expiredate varchar2 (10),
	cversion varchar2 (10)
) 
/

insert into license(companyname,license,hrmnum,expiredate,cversion) values('Company Type 1','no',10000,'9999-01-01','2.0')
/

insert into SystemRightRoles (rightid,roleid,rolelevel) values (120,4,'1')
/
insert into SystemRightRoles (rightid,roleid,rolelevel) values (121,4,'1')
/
insert into SystemRightToGroup (groupid,rightid) values (3,120)
/
insert into SystemRightToGroup (groupid,rightid) values (3,121)
/


insert into HrmRoles (rolesmark,rolesname,docid) values ('总经理','总经理',0)
/
insert into HrmRoles (rolesmark,rolesname,docid) values ('财务经理','财务经理',0)
/
insert into HrmRoles (rolesmark,rolesname,docid) values ('出纳','出纳',0)
/
insert into HrmRoles (rolesmark,rolesname,docid) values ('资产管理员','资产管理员',0)
/
insert into HrmRoles (rolesmark,rolesname,docid) values ('信息管理员','信息管理员',0)
/
insert into HrmRoles (rolesmark,rolesname,docid) values ('信息经理','信息经理',0)
/
insert into HrmRoles (rolesmark,rolesname,docid) values ('行政助理','行政助理',0)
/
insert into HrmRoles (rolesmark,rolesname,docid) values ('行政经理','行政经理',0)
/
insert into HrmRoles (rolesmark,rolesname,docid) values ('公章管理员','公章管理员',0)
/
insert into HrmRoles (rolesmark,rolesname,docid) values ('人事经理','人事经理',0)
/
insert into HrmRoles (rolesmark,rolesname,docid) values ('人事助理','人事助理',0)
/

update HrmRoleMembers set resourceid = '1' where id='1'
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (12,1,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (13,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (14,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (15,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (16,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (17,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (18,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (19,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (20,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (21,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (22,2,'2')
/






insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (27,0,0,'事假')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (27,0,1,'病假')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (27,0,2,'婚假')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (27,0,3,'丧假')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (27,0,5,'产假')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (27,0,7,'年休假')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (27,0,4,'工伤假')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (27,0,6,'奖励假')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (31,0,0,'公司支付')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (31,0,1,'自己垫付')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (32,0,0,'重要')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (32,0,1,'一般')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (33,0,0,'网络下载（共享软件）')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (33,0,1,'公司软件')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (33,0,2,'外部购买')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (69,0,0,'浦东机场')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (69,0,1,'虹桥机场')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (71,0,0,'新客站')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (71,0,2,'南站')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (71,0,1,'西站')
/



insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (72,0,0,'五星级')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (72,0,1,'四星级')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (72,0,2,'三星级')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (72,0,3,'二星级')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (72,0,4,'一星级')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (72,0,5,'普通')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (73,0,0,'EMS')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (73,0,1,'快递')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (75,0,1,'火车')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (75,0,0,'汽车')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (75,0,2,'飞机')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (78,0,0,'CMS')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (78,0,1,'Web Design')
/


insert into workflow_formdict (fieldname,fielddbtype,fieldhtmltype,type) values ('itservice','int','5',0)
/
insert into workflow_formdict (fieldname,fielddbtype,fieldhtmltype,type) values ('cplx','int','5',1)
/
insert into workflow_formdict (fieldname,fielddbtype,fieldhtmltype,type) values ('gzlx','int','5',1)
/


insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (79,0,1,'软件使用')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (79,0,0,'技术支持')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (79,0,2,'设备更新')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (80,0,0,'火车票')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (80,0,1,'汽车票')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (81,0,0,'业务章')
/
insert into workflow_SelectItem (fieldid,isbill,selectvalue,selectname) values (81,0,1,'公司章')
/



/* 2003 年 3 月 22日 为系统优化 */
alter table hrmresource add managerstr varchar2(200)
/

create  INDEX docdetail_res_in on DocDetail(doccreaterid)
/
create  INDEX docdetail_dep_in on DocDetail(docdepartmentid)
/
create  INDEX hrmdepartment_sub_in on HrmDepartment(subcompanyid1)
/

/* 2003 年 3 月 25日 为邮件系统 */
alter table SystemSet add defmailuser varchar2(100) 
/
alter table SystemSet add defmailpassword varchar2(100) 
/


/* 2003 年 3 月 22日 为系统优化 */
CREATE or replace PROCEDURE HrmResource_Insert 
 (resourceid integer,
loginid_1 	varchar2, 
password_2 	varchar2, 
firstname_3 	varchar2,
lastname_4 	varchar2, 
aliasname_5 	varchar2, 
titleid_6 IN OUT	integer,
 sex_8 	char, 
birthday_9 	char,
 nationality_10 IN OUT	integer, 
defaultlanguage_11 IN OUT	integer, 
systemlanguage_12 IN OUT	integer, 
maritalstatus_13 	char, 
marrydate_14 	char, 
telephone_15 	varchar2, 
mobile_16 	varchar2, 
mobilecall_17 	varchar2, 
email_18 	varchar2, 
countryid_19 IN OUT	integer, 
locationid_20 IN OUT	integer, 
workroom_21 	varchar2, 
homeaddress_22 	varchar2, 
homepostcode_23 	varchar2,
 homephone_24 	varchar2, 
resourcetype_25 	char, 
startdate_26 	char,
 enddate_27 	char, 
contractdate_28 	char,
 jobtitle_29 IN OUT	integer, 
jobgroup_30 IN OUT	integer,
 jobactivity_31 IN OUT	integer,
 jobactivitydesc_32 	varchar2, 
joblevel_33 	smallint, 
seclevel_34 	smallint,
 departmentid_35 IN OUT	integer,
 subcompanyid1_36 IN OUT	integer, 
subcompanyid2_37 IN OUT	integer,
 subcompanyid3_38 IN OUT	integer, 
subcompanyid4_39 IN OUT	integer, 
costcenterid_40 IN OUT	integer, 
managerid_41 IN OUT	integer, 
assistantid_42 IN OUT	integer, 
purchaselimit_43 	number,
currencyid_44 IN OUT	integer, 
bankid1_45 IN OUT	integer, 
accountid1_46 	varchar2, 
bankid2_47 IN OUT	integer, 
accountid2_48 	varchar2, 
securityno_49 	varchar2,
 creditcard_50 	varchar2, 
expirydate_51 	char, 
resourceimageid_52 	integer, 
createrid_53 	integer, 
createdate_54 	char, 
lastmodid_55 	integer, 
lastmoddate_56 	char, 
datefield1_1 	varchar2,
 datefield2_1 	varchar2,
 datefield3_1 	varchar2,
 datefield4_1 	varchar2,
 datefield5_1 	varchar2,
 numberfield1_1 	float,
 numberfield2_1 	float,
 numberfield3_1 	float,
 numberfield4_1 	float,
 numberfield5_1 	float,
 textfield1_1 	varchar2, 
textfield2_1 	varchar2, 
textfield3_1 	varchar2, 
textfield4_1 	varchar2, 
textfield5_1 	varchar2, 
tinyintfield1_1 smallint, 
tinyintfield2_1 smallint, 
tinyintfield3_1 smallint,
 tinyintfield4_1 smallint, 
tinyintfield5_1 smallint, 
certificatecategory_1	varchar2,			
certificatenum_1		varchar2,			
nativeplace_1		varchar2,			
educationlevel_1		varchar2,			
bememberdate_1		varchar2,			
bepartydate_1		varchar2,		
bedemocracydate_1		varchar2,			
regresidentplace_1	varchar2,				
healthinfo_1		char,			
residentplace_1		varchar2,			
policy_1			varchar2,			
degree_1			varchar2,			
height_1			varchar2,		
homepage_1		varchar2,			
train_1			varchar2,				
worktype_1		varchar2,			
usekind_1	IN OUT		integer,				
workcode_1		varchar2,			
contractbegintime_1	char,			
jobright_1		varchar2,	
jobcall_1	IN OUT		integer,		
jobtype_1	IN OUT		integer,	
accumfundaccount_1	varchar2,	
birthplace_1		varchar2,
folk_1			varchar2,
residentphone_1		varchar2,
residentpostcode_1	varchar2,
extphone_1       	varchar2,
	 flag out		integer,
	 msg out		varchar2, 
	 thecursor IN OUT cursor_define.weavercursor)
AS 

count_1   integer ;
managerstr_1 varchar2(200);

begin
if titleid_6=0 then
 titleid_6 := null;
 end if;

 if nationality_10=0 then
  nationality_10 := null ;
  end if;

if defaultlanguage_11=0   then
defaultlanguage_11 := null ;
end if;

if systemlanguage_12 = 0 then
systemlanguage_12 := null ;
end if;

if countryid_19 = 0 then
countryid_19 := null;
end if;

if locationid_20 = 0 then
locationid_20 := null;
end if;

if jobtitle_29 = 0 then
jobtitle_29 := null ;
end if;

if jobgroup_30 = 0 then
jobgroup_30 := null ;
end if;

if jobactivity_31 = 0 then
jobactivity_31 := null ;
end if;

if departmentid_35 = 0 then  
departmentid_35 := null;
end if;

if subcompanyid1_36 = 0 then
subcompanyid1_36 := null ;
end if;

if subcompanyid2_37 = 0 then
subcompanyid2_37 := null ;
end if;

if subcompanyid3_38 = 0 then
subcompanyid3_38 := null ;
end if;

if subcompanyid4_39 = 0 then
subcompanyid4_39 := null;
end if;

if costcenterid_40 = 0 then
costcenterid_40 := null ;
end if;

if managerid_41 = 0 then
managerid_41 := null;
end if;

if assistantid_42 = 0 then
assistantid_42 := null ;
end if;

if currencyid_44 = 0 then
currencyid_44 := null;
end if;

if bankid1_45 = 0 then
bankid1_45 := null;
end if ;

if bankid2_47 = 0 then
bankid2_47 := null;
end if;

if usekind_1 = 0 then
usekind_1 := null;
end if;

if jobcall_1 = 0 then
jobcall_1 := null;
end if;
if jobtype_1 = 0 then
jobtype_1 := null ;
end if;


/*判断是否有重复登录名*/
select count(*) INTO count_1 from HrmResource where loginid = loginid_1;
if count_1<>0 then
   open thecursor for
   select -1 from dual ;
	return ;
end if;
open thecursor for
select managerstr INTO managerstr_1 from hrmresource where id = managerid_41;
if managerstr_1 is null  then
managerstr_1 := '' ;
 managerstr_1 := concat( concat( managerstr_1 , to_char(managerid_41) ), ',');
 end if;

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
VALUES ( resourceid,loginid_1, password_2, firstname_3, lastname_4, aliasname_5, titleid_6, sex_8,
 birthday_9, nationality_10, defaultlanguage_11, systemlanguage_12, maritalstatus_13, marrydate_14, 
telephone_15, mobile_16, mobilecall_17, email_18, countryid_19, locationid_20, workroom_21, homeaddress_22,
 homepostcode_23, homephone_24, resourcetype_25, startdate_26, enddate_27, contractdate_28, jobtitle_29, jobgroup_30, 
jobactivity_31, jobactivitydesc_32, joblevel_33, seclevel_34, departmentid_35, subcompanyid1_36, subcompanyid2_37, 
subcompanyid3_38, subcompanyid4_39, costcenterid_40, managerid_41, assistantid_42, purchaselimit_43, currencyid_44, 
bankid1_45, accountid1_46, bankid2_47, accountid2_48, securityno_49, creditcard_50, expirydate_51, resourceimageid_52,
 createrid_53, createdate_54, lastmodid_55, lastmoddate_56, datefield1_1, datefield2_1, datefield3_1, datefield4_1, 
datefield5_1, numberfield1_1, numberfield2_1, numberfield3_1, numberfield4_1, numberfield5_1, textfield1_1, textfield2_1, textfield3_1, 
textfield4_1, textfield5_1, tinyintfield1_1, tinyintfield2_1, tinyintfield3_1, tinyintfield4_1, tinyintfield5_1,
certificatecategory_1,		
certificatenum_1,				
nativeplace_1,					
educationlevel_1,					
bememberdate_1,					
bepartydate_1,			
bedemocracydate_1,				
regresidentplace_1,				
healthinfo_1,		
residentplace_1,						
policy_1,						
degree_1,						
height_1,				
homepage_1,				
train_1,						
worktype_1,			
usekind_1,							
workcode_1,					
contractbegintime_1,				
jobright_1,		
jobcall_1,		
jobtype_1,	
accumfundaccount_1,
birthplace_1,
folk_1,
residentphone_1,
residentpostcode_1,
extphone_1,
managerstr_1
)  ;


open thecursor for
SELECT max(id) FROM HrmResource ;
end;
/



CREATE or replace PROCEDURE HrmResource_Update 
 (id_1 	integer, 
 loginid_2 	varchar2, 
 password_3 	varchar2, 
 firstname_4 	varchar2, 
 lastname_5 	varchar2, 
 aliasname_6 	varchar2, 
 titleid_7  IN OUT	integer,
 sex_9 	char, 
 birthday_10 	char, 
 nationality_11 IN OUT	integer, 
 defaultlanguage_12 IN OUT	integer,
 systemlanguage_13 	IN OUT integer, 
 maritalstatus_14 	char,
 marrydate_15 	char, 
 telephone_16 	varchar2, 
 mobile_17 	varchar2, 
 mobilecall_18 	varchar2, 
 email_19 	varchar2, 
 countryid_20 IN OUT	integer, 
 locationid_21 IN OUT	integer,
 workroom_22 	varchar2,
 homeaddress_23 	varchar2,
 homepostcode_24 	varchar2,
 homephone_25 	varchar2, 
 resourcetype_26 	char,
 startdate_27 	char, 
 enddate_28 	char, 
 contractdate_29 	char, 
 jobtitle_30 IN OUT	integer, 
 jobgroup_31 IN OUT integer,
 jobactivity_32 IN OUT	integer,
 jobactivitydesc_33 	varchar2,
 joblevel_34 	smallint, 
 seclevel_35 	smallint, 
 departmentid_36 IN OUT	integer, 
 subcompanyid1_37 IN OUT	integer, 
 subcompanyid2_38 IN OUT	integer, 
 subcompanyid3_39 IN OUT	integer, 
 subcompanyid4_40 IN OUT	integer, 
 costcenterid_41 IN OUT	integer, 
 managerid_42 IN OUT	integer, 
 assistantid_43 IN OUT	integer, 
 purchaselimit_44 	number,
 currencyid_45 IN OUT	integer, 
 bankid1_46 IN OUT	integer, 
 accountid1_47 	varchar2,
 bankid2_48 IN OUT	integer, 
 accountid2_49 	varchar2,
 securityno_50 	varchar2,
 creditcard_51 	varchar2,
 expirydate_52 	char, 
 resourceimageid_53 	integer, 
 lastmodid_54 	integer, 
 lastmoddate_55 	char,
 datefield1_1 	varchar2, 
 datefield2_1 	varchar2, 
 datefield3_1 	varchar2, 
 datefield4_1 	varchar2, 
 datefield5_1 	varchar2, 
 numberfield1_1 	float, 
 numberfield2_1 	float, 
 numberfield3_1 	float, 
 numberfield4_1 	float, 
 numberfield5_1 	float, 
 textfield1_1 	varchar2,
 textfield2_1 	varchar2,
 textfield3_1 	varchar2,
 textfield4_1 	varchar2,
 textfield5_1 	varchar2,
 tinyintfield1_1 	smallint, 
 tinyintfield2_1 	smallint, 
 tinyintfield3_1 	smallint, 
 tinyintfield4_1 	smallint, 
 tinyintfield5_1 	smallint, 
certificatecategory_1	varchar2,			
certificatenum_1		varchar2,			
nativeplace_1		varchar2,			
educationlevel_1		char,			
bememberdate_1		char,			
bepartydate_1		char,		
bedemocracydate_1		char,			
regresidentplace_1	varchar2,			
healthinfo_1		char,			
residentplace_1		varchar2,			
policy_1			varchar2,			
degree_1			varchar2,			
height_1			varchar2,		
homepage_1		varchar2,			
train_1			varchar2,				
worktype_1		varchar2,			
usekind_1	IN OUT		integer,				
workcode_1		varchar2,			
contractbegintime_1	char,			
jobright_1		varchar2,			
jobcall_1	IN OUT		integer,				
jobtype_1		IN OUT	integer,			
accumfundaccount_1	varchar2,	
birthplace_1		varchar2,
folk_1			varchar2,
residentphone_1		varchar2,
residentpostcode_1	varchar2,
extphone_1		varchar2,
 flag out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 

AS
 count_1 integer;
 managerstr_1 varchar2(200);

begin

if titleid_7 =0 then
titleid_7 := null;
end if;

if nationality_11=0 then
nationality_11 := null;
end if;

if defaultlanguage_12=0 then
defaultlanguage_12 := null; 
end if;

if systemlanguage_13 = 0 then
systemlanguage_13 := null;
end if;
if countryid_20 = 0 then
countryid_20 := null;
end if;
if locationid_21 = 0 then
locationid_21 := null;
end if;

if jobtitle_30 = 0 then
jobtitle_30 := null;
end if;
if jobgroup_31 = 0 then
jobgroup_31 := null ;
end if;
if jobactivity_32 = 0 then 
jobactivity_32 := null;
end if;

if departmentid_36 = 0 then
departmentid_36 := null;
end if;

if subcompanyid1_37 = 0 then
subcompanyid1_37 := null;
end if;

if subcompanyid2_38 = 0 then
subcompanyid2_38 := null;
end if;

if subcompanyid3_39 = 0 then
subcompanyid3_39 := null;
end if;

if subcompanyid4_40 = 0 then
subcompanyid4_40 := null;
end if;

if costcenterid_41 = 0 then
costcenterid_41 := null ;
end if;
if managerid_42 = 0 then
managerid_42 := null;
end if;

if assistantid_43 = 0 then
assistantid_43 := null;
end if;
if currencyid_45 = 0 then
currencyid_45 := null ;
end if;
if bankid1_46 = 0 then
bankid1_46 := null;
end if;
if bankid2_48 = 0 then
bankid2_48 := null ;
end if;
if usekind_1 = 0 then
usekind_1 := null ;
end if;
if jobcall_1 = 0 then
jobcall_1 := null ;
end if;

if jobtype_1 = 0 then
jobtype_1 := null;
end if;

/*判断是否有重复登录名*/

select count(*) INTO  count_1  from HrmResource where loginid = loginid_2 and id<>id_1;
if count_1<>0 then
   open thecursor for
   select -1 from dual ;
	return ;
end if;



select  managerstr INTO  managerstr_1  from hrmresource where id = managerid_42;
if managerstr_1 is null  then
managerstr_1 := '';
 managerstr_1 := concat( concat(managerstr_1 , to_char(managerid_42)) , ',');
end if;

if password_3 != '0' then
 UPDATE HrmResource  SET  
 loginid	 = loginid_2, 
 password	 = password_3, 
 firstname	 = firstname_4, 
 lastname	 = lastname_5, 
 aliasname	 = aliasname_6, 
 titleid	 = titleid_7, 
 sex	 = sex_9,
 birthday	 = birthday_10, 
 nationality	 = nationality_11,
 defaultlanguage	 = defaultlanguage_12, 
 systemlanguage	 = systemlanguage_13,
 maritalstatus	 = maritalstatus_14,
 marrydate	 = marrydate_15,
 telephone	 = telephone_16,
 mobile	 = mobile_17,
 mobilecall	 = mobilecall_18, 
 email	 = email_19, 
 countryid	 = countryid_20, 
 locationid	 = locationid_21,
 workroom	 = workroom_22,
 homeaddress	 = homeaddress_23,
 homepostcode	 = homepostcode_24,
 homephone	 = homephone_25,
 resourcetype	 = resourcetype_26,
 startdate	 = startdate_27,
 enddate	 = enddate_28,
 contractdate	 = contractdate_29,
 jobtitle	 = jobtitle_30,
 jobgroup	 = jobgroup_31, 
 jobactivity	 = jobactivity_32,
 jobactivitydesc	 = jobactivitydesc_33,
 joblevel	 = joblevel_34,
 seclevel	 = seclevel_35, 
 departmentid	 = departmentid_36, 
 subcompanyid1	 = subcompanyid1_37, 
 subcompanyid2	 = subcompanyid2_38,
 subcompanyid3	 = subcompanyid3_39,
 subcompanyid4	 = subcompanyid4_40,
 costcenterid	 = costcenterid_41,
 managerid	 = managerid_42, 
 assistantid	 = assistantid_43, 
 purchaselimit	 = purchaselimit_44, 
 currencyid	 = currencyid_45, 
 bankid1	 = bankid1_46,
 accountid1	 = accountid1_47,
 bankid2	 = bankid2_48,
 accountid2	 = accountid2_49, 
 securityno	 = securityno_50, 
 creditcard	 = creditcard_51,
 expirydate	 = expirydate_52, 
 resourceimageid	 = resourceimageid_53, 
 lastmodid	 = lastmodid_54, 
 lastmoddate	 = lastmoddate_55 ,
 datefield1	 = datefield1_1, 
 datefield2	 = datefield2_1,
 datefield3	 = datefield3_1,
 datefield4	 = datefield4_1,
 datefield5	 = datefield5_1,
 numberfield1	 = numberfield1_1, 
 numberfield2	 = numberfield2_1,
 numberfield3	 = numberfield3_1, 
 numberfield4	 = numberfield4_1, 
 numberfield5	 = numberfield5_1, 
 textfield1	 = textfield1_1, 
 textfield2	 = textfield2_1, 
 textfield3	 = textfield3_1, 
 textfield4	 = textfield4_1, 
 textfield5	 = textfield5_1,
 tinyintfield1	 = tinyintfield1_1,
 tinyintfield2	 = tinyintfield2_1,
 tinyintfield3	 = tinyintfield3_1,
tinyintfield4	 = tinyintfield4_1, 
tinyintfield5	 = tinyintfield5_1 ,
certificatecategory = certificatecategory_1,			
certificatenum	= certificatenum_1,			
nativeplace = nativeplace_1,		
educationlevel = educationlevel_1,			
bememberdate = bememberdate_1,			
bepartydate = bepartydate_1,
bedemocracydate = bedemocracydate_1,			
regresidentplace = regresidentplace_1,				
healthinfo = healthinfo_1,			
residentplace = residentplace_1,			
policy = policy_1,		
degree = degree_1,	
height = height_1,
homepage = homepage_1,			
train = train_1,				
worktype = worktype_1,			
usekind	= usekind_1,				
workcode = workcode_1,			
contractbegintime = contractbegintime_1,		
jobright = jobright_1,			
jobcall	= jobcall_1,				
jobtype	= jobtype_1,			
accumfundaccount = accumfundaccount_1,
birthplace = birthplace_1,
folk = folk_1,
residentphone = residentphone_1,
residentpostcode = residentpostcode_1,
extphone = extphone_1,
managerstr = managerstr_1 
WHERE ( id	 = id_1) ;

else 
UPDATE HrmResource  SET 
loginid	 = loginid_2, 
firstname	 = firstname_4,
lastname	 = lastname_5,
aliasname	 = aliasname_6,
titleid	 = titleid_7,
sex	 = sex_9,
birthday	 = birthday_10, 
nationality	 = nationality_11, 
defaultlanguage	 = defaultlanguage_12, 
systemlanguage	 = systemlanguage_13,
maritalstatus	 = maritalstatus_14, 
marrydate	 = marrydate_15,
telephone	 = telephone_16,
mobile	 = mobile_17,
mobilecall	 = mobilecall_18, 
email	 = email_19, 
countryid	 = countryid_20, 
locationid	 = locationid_21,
workroom	 = workroom_22,
homeaddress	 = homeaddress_23, 
homepostcode	 = homepostcode_24,
homephone	 = homephone_25, 
resourcetype	 = resourcetype_26,
startdate	 = startdate_27,
enddate	 = enddate_28,
contractdate	 = contractdate_29,
jobtitle	 = jobtitle_30,
jobgroup	 = jobgroup_31, 
jobactivity	 = jobactivity_32, 
jobactivitydesc	 = jobactivitydesc_33,
joblevel	 = joblevel_34,
seclevel	 = seclevel_35,
departmentid	 = departmentid_36,
subcompanyid1	 = subcompanyid1_37, 
subcompanyid2	 = subcompanyid2_38, 
subcompanyid3	 = subcompanyid3_39,
subcompanyid4	 = subcompanyid4_40,
costcenterid	 = costcenterid_41,
managerid	 = managerid_42,
assistantid	 = assistantid_43, 
purchaselimit	 = purchaselimit_44,
currencyid	 = currencyid_45, 
bankid1	 = bankid1_46, 
accountid1	 = accountid1_47, 
bankid2	 = bankid2_48, 
accountid2	 = accountid2_49,
securityno	 = securityno_50,
creditcard	 = creditcard_51,
expirydate	 = expirydate_52, 
resourceimageid	 = resourceimageid_53, 
lastmodid	 = lastmodid_54, 
lastmoddate	 = lastmoddate_55 , 
datefield1	 = datefield1_1, 
datefield2	 = datefield2_1,
datefield3	 = datefield3_1, 
datefield4	 = datefield4_1, 
datefield5	 = datefield5_1,
numberfield1	 = numberfield1_1, 
numberfield2	 = numberfield2_1,
numberfield3	 = numberfield3_1,
numberfield4	 = numberfield4_1, 
numberfield5	 = numberfield5_1, 
textfield1	 = textfield1_1,
textfield2	 = textfield2_1, 
textfield3	 = textfield3_1, 
textfield4	 = textfield4_1, 
textfield5	 = textfield5_1, 
tinyintfield1	 = tinyintfield1_1,
tinyintfield2	 = tinyintfield2_1, 
tinyintfield3	 = tinyintfield3_1,
tinyintfield4	 = tinyintfield4_1, 
tinyintfield5	 = tinyintfield5_1 ,
certificatecategory = certificatecategory_1,			
certificatenum	= certificatenum_1,			
nativeplace = nativeplace_1,		
educationlevel = educationlevel_1,			
bememberdate = bememberdate_1,			
bepartydate = bepartydate_1,
bedemocracydate = bedemocracydate_1,			
regresidentplace = regresidentplace_1,				
healthinfo = healthinfo_1,			
residentplace = residentplace_1,			
policy = policy_1,		
degree = degree_1,	
height = height_1,
homepage = homepage_1,			
train = train_1,				
worktype = worktype_1,			
usekind	= usekind_1,				
workcode = workcode_1,			
contractbegintime = contractbegintime_1,		
jobright = jobright_1,			
jobcall	= jobcall_1,				
jobtype	= jobtype_1,			
accumfundaccount = accumfundaccount_1,
birthplace = birthplace_1,
folk = folk_1,
residentphone = residentphone_1,
residentpostcode = residentpostcode_1,
extphone = extphone_1,
managerstr = managerstr_1  
WHERE ( id	 = id_1) ;
end if;
end ;
/


/* 2003 年 3 月 25日 为邮件系统 */

CREATE or replace PROCEDURE SystemSet_Update 
 (emailserver_1  varchar2 , 
  debugmode_1   char , 
  logleaveday_1  smallint ,
  defmailuser_1  varchar2 ,
  defmailpassword_1  varchar2 ,
flag	out integer, 
msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
AS 
begin
update SystemSet set 
emailserver=emailserver_1 , 
debugmode=debugmode_1,
logleaveday=logleaveday_1 ,
defmailuser=defmailuser_1 ,
defmailpassword=defmailpassword_1 ;
end ;
/

/* 2003 年 3 月 22日 为系统优化 */

    /* 定义临时表变量 */
CREATE GLOBAL TEMPORARY TABLE temptablevalue
(docid integer,sharelevel integer
)
/

CREATE GLOBAL TEMPORARY TABLE temptablevaluecrm
(crmid integer,sharelevel integer
)
/  

CREATE GLOBAL TEMPORARY TABLE temptablevaluePrj
(prjid integer,sharelevel integer
)
/  	
CREATE GLOBAL TEMPORARY TABLE temptablevalueCpt
(cptid integer,sharelevel integer
)
/  	


/* 对于角色表的更新 */
CREATE or REPLACE TRIGGER Tri_Update_HrmRoleMembersShare
after insert or update or delete ON  HrmRoleMembers
FOR each row
Declare roleid_1 integer;
        resourceid_1 integer;
        oldrolelevel_1 char(1);
        rolelevel_1 char(1);
        docid_1	 integer;
	    crmid_1	 integer;
	    prjid_1	 integer;
	    cptid_1	 integer;
        sharelevel_1  integer;
        departmentid_1 integer;
	    subcompanyid_1 integer;
        seclevel_1	 integer;
        countrec      integer;
        countdelete   integer;
        countinsert   integer;
		managerstr_11 varchar2(200); 
        
/* 某一个人加入一个角色或者在角色中的级别升高进行处理,这两种情况都是增加了共享的范围,不需要删除
原有共享信息,只需要判定增加的部分, 对于在角色中级别的降低或者删除某一个成员,只能删除全部共享细节,从作人力资源一个
人的部门或者安全级别改变的操作 */
begin
countdelete := :old.id;
countinsert := :new.id;
oldrolelevel_1 := :old.rolelevel;

if countinsert > 0 then
	roleid_1 := :new.roleid;
	resourceid_1 := :new.resourceid;
	rolelevel_1 := :new.rolelevel;
else 
	roleid_1 := :old.roleid;
	resourceid_1 := :old.resourceid;
	rolelevel_1 := :old.rolelevel;
end if;



if ( countinsert >0 and ( countdelete = 0 or rolelevel_1  > oldrolelevel_1 ) )  then   

    select  departmentid ,  subcompanyid1 ,  seclevel INTO  departmentid_1 ,subcompanyid_1 ,seclevel_1 
    from hrmresource where id = resourceid_1 ;
    if departmentid_1 is null  then
	departmentid_1 := 0;
	end if;
    if subcompanyid_1 is null  then
	subcompanyid_1 := 0;
	end if;


    if rolelevel_1 = '2'   then    /* 新的角色级别为总部级 */
     

	/* ------- DOC 部分 ------- */

        for sharedocid_cursor IN (select distinct docid , sharelevel from DocShare where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
        
        loop 
			docid_1 := sharedocid_cursor.docid ;
			sharelevel_1 := sharedocid_cursor.sharelevel;
            select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then            
                insert into docsharedetail values(docid_1, resourceid_1, 1, sharelevel_1);
            else if sharelevel_1 = 2 then            
                update docsharedetail set sharelevel = 2 where docid=docid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
				end if;
			end if;
        end loop;



	/* ------- CRM 部分 ------- */

		for sharecrmid_cursor IN (     select distinct relateditemid , sharelevel from CRM_ShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		crmid_1:=sharecrmid_cursor.relateditemid;
		sharelevel_1 := sharecrmid_cursor.sharelevel;
			select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
			if countrec = 0  then
			
				insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
			
			else if sharelevel_1 = 2  then
			
				update CrmShareDetail set sharelevel = 2 where crmid=crmid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
			end if;
			end if;
		end loop;
	   


	/* ------- PROJ 部分 ------- */

		for shareprjid_cursor IN (      select distinct relateditemid , sharelevel from Prj_ShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		prjid_1 := shareprjid_cursor.relateditemid;
		sharelevel_1 := shareprjid_cursor.sharelevel;
            select count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);
             
            else if sharelevel_1 = 2  then
            
                update PrjShareDetail set sharelevel = 2 where prjid=prjid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;
	
  



	/* ------- CPT 部分 ------- */

		for sharecptid_cursor IN (select distinct relateditemid , sharelevel from CptCapitalShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		cptid_1 :=sharecptid_cursor.relateditemid;
		sharelevel_1 :=sharecptid_cursor.sharelevel;
            select count(cptid) INTO  countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2 then 
            
                update CptShareDetail set sharelevel = 2 where cptid=cptid_1 and userid = resourceid_1 and usertype = 1;  /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;
    end if;

    if rolelevel_1 = '1' then        /* 新的角色级别为分部级 */
    

	/* ------- DOC 部分 ------- */
		for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2 ,
		hrmdepartment  t4 where t1.id=t2.docid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and
		t2.seclevel <= seclevel_1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= subcompanyid_1)
		
		loop 
			docid_1 := sharedocid_cursor.docid;
			sharelevel_1 := sharedocid_cursor.sharelevel;
			select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid = resourceid_1 and usertype = 1 ; 
			if countrec = 0  then            
				insert into docsharedetail values(docid_1, resourceid_1, 1, sharelevel_1);            
			else if sharelevel_1 = 2  then            
				update docsharedetail set sharelevel = 2 where docid=docid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
			end if;
			end if;
		end loop;


	/* ------- CRM 部分 ------- */
       for sharecrmid_cursor IN (      select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department = t4.id and t4.subcompanyid1= subcompanyid_1)
	   loop
	   crmid_1 :=sharecrmid_cursor.relateditemid;
	   sharelevel_1 :=sharecrmid_cursor.sharelevel;
            select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CrmShareDetail set sharelevel = 2 where crmid = crmid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
	   end loop;

  

	/* ------- PRJ 部分 ------- */

		for shareprjid_cursor IN (        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department=t4.id and t4.subcompanyid1= subcompanyid_1)
		loop
		prjid_1 := shareprjid_cursor.relateditemid;
		sharelevel_1 :=shareprjid_cursor.sharelevel;
            select  count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update PrjShareDetail set sharelevel = 2 where prjid=prjid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;
	

      

	/* ------- CPT 部分 ------- */

		for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.departmentid=t4.id and t4.subcompanyid1= subcompanyid_1)
		loop
		cptid_1 :=sharecptid_cursor.relateditemid;
		sharelevel_1 :=sharecptid_cursor.sharelevel;
            select  count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CptShareDetail set sharelevel = 2 where cptid=cptid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;

    end if;
    if rolelevel_1 = '0'     then     /* 为新建时候设定级别为部门级 */
    

        /* ------- DOC 部分 ------- */

		for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2
		where t1.id=t2.docid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <=
		seclevel_1 and t1.docdepartmentid= departmentid_1)
		
		loop 
			docid_1 := sharedocid_cursor.docid ;
			sharelevel_1 := sharedocid_cursor.sharelevel ;
			select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid =
			resourceid_1 and usertype = 1  ;
			if countrec = 0  then            
				insert into docsharedetail values(docid_1, resourceid_1, 1, sharelevel_1);            
			else if sharelevel_1 = 2  then            
				update docsharedetail set sharelevel = 2 where docid=docid_1 and userid = resourceid_1 and
				usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
			end if;
			end if;
		end loop;
	
	/* ------- CRM 部分 ------- */

		for sharecrmid_cursor IN (select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department = departmentid_1)
		loop
		crmid_1 :=sharecrmid_cursor.relateditemid;
		sharelevel_1 :=sharecrmid_cursor.sharelevel;
          select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CrmShareDetail set sharelevel = 2 where crmid = crmid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;
        
  

	/* ------- PRJ 部分 ------- */

		for shareprjid_cursor IN (       select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department= departmentid_1)
		loop
		prjid_1 :=shareprjid_cursor.relateditemid;
		sharelevel_1 := shareprjid_cursor.sharelevel;
            select  count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update PrjShareDetail set sharelevel = 2 where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;
 


	/* ------- CPT 部分 ------- */

		for sharecptid_cursor IN (       select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.departmentid= departmentid_1)
		loop
		 cptid_1 :=sharecptid_cursor.relateditemid;
		 sharelevel_1 := sharecptid_cursor.sharelevel;
            select count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CptShareDetail set sharelevel = 2 where cptid = cptid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
		end loop;    

    end if;


else if ( countdelete > 0 and ( countinsert = 0 or rolelevel_1  < oldrolelevel_1 ) )  then 
/* 当为删除或者级别降低 */


    select  departmentid ,  subcompanyid1 ,  seclevel INTO departmentid_1 ,subcompanyid_1 ,seclevel_1 
    from hrmresource where id = resourceid_1 ;
    if departmentid_1 is null then
	departmentid_1 := 0;
    end if;
	if subcompanyid_1 is null then
	subcompanyid_1 := 0;
	end if;
	
    /* 删除原有的该人的所有文档共享信息 */
	delete from DocShareDetail where userid = resourceid_1 and usertype = 1;


    /*  将所有的信息现放到 temptablevalue 中 */
    /*  自己创建的或者是 owner 的文章可以编辑 */
    for docid_cursor IN (select distinct id from DocDetail where ( doccreaterid = resourceid_1 or ownerid = resourceid_1 ) and usertype= '1')
    
    loop 
		docid_1 := docid_cursor.id;
        insert into temptablevalue values(docid_1, 2);
    end loop;



    /* 自己下级的文档 */
    /* 查找下级 */
    managerstr_11 := concat( concat('%,' , to_char(resourceid_1)) , ',%' );

    for subdocid_cursor IN (select distinct id from DocDetail where ( doccreaterid in (select distinct id from
	HrmResource where concat(',' , managerstr) like managerstr_11 ) or ownerid in (select distinct id from
	HrmResource where concat(',' , managerstr) like managerstr_11 ) ) and usertype= '1')
    
    loop
		docid_1 := subdocid_cursor.id;
        select  count(docid) INTO countrec  from temptablevalue where docid = docid_1;
        if countrec = 0 then
		insert into temptablevalue values(docid_1, 1);
		end if;
    end loop;
         
         


    /* 由文档的共享获得的权利 , 将共享分成两个部分, 角色共享一个部分.其它一个部分,否则查询太慢*/
    for sharedocid_cursor IN (select distinct docid , sharelevel from DocShare  where  (foralluser=1 and
	seclevel<= seclevel_1 )  or ( userid= resourceid_1 ) or (departmentid= departmentid_1 and seclevel<=
	seclevel_1 ))
    
    loop 
		docid_1 :=sharedocid_cursor.docid;
		sharelevel_1 :=sharedocid_cursor.sharelevel;
        select count(docid) INTO countrec  from temptablevalue where docid = docid_1  ;
        if countrec = 0  then        
            insert into temptablevalue values(docid_1, sharelevel_1);        
        else if sharelevel_1 = 2  then        
            update temptablevalue set sharelevel = 2 where docid=docid_1; /* 共享是可以编辑, 则都修改原有记录    */
        end if;
		end if;
    end loop;

    for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2, 
	HrmRoleMembers  t3 , hrmdepartment t4 where t1.id=t2.docid and t3.resourceid= resourceid_1 and
	t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= seclevel_1 and ( (t2.rolelevel=0  and
	t1.docdepartmentid= departmentid_1 ) or (t2.rolelevel=1 and t1.docdepartmentid=t4.id and t4.subcompanyid1=
	subcompanyid_1 ) or (t3.rolelevel=2) ))

    loop
		docid_1 :=sharedocid_cursor.docid ;
		sharelevel_1 := sharedocid_cursor.sharelevel ;
        select  count(docid) INTO countrec  from temptablevalue where docid = docid_1 ; 
        if countrec = 0  then        
            insert into temptablevalue values(docid_1, sharelevel_1);        
        else if sharelevel_1 = 2  then        
            update temptablevalue set sharelevel = 2 where docid=docid_1; /* 共享是可以编辑, 则都修改原有记录    */
			end if;
		end if;
    end loop ;

    /* 将临时表中的数据写入共享表 */
    for alldocid_cursor IN (select * from temptablevalue)    
    loop 
		docid_1 := alldocid_cursor.docid;
		sharelevel_1 := alldocid_cursor.sharelevel;
        insert into docsharedetail values(docid_1, resourceid_1,1,sharelevel_1);
    end loop;

    /* ------- CRM  部分 ------- */


    /* 删除原有的该人的所有客户共享信息 */
	delete from CrmShareDetail where userid = resourceid_1 and usertype = 1;



    /*  将所有的信息现放到 temptablevaluecrm 中 */
    /*  自己是 manager 的客户 2 */
    for crmid_cursor IN (   select id from CRM_CustomerInfo where manager = resourceid_1 )
	loop
	crmid_1 := crmid_cursor.id;
	insert into temptablevaluecrm values(crmid_1, 2);
	end loop;
 


    /* 自己下级的客户 3 */
    /* 查找下级 */
     
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)) , ',%' );

    for subcrmid_cursor IN (  select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
	loop
	crmid_1 :=  subcrmid_cursor.id;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0  then
		insert into temptablevaluecrm values(crmid_1, 3);
		end if;
	end loop;
  

 
    /* 作为crm管理员能看到的客户 */
    for rolecrmid_cursor IN (   select distinct t1.id from CRM_CustomerInfo  t1, hrmrolemembers  t2  where t2.roleid=8 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
	loop
	crmid_1 := rolecrmid_cursor.id;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0 then
		insert into temptablevaluecrm values(crmid_1, 4);
		end if;
	end loop;



    /* 由客户的共享获得的权利 1 2 */
    for sharecrmid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid = departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	crmid_1:= sharecrmid_cursor.relateditemid;
	sharelevel_1 :=sharecrmid_cursor.sharelevel;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1  ;
        if countrec = 0  then
        
            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
	end loop;






    for sharecrmid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department = departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ) )
	loop
	crmid_1 :=sharecrmid_cursor.relateditemid;
	sharelevel_1 := sharecrmid_cursor.sharelevel;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1  ;
        if countrec = 0  then
        
            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
	end loop;




    /* 将临时表中的数据写入共享表 */
    for allcrmid_cursor IN (    select * from temptablevaluecrm)
	loop
	crmid_1 :=allcrmid_cursor.crmid;
	sharelevel_1  := allcrmid_cursor.sharelevel;
        insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(crmid_1, resourceid_1,1,sharelevel_1);
	end loop;





    /* ------- PROJ 部分 ------- */



    /*  将所有的信息现放到 temptablevaluePrj 中 */
    /*  自己的项目2 */
    for prjid_cursor IN (select id from Prj_ProjectInfo where manager = resourceid_1 )
	loop
	prjid_1 := prjid_cursor.id;
      insert into temptablevaluePrj values(prjid_1, 2);
	end loop;



    /* 自己下级的项目3 */
    /* 查找下级 */
     
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)), ',%' );

    for subprjid_cursor IN (    select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like managerstr_11 ) ))
	loop
	prjid_1 :=subprjid_cursor.id;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
		insert into temptablevaluePrj values(prjid_1, 3);
		end if;
	end loop;


 
    /* 作为项目管理员能看到的项目4 */
    for roleprjid_cursor IN (   select distinct t1.id from Prj_ProjectInfo  t1, hrmrolemembers  t2  where t2.roleid=9 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
	loop
	prjid_1:=roleprjid_cursor.id;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
		insert into temptablevaluePrj values(prjid_1, 4);
		end if;
	end loop;

	 


    /* 由项目的共享获得的权利 1 2 */
    for shareprjid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	prjid_1 := shareprjid_cursor.relateditemid;
	sharelevel_1 :=  shareprjid_cursor.sharelevel;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0  then
        
            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
	end loop;



    for shareprjid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and  t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department=departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ) 
    
	)
	loop
	prjid_1 := shareprjid_cursor.relateditemid;
	sharelevel_1 := shareprjid_cursor.sharelevel;
        select  count(prjid) INTO countrec from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0 then 
        
            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
	end loop;

	

    /* 项目成员5 (内部用户) */
    for inuserprjid_cursor IN (    SELECT distinct t2.id FROM Prj_TaskProcess  t1,Prj_ProjectInfo  t2 WHERE  t1.hrmid =resourceid_1 and t2.id=t1.prjid and t1.isdelete<>'1' and t2.isblock='1' )
	loop
	prjid_1 :=inuserprjid_cursor.id;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1 ; 
        if countrec = 0  then
        
            insert into temptablevaluePrj values(prjid_1, 5);
        end if;
	end loop;



    /* 删除原有的与该人员相关的所有项目权 */
    delete from PrjShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allprjid_cursor IN (select * from temptablevaluePrj)
	loop
	prjid_1 := allprjid_cursor.prjid;
	sharelevel_1 := allprjid_cursor.sharelevel;
        insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(prjid_1, resourceid_1,1,sharelevel_1);
	end loop;
    



    /* ------- CPT 部分 ------- */


    /*  将所有的信息现放到 temptablevalueCpt 中 */
    /*  自己的资产2 */
    for cptid_cursor IN (    select id from CptCapital where resourceid = resourceid_1 )
	loop
	cptid_1 := cptid_cursor.id;
	  insert into temptablevalueCpt values(cptid_1, 2);
	end loop;




    /* 自己下级的资产1 */
    /* 查找下级 */
     
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)), ',%' );

    for subcptid_cursor IN (   select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like managerstr_11 ) ))
	loop
	cptid_1 := subcptid_cursor.id;
        select  count(cptid) INTO countrec  from temptablevalueCpt where cptid = cptid_1;
        if countrec = 0 then
		insert into temptablevalueCpt values(cptid_1, 1);
		end if;
	end loop;

 
   
    /* 由资产的共享获得的权利 1 2 */
    for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	cptid_1 := sharecptid_cursor.relateditemid;
	sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid) INTO countrec from temptablevalueCpt where cptid = cptid_1  ;
        if countrec = 0  then
        
            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end if;
	end loop;




    for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= subcompanyid_1 ) or (t3.rolelevel=2) ))
	loop
	cptid_1 := sharecptid_cursor.relateditemid;
	sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid) INTO countrec from temptablevalueCpt where cptid = cptid_1  ;
        if countrec = 0  then
        
            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end    if;
	end loop;

    


    /* 删除原有的与该人员相关的所有资产权 */
    delete from CptShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allcptid_cursor IN (select * from temptablevalueCpt)
	loop
	cptid_1 :=allcptid_cursor.cptid;
	sharelevel_1 :=allcptid_cursor.sharelevel;
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(cptid_1, resourceid_1,1,sharelevel_1);
	end loop;	

	end if;
end if; /* 结束角色删除或者级别降低的处理 */
end ;
/



/* 人力资源表涉及请求的创建 */
drop TRIGGER Tri_U_workflow_createlist
/

CREATE or REPLACE TRIGGER Tri_U_workflow_createlist 
after insert or update or delete ON  HrmResource
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
countdelete := :old.id;
olddepartmentid_1 := :old.departmentid;
oldseclevel_1 := :old.seclevel;
departmentid_1 := :new.departmentid;
seclevel_1 := :new.seclevel;




/* 如果部门和安全级别信息被修改(在新建的时候这两个信息肯定被修改) */
if ( countdelete = 0 or departmentid_1 <>olddepartmentid_1 or  seclevel_1 <> oldseclevel_1 )   then  


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



update HrmResource set loginid='gmanager',lastname='gmanager',aliasname='gmanager' where id='1'
/

update HrmResource set managerid='1', managerstr='1,'
/
