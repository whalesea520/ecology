ALTER TABLE FnaYearsPeriods ADD status integer NULL
/

alter table FnaBudgetfeeType add feelevel integer
/

alter table FnaBudgetfeeType add supsubject integer
/

alter table FnaBudgetfeeType add alertvalue integer
/

declare 
	os11id integer;	os12id integer;	os13id integer;	os14id integer;
	os21id integer;	os22id integer;	os23id integer;	os24id integer;
begin
	insert into FnaBudgetfeeType (name,description,feeperiod,feelevel,supsubject)
	values('其他月度科目','每月结算其他一级科目',1,1,0);
	
	select max(id) into os11id from FnaBudgetfeeType;
	
	insert into FnaBudgetfeeType (name,description,feeperiod,feelevel,supsubject)
	values('其他季度科目','每季度结算其他一级科目',2,1,0);
	
	select max(id) into os12id from FnaBudgetfeeType;

	insert into FnaBudgetfeeType (name,description,feeperiod,feelevel,supsubject)
	values('其他半年科目','每半年结算其他一级科目',3,1,0);
	
	select max(id) into os13id from FnaBudgetfeeType;


	insert into FnaBudgetfeeType (name,description,feeperiod,feelevel,supsubject)
	values('其他年度科目','每年结算其他一级科目',4,1,0);
	
	select max(id) into os14id from FnaBudgetfeeType;


	insert into FnaBudgetfeeType (name,description,feelevel,supsubject)
	values('其他月度科目','每月结算其他二级科目',2,os11id);
	
	select max(id) into os21id from FnaBudgetfeeType;


	insert into FnaBudgetfeeType (name,description,feelevel,supsubject)
	values('其他季度科目','每季度结算其他二级科目',2,os12id);
	
	select max(id) into os22id from FnaBudgetfeeType;

	insert into FnaBudgetfeeType (name,description,feelevel,supsubject)
	values('其他半年科目','每半年结算其他二级科目',2,os13id);
	
	select  max(id) into os23id from FnaBudgetfeeType;


	insert into FnaBudgetfeeType (name,description,feelevel,supsubject)
	values('其他年度科目','每年结算其他二级科目',2,os14id);
	
	select  max(id) into os24id from FnaBudgetfeeType;

	update FnaBudgetfeeType set feelevel = 3,supsubject = os21id,alertvalue = 100
	where supsubject is null and feeperiod = 1;
	
	update FnaBudgetfeeType set feelevel = 3,supsubject = os22id,alertvalue = 100
	where supsubject is null and feeperiod = 2;
	
	update FnaBudgetfeeType set feelevel = 3,supsubject = os23id,alertvalue = 100
	where supsubject is null and feeperiod = 3;
	
	update FnaBudgetfeeType set feelevel = 3,supsubject = os24id,alertvalue = 100
	where supsubject is null and feeperiod = 4;
end;
/

ALTER TABLE FnaBudgetInfo ADD budgetorganizationid integer NULL
/

ALTER TABLE FnaBudgetInfo ADD organizationtype integer NULL
/

ALTER TABLE FnaBudgetInfo ADD budgetperiods integer NULL
/

ALTER TABLE FnaBudgetInfo ADD revision integer NULL
/

ALTER TABLE FnaBudgetInfo ADD status integer NULL
/

ALTER TABLE FnaBudgetInfo ADD remark varchar2(250) NULL
/

ALTER TABLE FnaBudgetInfo DROP COLUMN budgetyears
/

UPDATE FnaBudgetInfo SET budgetorganizationid = budgetdepartmentid,organizationtype = 2
/

UPDATE FnaBudgetInfo SET status = 0
/

ALTER TABLE FnaBudgetInfo DROP COLUMN budgetdepartmentid
/


ALTER TABLE FnaBudgetInfoDetail ADD budgetperiodslist integer NULL
/

ALTER TABLE FnaBudgetInfoDetail DROP COLUMN budgetstartdate
/

ALTER TABLE FnaBudgetInfoDetail DROP COLUMN budgetenddate
/

INSERT INTO HtmlLabelIndex values(18430,'未生效') 
/
INSERT INTO HtmlLabelInfo VALUES(18430,'未生效',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18430,'unefficient',8) 
/


delete from  HtmlLabelIndex where id=18431
/
delete from  HtmlLabelInfo where indexId=18431
/

