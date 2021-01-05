update workflow_bill set detailtablename = 'Bill_ExpenseDetail' where id = 7
/
update HtmlLabelInfo set labelname = '帮助文档' where indexid = 15593 and  languageid = 7
/

update HtmlLabelIndex set indexdesc = '帮助文档' where id = 15593 
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


INSERT INTO HtmlLabelIndex values(16756,'每行数据必须全部填写，否则将不被保存！') 
/
INSERT INTO HtmlLabelInfo VALUES(16756,'每行数据必须全部填写，否则将不被保存！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16756,'',8) 
/


delete workflow_bill where id = 50
/

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, operationpage, detailtablename, detailkeyfield) VALUES(50,16676,'Bill_HrmScheduleMain','AddBillHrmScheduleMain.jsp','ManageBillHrmScheduleMain.jsp','ViewBillHrmScheduleMain.jsp','BillHrmScheduleMainOperation.jsp','Bill_HrmScheduleDetail','scheduleid') 
/

delete workflow_billfield where billid = 50
/


INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'departmentid',124,'integer',3,4,1,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'resource_n',368,'integer',3,1,2,0)
/ 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'sumday',852,'integer',1,2,3,0)
/ 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'reason',791,'varchar(255)',2,0,4,0)
/ 

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'diffid',1881,'integer',3,34,6,1)
/ 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'startdate',740,'char(10)',3,2,7,1)
/ 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'starttime',742,'char(8)',3,19,8,1)
/ 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'enddate',741,'char(10)',3,2,9,1)
/ 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'endtime',743,'char(8)',3,19,10,1)
/ 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'sumday',852,'integer',1,2,11,1)
/ 


CREATE TABLE Bill_HrmScheduleMain (
	id integer NOT NULL  ,
	resource_n integer   NULL ,
	reason varchar (255) NULL,
    sumday integer ,
	requestid  integer
) 
/
create sequence Bill_HrmScheduleMain_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Bill_HrmScheduleMain_Trigger
before insert on Bill_HrmScheduleMain
for each row
begin
select Bill_HrmScheduleMain_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Bill_HrmScheduleDetail (
	id integer NOT NULL  ,
	scheduleid  integer   NULL ,
    diffid integer ,
	startdate  char(10) NULL,
	starttime  char(8) NULL,
	enddate  char(10) NULL,
	endtime  char(8) NULL,
    sumday integer 
) 
/
create sequence Bill_HrmScheduleDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Bill_HrmScheduleDetail_Trigger
before insert on Bill_HrmScheduleDetail
for each row
begin
select Bill_HrmScheduleDetail_id.nextval into :new.id from dual;
end;
/

alter table Bill_HrmScheduleMain add departmentid integer 
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
    select count(distinct t1.requestid) typecount,t3.workflowtype from workflow_currentoperator t1,workflow_requestbase t2 , workflow_base t3 
    where t1.userid= userid_1  and t1.usertype= usertype_1 and t1.isremark in( '0','1') and
    t1.requestid=t2.requestid and t2.workflowid = t3.id and ( t2.deleted=0 or t2.deleted is null ) and t2.currentnodetype<>'3' 
    group by t3.workflowtype ;
    end if;
    if complete_1 =1 then
    open thecursor for
    select count(distinct t1.requestid) typecount,t3.workflowtype from workflow_currentoperator
    t1,workflow_requestbase t2 , workflow_base t3 where t1.userid= userid_1 and t1.usertype= usertype_1 and t1.isremark ='0' 
    and t1.requestid=t2.requestid and t2.workflowid = t3.id and ( t2.deleted=0 or t2.deleted is null ) and t2.currentnodetype='3'
    group by t3.workflowtype ;
    end if;
end;
/

INSERT INTO HtmlLabelIndex values(16757,'文档监控') 
/
INSERT INTO HtmlLabelInfo VALUES(16757,'文档监控',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16757,'',8) 
/

INSERT INTO HtmlLabelIndex values(16758,'流程监控') 
/
INSERT INTO HtmlLabelInfo VALUES(16758,'流程监控',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16758,'',8) 
/
