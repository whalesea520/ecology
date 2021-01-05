/* FOR BUG 78 "职务类别维护"权限在权限设置中显示的是"工作类型维护"*/
delete from SystemRights where id=28
/
delete from SystemRightsLanguage where id=28
/
delete from SystemRightDetail where rightid=28
/
insert into SystemRights (id,rightdesc,righttype) values (28,'职务类别维护','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (28,7,'职务类别维护','职务类别的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (28,8,'HrmJobGroups','Add,delete,update and log HrmJobGroups') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (96,'职务类别添加','HrmJobGroupsAdd:Add',28) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (97,'职务类别编辑','HrmJobGroupsEdit:Edit',28) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (98,'职务类别删除','HrmJobGroupsEdit:Delete',28) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (99,'职务类别日志查看','HrmJobGroups:Log',28) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (198,'职务类别添加','AddWorkType:Add',28) 
/

/* FOR BUG 84 职称的日志页面仍然没有日志信息*/
insert into SystemLogItem(itemid,lableid,itemdesc) values(65,16462,'职称设置')
/

/*FOR BUG 197 修改月工作总结默认不正确的出口*/
update WORKFLOW_NODELINK set isreject='1' where id=14
/
update WORKFLOW_NODELINK set isreject=' ' where id=15
/

/*
 * Script Created ON : May 20,2004
 * Author : Charoes Huang Yu
*/
/*FOR BUG 310 修改HrmAwardInfo表的resourseid字段的类型为varchar(4000)*/
ALTER TABLE HrmAwardInfo add resourseid_t varchar2(4000)
/
update HrmAwardInfo set resourseid_t=resourseid
/
ALTER TABLE HrmAwardInfo drop column resourseid
/
ALTER TABLE HrmAwardInfo add resourseid varchar2(4000)
/
update HrmAwardInfo set resourseid=resourseid_t
/
ALTER TABLE HrmAwardInfo drop column resourseid_t
/
/*修改奖惩 考核 resourseid_3 int字段类型为varchar(4000)*/
/*插入*/
CREATE or replace  PROCEDURE HrmAwardInfo_Insert
(rptitle_2 varchar2,
 resourseid_3 varchar2,
 rptypeid_4 integer,
 rpdate_5 char,
 rpexplain_6 varchar2,
 rptransact_7 varchar2,
 flag out integer,
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor)
 AS
 begin
    insert into HrmAwardInfo (rptitle,resourseid,rptypeid,rpdate,rpexplain,rptransact) values 
    (rptitle_2,resourseid_3,rptypeid_4,rpdate_5,rpexplain_6,rptransact_7);
end;
/
/*更新*/
CREATE or replace  PROCEDURE HrmAwardInfo_Update
(id_1 integer,
 rptitle_2 varchar2,
 resourseid_3 varchar2,
 rptypeid_4 integer,
 rpdate_5 char,
 rpexplain_6 varchar2,
 rptransact_7 varchar2,
  flag out integer,
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
UPDATE HrmAwardInfo set
rptitle = rptitle_2,
resourseid = resourseid_3,
rptypeid = rptypeid_4,
rpdate = rpdate_5,
rpexplain = rpexplain_6,
rptransact = rptransact_7
WHERE
 id = id_1;
end;
/

/*td:394 报表中心的【最多文档著者】报表的正常文档和回复文档的统计数目不正确  */
CREATE or REPLACE PROCEDURE DocRpSum 
 (optional_1	varchar2,
 userid_1 integer,
 flag	out integer,
 msg   out  varchar2,
thecursor IN OUT cursor_define.weavercursor
 ) 
 AS 
 resultid_1  integer;
 count_1  integer;
 replycount_1  integer ;
 begin
     if   optional_1='doccreater' then
	for resultid_cursor in(
	select * from (select count(id) resultcount,ownerid resultid from docdetail  t1,DocShareDetail  t2 where t1.id=t2.docid and t1.docstatus in (1,2,5) and t2.usertype=1 and  t2.userid=userid_1 group by ownerid order by resultcount desc) where rownum<21)
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
		select count(id) into replycount_1 from docdetail t1,DocShareDetail t2 where t1.id=t2.docid and t1.docstatus in (1,2,5) and t2.usertype=1 and t2.userid=userid_1  and doccreaterid=resultid_1 and isreply='1' ;
		insert into TM_DocRpSum values(resultid_1,count_1,replycount_1);
        end loop; 
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;

     if   optional_1='crm'  then
	for resultid_cursor in(
	select * from (select count(id) resultcount,t1.crmid resultid from docdetail t1,DocShareDetail t2 where t1.id=t2.docid and t1.docstatus in (1,2,5) and t2.usertype=1 and t2.userid=userid_1 group by t1.crmid order by resultcount desc) where rownum<21) 
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
		select count(id) into replycount_1 from docdetail  t1,DocShareDetail  t2 where t1.id=t2.docid and t1.docstatus in (1,2,5) and t2.usertype=1 and t2.userid=userid_1 and t1.crmid=resultid_1 and isreply='1' ; 
		insert into TM_DocRpSum values(resultid_1,count_1,replycount_1) ;
	end loop;
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;

     if   optional_1='resource'  then
	for resultid_cursor in(
	select * from (select count(id) resultcount,hrmresid resultid from docdetail t1,DocShareDetail t2 where t1.id=t2.docid and t1.docstatus in (1,2,5) and t2.usertype=1 and t2.userid=userid_1 group by hrmresid order by resultcount desc) where rownum<21)
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
		select count(id) into replycount_1 from docdetail  t1,DocShareDetail  t2 where t1.id=t2.docid and t1.docstatus in (1,2,5) and t2.usertype=1 and t2.userid=userid_1 and hrmresid=resultid_1 and isreply='1';
		insert into TM_DocRpSum values(resultid_1,count_1,replycount_1);
	end loop;
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;

    if   optional_1='project' then
	for resultid_cursor in(
	select * from (select count(id) resultcount,projectid resultid from docdetail t1,DocShareDetail t2 where t1.id=t2.docid and t1.docstatus in (1,2,5) and t2.usertype=1 and t2.userid=userid_1 group by projectid order by resultcount desc) where rownum<21)
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
		select count(id) into replycount_1 from docdetail  t1,DocShareDetail  t2 where t1.id=t2.docid and t1.docstatus in (1,2,5) and t2.usertype=1 and t2.userid=userid_1 and projectid=resultid_1 and isreply='1' ;
		insert into TM_DocRpSum values(resultid_1,count_1,replycount_1) ; 
	end loop;
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;

    if   optional_1='department'  then 
	for resultid_cursor in(
	select * from (select count(id) resultcount,docdepartmentid resultid from docdetail t1,DocShareDetail t2 where t1.id=t2.docid and t1.docstatus in (1,2,5) and t2.usertype=1 and t2.userid=userid_1  group by docdepartmentid order by resultcount desc) where rownum<21 )
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
		select count(id) into replycount_1 from docdetail t1,DocShareDetail t2 where t1.id=t2.docid and t1.docstatus in (1,2,5) and t2.usertype=1 and t2.userid=userid_1 and docdepartmentid=resultid_1 and isreply='1' ;
		insert into TM_DocRpSum values(resultid_1,count_1,replycount_1) ; 
	end loop;
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;

   if   optional_1='language'  then 
	for resultid_cursor in(
	select * from (select count(id) resultcount,doclangurage resultid from docdetail t1,DocShareDetail t2 where t1.id=t2.docid and t1.docstatus in (1,2,5) and t2.usertype=1 and t2.userid=userid_1 group by doclangurage order by resultcount desc 
	) where rownum<21 )
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
		select count(id) into replycount_1 from docdetail t1,DocShareDetail t2 where t1.id=t2.docid and t1.docstatus in (1,2,5) and t2.usertype=1 and t2.userid=userid_1 and doclangurage=resultid_1 and isreply='1' ;
		insert into TM_DocRpSum values(resultid_1,count_1,replycount_1) ;
        end loop;
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;

   if   optional_1='item'  then
	for resultid_cursor in(
	select * from (select count(id) resultcount,itemid resultid from docdetail t1,DocShareDetail t2 where t1.id=t2.docid and t1.docstatus in (1,2,5) and t2.usertype=1 and t2.userid=userid_1 group by itemid order by resultcount desc) where rownum<21 )
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
	select count(id) into replycount_1 from docdetail t1,DocShareDetail t2 where t1.id=t2.docid and t1.docstatus in (1,2,5) and t2.usertype=1 and t2.userid=userid_1 and itemid=resultid_1 and isreply='1';
	insert into TM_DocRpSum values(resultid_1,count_1,replycount_1);
	end loop;
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;
end;
/

/*
 * Script Created ON : May 20,2004
 * Author : Charoes lu peng
*/
/*FOR BUG 430 修改了存储过程FnaYearsPeriods_Select，增加了对期间年倒序排列功能*/
CREATE or replace PROCEDURE FnaYearsPeriods_Select (
 flag out integer,
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
open thecursor for
SELECT * FROM FnaYearsPeriods ORDER BY fnayear DESC;
end;
/


/* FOR BUG 432 财务期间可以被任意删除*/
CREATE OR REPLACE PROCEDURE FnaYearsPeriods_Delete
(id_1     integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
count_1 integer;
fnayear_1 char(4);
count_2 integer;
begin
SELECT fnayear into fnayear_1 FROM FnaYearsPeriods WHERE id = id_1;
select count(id) into count_1 from FnaYearsPeriodsList where fnayearid = id_1
and isclose ='1';
SELECT count(id) into count_2 from FnaBudgetInfo WHERE budgetyears = fnayear_1;
if count_1 <> 0 or count_2>0 then
open thecursor for
select '20' from dual;
return ;
end if;
DELETE FnaYearsPeriods  WHERE ( id=id_1);
DELETE FnaYearsPeriodsList where  fnayearid = id_1;
end;
/

/*FOR BUG 440 费用类型被报销流程或者预算设置引用，则不能被删除。*/
CREATE or REPLACE PROCEDURE FnaBudgetfeeType_Delete
(id_1 integer,
flag out integer,
msg  out  varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
typeId integer;
count_1 integer;
count_2 integer;
begin
SELECT count(feetypeid) into count_1 FROM bill_expensedetail WHERE feetypeid = id_1;
SELECT count(id) into count_2 FROM FnaBudgetCheckDetail WHERE budgettypeid = id_1;
if count_1>0 or count_2>0 then
open thecursor for
select -1 from dual;
return;
end if;
delete from fnaBudgetfeetype where id= id_1;
end;
/

/*FOR BUG 443 增加了财务销帐维护权限，并用该权限来检查财务销帐维护。*/
insert into SystemRights (id,rightdesc,righttype) values (437,'财务销帐维护','2') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (437,7,'财务销帐维护','财务销帐维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (437,8,'Write-Off','Write-Off') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3127,'财务销帐维护','FinanceWriteOff:Maintenance',437) 
/
insert into SystemRightToGroup (groupid, rightid) values (4, 437)
/
insert into SystemRightRoles (rightid, roleid, rolelevel) values (437, 5, '2')
/

/*FOR BUG 445 修改‘详细'为'财务销帐处理'*/
INSERT INTO HtmlLabelIndex values(17390,'财务销帐处理') 
/
INSERT INTO HtmlLabelInfo VALUES(17390,'财务销帐处理',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17390,'Write-Off',8) 
/

/*FOR BUG 447 修改在“个人财务销帐”页面，增加了对“凭证号”字段的链接。*/
CREATE or REPLACE PROCEDURE FnaLoanLog_Update (
id_0 integer, loantypeid_1 integer, resourceid_2 integer, departmentid_3 integer, crmid_4 integer, projectid_5 integer, amount_6 decimal, 
description_7 varchar2, credenceno_8 varchar2, occurdate_9 char, releatedid_10 integer, releatedname_11 varchar2,
returndate_12 char, dealuser_13 integer, 
flag out integer,
msg  out  varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS
begin
UPDATE FnaLoanLog SET loantypeid = loantypeid_1, resourceid = resourceid_2, departmentid = departmentid_3,
crmid = crmid_4, projectid = projectid_5, amount = amount_6, description = description_7, credenceno = credenceno_8,
occurdate = occurdate_9, releatedid = releatedid_10, releatedname = releatedname_11, returndate = returndate_12,
dealuser = dealuser_13 WHERE id = id_0;
end;
/

CREATE or REPLACE PROCEDURE FnaLoanLog_Delete (
id_0 integer, 
flag out integer,
msg  out  varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS
begin
DELETE FnaLoanLog WHERE id = id_0;
end;
/

/*FOR BUG 646  财务销帐输入的负数不能正确显示*/
CREATE or REPLACE PROCEDURE bill_HrmFinance_SelectLoan 
(
	resourceid_1	integer, 
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
AS 
    tmpamount1   number(10,3);
    tmpamount2   number(10,3);
begin
  select sum(amount) INTO tmpamount1 from FnaLoanLog 
  where resourceid= resourceid_1 and loantypeid = 1;
  
  select sum(amount) INTO tmpamount2 from FnaLoanLog
  where resourceid= resourceid_1 and loantypeid != 1;
  
  if    tmpamount1 is null then
         tmpamount1 :=0;
  end if;
  
  if    tmpamount2 is null then
         tmpamount2 := 0;
  end if;
  
  tmpamount1 := tmpamount1-tmpamount2 ;
  
  open thecursor for
	select tmpamount1 from dual; 
end;
/

