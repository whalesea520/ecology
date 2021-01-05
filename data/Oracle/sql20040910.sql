
/*td:667  by 王金永 for  表单明细字段新建页面的页头是【字段管理:添加】修改为【 新建：明细字段 】*/

delete HtmlLabelInfo   where indexid = 17463
/
delete HtmlLabelIndex   where id = 17463
/
delete HtmlLabelInfo   where indexid = 6074
/
delete HtmlLabelIndex   where id = 6074
/
INSERT INTO HtmlLabelIndex values(6074,'主') 
/
INSERT INTO HtmlLabelInfo VALUES(6074,'主',7) 
/
INSERT INTO HtmlLabelInfo VALUES(6074,'Main',8) 
/
INSERT INTO HtmlLabelIndex values(17463,'明细') 
/
INSERT INTO HtmlLabelInfo VALUES(17463,'明细',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17463,'Detail',8) 
/

/* td：690 by 董平 for  清除了项目类型的自动批处理缺陷 */
CREATE OR REPLACE PROCEDURE Prj_T_ShareInfo_SbyRelateid 
( relateditemid_1 integer , 
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS
begin 
    open thecursor for
    select * from Prj_T_ShareInfo where ( relateditemid = relateditemid_1 ) order by sharetype; 
end;
/

/* td:708  by 王金永 for 新建或者编辑工作流名称不能超过60个字符，否则返回500错误。现已修改为新建或者编辑工作流名称，最多可以输入50个字母或汉字*/
alter table workflow_base modify (workflowname varchar(100))
/
alter table workflow_base modify(workflowdesc varchar(200))
/

/*td:729 项目任务的【人力使用】页面没有显示内容，并且负责人下拉菜单中也没有内容。*/
 CREATE OR REPLACE PROCEDURE Prj_Member_SumProcess (
 prjid1 integer,
 hrmid1 integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
 )
 AS
     begin

          if hrmid1 = 0 or hrmid1 is null then
               open thecursor for

               SELECT hrmid,  min(begindate)   begindate1, max(enddate)   enddate1 FROM Prj_TaskProcess
               WHERE ( prjid     = prjid1  and isdelete <> 1 ) group by hrmid ;
          else
               open thecursor for

               SELECT hrmid,  min(begindate)   begindate1, max(enddate)   enddate1
               FROM Prj_TaskProcess WHERE ( prjid   = prjid1  and isdelete <> 1 and hrmid=hrmid1)
               group by hrmid;
          end if;
     end;
/

/* td：733 */
update  Prj_ProjectStatus set id =7 where fullname='审批退回'
/

/* td:736 项目任务中不能更改任务的负责人*/
 CREATE OR REPLACE PROCEDURE Prj_TaskProcess_Update 
 (
 id1	integer, 
 wbscoding1 varchar2, 
 subject1 	varchar2,
 begindate1 	varchar2, 
 enddate1 	varchar2, 
 workday1 number, 
 content1 	varchar2, 
 fixedcost1 number, 
 hrmid1 integer, 
 oldhrmid1 integer, 
 finish1 smallint, 
 taskconfirm1 char, 
 islandmark1 char, 
 prefinish_1 varchar2,
 flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor 
 ) AS currenthrmid1 varchar2(255); currentoldhrmid1 varchar2(255); 
 begin 
         UPDATE Prj_TaskProcess  
                SET wbscoding = wbscoding1, subject = subject1 , begindate = begindate1, enddate = enddate1 	, workday = workday1, content = content1, fixedcost = fixedcost1, hrmid = hrmid1, finish = finish1 , taskconfirm = taskconfirm1, islandmark = islandmark1, prefinish =prefinish_1                 
                WHERE ( id = id1) ; 

                if hrmid1 <> oldhrmid1 then  
                        currenthrmid1 := concat(concat(concat('|' , to_char( id1)) , ',') ,  concat(to_char( hrmid1) , '|'));
                        currentoldhrmid1 :=  concat(concat(concat('|' , to_char( id1)) , ',') , concat(to_char( oldhrmid1) , '|')); 
                        
                        UPDATE Prj_TaskProcess
                        set parenthrmids =replace(parenthrmids,currentoldhrmid1,currenthrmid1) where (parenthrmids like concat(concat('%',currentoldhrmid1),'%')); 
                end if;
 end;
/

/* td:801 客户管理模块不能删除产品*/
 CREATE OR REPLACE PROCEDURE LgcAsset_Delete 
 (id_1 	integer, 
 assetcountryid_2 integer,
 flag out integer ,
 msg out varchar2, thecursor IN OUT cursor_define.weavercursor)  
 AS isdefault_1 char; assortmentid_1 integer;
 begin
        select assortmentid INTO assortmentid_1  from LgcAsset where id=id_1;
        DELETE LgcAsset  WHERE id=id_1;
        DELETE LgcAssetCountry  WHERE assetid=id_1 ; 
        update LgcAssetAssortment set assetcount = assetcount-1 where id= assortmentid_1; 
end;
/
/* td:848 具有客户卡片编辑权限的用户，点击编辑菜单返回无权限的页面*/
CREATE or REPLACE PROCEDURE CRM_ShareEditToManager(
crmId_1 integer, managerId_1 integer, 
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS
count_1 integer;
begin
SELECT count(id) into count_1 FROM CRM_ShareInfo WHERE relateditemid = crmId_1
AND sharetype = 1 AND userid = managerId_1;
if count_1 <> 0 then
    UPDATE CRM_ShareInfo SET sharelevel = 2 WHERE relateditemid =crmId_1
    AND sharetype = 1 AND userid = managerId_1;
ELSE 
    INSERT INTO CRM_ShareInfo(relateditemid, sharetype, sharelevel, userid) 
    VALUES(crmId_1, 1, 2, managerId_1);
end if;
end;
/
/*td:949 借款申请流程没有纳入财务销帐中 */
update workflow_bill set operationpage = 'BillLoanOperation.jsp' where id = 13
/
