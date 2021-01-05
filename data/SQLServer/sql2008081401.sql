delete from HtmlLabelIndex where id=21767 
GO
delete from HtmlLabelInfo where indexid=21767 
GO
INSERT INTO HtmlLabelIndex values(21767,'添加到系统提醒') 
GO
delete from HtmlLabelIndex where id=21768 
GO
delete from HtmlLabelInfo where indexid=21768 
GO
INSERT INTO HtmlLabelIndex values(21768,'从系统提醒中移除') 
GO
INSERT INTO HtmlLabelInfo VALUES(21767,'添加到系统提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21767,'添加到系统提醒',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21768,'从系统提醒中移除',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21768,'Remove From Remind',8) 
GO


delete from HtmlLabelIndex where id=21775 
GO
delete from HtmlLabelInfo where indexid=21775 
GO
INSERT INTO HtmlLabelIndex values(21775,'确认把此元素添加到系统提醒中去吗?') 
GO
delete from HtmlLabelIndex where id=21776 
GO
delete from HtmlLabelInfo where indexid=21776 
GO
INSERT INTO HtmlLabelIndex values(21776,'确认把此元素从系统提醒中移除吗?') 
GO
INSERT INTO HtmlLabelInfo VALUES(21775,'确认把此元素添加到系统提醒中去吗?',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21775,'Confirm add this to system remind?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21776,'确认把此元素从系统提醒中移除吗?',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21776,'confirm remove this from system remind?',8) 
GO