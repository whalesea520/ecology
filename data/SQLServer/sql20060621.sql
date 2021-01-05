INSERT INTO HtmlLabelIndex values(19314,'资产导入') 
GO
INSERT INTO HtmlLabelInfo VALUES(19314,'资产导入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19314,'capital auto loading',8) 
GO
INSERT INTO HtmlLabelIndex values(19316,'服务器正在处理资产导入，请稍等...') 
GO
INSERT INTO HtmlLabelIndex values(19317,'资产导入成功！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19316,'服务器正在处理资产导入，请稍等...',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19316,'capital loading,please wait...',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19317,'资产导入成功！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19317,'capital load success!',8) 
GO
INSERT INTO HtmlLabelIndex values(19320,'资产资料导入') 
GO
INSERT INTO HtmlLabelInfo VALUES(19320,'资产资料导入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19320,'capital type load',8) 
GO
INSERT INTO HtmlLabelIndex values(19322,'资产资料编号') 
GO
INSERT INTO HtmlLabelInfo VALUES(19322,'资产资料编号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19322,'capital type no',8) 
GO
INSERT INTO HtmlLabelIndex values(19326,'资产资料导入成功！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19326,'资产资料导入成功！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19326,'capital type load success!',8) 
GO

INSERT INTO HtmlLabelIndex values(19364,'服务器正在处理资产资料导入，请稍等...') 
GO
INSERT INTO HtmlLabelInfo VALUES(19364,'服务器正在处理资产资料导入，请稍等...',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19364,'capital type loading,please wait...',8) 
GO

INSERT INTO HtmlLabelIndex values(17342,'入库单价') 
GO
INSERT INTO HtmlLabelInfo VALUES(17342,'入库单价',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17342,'',8) 
GO


EXECUTE MMConfig_U_ByInfoInsert 8,4
GO
EXECUTE MMInfo_Insert 511,19320,'资产资料导入','/cpt/capital/CapitalExcelToDB.jsp','mainFrame',8,1,4,0,'',1,'Capital:Maintenance',0,'','',0,'','',7
GO

ALTER table cptcapital ALTER COLUMN capitalnum DECIMAL(18,1)
GO

