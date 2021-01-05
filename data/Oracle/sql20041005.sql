/*td:699 */
update SystemRightsLanguage set rightname = '字段定义' ,rightdesc ='字段定义' where id = 92  and languageid= 7 
/
update SystemRights set rightdesc ='字段定义',righttype='6' where id =92
/
/*td:701 删除无用的项目维护权限：计划分类维护、计划类型维护、项目状态维护、监控类型维护、项目维护、项目查看、项目成员维护*/
delete SystemRights where  id = 56 or  id = 57 or  id = 58 or  id = 59 or  id = 98 or  id = 99 or  id = 100
/
delete SystemRightsLanguage where  id = 56 or  id = 57 or  id = 58 or  id = 59 or  id = 98 or  id = 99 or  id = 100
/
delete systemrighttogroup where rightid = 56 or  rightid = 57 or  rightid = 58 or  rightid = 59 or  rightid = 98 or  rightid = 99 or  rightid = 100
/
delete systemrightroles where rightid = 56 or  rightid = 57 or  rightid = 58 or  rightid = 59 or  rightid = 98 or  rightid = 99 or  rightid = 100
/
/*td：720 培训种类和培训规划的显示页面添加新建日志*/
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

  open thecursor for 
  select max(id) from HrmTrainType;
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

 open thecursor for 
  select max(id) from HrmTrainLayout;

end;
/
/* td：721 城市维护权限和省份维护权限添加默认放入角色－总部级别的系统管理员 */
create PROCEDURE doInitInsert
as 
result integer ;
begin
select count(id) into result from SystemRightRoles  where rightid = 135 and roleid = 2 ;
if  result = 0 then
	insert into SystemRightRoles (rightid,roleid,rolelevel) values (135,2,2) ;
end if ;

select count(id) into result from SystemRightRoles  where rightid = 134 and roleid = 2 ;
if  result = 0 then
	insert into SystemRightRoles (rightid,roleid,rolelevel) values (134,2,2) ;
end if ;
end ;
/
call doInitInsert()  
/
drop PROCEDURE doInitInsert
/

/* td:724 新建培训安排，无法保存预算费用*/
alter table HrmTrainPlan modify planbudgettype varchar2(4)
/

/*td:1110 缺陷:收藏夹允许重复插入同一一个页面，并且收藏夹中最多只能容纳15个页面。现已修改为收藏夹可以无限制添加，但是不能加入同一页面 */

INSERT INTO HtmlLabelIndex values(17552,'此页面已经存在！') 
/
INSERT INTO HtmlLabelInfo VALUES(17552,'此页面已经存在！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17552,'The page has exist',8) 
/
 CREATE or REPLACE PROCEDURE SysFavourite_Insert 
 ( resourceid1 integer,
 Adddate1 char,
 Addtime1 char, 
 Pagename1    varchar2,
 URL1     varchar2, 
 flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 
   totalcount   integer; 
begin
select count(*)  INTO totalcount  from sysfavourite where URL=URL1 ;
if totalcount<=0 
then 
INSERT INTO SysFavourite 
( Resourceid, 
Adddate,
Addtime, 
Pagename,
URL) 
VALUES
( Resourceid1,
Adddate1,
Addtime1,
Pagename1,
URL1) ;
open thecursor for
    select 1 from dual;
    return ;
else 
    open thecursor for
    select 0 from dual;
    return ;
end if;
end;
/
/*td:1121 不能正常编辑客户类型*/
CREATE or replace PROCEDURE CRM_CustomerType_SelectByID 
(id_1 integer, 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) AS
begin
open thecursor for
SELECT CRM_CustomerType.* , workflow_base.workflowname FROM CRM_CustomerType , workflow_base 
where CRM_CustomerType.workflowid = workflow_base.id(+) and (CRM_CustomerType.id = id_1);
end;
/
INSERT INTO HtmlLabelIndex values(17037,'自定义字段') 
/
INSERT INTO HtmlLabelInfo VALUES(17037,'自定义字段',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17037,'User Definition',8)
/
delete HtmlLabelIndex where id = 16676
/
delete HtmlLabelInfo where indexid = 16676
/
insert into HtmlLabelIndex values(16676,'多行请假单')
/
insert into HtmlLabelInfo values(16676,'多行请假单',7)
/
insert into HtmlLabelInfo values(16676,'',8)
/
CREATE or REPLACE PROCEDURE Workflow_ReportType_Delete 
	(id_1 	integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS 
	count1 integer;
begin
	select count(id) INTO count1 from Workflow_Report where reporttype = id_1;
if count1 <> 0 then
	open thecursor for
	select 0 from dual;
else
	DELETE Workflow_ReportType WHERE ( id = id_1);
end if;
end;
/
UPDATE license set cversion = '2.643'
/