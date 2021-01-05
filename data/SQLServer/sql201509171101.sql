delete from HtmlLabelIndex where id=125623 
GO
delete from HtmlLabelInfo where indexid=125623 
GO
INSERT INTO HtmlLabelIndex values(125623,'搜索全文') 
GO
delete from HtmlLabelIndex where id=125624 
GO
delete from HtmlLabelInfo where indexid=125624 
GO
INSERT INTO HtmlLabelIndex values(125624,'搜索标题') 
GO
delete from HtmlLabelIndex where id=125625 
GO
delete from HtmlLabelInfo where indexid=125625 
GO
INSERT INTO HtmlLabelIndex values(125625,'按相关度排序') 
GO
delete from HtmlLabelIndex where id=125626 
GO
delete from HtmlLabelInfo where indexid=125626 
GO
INSERT INTO HtmlLabelIndex values(125626,'按时间排序') 
GO
INSERT INTO HtmlLabelInfo VALUES(125626,'按时间排序',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125626,'Sort by time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125626,'按時間排序',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(125625,'按相关度排序',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125625,'Sort by score',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125625,'按相關度排序',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(125624,'搜索标题',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125624,'Search title',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125624,'搜索标題',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(125623,'搜索全文',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125623,'Search full text',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125623,'搜索全文',9) 
GO