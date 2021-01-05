/* by 王金永 for 新增功能：人力资源模块自定义个人信息和工作信息的字段*/
CREATE TABLE cus_treeform (
    scope varchar2(50) NOT NULL ,
    formlabel varchar2(50) NOT NULL ,
    id integer NOT NULL ,
	parentid integer NOT NULL ,
    viewtype char(1) ,
    scopeorder integer
)
/

delete from cus_treeform where scope='HrmCustomFieldByInfoType' and id in(1,3)
/
insert into cus_treeform(scope,formlabel,id,parentid,viewtype,scopeorder) values('HrmCustomFieldByInfoType','个人信息',1,0,0,10)
/
insert into cus_treeform(scope,formlabel,id,parentid,viewtype,scopeorder) values('HrmCustomFieldByInfoType','工作信息',3,0,0,10)
/

CREATE TABLE HrmRpSubDefine (
	id integer NOT NULL ,
    scopeid integer ,
	resourceid integer  ,
	colname varchar2 (30)  ,
	showorder integer ,
	header varchar2 (60)  
) 
/
create sequence HrmRpSubDefine_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmRpSubDefine_Trigger
before insert on HrmRpSubDefine
for each row
begin
select HrmRpSubDefine_id.nextval into :new.id from dual;
end;
/

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 119,803,'int','/systeminfo/BrowserMain.jsp?url=/hrm/speciality/SpecialityBrowser.jsp','HrmSpeciality','name','id','')
/

INSERT INTO HtmlLabelIndex values(17549,'信息种类') 
/
INSERT INTO HtmlLabelInfo VALUES(17549,'信息种类',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17549,'info type',8) 
/
INSERT INTO HtmlLabelIndex values(17550,'新建子信息') 
/
INSERT INTO HtmlLabelInfo VALUES(17550,'新建子信息',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17550,'new sub info',8) 
/
delete from HtmlLabelIndex where id=17088
/
delete from HtmlLabelInfo where indexid =17088
/
INSERT INTO HtmlLabelIndex values(17088,'自定义信息') 
/
INSERT INTO HtmlLabelInfo VALUES(17088,'自定义信息',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17088,'User Definition',8) 
/
alter table HrmSearchMould add birthdayyear integer
/
alter table HrmSearchMould add birthdaymonth integer
/
alter table HrmSearchMould add birthdayday integer
/
alter table HrmSearchMould add educationlevelto integer
/
alter table HrmSearchMould  modify ( educationlevel integer)
/

