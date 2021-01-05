delete from HtmlLabelIndex where id=131203 
GO
delete from HtmlLabelInfo where indexid=131203 
GO
INSERT INTO HtmlLabelIndex values(131203,'您选择的日期对应的账期已关闭，不能提交') 
GO
INSERT INTO HtmlLabelInfo VALUES(131203,'您选择的日期对应的账期已关闭，不能提交',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(131203,'You choose the date of the corresponding payment days are closed and cannot be submitted',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(131203,'您選擇的日期對應的賬期已關閉，不能提交',9) 
GO

delete from HtmlLabelIndex where id=131210 
GO
delete from HtmlLabelInfo where indexid=131210 
GO
INSERT INTO HtmlLabelIndex values(131210,'模版不匹配，请重新下载模版') 
GO
INSERT INTO HtmlLabelInfo VALUES(131210,'模版不匹配，请重新下载模版',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(131210,'The template does not match, please download the template again',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(131210,'模版不匹配，請重新下載模版',9) 
GO
