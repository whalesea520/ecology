
/*
BUG 87 学历维护的权限bug-王金永
*/

delete from SystemRightToGroup where rightid=382
/
insert into SystemRightToGroup (groupid,rightid) values (3,382) 
/
update SystemRightRoles set rolelevel='2' where rightid=382
/ 
delete from SystemRightToGroup where rightid=127
/
insert into SystemRightToGroup (groupid,rightid) values (3,127) 
/
delete from SystemRightRoles where rightid=127
/ 
insert into SystemRightRoles (rightid,roleid,rolelevel) values (127,4,'2') 
/

/**
*For bug 87,
*删除 工作简历维护，教育情况维护，家庭情况维护，成本中心维护权限
*
*/
/*工作简历*/
DELETE FROM SystemRights WHERE id=128 
/
DELETE FROM SystemRightsLanguage WHERE id=128
/
DELETE FROM SystemRightDetail WHERE rightid=128
/
DELETE FROM systemrighttogroup WHERE Rightid=128
/
DELETE FROM SystemRightRoles WHERE RightID =128  
/

/*教育情况*/
DELETE FROM SystemRights WHERE id= 129
/
DELETE FROM SystemRightsLanguage WHERE id=129
/
DELETE FROM SystemRightDetail WHERE rightid=129
/
DELETE FROM systemrighttogroup WHERE Rightid=129
/
DELETE FROM SystemRightRoles WHERE RightID = 129 
/

/*家庭情况*/
DELETE FROM SystemRights WHERE id= 130
/
DELETE FROM SystemRightsLanguage WHERE id= 130
/
DELETE FROM SystemRightDetail WHERE rightid= 130
/ 
DELETE FROM systemrighttogroup WHERE Rightid= 130
/
DELETE FROM SystemRightRoles WHERE RightID =  130
/

/*成本中心*/
DELETE FROM SystemRights WHERE id= 20
/
DELETE FROM SystemRightsLanguage WHERE id=20
/
DELETE FROM SystemRightDetail WHERE rightid=20
/
DELETE FROM systemrighttogroup WHERE Rightid=20
/
DELETE FROM SystemRightRoles WHERE RightID = 20 
/
/*成本中心类别维护*/
DELETE FROM SystemRights WHERE id=21
/
DELETE FROM SystemRightsLanguage WHERE id=21
/
DELETE FROM SystemRightDetail WHERE rightid=21
/
DELETE FROM systemrighttogroup WHERE Rightid=21
/
DELETE FROM SystemRightRoles WHERE RightID =21
/

