delete from HtmlLabelIndex where id=21159
GO
delete from HtmlLabelInfo where indexid=21159 
GO
INSERT INTO HtmlLabelIndex values(21159,'部门不存在') 
GO
delete from HtmlLabelIndex where id=21160 
GO
delete from HtmlLabelInfo where indexid=21160 
GO
INSERT INTO HtmlLabelIndex values(21160,'岗位不存在') 
GO
delete from HtmlLabelIndex where id=21161 
GO
delete from HtmlLabelInfo where indexid=21161 
GO
INSERT INTO HtmlLabelIndex values(21161,'分部不存在') 
GO
INSERT INTO HtmlLabelInfo VALUES(21159,'部门不存在',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21159,'Department does not exist',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21160,'岗位不存在',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21160,'Positions does not exist',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21161,'分部不存在',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21161,'Subcompany does not exist',8) 
GO
delete from HtmlLabelIndex where id=21168 
GO
delete from HtmlLabelInfo where indexid=21168 
GO
INSERT INTO HtmlLabelIndex values(21168,'或和部门上下级关系不存在') 
GO
INSERT INTO HtmlLabelInfo VALUES(21168,'或和部门上下级关系不存在',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21168,'or a superior-subordinate relationship does not exist with department',8) 
GO
