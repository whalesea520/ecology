delete from htmllabelindex where id=17717 or id=17718 or id=19985
go
delete from htmllabelinfo where indexid=17717 or indexid=17718 or indexid=19985
go
INSERT INTO HtmlLabelIndex values(17717,'协作区管理') 
GO
INSERT INTO HtmlLabelInfo VALUES(17717,'协作区管理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17717,'Cowork Management',8) 
GO
 
INSERT INTO HtmlLabelIndex values(17718,'协作区设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(17718,'协作区设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17718,'Cowork Set',8) 
GO

INSERT INTO HtmlLabelIndex values(19985,'协作监控') 
GO
INSERT INTO HtmlLabelInfo VALUES(19985,'协作监控',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19985,'Cowork Monitor',8) 
GO
INSERT INTO SystemLogItem VALUES(90,17855,'协作')
GO
