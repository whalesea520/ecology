/*客户类型*/

alter table CRM_CustomerType add workflowid int
go

alter PROCEDURE CRM_CustomerType_Insert (@fullname varchar(50), @description varchar(150),@workflowid int, @flag int output, @msg varchar(80)	output) AS INSERT INTO CRM_CustomerType ( fullname, description,workflowid) VALUES ( @fullname, @description,@workflowid) set @flag = 1 set @msg = 'OK!'
GO

alter PROCEDURE CRM_CustomerType_Update (@id 	int, @fullname 	varchar(50), @description 	varchar(150),@workflowid int, @flag	int	output, @msg	varchar(80)	output) AS UPDATE CRM_CustomerType SET  fullname	 = @fullname, description	 = @description,workflowid = @workflowid WHERE ( id	 = @id) set @flag = 1 set @msg = 'OK!'
GO

alter PROCEDURE CRM_CustomerType_SelectByID (@id int, @flag int	output, @msg varchar(80) output) AS SELECT t1.*, t2.workflowname AS workflowname FROM CRM_CustomerType t1 LEFT OUTER JOIN workflow_base t2 ON t1.workflowid = t2.id WHERE (t1.id = @id) set @flag = 1 set @msg = 'OK!'
GO

/*客户审批工作流*/
CREATE TABLE bill_ApproveCustomer ( 
    id int IDENTITY,
    managerid int,
    requestid int,
    approveid int,
    approvevalue int,
    approvedesc varchar(50),
    status char(1),
    approvetype int) 
GO

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(79,17180,'bill_ApproveCustomer','AddBillApproveCustomer.jsp','ManageBillApproveCustomer.jsp','ViewBillApproveCustomer.jsp','','','BillApproveCustomerOperation.jsp') 
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (79,'managerid',1278,'int',3,1,3,0)
GO 
  

INSERT INTO HtmlLabelIndex values(17181,'相关描述') 
GO
INSERT INTO HtmlLabelInfo VALUES(17181,'相关描述',7) 
GO

INSERT INTO HtmlLabelIndex values(17180,'客户审批流转单') 
GO
INSERT INTO HtmlLabelInfo VALUES(17180,'客户审批流转单',7) 
GO
 
/*新客户*/
CREATE TABLE CRM_ViewLog2 ( 
    customerid int,
    oldmanager int,
    newmanager int,
    movedate char(10),
    movetime char(8)) 
GO

/*增加节点操作者*/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 87,780,'','/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingRoomBrowser.jsp','MeetingRoom','name','id','/meeting/Maint/MeetingRoom.jsp?id=')
go 
INSERT INTO HtmlLabelIndex values(17204,'客户字段经理的经理') 
GO
INSERT INTO HtmlLabelInfo VALUES(17204,'客户字段经理的经理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17204,'manager''s manager',8) 
GO



/*回复自动提醒*/

alter table DocDetail add canremind char(1)
go

/*文档批量共享*/

INSERT INTO HtmlLabelIndex values(17220,'文档批量共享') 
GO
INSERT INTO HtmlLabelInfo VALUES(17220,'文档批量共享',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17220,'Muti Document Share',8) 
GO

/*客户批量共享*/

INSERT INTO HtmlLabelIndex values(17221,'客户批量共享') 
GO
INSERT INTO HtmlLabelInfo VALUES(17221,'客户批量共享',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17221,'Customer Muti Share',8) 
GO

/*群发邮件*/
CREATE TABLE MailSendRecord ( 
    id int IDENTITY,
    sendfrom varchar(200),
    sendcc varchar(200),
    sendbcc varchar(200),
    sendto varchar(200),
    subject varchar(200),
    body text,
    charset char(1),
    priority char(1),
    senddate char(10),
    sendtime char(8),
    isfinished char(1),
    sender int,
    sendcount int,
    isdeleted char(1),
    sendtotype char(1),
    sendtoid int) 
GO

CREATE PROCEDURE MailSendRecord_Insert
	(@sendfrom_2 	varchar(200),
	 @sendcc_3 	varchar(200),
	 @sendbcc_4 	varchar(200),
	 @sendto_5 	varchar(200),
	 @subject_6 	varchar(200),
	 @body_7 	text,
	 @charset_8 	char(1),
	 @priority_9 	char(1),
	 @senddate_10 	char(10),
	 @sendtime_11 	char(8),
	 @isfinished_12 	char(1),
	 @sender_13 	int,
	 @sendcount_14 	int,
     @isdeleted_15 char(1),
     @sendtotype_16 char(1),
     @sendtoid_17 int,
     @flag int output, 
     @msg varchar(80) output)

AS INSERT INTO MailSendRecord 
	 (sendfrom,
	 sendcc,
	 sendbcc,
	 sendto,
	 subject,
	 body,
	 charset,
	 priority,
	 senddate,
	 sendtime,
	 isfinished,
	 sender,
	 sendcount,
     isdeleted,
     sendtotype,
     sendtoid) 
 
VALUES 
	(@sendfrom_2,
	 @sendcc_3,
	 @sendbcc_4,
	 @sendto_5,
	 @subject_6,
	 @body_7,
	 @charset_8,
	 @priority_9,
	 @senddate_10,
	 @sendtime_11,
	 @isfinished_12,
	 @sender_13,
	 @sendcount_14,
     @isdeleted_15,
     @sendtotype_16,
     @sendtoid_17)

/*左面工作区标签*/
INSERT INTO HtmlLabelIndex values(17288,'级别申请') 
GO
INSERT INTO HtmlLabelIndex values(17289,'重设密码') 
GO
INSERT INTO HtmlLabelIndex values(17290,'基础客户') 
GO
INSERT INTO HtmlLabelIndex values(17292,'成功客户') 
GO
INSERT INTO HtmlLabelIndex values(17293,'试点客户') 
GO
INSERT INTO HtmlLabelIndex values(17294,'典型客户') 
GO
INSERT INTO HtmlLabelIndex values(17297,'需要审批门户的客户') 
GO
INSERT INTO HtmlLabelIndex values(17296,'需要审批级别的客户') 
GO
INSERT INTO HtmlLabelIndex values(17291,'潜在客户') 
GO
INSERT INTO HtmlLabelIndex values(17295,'无效客户') 
GO
INSERT INTO HtmlLabelInfo VALUES(17288,'级别申请',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17288,'level apply',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17289,'重设密码',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17289,'reset password',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17290,'基础客户',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17290,'base customer',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17291,'潜在客户',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17291,'',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17292,'成功客户',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17292,'',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17293,'试点客户',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17293,'',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17294,'典型客户',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17294,'',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17295,'无效客户',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17295,'',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17296,'需要审批级别的客户',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17296,'',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17297,'需要审批门户的客户',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17297,'',8) 
GO
