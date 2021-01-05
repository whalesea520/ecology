delete from HtmlLabelIndex where id=126274 
GO
delete from HtmlLabelInfo where indexid=126274 
GO
INSERT INTO HtmlLabelIndex values(126274,'您所导入的分部名称与系统中已被封存的分部名称相同,不得导入分部及人员！') 
GO
INSERT INTO HtmlLabelInfo VALUES(126274,'您所导入的分部名称与系统中已被封存的分部名称相同,不得导入分部及人员！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126274,'The Importing Subcompany Have the Same Name with the canceled Subcompany Name,You can not import in this case',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126274,'您所導入的分部名稱與系統中已被封存的分部名稱相同，不得導入分部及人員！',9) 
GO

delete from HtmlLabelIndex where id=126275 
GO
delete from HtmlLabelInfo where indexid=126275  
GO
INSERT INTO HtmlLabelIndex values(126275 ,'您所导入的部门名称与系统中已被封存的部门名称相同,不得导入部门及人员！') 
GO
INSERT INTO HtmlLabelInfo VALUES(126275 ,'您所导入的部门名称与系统中已被封存的部门名称相同,不得导入部门及人员！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126275 ,'The Importing Department Have the Same Name with the canceled Department Name,You can not import in this case',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126275 ,'您所導入的部門名稱與系統中已被封存的部門名稱相同，不得導入部門及人員！',9) 
GO


delete from HtmlLabelIndex where id=126276 
GO
delete from HtmlLabelInfo where indexid=126276 
GO
INSERT INTO HtmlLabelIndex values(126276,'不能删除已经结束的培训活动！') 
GO
INSERT INTO HtmlLabelInfo VALUES(126276,'不能删除已经结束的培训活动！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126276,'Cannot delete the Finished Plan Activities!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126276,'不能刪除已經結束的培訓活動！',9) 
GO