INSERT INTO HtmlLabelIndex values(19582,'阅读日志统计') 
GO
INSERT INTO HtmlLabelInfo VALUES(19582,'阅读日志统计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19582,'doc reader Statistic',8) 
GO

EXECUTE MMConfig_U_ByInfoInsert 207,16
GO
EXECUTE MMInfo_Insert 522,19582,'','/docs/report/DocRpReadStatistic.jsp','mainFrame',207,2,16,0,'',0,'',0,'','',0,'','',1
GO

INSERT INTO HtmlLabelIndex values(19584,'阅读次数') 
GO
INSERT INTO HtmlLabelIndex values(19585,'阅读文档数量') 
GO
INSERT INTO HtmlLabelInfo VALUES(19584,'阅读次数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19584,'read counts',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19585,'阅读文档数量',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19585,'read doc counts',8) 
GO