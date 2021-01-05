delete from HtmlLabelIndex where id=127816 
GO
delete from HtmlLabelInfo where indexid=127816 
GO
INSERT INTO HtmlLabelIndex values(127816,'一级部门及所有下级部门') 
GO
INSERT INTO HtmlLabelInfo VALUES(127816,'一级部门及所有下级部门',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127816,'All departments and subordinate departments',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127816,'壹級部門及所有下級部門',9) 
GO

delete from HtmlLabelIndex where id=127815 
GO
delete from HtmlLabelInfo where indexid=127815 
GO
INSERT INTO HtmlLabelIndex values(127815,'是否允许多次意见征询') 
GO
INSERT INTO HtmlLabelInfo VALUES(127815,'是否允许多次意见征询',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127815,'Whether to allow multiple consultation',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127815,'是否允許多次意見征詢',9) 
GO