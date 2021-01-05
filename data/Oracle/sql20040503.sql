/*客户类型*/

alter table CRM_CustomerType add workflowid integer
/

CREATE or replace PROCEDURE CRM_CustomerType_Insert 
(fullname varchar2, 
description varchar2,
workflowid integer, 
 flag out integer,
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor) 
AS
begin
INSERT INTO CRM_CustomerType 
( fullname, description,workflowid) 
VALUES ( fullname, description,workflowid);
end;
/

CREATE or replace PROCEDURE CRM_CustomerType_Update 
(id_1	integer, 
fullname_1 varchar2, 
description_1 varchar2,
workflowid_1 integer, 
flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
UPDATE CRM_CustomerType SET  fullname = fullname_1, 
description	 = description_1,
workflowid = workflowid_1
WHERE ( id	 = id_1);
end;
/

CREATE or replace PROCEDURE CRM_CustomerType_SelectByID 
(id_1 integer, 
flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
AS
begin
open thecursor for
SELECT t1.*, t2.workflowname AS workflowname 
FROM CRM_CustomerType t1 LEFT OUTER JOIN workflow_base t2 
ON t1.workflowid = t2.id WHERE (t1.id = id_1);
end;
/

/*客户审批工作流*/
CREATE TABLE bill_ApproveCustomer ( 
    id integer,
    managerid integer,
    requestid integer,
    approveid integer,
    approvevalue integer,
    approvedesc varchar2(50),
    status char(1),
    approvetype integer) 
/
create sequence bill_ApproveCustomer_id
start with 1
increment by 1
nomaxvalue
nocycle
/                           


create or replace trigger bill_ApproveCustomer_Tri
before insert on bill_ApproveCustomer
for each row
begin
select bill_ApproveCustomer_id.nextval into :new.id from dual;
end;
/

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(79,17180,'bill_ApproveCustomer','AddBillApproveCustomer.jsp','ManageBillApproveCustomer.jsp','ViewBillApproveCustomer.jsp','','','BillApproveCustomerOperation.jsp') 
/ 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (79,'managerid',1278,'integer',3,1,3,0)
/ 
  

INSERT INTO HtmlLabelIndex values(17181,'相关描述') 
/
INSERT INTO HtmlLabelInfo VALUES(17181,'相关描述',7) 
/

INSERT INTO HtmlLabelIndex values(17180,'客户审批流转单') 
/
INSERT INTO HtmlLabelInfo VALUES(17180,'客户审批流转单',7) 
/
 
/*新客户*/
CREATE TABLE CRM_ViewLog2 ( 
    customerid integer,
    oldmanager integer,
    newmanager integer,
    movedate char(10),
    movetime char(8)) 
/

/*增加节点操作者*/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 87,780,'','/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingRoomBrowser.jsp','MeetingRoom','name','id','/meeting/Maint/MeetingRoom.jsp?id=')
/
INSERT INTO HtmlLabelIndex values(17204,'客户字段经理的经理') 
/
INSERT INTO HtmlLabelInfo VALUES(17204,'客户字段经理的经理',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17204,'manager''s manager',8) 
/



/*回复自动提醒*/

alter table DocDetail add canremind char(1)
/

/*文档批量共享*/

INSERT INTO HtmlLabelIndex values(17220,'文档批量共享') 
/
INSERT INTO HtmlLabelInfo VALUES(17220,'文档批量共享',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17220,'Muti Document Share',8) 
/

/*客户批量共享*/

INSERT INTO HtmlLabelIndex values(17221,'客户批量共享') 
/
INSERT INTO HtmlLabelInfo VALUES(17221,'客户批量共享',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17221,'Customer Muti Share',8) 
/

/*群发邮件*/
CREATE TABLE MailSendRecord ( 
    id integer,
    sendfrom varchar2(200),
    sendcc varchar2(200),
    sendbcc varchar2(200),
    sendto varchar2(200),
    subject varchar2(200),
    body Varchar2(4000),
    charset char(1),
    priority char(1),
    senddate char(10),
    sendtime char(8),
    isfinished char(1),
    sender integer,
    sendcount integer,
    isdeleted char(1),
    sendtotype char(1),
    sendtoid integer) 
/
create sequence MailSendRecord_id
start with 1
increment by 1
nomaxvalue
nocycle
/                           


create or replace trigger MailSendRecord_Tri
before insert on bill_ApproveCustomer
for each row
begin
select MailSendRecord_id.nextval into :new.id from dual;
end;
/

create or replace PROCEDURE MailSendRecord_Insert
	(sendfrom_2 	varchar2,
	 sendcc_3 	varchar2,
	 sendbcc_4 	varchar2,
	 sendto_5 	varchar2,
	 subject_6 	varchar2,
	 body_7 	varchar2,
	 charset_8 	char,
	 priority_9 	char,
	 senddate_10 	char,
	 sendtime_11 	char,
	 isfinished_12 	char,
	 sender_13 	integer,
	 sendcount_14 	integer,
     isdeleted_15 char,
     sendtotype_16 char,
     sendtoid_17 integer,
 flag out integer,
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO MailSendRecord 
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
	(sendfrom_2,
	 sendcc_3,
	 sendbcc_4,
	 sendto_5,
	 subject_6,
	 body_7,
	 charset_8,
	 priority_9,
	 senddate_10,
	 sendtime_11,
	 isfinished_12,
	 sender_13,
	 sendcount_14,
     isdeleted_15,
     sendtotype_16,
     sendtoid_17);
end;

/*左面工作区标签*/
INSERT INTO HtmlLabelIndex values(17288,'级别申请') 
/
INSERT INTO HtmlLabelIndex values(17289,'重设密码') 
/
INSERT INTO HtmlLabelIndex values(17290,'基础客户') 
/
INSERT INTO HtmlLabelIndex values(17292,'成功客户') 
/
INSERT INTO HtmlLabelIndex values(17293,'试点客户') 
/
INSERT INTO HtmlLabelIndex values(17294,'典型客户') 
/
INSERT INTO HtmlLabelIndex values(17297,'需要审批门户的客户') 
/
INSERT INTO HtmlLabelIndex values(17296,'需要审批级别的客户') 
/
INSERT INTO HtmlLabelIndex values(17291,'潜在客户') 
/
INSERT INTO HtmlLabelIndex values(17295,'无效客户') 
/
INSERT INTO HtmlLabelInfo VALUES(17288,'级别申请',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17288,'level apply',8) 
/
INSERT INTO HtmlLabelInfo VALUES(17289,'重设密码',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17289,'reset password',8) 
/
INSERT INTO HtmlLabelInfo VALUES(17290,'基础客户',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17290,'base customer',8) 
/
INSERT INTO HtmlLabelInfo VALUES(17291,'潜在客户',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17291,'',8) 
/
INSERT INTO HtmlLabelInfo VALUES(17292,'成功客户',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17292,'',8) 
/
INSERT INTO HtmlLabelInfo VALUES(17293,'试点客户',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17293,'',8) 
/
INSERT INTO HtmlLabelInfo VALUES(17294,'典型客户',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17294,'',8) 
/
INSERT INTO HtmlLabelInfo VALUES(17295,'无效客户',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17295,'',8) 
/
INSERT INTO HtmlLabelInfo VALUES(17296,'需要审批级别的客户',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17296,'',8) 
/
INSERT INTO HtmlLabelInfo VALUES(17297,'需要审批门户的客户',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17297,'',8) 
/
