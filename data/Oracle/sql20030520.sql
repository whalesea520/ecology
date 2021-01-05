
CREATE or replace procedure HrmTrain_Delete
(
id_1 integer,
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
delete HrmTrain 
where
 id = id_1;
delete from HrmTrainActor
where 
  traindayid in (select id from HrmTrainDay where trainid = id_1);
delete from HrmTrainDay
where
  trainid = id_1;
delete from HrmTrainAssess
where
  trainid = id_1;
delete from HrmTrainTest
where
  trainid = id_1;
end;
/






delete HrmJobActivities where jobgroupid not in (select id from HrmJobGroups)
/

delete HrmJobTitles where jobactivityid not in (select id from HrmJobActivities) or jobdepartmentid not in (select id from HrmDepartment)
/

delete HrmCostcenter where departmentid not in (select id from HrmDepartment)
/

alter table license add portal char
/

update license set portal='n'
/

DELETE FROM CRM_CustomizeOption WHERE (id IN (118, 122, 123, 204, 205, 213, 214))
/

UPDATE CRM_CustomizeOption SET labelname = '简称(英文)' WHERE (id = 103)
/

UPDATE CRM_CustomizeOption SET labelname = '代理' WHERE (id = 126)
/

UPDATE CRM_CustomizeOption SET labelname = '上级单位' WHERE (id = 127)
/

UPDATE CRM_CustomizeOption SET fieldname = 'firstname', labelname = '姓名' WHERE (id = 203)
/

DELETE FROM CRM_Customize
/

CREATE or replace procedure Prj_Member_SelectSumByMember
(
id_1	 varchar2,
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS
begin
open thecursor for
select count(id) from prj_projectinfo where  (  concat(concat(',',members),',')  like concat(concat('%,',id_1),',%') and isblock= 1) or manager= id_1 ;
end;
/


CREATE or replace procedure LgcAsset_Update
(
id_1 	integer,
assetcountryid_2 in out integer, 
barcode_3 	varchar2, 
seclevel_4 	smallint, 
assetimageid_5 	integer, 
assettypeid_6 	integer, 
assetunitid_7 	integer, 
replaceassetid_8 	integer, 
assetversion_9 	varchar2, 
assetattribute_10 	varchar2,
counttypeid_11 	integer,
assortmentid_12 	integer,
assortmentstr_13 	varchar2,
relatewfid_1    integer,
assetname_2 	varchar2, 
assetcountyid_3 	integer,
startdate_4 	char,
enddate_5 	char, 
departmentid_6 	integer,
resourceid_7 	integer,
assetremark_8 	varchar2, 
currencyid_9 	integer, 
salesprice_10  IN OUT	varchar2,
costprice_11  IN OUT	varchar2,
datefield1_12 	char,
datefield2_13 	char, 
datefield3_14 	char, 
datefield4_15 	char, 
datefield5_16 	char, 
numberfield1_17 	float,
numberfield2_18 	float, 
numberfield3_19 	float,
numberfield4_20 	float,
numberfield5_21 	float,
textfield1_22 	varchar2,
textfield2_23 	varchar2,
textfield3_24 	varchar2,
textfield4_25 	varchar2, 
textfield5_26 	varchar2, 
tinyintfield1_27 	char, 
tinyintfield2_28 	char, 
tinyintfield3_29 	char,
tinyintfield4_30 	char, 
tinyintfield5_31 	char, 
lastmoderid_32 	integer, 
lastmoddate_33 	char, 
isdefault_1 		char, 
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
salesprice_10 := to_number(salesprice_10);
costprice_11 := to_number(costprice_11) ;

UPDATE    LgcAsset SET  	
relatewfid = relatewfid_1 , 
barcode	 = barcode_3,
seclevel	 = seclevel_4, 
assetimageid	 = assetimageid_5,
assettypeid	 = assettypeid_6, 
assetunitid	 = assetunitid_7, 
replaceassetid	 = replaceassetid_8, 
assetversion	 = assetversion_9,
assetattribute	 = assetattribute_10, 
counttypeid	 = counttypeid_11,
assortmentid	 = assortmentid_12, 
assortmentstr	 = assortmentstr_13  WHERE ( id	 = id_1);  

if  assetcountryid_2=-1 then
select  assetcountyid into assetcountryid_2 from LgcAssetCountry 
where assetid=id_1 and isdefault='1' ;
end   if;
if   isdefault_1='1'  then
update LgcAssetCountry set isdefault='0' where assetid=id_1 ;
end if;

UPDATE LgcAssetCountry SET  
assetname	 = assetname_2,
assetcountyid = assetcountyid_3,
startdate	 = startdate_4,
enddate	 = enddate_5,
departmentid	 = departmentid_6, 
resourceid	 = resourceid_7,
assetremark	 = assetremark_8, 
currencyid	 = currencyid_9, 
salesprice	 = salesprice_10,
costprice	 = costprice_11,
datefield1	 = datefield1_12,
datefield2	 = datefield2_13, 
datefield3	 = datefield3_14, 
datefield4	 = datefield4_15,
datefield5	 = datefield5_16,
numberfield1	 = numberfield1_17,
numberfield2	 = numberfield2_18,
numberfield3	 = numberfield3_19,
numberfield4	 = numberfield4_20,
numberfield5	 = numberfield5_21, 
textfield1	 = textfield1_22, 
textfield2	 = textfield2_23,
textfield3	 = textfield3_24, 
textfield4	 = textfield4_25, 
textfield5	 = textfield5_26, 
tinyintfield1 = tinyintfield1_27, 
tinyintfield2 = tinyintfield2_28, 
tinyintfield3 = tinyintfield3_29,
tinyintfield4 = tinyintfield4_30, 
tinyintfield5 = tinyintfield5_31,
lastmoderid	 = lastmoderid_32,
lastmoddate	 = lastmoddate_33 , 
isdefault	= isdefault_1 
WHERE ( (assetid = id_1) and (assetcountyid =assetcountryid_2)) ;
end;
/


CREATE or replace procedure workflow_currentoperator_SWft 
(
    userid_1		integer,
    usertype_1	integer, 
    complete_1	integer,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor) 
as 
begin
    if complete_1 =0  then
    open thecursor for 
    select count(distinct t1.requestid) typecount,t1.workflowtype from workflow_currentoperator t1,workflow_requestbase t2 
    where t1.userid= userid_1  and t1.usertype= usertype_1 and t1.isremark in( '0','1') and
    t1.requestid=t2.requestid and ( t2.deleted=0 or t2.deleted is null ) and t2.currentnodetype<>'3' 
    group by t1.workflowtype ;
    end if;
    if complete_1 =1 then
    open thecursor for
    select count(distinct t1.requestid) typecount,t1.workflowtype from workflow_currentoperator
    t1,workflow_requestbase t2 where t1.userid= userid_1 and t1.usertype= usertype_1 and t1.isremark ='0' 
    and t1.requestid=t2.requestid and ( t2.deleted=0 or t2.deleted is null ) and t2.currentnodetype='3'
    group by t1.workflowtype ;
    end if;
end;
/



CREATE or replace procedure workflow_currentoperator_SWf 
(
    userid_1		integer, 
    usertype_1	integer, 
    complete_1	integer, 
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
as 
begin
  if complete_1 =0  then
   open thecursor for
  select count( distinct t1.requestid) workflowcount,t1.workflowid from workflow_currentoperator
  t1,workflow_requestbase t2 where t1.isremark in( '0','1') and t1.userid= userid_1 and t1.usertype=
  usertype_1 and t1.requestid=t2.requestid and ( t2.deleted=0 or t2.deleted is null ) and
  t2.currentnodetype<>'3' group by t1.workflowid ;
  end if;
  if complete_1 =1  then 
  open thecursor for
  select count( distinct t1.requestid) workflowcount,t1.workflowid from workflow_currentoperator
  t1,workflow_requestbase t2 where t1.isremark ='0' and t1.userid= userid_1 and t1.usertype= usertype_1 and
  t1.requestid=t2.requestid and ( t2.deleted=0 or t2.deleted is null ) and t2.currentnodetype='3'
  group by t1.workflowid ;
  end if;
end;
/


/*2003年5月22日 建立了一个新的标签*/

insert into HtmlLabelIndex (id,indexdesc) values (7172,'奖惩报告')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7172,'奖惩报告',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7172,'',8)
/

/*2003年5月22日 建立了一个新的标签*/

insert into HtmlLabelIndex (id,indexdesc) values (7173,'奖惩人员统计')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7173,'奖惩人员统计',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7173,'',8)
/

/*2003年5月23日 建立了一个新的标签*/

insert into HtmlLabelIndex (id,indexdesc) values (7174,'奖惩趋势图')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7174,'奖惩趋势图',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7174,'',8)
/

CREATE TABLE WorkPlan (
	id integer  NOT NULL ,
	type_n char(1)  NULL ,
	name varchar2(100)  NULL ,
	resourceid varchar2(200)  NULL ,
	begindate char (10)  NULL ,
	begintime char (8)  NULL ,
	enddate char (10)  NULL ,
	endtime char (8)  NULL ,	
	color char (6)  NULL ,
	description varchar2(255)  NULL ,
	requestid varchar2(100)  NULL ,
	projectid varchar2(100)  NULL ,
	taskid integer  NULL ,
	crmid varchar2(100)  NULL ,
	docid varchar2(100)  NULL ,
	meetingid varchar2(100)  NULL ,
	status char(1)  NULL ,
	isremind integer NULL ,
	waketime integer  NULL ,	
	createrid integer  NULL ,
	createdate char (10)  NULL ,
	createtime char (8)  NULL 	,
	deleted char (1)  NULL 
) 
/
create sequence WorkPlan_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WorkPlan_Trigger
before insert on WorkPlan
for each row
begin
select WorkPlan_id.nextval into :new.id from dual;
end ;
/

CREATE TABLE WorkPlanShareDetail (
	workid integer NULL ,
	userid integer NULL ,
	usertype integer NULL ,
	sharelevel integer NULL 
)
/

CREATE or replace PROCEDURE WorkPlan_Insert 
	(
    type_n_1  char   ,
	name_1  varchar2   ,
	resourceid_1  varchar2   ,
	begindate_1  char   ,
	begintime_1  char   ,
	enddate_1  char    ,
	endtime_1  char  ,	
	color_1 char   ,
	description_1  varchar2   ,
	requestid_1  varchar2   ,
	projectid_1  varchar2   ,
	crmid_1  varchar2  ,
	docid_1  varchar2    ,
	meetingid_1  varchar2   ,
	status_1  char  ,
	isremind_1 integer  ,
	waketime_1 integer   ,	
	createrid_1 integer   ,
	createdate_1 char    ,
	createtime_1 char  ,
	deleted_1 char   ,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO WorkPlan 
	(type_n ,
	name  ,
	resourceid ,
	begindate ,
	begintime ,
	enddate ,
	endtime  ,
	color ,
	description ,
	requestid  ,
	projectid ,
	crmid  ,
	docid  ,
	meetingid ,
	status  ,
	isremind  ,
	waketime  ,	
	createrid  ,
	createdate  ,
	createtime ,
	deleted) 
 
VALUES 
	(type_n_1 ,
	name_1  ,
	resourceid_1 ,
	begindate_1 ,
	begintime_1 ,
	enddate_1 ,
	endtime_1  ,
	color_1 ,
	description_1 ,
	requestid_1  ,
	projectid_1 ,
	crmid_1  ,
	docid_1  ,
	meetingid_1 ,
	status_1  ,
	isremind_1  ,
	waketime_1  ,	
	createrid_1  ,
	createdate_1  ,
	createtime_1 ,
	deleted_1 );
open thecursor for 
select  * from (select * from  WorkPlan order by id desc ) where rownum = 1;
end;
/

CREATE or replace PROCEDURE WorkPlan_Update
	(
	id_1 	integer ,	
	type_n_1  char    ,
	name_1  varchar2   ,
	resourceid_1  varchar2   ,
	begindate_1  char    ,
	begintime_1  char    ,
	enddate_1  char    ,
	endtime_1  char    ,	
	color_1 char   ,
	description_1  varchar2   ,
	requestid_1  varchar2   ,
	projectid_1  varchar2   ,
	crmid_1  varchar2   ,
	docid_1  varchar2   ,
	meetingid_1  varchar2   ,
	isremind_1 integer  ,
	waketime_1 integer   ,	
    flag	out integer, 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS 
begin
UPDATE WorkPlan SET 
	 type_n = type_n_1 , 
	 name = name_1, 
	 resourceid = resourceid_1,
	 begindate = begindate_1, 
	 begintime = begintime_1,
	 enddate = enddate_1 , 
	 endtime = endtime_1, 
	 color = color_1 ,
	 description = description_1 ,
	 requestid = requestid_1 , 
	 projectid = projectid_1 , 
	 crmid = crmid_1 , 
	 docid = docid_1 , 
	 meetingid = meetingid_1 ,
	 isremind = isremind_1 , 
	 waketime = waketime_1 	 
	 where id = id_1 ;
end;
/



CREATE or replace PROCEDURE WorkPlanShare_Insert 
	(
	workid_1 integer  ,
	userid_1 integer   ,	
	usertype_1 integer   ,
	sharelevel_1 integer   ,
    flag	out integer, 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO WorkPlanShareDetail 
	(workid , userid , usertype , sharelevel)
	VALUES
	(workid_1 , userid_1 , usertype_1 , sharelevel_1);
end;
/


CREATE or replace PROCEDURE WorkPlanShare_DelById
	(
	workid_1 integer  ,
    flag	out integer, 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS
begin
delete WorkPlanShareDetail where workid = workid_1;
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
			for detail_cursor IN (select id from HrmResource_Trigger where departmentid = objid and seclevel >= level_n)
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
		for detail_cursor IN (select id from HrmResource_Trigger where subcompanyid1 = objid and seclevel >= level_n)
			loop
			userid :=detail_cursor.id;
			insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,userid,'0');
			end loop;
		end if;

	end loop; 
end if;
end ;
/