INSERT INTO HtmlLabelIndex values(18431,'生效') 
/
INSERT INTO HtmlLabelInfo VALUES(18431,'生效',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18431,'efficient',8) 
/


INSERT INTO ErrorMsgIndex values(53,'请先关闭当前预算期间')
/
INSERT INTO ErrorMsgInfo VALUES(53,'请先关闭当前预算期间!',7)
/
INSERT INTO ErrorMsgInfo VALUES(53,'pls close current budget period before this operation!',8)
/


INSERT INTO HtmlNoteIndex values(75,'关闭后将不能再使用当前期间的预算')
/
INSERT INTO HtmlNoteInfo VALUES(75,'关闭后将不能再使用当前期间的预算,确定关闭吗?',7)
/
INSERT INTO HtmlNoteInfo VALUES(75,'Are you sure to close current budget period',8)
/


UPDATE HtmlLabelIndex SET indexdesc = '预算科目' WHERE id = 1462
/
UPDATE HtmlLabelInfo SET labelname = '预算科目' WHERE indexid = 1462 AND languageid = 7
/
UPDATE HtmlLabelInfo SET labelname = 'Budget Classification' WHERE indexid = 1462 AND languageid = 8
/


UPDATE HtmlLabelIndex SET indexdesc = '预算科目维护' WHERE id = 1011
/
UPDATE HtmlLabelInfo SET labelname = '预算科目维护' WHERE indexid = 1011 AND languageid = 7
/
UPDATE HtmlLabelInfo SET labelname = 'Budget Classification Maintenance' WHERE indexid = 1011 AND languageid = 8
/


INSERT INTO HtmlLabelIndex values(18424,'一级科目')
/
INSERT INTO HtmlLabelInfo VALUES(18424,'一级科目',7)
/
INSERT INTO HtmlLabelInfo VALUES(18424,'1st subject',8)
/


INSERT INTO HtmlLabelIndex values(18425,'二级科目')
/
INSERT INTO HtmlLabelInfo VALUES(18425,'二级科目',7)
/
INSERT INTO HtmlLabelInfo VALUES(18425,'2nd subject',8)
/


INSERT INTO HtmlLabelIndex values(18426,'三级科目')
/
INSERT INTO HtmlLabelInfo VALUES(18426,'三级科目',7)
/
INSERT INTO HtmlLabelInfo VALUES(18426,'3rd subject',8)
/


INSERT INTO HtmlLabelIndex values(18427,'科目级别')
/
INSERT INTO HtmlLabelInfo VALUES(18427,'科目级别',7)
/
INSERT INTO HtmlLabelInfo VALUES(18427,'subject level',8)
/


INSERT INTO HtmlLabelIndex values(18428,'上级科目')
/
INSERT INTO HtmlLabelInfo VALUES(18428,'上级科目',7)
/
INSERT INTO HtmlLabelInfo VALUES(18428,'sup subject',8)
/


INSERT INTO HtmlLabelIndex values(18429,'科目预警值')
/
INSERT INTO HtmlLabelInfo VALUES(18429,'科目预警值',7)
/
INSERT INTO HtmlLabelInfo VALUES(18429,'alert value',8)
/


insert into SystemRights (id,rightdesc,righttype,detachable) values (639,'总部预算维护','2',0)
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (639,7,'总部预算维护','总部预算维护')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (639,8,'headquarter budget maintain','headquarter budget maintain')
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4139,'总部预算维护','HeadBudget:Maint',639)
/


insert into SystemRights (id,rightdesc,righttype,detachable) values (640,'分部预算维护','2',1)
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (640,8,'subcompany budget maintain','subcompany budget maintain')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (640,7,'分部预算维护','分部预算维护')
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4140,'分部预算维护','SubBudget:Maint',640)
/


insert into SystemRightToGroup (groupid,rightid) values (4,639)
/
insert into SystemRightToGroup (groupid,rightid) values (4,640)
/


INSERT INTO HtmlLabelIndex values(18496,'生效版本') 
/
INSERT INTO HtmlLabelInfo VALUES(18496,'生效版本',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18496,'Efficient version',8) 
/


INSERT INTO HtmlLabelIndex values(18500,'历史版本') 
/
INSERT INTO HtmlLabelInfo VALUES(18500,'历史版本',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18500,'History version',8) 
/


INSERT INTO HtmlLabelIndex values(18501,'预算总额') 
/
INSERT INTO HtmlLabelInfo VALUES(18501,'预算总额',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18501,'budget amount',8) 
/
 

