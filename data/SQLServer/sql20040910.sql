/*td:667  by 王金永 for  表单明细字段新建页面的页头是【字段管理:添加】修改为【 新建：明细字段 】*/
delete HtmlLabelInfo   where indexid = 17463
go
delete HtmlLabelIndex   where id = 17463
go
delete HtmlLabelInfo   where indexid = 6074
go
delete HtmlLabelIndex   where id = 6074
go
INSERT INTO HtmlLabelIndex values(6074,'主') 
GO
INSERT INTO HtmlLabelInfo VALUES(6074,'主',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(6074,'Main',8) 
GO
INSERT INTO HtmlLabelIndex values(17463,'明细') 
GO
INSERT INTO HtmlLabelInfo VALUES(17463,'明细',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17463,'Detail',8) 
GO
/* td:708 新建或者编辑工作流名称不能超过60个字符，否则返回500错误。现已修改为新建或者编辑工作流名称，最多可以输入50个字母或汉字*/
alter table workflow_base alter column workflowname varchar(100)
go
alter table workflow_base alter column workflowdesc varchar(200)
go

/* td:848 具有客户卡片编辑权限的用户，点击编辑菜单返回无权限的页面*/
CREATE PROCEDURE CRM_ShareEditToManager(
@crmId int, @managerId int, @flag integer output,@msg varchar(80) output)
AS
IF EXISTS(SELECT id FROM CRM_ShareInfo WHERE relateditemid = @crmId 
AND sharetype = 1 AND userid = @managerId)
UPDATE CRM_ShareInfo SET sharelevel = 2 WHERE relateditemid = @crmId 
AND sharetype = 1 AND userid = @managerId
ELSE 
INSERT INTO CRM_ShareInfo(relateditemid, sharetype, sharelevel, userid) 
VALUES(@crmId, 1, 2, @managerId)
GO
/*td:949 借款申请流程没有纳入财务销帐中 */
update workflow_bill set operationpage = 'BillLoanOperation.jsp' where id = 13
GO