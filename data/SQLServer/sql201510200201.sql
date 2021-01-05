delete from HtmlLabelIndex where id=271855 
GO
delete from HtmlLabelInfo where indexid=271855 
GO
INSERT INTO HtmlLabelIndex values(271855,'您所导入的分部名称与系统中已被封存的分部名称相同,不得导入分部及人员！') 
GO
INSERT INTO HtmlLabelInfo VALUES(271855,'您所导入的分部名称与系统中已被封存的分部名称相同,不得导入分部及人员！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(271855,'The Importing Subcompany Have the Same Name with the canceled Subcompany Name,You can not import in this case',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(271855,'您所導入的分部名稱與系統中已被封存的分部名稱相同，不得導入分部及人員！',9) 
GO

delete from HtmlLabelIndex where id=271876 
GO
delete from HtmlLabelInfo where indexid=271876 
GO
INSERT INTO HtmlLabelIndex values(271876,'您所导入的部门名称与系统中已被封存的部门名称相同,不得导入部门及人员！') 
GO
INSERT INTO HtmlLabelInfo VALUES(271876,'您所导入的部门名称与系统中已被封存的部门名称相同,不得导入部门及人员！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(271876,'The Importing Department Have the Same Name with the canceled Department Name,You can not import in this case',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(271876,'您所導入的部門名稱與系統中已被封存的部門名稱相同，不得導入部門及人員！',9) 
GO