INSERT INTO HtmlLabelIndex values(18502,'已分配预算') 
/
INSERT INTO HtmlLabelInfo VALUES(18502,'已分配预算',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18502,'allotted budget',8) 
/


INSERT INTO HtmlLabelIndex values(18503,'已发生费用') 
/
INSERT INTO HtmlLabelInfo VALUES(18503,'已发生费用',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18503,'used fee',8) 
/


INSERT INTO HtmlLabelIndex values(18552,'版本历史') 
/
INSERT INTO HtmlLabelInfo VALUES(18552,'版本历史',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18552,'versions history',8) 
/


INSERT INTO HtmlLabelIndex values(18553,'版本对比') 
/
INSERT INTO HtmlLabelInfo VALUES(18553,'版本对比',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18553,'version contrast',8) 
/


INSERT INTO HtmlLabelIndex values(18554,'人员预算') 
/
INSERT INTO HtmlLabelInfo VALUES(18554,'人员预算',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18554,'person budget',8) 
/


INSERT INTO HtmlLabelIndex values(18568,'已分配下级预算') 
/
INSERT INTO HtmlLabelInfo VALUES(18568,'已分配下级预算',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18568,'under allotted budget',8) 
/
 

INSERT INTO HtmlLabelIndex values(18569,'原预算额') 
/
INSERT INTO HtmlLabelInfo VALUES(18569,'原预算额',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18569,'original budget',8) 
/
 

INSERT INTO HtmlLabelIndex values(18570,'新预算额') 
/
INSERT INTO HtmlLabelInfo VALUES(18570,'新预算额',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18570,'new budget',8) 
/
 

INSERT INTO HtmlLabelIndex values(18571,'预算增额') 
/
INSERT INTO HtmlLabelInfo VALUES(18571,'预算增额',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18571,'added budget',8) 
/


INSERT INTO HtmlLabelIndex values(18577,'Excel文件导入') 
/
INSERT INTO HtmlLabelInfo VALUES(18577,'Excel文件导入',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18577,'import Excel file',8) 
/
 


INSERT INTO HtmlLabelIndex values(18579,'按预算期均分') 
/
INSERT INTO HtmlLabelInfo VALUES(18579,'按预算期均分',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18579,'average by period',8) 
/
 

INSERT INTO HtmlLabelIndex values(18604,'上级可用预算') 
/
INSERT INTO HtmlLabelInfo VALUES(18604,'上级可用预算',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18604,'upper useable budget',8) 
/
 

