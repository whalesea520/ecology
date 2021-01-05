INSERT INTO HtmlLabelIndex values(17626,'客户类型已存在,请重新定义类型名称') 
GO
INSERT INTO HtmlLabelInfo VALUES(17626,'客户类型已存在,请重新定义类型名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17626,'customer type has exist',8) 
GO
insert into CRM_CustomerType values('个人用户','个人用户','n','n',null)
go
INSERT INTO HtmlLabelIndex values(17706,'个人用户') 
GO
INSERT INTO HtmlLabelInfo VALUES(17706,'个人用户',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17706,'personal customer',8) 
GO
ALTER TABLE CRM_CustomerInfo ADD Sex  tinyint DEFAULT (0)
GO
ALTER TABLE CRM_CustomerInfo ADD IDCardNo  varchar(50) NULL
GO

/*td:1548*/
insert into ErrorMsgIndex values (49,'该行业已经关联客户,不能删除')
GO
insert into ErrorMsgInfo values (49,'该行业已经关联客户,不能删除!',7)
GO
insert into ErrorMsgInfo values (49,'associated with one client,can''t delete',8)
GO
insert into ErrorMsgIndex values (50,'该行业有子行业,不能删除')
GO
insert into ErrorMsgInfo values (50,'该行业有子行业,不能删除',7)
GO
insert into ErrorMsgInfo values (50,'It has the subordinate profession, can''t delete',8)
GO