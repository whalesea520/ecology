INSERT INTO HtmlLabelIndex values(19582,'阅读日志统计') 
/
INSERT INTO HtmlLabelInfo VALUES(19582,'阅读日志统计',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19582,'doc reader Statistic',8) 
/

call MMConfig_U_ByInfoInsert (207,16)
/
call MMInfo_Insert (522,19582,'','/docs/report/DocRpReadStatistic.jsp','mainFrame',207,2,16,0,'',0,'',0,'','',0,'','',1)
/

INSERT INTO HtmlLabelIndex values(19584,'阅读次数') 
/
INSERT INTO HtmlLabelIndex values(19585,'阅读文档数量') 
/
INSERT INTO HtmlLabelInfo VALUES(19584,'阅读次数',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19584,'read counts',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19585,'阅读文档数量',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19585,'read doc counts',8) 
/