CREATE or REPLACE PROCEDURE HrmSearchMould_Insert
	(mouldname_1 	varchar2,
	 userid_2 	integer,
	 resourceid_3 	integer,
	 resourcename_4 	varchar2,
	 jobtitle_5 	integer,
	 activitydesc_6 	varchar2,
	 jobgroup_7 	integer,
	 jobactivity_8 	integer,
	 costcenter_9 	integer,
	 competency_10 	integer,
	 resourcetype_11 	char,
	 status_12 	char,
	 subcompany1_13 	integer,
	 department_14 	integer,
	 location_15 	integer,
	 manager_16 	integer,
	 assistant_17 	integer,
	 roles_18 	integer,
	 seclevel_19 	smallint,
	 joblevel_20 	smallint,
	 workroom_21 	varchar2,
	 telephone_22 	varchar2,
	 startdate_23 	char,
	 enddate_24 	char,
	 contractdate_25 	char,
	 birthday_26 	char,
	 sex_27 	char,
	 seclevelTo_28 	smallint,
	 joblevelTo_29 	smallint,
	 startdateTo_30 	char,
	 enddateTo_31 	char,
	 contractdateTo_32 	char,
	 birthdayTo_33 	char,
	 age_34 	integer,
	 ageTo_35 	integer,
	 resourceidfrom_36 	integer,
	 resourceidto_37 	integer,
	 workcode_38 	varchar2,
	 jobcall_39 	integer,
	 mobile_40 	varchar2,
	 mobilecall_41 	varchar2,
	 fax_42 	varchar2,
	 email_43 	varchar2,
	 folk_44 	varchar2,
	 nativeplace_45 	varchar2,
	 regresidentplace_46 	varchar2,
	 maritalstatus_47 	char,
	 certificatenum_48 	varchar2,
	 tempresidentnumber_49 	varchar2,
	 residentplace_50 	varchar2,
	 homeaddress_51 	varchar2,
	 healthinfo_52 	char,
	 heightfrom_53 	integer,
	 heightto_54 	integer,
	 weightfrom_55 	integer,
	 weightto_56 	integer,
	 educationlevel_57 	char,
	 degree_58 	varchar2,
	 usekind_59 	integer,
	 policy_60 	varchar2,
	 bememberdatefrom_61 	char,
	 bememberdateto_62 	char,
	 bepartydatefrom_63 	char,
	 bepartydateto_64 	char,
	 islabouunion_65 	char,
	 bankid1_66 	integer,
	 accountid1_67 	varchar2,
	 accumfundaccount_68 	varchar2,
	 loginid_69 	varchar2,
	 systemlanguage_70 	integer,
	 birthdayyear_71   integer,
	 birthdaymonth_72  integer,
	 birthdayday_73    integer,
	 educationlevelto_74   integer,
	 flag out integer ,
	 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS
begin
INSERT INTO HrmSearchMould 
	 ( mouldname,
	 userid,
	 resourceid,
	 resourcename,
	 jobtitle,
	 activitydesc,
	 jobgroup,
	 jobactivity,
	 costcenter,
	 competency,
	 resourcetype,
	 status,
	 subcompany1,
	 department,
	 location,
	 manager,
	 assistant,
	 roles,
	 seclevel,
	 joblevel,
	 workroom,
	 telephone,
	 startdate,
	 enddate,
	 contractdate,
	 birthday,
	 sex,
	 seclevelTo,
	 joblevelTo,
	 startdateTo,
	 enddateTo,
	 contractdateTo,
	 birthdayTo,
	 age,
	 ageTo,
	 resourceidfrom,
	 resourceidto,
	 workcode,
	 jobcall,
	 mobile,
	 mobilecall,
	 fax,
	 email,
	 folk,
	 nativeplace,
	 regresidentplace,
	 maritalstatus,
	 certificatenum,
	 tempresidentnumber,
	 residentplace,
	 homeaddress,
	 healthinfo,
	 heightfrom,
	 heightto,
	 weightfrom,
	 weightto,
	 educationlevel,
	 degree,
	 usekind,
	 policy,
	 bememberdatefrom,
	 bememberdateto,
	 bepartydatefrom,
	 bepartydateto,
	 islabouunion,
	 bankid1,
	 accountid1,
	 accumfundaccount,
	 loginid,
	 systemlanguage,
	 birthdayyear,
	 birthdaymonth,
	 birthdayday,
	 educationlevelto) 
 
VALUES 
	( mouldname_1,
	 userid_2,
	 resourceid_3,
	 resourcename_4,
	 jobtitle_5,
	 activitydesc_6,
	 jobgroup_7,
	 jobactivity_8,
	 costcenter_9,
	 competency_10,
	 resourcetype_11,
	 status_12,
	 subcompany1_13,
	 department_14,
	 location_15,
	 manager_16,
	 assistant_17,
	 roles_18,
	 seclevel_19,
	 joblevel_20,
	 workroom_21,
	 telephone_22,
	 startdate_23,
	 enddate_24,
	 contractdate_25,
	 birthday_26,
	 sex_27,
	 seclevelTo_28,
	 joblevelTo_29,
	 startdateTo_30,
	 enddateTo_31,
	 contractdateTo_32,
	 birthdayTo_33,
	 age_34,
	 ageTo_35,
	 resourceidfrom_36,
	 resourceidto_37,
	 workcode_38,
	 jobcall_39,
	 mobile_40,
	 mobilecall_41,
	 fax_42,
	 email_43,
	 folk_44,
	 nativeplace_45,
	 regresidentplace_46,
	 maritalstatus_47,
	 certificatenum_48,
	 tempresidentnumber_49,
	 residentplace_50,
	 homeaddress_51,
	 healthinfo_52,
	 heightfrom_53,
	 heightto_54,
	 weightfrom_55,
	 weightto_56,
	 educationlevel_57,
	 degree_58,
	 usekind_59,
	 policy_60,
	 bememberdatefrom_61,
	 bememberdateto_62,
	 bepartydatefrom_63,
	 bepartydateto_64,
	 islabouunion_65,
	 bankid1_66,
	 accountid1_67,
	 accumfundaccount_68,
	 loginid_69,
	 systemlanguage_70,
	 birthdayyear_71,
	 birthdaymonth_72,
	 birthdayday_73,
	 educationlevelto_74      
     );
open thecursor for 
select max(id) from HrmSearchMould;
end;
/

CREATE or REPLACE PROCEDURE HrmSearchMould_Update
	(id_1 	integer,
	 userid_2 	integer,
	 resourceid_3 	integer,
	 resourcename_4 	varchar2,
	 jobtitle_5 	integer,
	 activitydesc_6 	varchar2,
	 jobgroup_7 	integer,
	 jobactivity_8 	integer,
	 costcenter_9 	integer,
	 competency_10 	integer,
	 resourcetype_11 	char,
	 status_12 	char,
	 subcompany1_13 	integer,
	 department_14 	integer,
	 location_15 	integer,
	 manager_16 	integer,
	 assistant_17 	integer,
	 roles_18 	integer,
	 seclevel_19 	smallint,
	 joblevel_20 	smallint,
	 workroom_21 	varchar2,
	 telephone_22 	varchar2,
	 startdate_23 	char,
	 enddate_24 	char,
	 contractdate_25 	char,
	 birthday_26 	char,
	 sex_27 	char,
	 seclevelTo_28 	smallint,
	 joblevelTo_29 	smallint,
	 startdateTo_30 	char,
	 enddateTo_31 	char,
	 contractdateTo_32 	char,
	 birthdayTo_33 	char,
	 age_34 	integer,
	 ageTo_35 	integer,
	 resourceidfrom_36 	integer,
	 resourceidto_37 	integer,
	 workcode_38 	varchar2,
	 jobcall_39 	integer,
	 mobile_40 	varchar2,
	 mobilecall_41 	varchar2,
	 fax_42 	varchar2,
	 email_43 	varchar2,
	 folk_44 	varchar2,
	 nativeplace_45 	varchar2,
	 regresidentplace_46 	varchar2,
	 maritalstatus_47 	char,
	 certificatenum_48 	varchar2,
	 tempresidentnumber_49 	varchar2,
	 residentplace_50 	varchar2,
	 homeaddress_51 	varchar2,
	 healthinfo_52 	char,
	 heightfrom_53 	integer,
	 heightto_54 	integer,
	 weightfrom_55 	integer,
	 weightto_56 	integer,
	 educationlevel_57 	char,
	 degree_58 	varchar2,
	 usekind_59 	integer,
	 policy_60 	varchar2,
	 bememberdatefrom_61 	char,
	 bememberdateto_62 	char,
	 bepartydatefrom_63 	char,
	 bepartydateto_64 	char,
	 islabouunion_65 	char,
	 bankid1_66 	integer,
	 accountid1_67 	varchar2,
	 accumfundaccount_68 	varchar2,
	 loginid_69 	varchar2,
	 systemlanguage_70 	integer,
	 birthdayyear_71   integer,
	 birthdaymonth_72  integer,
	 birthdayday_73    integer,
	 educationlevelto_74   integer,
	 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS 
begin
UPDATE HrmSearchMould 
SET      userid	 = userid_2,
	 resourceid	 = resourceid_3,
	 resourcename	 = resourcename_4,
	 jobtitle	 = jobtitle_5,
	 activitydesc	 = activitydesc_6,
	 jobgroup	 = jobgroup_7,
	 jobactivity	 = jobactivity_8,
	 costcenter	 = costcenter_9,
	 competency	 = competency_10,
	 resourcetype	 = resourcetype_11,
	 status	 = status_12,
	 subcompany1	 = subcompany1_13,
	 department	 = department_14,
	 location	 = location_15,
	 manager	 = manager_16,
	 assistant	 = assistant_17,
	 roles	 = roles_18,
	 seclevel	 = seclevel_19,
	 joblevel	 = joblevel_20,
	 workroom	 = workroom_21,
	 telephone	 = telephone_22,
	 startdate	 = startdate_23,
	 enddate	 = enddate_24,
	 contractdate	 = contractdate_25,
	 birthday	 = birthday_26,
	 sex	 = sex_27,
	 seclevelTo	 = seclevelTo_28,
	 joblevelTo	 = joblevelTo_29,
	 startdateTo	 = startdateTo_30,
	 enddateTo	 = enddateTo_31,
	 contractdateTo	 = contractdateTo_32,
	 birthdayTo	 = birthdayTo_33,
	 age	 = age_34,
	 ageTo	 = ageTo_35,
	 resourceidfrom	 = resourceidfrom_36,
	 resourceidto	 = resourceidto_37,
	 workcode	 = workcode_38,
	 jobcall	 = jobcall_39,
	 mobile	 = mobile_40,
	 mobilecall	 = mobilecall_41,
	 fax	 = fax_42,
	 email	 = email_43,
	 folk	 = folk_44,
	 nativeplace	 = nativeplace_45,
	 regresidentplace	 = regresidentplace_46,
	 maritalstatus	 = maritalstatus_47,
	 certificatenum	 = certificatenum_48,
	 tempresidentnumber	 = tempresidentnumber_49,
	 residentplace	 = residentplace_50,
	 homeaddress	 = homeaddress_51,
	 healthinfo	 = healthinfo_52,
	 heightfrom	 = heightfrom_53,
	 heightto	 = heightto_54,
	 weightfrom	 = weightfrom_55,
	 weightto	 = weightto_56,
	 educationlevel	 = educationlevel_57,
	 degree	 = degree_58,
	 usekind	 = usekind_59,
	 policy	 = policy_60,
	 bememberdatefrom	 = bememberdatefrom_61,
	 bememberdateto	 = bememberdateto_62,
	 bepartydatefrom	 = bepartydatefrom_63,
	 bepartydateto	 = bepartydateto_64,
	 islabouunion	 = islabouunion_65,
	 bankid1	 = bankid1_66,
	 accountid1	 = accountid1_67,
	 accumfundaccount	 = accumfundaccount_68,
	 loginid	 = loginid_69,
	 systemlanguage	 = systemlanguage_70 ,
	 birthdayyear   =   birthdayyear_71   ,
	 birthdaymonth  =   birthdaymonth_72  ,
	 birthdayday    =   birthdayday_73    ,
	 educationlevelto   =   educationlevelto_74 

WHERE 
	( id = id_1);
end;
/