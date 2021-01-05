create table workflow_TitleSet(
flowId int not null,
fieldId int  null
)
Go

INSERT INTO HtmlLabelIndex values(19501,'标题字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(19501,'标题字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19501,'title field',8) 
GO

insert into SystemRights (id,rightdesc,righttype) values (662,'标题字段管理','5') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (662,7,'标题字段管理','标题字段管理') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (662,8,'MANAGER FIELD OF TITLE','MANAGER FIELD OF TITLE') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4163,'标题字段管理','WorkFlowTitleSet:ALL',662) 
GO



INSERT INTO HtmlLabelIndex values(19502,'流程编号') 
GO
INSERT INTO HtmlLabelInfo VALUES(19502,'流程编号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19502,'flow code',8) 
GO


insert into SystemRights (id,rightdesc,righttype) values (663,'流程编号','5') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (663,8,'flow code','flow code') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (663,7,'流程编号','流程编号') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4164,'流程编号','FLOWCODE:ALL',663) 
GO

INSERT INTO HtmlLabelIndex values(19503,'编号字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(19503,'编号字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19503,'field of coding',8) 
GO

INSERT INTO HtmlLabelIndex values(19504,'编号规则') 
GO
INSERT INTO HtmlLabelInfo VALUES(19504,'编号规则',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19504,'rule of coding',8) 
GO
 
create table workflow_Code(
formId int not null,
flowId int not null,
codeFieldId int null,
isUse char(1) null,
currentCode varchar(100) null
)
Go
create table workflow_CodeDetail(
mainId int not null,
showId int not null,
codeValue varchar(100) null,
codeOrder int null
)
Go

create table workflow_codeSet
(id int not null,
showName varchar(100) null,
showType char(1) null
)
GO

alter PROCEDURE HrmResource_SelectAll 
 (@flag integer output, @msg   varchar(80) output ) 
AS select 
  id,
  loginid,  
  lastname,
  sex,
  resourcetype,
  email,
  locationid,
  workroom, 
  departmentid,
  costcenterid,
  jobtitle,
  managerid,
  assistantid ,
  seclevel,
  joblevel,
  status,
  account,
  mobile,
  password
from HrmResource  
if @@error<>0 begin set @flag=1 set @msg='查询人力资源信息成功' return end else begin set @flag=0 set @msg='查询人力资源信息失败' return end 

GO

insert into workflow_codeSet values(1,18729,'2')
go
insert into workflow_codeSet values(2,445,'1')
go
insert into workflow_codeSet values(3,6076,'1')
go
insert into workflow_codeSet values(4,18811,'2')
go