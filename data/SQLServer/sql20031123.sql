update workflow_bill set detailtablename = 'Bill_ExpenseDetail' where id = 7
GO
update HtmlLabelInfo set labelname = '帮助文档' where indexid = 15593 and  languageid = 7
GO

update HtmlLabelIndex set indexdesc = '帮助文档' where id = 15593 
GO
delete HtmlLabelIndex where id = 16676
GO

delete HtmlLabelInfo where indexid = 16676
GO

insert into HtmlLabelIndex values(16676,'多行请假单')
GO
insert into HtmlLabelInfo values(16676,'多行请假单',7)
GO
insert into HtmlLabelInfo values(16676,'',8)
GO


INSERT INTO HtmlLabelIndex values(16756,'每行数据必须全部填写，否则将不被保存！') 
GO
INSERT INTO HtmlLabelInfo VALUES(16756,'每行数据必须全部填写，否则将不被保存！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16756,'',8) 
GO


delete workflow_bill where id = 50
GO

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, operationpage, detailtablename, detailkeyfield) VALUES(50,16676,'Bill_HrmScheduleMain','AddBillHrmScheduleMain.jsp','ManageBillHrmScheduleMain.jsp','ViewBillHrmScheduleMain.jsp','BillHrmScheduleMainOperation.jsp','Bill_HrmScheduleDetail','scheduleid') 
GO

delete workflow_billfield where billid = 50
GO


INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'departmentid',124,'int',3,4,1,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'resource_n',368,'int',3,1,2,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'sumday',852,'int',1,2,3,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'reason',791,'varchar(255)',2,0,4,0)
GO 

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'diffid',1881,'int',3,34,6,1)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'startdate',740,'char(10)',3,2,7,1)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'starttime',742,'char(8)',3,19,8,1)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'enddate',741,'char(10)',3,2,9,1)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'endtime',743,'char(8)',3,19,10,1)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (50,'sumday',852,'int',1,2,11,1)
GO 


CREATE TABLE Bill_HrmScheduleMain (
	id int IDENTITY (1, 1) NOT NULL  ,
	resource_n int   NULL ,
	reason varchar (255) NULL,
    sumday int ,
	requestid  int
) 
GO


CREATE TABLE Bill_HrmScheduleDetail (
	id int IDENTITY (1, 1) NOT NULL  ,
	scheduleid  int   NULL ,
    diffid int ,
	startdate  char(10) NULL,
	starttime  char(8) NULL,
	enddate  char(10) NULL,
	endtime  char(8) NULL,
    sumday int 
) 
GO

alter table Bill_HrmScheduleMain add departmentid int 
GO
alter PROCEDURE workflow_currentoperator_SWft 
  @userid		int,
@usertype	int, 
   @complete	int, @flag integer output ,
    @msg varchar(80) output  
    as 
    if @complete=0 
    begin 
    select count(distinct t1.requestid) typecount,t3.workflowtype from workflow_currentoperator t1,workflow_requestbase t2 , workflow_base t3 where t1.userid=@userid  and t1.usertype=@usertype and t1.isremark in( '0','1') and t1.requestid=t2.requestid and t2.workflowid = t3.id and ( t2.deleted=0 or t2.deleted is null ) and t2.currentnodetype<>'3' group by t3.workflowtype 
    end 
    if @complete=1 
    begin 
    select count(distinct t1.requestid) typecount,t3.workflowtype from workflow_currentoperator t1,workflow_requestbase t2 , workflow_base t3 where t1.userid=@userid and t1.usertype=@usertype and t1.isremark ='0' and t1.requestid=t2.requestid and t2.workflowid = t3.id and ( t2.deleted=0 or t2.deleted is null ) and t2.currentnodetype='3' group by t3.workflowtype 
    end
GO





INSERT INTO HtmlLabelIndex values(16757,'文档监控') 
GO
INSERT INTO HtmlLabelInfo VALUES(16757,'文档监控',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16757,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16758,'流程监控') 
GO
INSERT INTO HtmlLabelInfo VALUES(16758,'流程监控',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16758,'',8) 
GO


