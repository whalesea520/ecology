delete from HtmlLabelIndex where id=24297 
GO
delete from HtmlLabelInfo where indexid=24297 
GO
INSERT INTO HtmlLabelIndex values(24297,'该部门不能解封,请先解封上级部门!') 
GO
delete from HtmlLabelIndex where id=24298 
GO
delete from HtmlLabelInfo where indexid=24298 
GO
INSERT INTO HtmlLabelIndex values(24298,'该分部不能解封,请先解封上级分部!') 
GO
INSERT INTO HtmlLabelInfo VALUES(24297,'该部门不能解封,请先解封上级部门!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24297,'The department can not be re-opened, please re-opened higher authorities!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24297,'該部門不能解封,請先解封上級部門!',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(24298,'该分部不能解封,请先解封上级分部!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24298,'The Division can not be re-opened, please re-opened higher division!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24298,'該分部不能解封,請先解封上級分部!',9) 
GO