INSERT INTO HtmlLabelIndex values(18687,'请选择2个要对比版本！') 
/
INSERT INTO HtmlLabelInfo VALUES(18687,'请选择2个要对比版本！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18687,'pls select 2 versions to compare',8) 
/


INSERT INTO HtmlLabelIndex values(18752,'当前部门为生效状态，该操作会将所有分配对象的生效版本另存为草稿，已存在的草稿将会被替换，您确定吗?') 
/
INSERT INTO HtmlLabelInfo VALUES(18752,'当前部门为生效状态，该操作会将所有分配对象的生效版本另存为草稿，已存在的草稿将会被替换，您确定吗?',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18752,'are you sure ?',8) 
/



INSERT INTO HtmlLabelIndex values(18755,'全年预算额与各期预算额之和不相等!') 
/
INSERT INTO HtmlLabelInfo VALUES(18755,'全年预算额与各期预算额之和不相等!',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18755,'calculation is error',8) 
/
 
 

INSERT INTO HtmlLabelIndex values(18756,'新预算额必须大于已分配预算!') 
/
INSERT INTO HtmlLabelInfo VALUES(18756,'新预算额必须大于已分配预算!',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18756,'calculation is error',8) 
/
 

INSERT INTO HtmlLabelIndex values(18757,'预算增额必须小于上级可用预算!') 
/
INSERT INTO HtmlLabelInfo VALUES(18757,'预算增额必须小于上级可用预算!',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18757,'calculation is error',8) 
/
 
INSERT INTO HtmlLabelIndex values(18764,'下级部门预算之和不能大于预算总额!')
/
INSERT INTO HtmlLabelInfo VALUES(18764,'下级部门预算之和不能大于预算总额!',7)
/
INSERT INTO HtmlLabelInfo VALUES(18764,'calculation is error',8)
/

CREATE or REPLACE PROCEDURE FnaBudgetfeeType_Delete
(id_1 integer,
flag out integer,
msg  out  varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
typeId integer;
count_1 integer;
count_2 integer;
count_3 integer;
begin
SELECT count(feetypeid) into count_1 FROM bill_expensedetail WHERE feetypeid = id_1;
SELECT count(id) into count_2 FROM FnaBudgetInfoDetail WHERE budgettypeid = id_1;
SELECT count(id) into count_3 FROM FnaBudgetCheckDetail WHERE budgettypeid = id_1;
if count_1>0 or count_2>0 or count_3>0 then
open thecursor for
select -1 from dual;
return;
end if;
delete from fnaBudgetfeetype where id= id_1;
end;
/

create or replace PROCEDURE FnaBudgetfeeType_Insert
(   name_1	varchar2,
    feeperiod_1	integer,
    feetype_1	integer,
    agreegap_1	integer,
	description_1	varchar2,
	feelevel_1	integer,
	alertvalue_1 integer,
	supsubject_1 integer,
	flag out integer,
	msg  out  varchar2,
	thecursor IN OUT cursor_define.weavercursor )
as
begin
	insert into fnaBudgetfeetype (name,feeperiod,feetype,agreegap,description,feelevel,alertvalue,supsubject)
    values (name_1,feeperiod_1,feetype_1,agreegap_1,description_1,feelevel_1,alertvalue_1,supsubject_1);
end;
/

create or replace PROCEDURE FnaBudgetfeeType_Update
(   id_1		integer,
	name_1	varchar2,
    feeperiod_1	integer,
    feetype_1	integer,
    agreegap_1	integer,
	description_1	varchar2,
	feelevel_1	integer,
	alertvalue_1 integer,
	supsubject_1 integer,
	flag out integer,
	msg  out  varchar2,
	thecursor IN OUT cursor_define.weavercursor )
as
begin
	update fnaBudgetfeetype set name=name_1,feeperiod=feeperiod_1,feetype=feetype_1
    ,agreegap=agreegap_1,description=description_1,feelevel=feelevel_1,alertvalue=alertvalue_1,supsubject=supsubject_1 where id=id_1;
end;
/

create or replace PROCEDURE FnaBudgetInfo_Insert
(budgetperiods_1 integer,
	budgetorganizationid_2 integer,
	organizationtype_3 integer,
	budgetstatus_4 integer,
	createrid_5 integer,
	createdate_6 char,
	revision_7 integer,
	status_8 integer,
	flag out integer,
	msg  out  varchar2,
	thecursor IN OUT cursor_define.weavercursor )
AS
count_1 integer;
begin
		SELECT count(id) into count_1 FROM FnaBudgetInfo WHERE budgetorganizationid = budgetorganizationid_2
		AND organizationtype = organizationtype_3
		AND budgetperiods = budgetperiods_1
		AND status = status_8
		AND revision = revision_7
		;
		if count_1 >0 then
			open thecursor for
			select -1 from dual;
			return;
	
	ELSE
		INSERT INTO FnaBudgetInfo
			(budgetperiods,
			 budgetorganizationid,
			 organizationtype,
			 budgetstatus,
			 createrid,
			 createdate,
			 revision,
			 status) 
		VALUES 
			(budgetperiods_1,
			 budgetorganizationid_2,
			 organizationtype_3,
			 budgetstatus_4,
			 createrid_5,
			 createdate_6,
			 revision_7,
			 status_8);
			open thecursor for
			select max(id) from FnaBudgetInfo;
		end if;
end;
/

CREATE or replace  PROCEDURE FnaBudgetInfo_UpdateStatus
   (id_1 	integer,
	status_2 	integer,
	revision_3 	integer,
	budgetstatus_4		integer,
	flag out integer,
	msg  out  varchar2,
	thecursor IN OUT cursor_define.weavercursor )

AS
begin
	UPDATE FnaBudgetInfo
	SET budgetstatus = budgetstatus_4,
		status = status_2,
		revision = revision_3	WHERE (id = id_1);
end;
/

CREATE or replace  PROCEDURE FnaBudgetInfoDetail_Insert
	(budgetinfoid_1 	integer,
	 budgetperiods_2 	integer,
	 budgetperiodslist_3 	integer,
	 budgettypeid_4 	integer,
	 budgetresourceid_5 	integer,
	 budgetcrmid_6 	integer,
	 budgetprojectid_7 	integer,
	 budgetaccount_8 	number,
	 budgetremark_9 	varchar2,
	flag out integer,
	msg  out  varchar2,
	thecursor IN OUT cursor_define.weavercursor )

AS
count_1 integer;
begin
	select count(id) into count_1 from FnaBudgetInfoDetail where budgetinfoid = budgetinfoid_1
	and budgetperiods = budgetperiods_2
	and budgetperiodslist = budgetperiodslist_3
	and budgettypeid = budgettypeid_4;
	if count_1 >0 
	then
		UPDATE FnaBudgetInfoDetail SET budgetaccount = budgetaccount_8
		 WHERE budgetinfoid = budgetinfoid_1
		   AND budgetperiods = budgetperiods_2
		   AND budgetperiodslist = budgetperiodslist_3
		   AND budgettypeid = budgettypeid_4;
	ELSE
	INSERT INTO FnaBudgetInfoDetail 
			(budgetinfoid,
			 budgetperiods,
			 budgetperiodslist,
			 budgettypeid,
			 budgetresourceid,
			 budgetcrmid,
			 budgetprojectid,
			 budgetaccount,
			 budgetremark) 
		VALUES 
			(budgetinfoid_1,
			 budgetperiods_2,
			 budgetperiodslist_3,
			 budgettypeid_4,
			 budgetresourceid_5,
			 budgetcrmid_6,
			 budgetprojectid_7,
			 budgetaccount_8,
			 budgetremark_9);
	END if;
end;
/

CREATE or replace PROCEDURE FnaYearsPeriods_Close
(	id_1 integer,
	flag out integer,
	msg  out  varchar2,
	thecursor IN OUT cursor_define.weavercursor )
AS
begin
	UPDATE FnaYearsPeriods SET status = -1 WHERE  id = id_1;
end;
/

CREATE or replace PROCEDURE FnaYearsPeriods_Delete
(id_1 integer,
	flag out integer,
	msg  out  varchar2,
	thecursor IN OUT cursor_define.weavercursor)
AS
count_1 integer;
count_2 integer;
count_3 integer;
begin
	SELECT  count(id)  into count_1 FROM FnaYearsPeriodsList WHERE fnayearid = id_1 AND isclose ='1';
    SELECT  count(id)  into count_2 from FnaBudgetInfo WHERE budgetperiods = id_1;
    SELECT count(id)  into count_3 from FnaBudgetInfoDetail WHERE budgetperiods = id_1;
	IF count_1 >0 OR count_2 > 0 OR count_3 > 0	then
	open thecursor for
	SELECT '20' from  dual;
	RETURN;
	END if;
	DELETE from  FnaYearsPeriods WHERE id = id_1;
	DELETE from FnaYearsPeriodsList WHERE fnayearid = id_1;
end;
/

CREATE or replace PROCEDURE FnaYearsPeriods_Insert
(fnayear_1 char,
	startdate_2 char,
	enddate_3 char,
	status integer,
	flag out integer,
	msg  out  varchar2,
	thecursor IN OUT cursor_define.weavercursor)
AS
	count_1 integer;
	begin
	select count(id) into count_1 from FnaYearsPeriods where fnayear = fnayear_1;
	if count_1 > 0
	then
	open thecursor for
	SELECT -1 from  dual;
	return;
	end if;
	INSERT INTO FnaYearsPeriods (fnayear,startdate,enddate,status)
	VALUES (fnayear_1,startdate_2,enddate_3,status);
	open thecursor for
	select max(id) from FnaYearsPeriods;
	end;
/

CREATE or replace PROCEDURE FnaYearsPeriods_SelectMaxYear
(flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS
fnayear_1 char(4);
fnayear_count integer;
begin
select count(fnayear) into fnayear_count from FnaYearsPeriods where status > -1 ;
if fnayear_count>0 then
select max(fnayear) into fnayear_1 from FnaYearsPeriods ;
end if;

open thecursor for
select * from FnaYearsPeriods where fnayear = fnayear_1;
end;
/

CREATE or replace PROCEDURE FnaYearsPeriods_TakeEffect
(id_1 integer,
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS 
	 count_1 integer;
begin
	SELECT   count(id) into  count_1 FROM FnaYearsPeriods WHERE status = 1;
	IF (count_1 >0) then
	open thecursor for
	SELECT '-1' from dual;
	RETURN;
	END if;
	UPDATE FnaYearsPeriods SET status = 1 WHERE  id = id_1;
end;
/
update FnaYearsPeriods set status = 0 where status is null
/