/*
bug:93 显示栏目维护权限没有默认的角色设置 by 王金永 
*/
delete from SystemRights where id = 309
/
delete from SystemRightsLanguage where id = 309
/
delete from SystemRightDetail where id=2009
/ 
insert into SystemRights (id,rightdesc,righttype) values (309,'显示栏目维护','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (309,7,'显示栏目维护','显示栏目维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (309,8,'ShowColumn','ShowColumn') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (2009,'显示栏目维护','ShowColumn:Operate',309) 
/
delete from SystemRightToGroup where rightid=309
/
insert into SystemRightToGroup (groupid,rightid) values (3,309) 
/
delete from SystemRightRoles where rightid=309
/ 
insert into SystemRightRoles (rightid,roleid,rolelevel) values (309,4,'2') 
/

/**
*For Bug 99 ,图形编辑维护权限的默认角色设置为总部级别的人力资源管理员。
*/
insert into SystemRights (id,rightdesc,righttype) values (417,'组织架构图形编辑','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (417,8,'Organization Hiberarchy Chart','Organization Hiberarchy Chart') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (417,7,'组织架构图形编辑','组织架构图形编辑') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3107,'组织架构图形编辑','HrmDepartLayoutEdit:Edit',417) 
/
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,417)
/
DELETE FROM SystemRightRoles WHERE RightID = 417 and RoleID = 4
/
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (417,4,2)
/

/*For Bug 119，Modified by Charoes Huang On May 28,2004*/
CREATE or replace PROCEDURE Employee_SByStatus
(
	flag	out		integer,
	msg  out		varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
as
hrmid_1 integer;
id_1 integer;
lastname_1 varchar2(60);
sex_1 char(1);
startdate_1 char(10);
departmentid_1 integer;
joblevel_1 smallint;
managerid_1 integer;

begin  
for employee_cursor  IN (select distinct(hrmid) from HrmInfoStatus t1,HrmResource t2 where t1.status ='0' and t1.hrmid = t2.id) 
loop
hrmid_1 :=employee_cursor.hrmid ;
select id,lastname,sex,startdate,departmentid,joblevel,managerid INTO id_1,
lastname_1,sex_1,startdate_1,departmentid_1,joblevel_1,managerid_1 from HrmResource WHERE id=hrmid_1;
	
	insert INTO temp_Employee_table_01(id,lastname,sex,startdate,departmentid,joblevel,managerid)
	values(id_1,lastname_1,sex_1,startdate_1,departmentid_1,joblevel_1,managerid_1);
end loop;
open thecursor for
	select * from temp_Employee_table_01;
end;
/

/* bug 183 Added BY Huang Yu,增加培训资源到日志条目基本表中*/
DELETE FROM SystemLogItem WHERE itemid = 68
/
INSERT INTO SystemLogItem (itemid,lableid,itemdesc) VALUES (68,15879,'培训资源')
/

/*合同种类维护 权限 BUG 208*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=383
/
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,383)
/
DELETE FROM SystemRightRoles WHERE RightID = 383 and RoleID = 4
/
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (383,4,2)
/

/*Bug 216, 将“合同维护”权限归纳到“人力资源管理权限组”中*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=384
/
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,384)
/
DELETE FROM SystemRightRoles WHERE RightID = 384 and RoleID = 4
/
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (384,4,2)
/

/* bug：226 Created By Charoes Huang On May 21,2004*/
INSERT INTO HtmlLabelIndex values(17411,'试用期结束日期必须在合同开始和结束日期之间') 
/
INSERT INTO HtmlLabelInfo VALUES(17411,'试用期结束日期必须在合同开始和结束日期之间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17411,'The probation end date must be betwee the start date and end date of the contract!',8) 
/

/**
*Create by Charoes Huang
*Date July 16 ,2004
*Description : For bug 229,设置 流程用工需求的 提交人默认为显示
*/

update workflow_nodeform set isview=1 where nodeid=233 and fieldid=412
/
update workflow_nodeform set isview=1 where nodeid=234 and fieldid=412
/
update workflow_nodeform set isview=1 where nodeid=235 and fieldid=412
/
update workflow_nodeform set isview=1 where nodeid=236 and fieldid=412
/
update workflow_nodeform set isview=1 where nodeid=237 and fieldid=412
/

/*BUG270  hangyu */
DELETE FROM SystemRights WHERE id = 122
/
DELETE FROM SystemRightsLanguage WHERE id = 122
/
DELETE FROM SystemRightDetail WHERE rightid = 122
/
insert into SystemRights (id,rightdesc,righttype) values (122,'培训种类维护','3') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (122,7,'培训种类维护','培训种类维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (122,8,'TrainTypeMaintenance','TrainTypeMaintenance') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (410,'培训种类添加','HrmTrainTypeAdd:Add',122) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (411,'培训种类编辑','HrmTrainTypeEdit:Edit',122) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (412,'培训种类删除','HrmTrainTypeEdit:Delete',122) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (413,'培训种类日志查看','HrmTrainType:Log',122) 
/
/*更改默认为人力资源管理组的权限*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=122
/
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,122)
/
DELETE FROM SystemRightRoles WHERE RightID = 122 and RoleID = 4
/
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (122,4,2)
/

/*Bug 274, 将“培训规划”权限归纳到“人力资源管理权限组”中*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=370
/
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,370)
/
DELETE FROM SystemRightRoles WHERE RightID = 370 and RoleID = 4
/
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (370,4,2)
/


/*Bug 283, 将“培训资源”权限归纳到“人力资源管理权限组”中*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=372
/
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,372)
/
DELETE FROM SystemRightRoles WHERE RightID = 372 and RoleID = 4
/
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (372,4,2)
/

/*BUG286  by hy 删除培训安排，培训活动的权限 */
/*培训安排*/
DELETE FROM SystemRights WHERE id = 371
/
DELETE FROM SystemRightsLanguage WHERE id = 371
/
DELETE FROM SystemRightDetail WHERE rightid = 371
/
DELETE FROM SystemRightToGroup WHERE rightid=371
/
DELETE FROM SystemRightRoles WHERE RightID = 371 
/
/*培训活动*/
DELETE FROM SystemRights WHERE id = 373
/
DELETE FROM SystemRightsLanguage WHERE id = 373
/
DELETE FROM SystemRightDetail WHERE rightid = 373
/
DELETE FROM SystemRightToGroup WHERE rightid=373
/
DELETE FROM SystemRightRoles WHERE RightID = 373 
/

/*更改'专业维护'权限 默认为人力资源管理组的权限*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=125
/
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,125)
/
DELETE FROM SystemRightRoles WHERE RightID = 125 and RoleID = 4
/
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (125,4,2)
/

/*For Bug 290 with Modified By Charoes Huang ,May 31,2004*/
create or replace  procedure HrmTrain_Insert
(name_1 varchar2,
 planid_2 integer,
 organizer_3 varchar2,
 startdate_4 char,
 enddate_5 char,
 content_6 Varchar2,
 aim_7 Varchar2,
 address_8 varchar2,
 resource_n_9 varchar2, 
 createrid_10 integer,
 testdate_11 char,
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
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
 select max(id) from HrmTrain ;
 end;/* Modified From ' select max(id) from HrmTrainDay'*/
/

/*for id=298 by 王金永*/
update workflow_base set isvalid='1' where id=26 and workflowname='培训申请'
/

/*Created By Charoes Huang On May 19,2004 FOR BUG 301
 *奖惩类型维护 ->奖惩种类维护	
*/
DELETE SystemRights WHERE id = 123
/
DELETE SystemRightsLanguage WHERE id = 123
/
DELETE SystemRightDetail WHERE rightid = 123
/
insert into SystemRights (id,rightdesc,righttype) values (123,'奖惩种类维护','3') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (123,7,'奖惩种类维护','奖惩种类维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (123,8,'Awards-Punishments Type Maintenance','Awards-Punishments Type Maintenance') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (414,'奖惩种类添加','HrmRewardsTypeAdd:Add',123) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (415,'奖惩种类编辑','HrmRewardsTypeEdit:Edit',123) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (416,'奖惩种类删除','HrmRewardsTypeEdit:Delete',123) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (417,'奖惩种类日志查看','HrmRewardsType:Log',123) 
/
/*更改默认为人力资源管理组的权限*/
DELETE systemrighttogroup WHERE GroupID = 3 and rightid=123
/
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,123)
/
DELETE SystemRightRoles WHERE RightID = 123 and RoleID = 4
/
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (123,4,1)
/


/*
* For Bug 304
* Created By Charoes Huang ,June 1,2004
*/
create or replace  PROCEDURE HrmTrainTest_Update
(trainid_1 integer,
 resourceid_2 integer,
 testdate_3 char,
 result_4 integer,
 explain_5 Varchar2,
 testerid_6 integer,
 id_7 integer,
 flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin
   UPDATE HrmTrainTest
      SET resourceid = resourceid_2,
	  testdate = testdate_3,
	  result = result_4,
          explain = explain_5
      WHERE ID = id_7;
end;
/

/*
*Created by Charoes Huang
*FOR bug 312
*/

CREATE OR REPLACE PROCEDURE HrmCheckItem_SByid 
(id_1 integer,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS
begin 
open thecursor for 
SELECT * FROM HrmCheckItem WHERE id = id_1;
end;
/

/*
Created By Charoes Huang On May 30,2004
FOR BUG 313, 删除权限没有插入数据库*/

DELETE FROM SystemRights WHERE id = 387
/
DELETE FROM SystemRightsLanguage WHERE id = 387
/
DELETE FROM SystemRightDetail WHERE rightid = 387
/
insert into SystemRights (id,rightdesc,righttype) values (387,'人力资源考核项目维护','3') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (387,7,'人力资源考核项目维护','人力资源考核项目新建，编辑和删除') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (387,8,'HRMTestItemMaintenance','New,Edit and Delete HRMTestItem') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (387,7,'人力资源考核项目维护','人力资源考核项目新建，编辑和删除') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (387,8,'HRMTestItemMaintenance','New,Edit and Delete HRMTestItem') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3054,'人力资源考核项目新建','HrmCheckItemAdd:Add',387) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3055,'人力资源考核项目编辑','HrmCheckItemEdit:Edit',387) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3128,'人力资源考核项目删除','HrmCheckItemEdit:Delete',387) 
/
/*更改默认为人力资源管理组的权限*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=387
/
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,387)
/
DELETE FROM SystemRightRoles WHERE RightID = 387 and RoleID = 4
/
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (387,4,1) /*分部级别的权限*/
/

/*
Created By Charoes Huang On May 19,2004
FOR BUG 414*/
INSERT INTO HtmlLabelIndex values(17408,'考核期必须大于零') 
/
INSERT INTO HtmlLabelInfo VALUES(17408,'考核期必须大于零',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17409,'The test period must be larger than zero!',8) 
/

/**
 *For Bug 426
 *Created by Charoes Huang, June 2,2004
 *
*/
INSERT INTO HtmlLabelIndex values(17425,'被考核岗位') 
/
INSERT INTO HtmlLabelInfo VALUES(17425,'被考核岗位',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17425,'Post Examined',8) 
/
/*
 * Script Created ON : May 13,2004
 * Author : Charoes lu peng
*/
/*FOR BUG 436 修改了存储过程FnaYearsPeriodsList_SByFnayear，增加对Periodsid排序*/
CREATE OR REPLACE PROCEDURE FnaYearsPeriodsList_SByFnayear (id_1 	integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) 
as 
begin 
open thecursor for select * from FnaYearsPeriodsList where fnayearid =id_1 order by Periodsid;
end;
/
CREATE OR REPLACE PROCEDURE FnaYearsPeriodsList_Update
(id_1 	integer,
startdate_2 	char,
enddate_3 	char,
fnayearid_4    integer,
isactive_5 	char,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 
minfromdate_1 char(10);
maxenddate_1 char(10); 
begin 
UPDATE FnaYearsPeriodsList SET  startdate=startdate_2, enddate=enddate_3 , isactive=isactive_5 WHERE ( id=id_1); 
select min(startdate) into minfromdate_1 from FnaYearsPeriodsList where fnayearid=fnayearid_4 and (startdate is not null); 
select  max(enddate) into maxenddate_1 from FnaYearsPeriodsList where fnayearid=fnayearid_4 and (enddate is not null) ; 
update FnaYearsPeriods set startdate=minfromdate_1 , enddate = maxenddate_1 where id = fnayearid_4; 
end;
/

/*FOR BUG 437 在ORACLE上的存储过程FnaYearsPeriodsList_Update中使用错误的空值判断enddate <> ''，现修改为enddate <> IS NOT NULL*/
CREATE OR REPLACE PROCEDURE FnaYearsPeriodsList_SByFnayear
(id_1 	integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
as 
begin 
open thecursor for select * from FnaYearsPeriodsList where fnayearid =  id_1 order by Periodsid;
end;
/
CREATE OR REPLACE PROCEDURE FnaYearsPeriodsList_Update
(id_1 	integer,
startdate_2 	char,
enddate_3 	char,
fnayearid_4    integer,
isactive_5 	char,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 
minfromdate_1 char(10);
maxenddate_1 char(10); 
begin 
UPDATE FnaYearsPeriodsList SET  startdate=startdate_2, enddate=enddate_3 , isactive=isactive_5 WHERE ( id=id_1); 
select min(startdate) into minfromdate_1 from FnaYearsPeriodsList where fnayearid=fnayearid_4 and (startdate is not null); 
select  max(enddate) into maxenddate_1 from FnaYearsPeriodsList where fnayearid=fnayearid_4 and (enddate is not null) ; 
update FnaYearsPeriods set startdate=minfromdate_1 , enddate = maxenddate_1 where id = fnayearid_4;
end;
/

/*FOR BUG 449 修改了FnaLoanLog表的description字段长度为4000*/
ALTER TABLE FnaLoanLog MODIFY description varchar2(4000)
/

/*FOR BUG 522,by 路鹏*/
DELETE SystemRightRoles WHERE rightid = 137 AND roleid = 2
/

/*FOR BUG 528 and 540,by 路鹏*/
insert into HtmlNoteIndex (id,indexdesc) values (56,'该资产组下已设置资产，不能再新建资产组。') 
/
insert into HtmlNoteInfo (indexid,notename,languageid) values (56, '该资产组下已设置资产，不能再新建资产组。', 7) 
/
insert into HtmlNoteInfo (indexid,notename,languageid) values (56, 'Can''t create a capital group under this group.', 8) 
/

/*FOR BUG 538,by 路鹏*/
UPDATE SystemLogItem SET lableid=831, itemdesc='资产组' WHERE itemid=43
/


/*FOR BUG 541,by 路鹏 （此脚本没有对应的sql脚本）*/
CREATE OR REPLACE PROCEDURE CptCapitalAssortment_Delete (id_1 	int, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) 
AS 
count_1 integer ; 
supassortmentid_1 integer; 
begin 
select  capitalcount into count_1  from CptCapitalAssortment where id =  id_1 ; 
if  count_1 <> 0  then open thecursor for select -1 from dual ; 
return ; 
end  if;  
select  subassortmentcount into count_1 from CptCapitalAssortment where id =  id_1 ; 
if  count_1 <> 0 then open thecursor for select -1 from dual; 
return ; 
end  if;  
select  supassortmentid into supassortmentid_1 from CptCapitalAssortment where id=  id_1;  
update CptCapitalAssortment set subassortmentcount = subassortmentcount-1 where id=  supassortmentid_1; 
DELETE CptCapitalAssortment WHERE id =  id_1; 
end;
/

/*FOR BUG 544,by 路鹏(仅oracle)*/
CREATE OR REPLACE PROCEDURE CptCapital_Delete 
(id_1 	integer,
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
AS begin 
update CptCapitalAssortment set 
capitalcount = capitalcount-1 where id in (select capitalgroupid from CptCapital where id = id_1 );  
DELETE CptCapital WHERE ( id=id_1);
open thecursor for select max(id) from CptCapital;
end;
/
/* td :546 by lp */
UPDATE SysMaintenanceLog SET operateitem = 44 WHERE operatedesc LIKE 'CptCapitalType%'
/

/*FOR BUG 547 被引用的资产类型，却能被删除,by 路鹏*/
CREATE or REPLACE PROCEDURE CptCapitalType_Delete (
id_1 integer,
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
count_1 integer;
begin
SELECT count(id) into count_1 FROM CptCapital WHERE capitaltypeid = id_1;
    if (count_1>0) then
        open thecursor for
        select -1 from dual;
        return;
    end if;
    DELETE CptCapitalType WHERE id = id_1;
end;
/

/*FOR BUG 553 在新建时自动将数据库记录ID赋给“标识”字段。by 路鹏*/
CREATE or REPLACE PROCEDURE LgcAssetUnit_Insert (
unitmark_1 	varchar2, 
unitname_2 	varchar2, 
unitdesc_3 	varchar2, 
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
AS 
unitId_1 integer;
begin
INSERT INTO LgcAssetUnit 
( unitmark, unitname, unitdesc)  
VALUES ( unitmark_1, unitname_2, unitdesc_3);
select max(id) into unitId_1 from LgcAssetUnit;
UPDATE LgcAssetUnit SET unitmark = to_char(unitId_1) WHERE id = unitId_1;
end;
/
/* Create the set marks stored procedure */
CREATE or REPLACE PROCEDURE LgcAssetUnit_SetAllMarks 
AS
m_id integer;
m_mark varchar2(60);
begin
for all_cursor in
(SELECT id, unitmark FROM LgcAssetUnit)
loop
    m_id:=all_cursor.id;
    m_mark:=all_cursor.unitmark;
    if (m_mark IS NULL OR m_mark = '') then
         UPDATE LgcAssetUnit SET unitmark = to_char(m_id) WHERE id = m_id;
    end if;
end loop;
end;
/
/* end */


/* Invoke the above stored procedure */
call LgcAssetUnit_SetAllMarks()
/
DROP PROCEDURE LgcAssetUnit_SetAllMarks
/
/* end */

/*FOR BUG 554 在计量单位删除的存储过程中增加了对资产资料引用的判断 by 路鹏*/
CREATE or REPLACE PROCEDURE LgcAssetUnit_Delete (
id_1 integer, 
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS
count_1 integer;
begin
select count(id) into count_1 from LgcAsset where assetunitid = id_1 ;
if count_1 <> 0 then
open thecursor for
select -1 from dual;
return;
end if;
SELECT count(id) into count_1 FROM CptCapital WHERE unitid = id_1 ;
if count_1 <> 0 then
open thecursor for
select -1 from dual;
return;
end if;
DELETE LgcAssetUnit WHERE ( id= id_1);
end;
/

/*td:555 */
UPDATE SystemRights SET rightdesc = '资产自定义的信息维护' WHERE id = 119
/
UPDATE SystemRightsLanguage SET rightname = '资产自定义信息维护', rightdesc='资产自定义信息维护' WHERE id = 119 AND languageid=7
/
UPDATE SystemRightDetail SET rightdetailname = '资产自定义信息维护' WHERE rightid = 119
/

/*FOR BUG 556 资产'自定义信息'列表和编辑页面的页头错误 by 路鹏*/
INSERT INTO HtmlLabelIndex values(17476,'资产自定义字段') 
/
INSERT INTO HtmlLabelInfo VALUES(17476,'资产自定义字段',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17476,'User Definition Field',8) 
/
/*td:558 by lp */
insert into SystemRights (id,rightdesc,righttype) values (439,'资产资料维护','0') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (439,7,'资产资料维护','资产资料维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (439,8,'Capital Maintenance','Capital Maintenance') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3130,'资产资料维护','Capital:Maintenance',439) 
/
insert into SystemRightToGroup (groupid, rightid) values (9, 439)
/
insert into SystemRightRoles (rightid, roleid, rolelevel) values (439, 7, '2')
/
CREATE or REPLACE PROCEDURE CptCapital_ForcedDelete (
id_1 integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
AS
begin
UPDATE CptCapitalAssortment SET capitalcount = capitalcount-1 
WHERE id IN (SELECT capitalgroupid FROM CptCapital WHERE id = id_1) ; 
DELETE CptCapital WHERE id = id_1 ;
end;
/
/*td:562 资产资料删除图片，返回500错误（仅oracle脚本）*/
CREATE OR REPLACE PROCEDURE CptCapital_UpdatePic (
id_1 integer, capitalimageid_2 integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
AS 
BEGIN
UPDATE CptCapital SET capitalimageid = 0 WHERE id = id_1;
DELETE ImageFile WHERE imagefileid = capitalimageid_2;
END;
/

/*FOR BUG620 (3) ,专业设置的日志*/
DELETE FROM SystemLogItem WHERE ItemID = '63'
/
INSERT INTO SystemLogItem(itemid,lableid,itemdesc) Values ('63',16463,'专业设置')
/