delete from  HtmlLabelIndex where id=18792
GO
delete from  HtmlLabelInfo where indexId=18792
GO
delete from  HtmlLabelIndex where id=18791
GO
delete from  HtmlLabelInfo where indexId=18791
GO
delete from  HtmlLabelIndex where id=18790
GO
delete from  HtmlLabelInfo where indexId=18790
GO
INSERT INTO HtmlLabelIndex values(18792,'考核员评分') 
GO
INSERT INTO HtmlLabelIndex values(18791,'安排说明') 
GO
INSERT INTO HtmlLabelIndex values(18790,'工作安排单据(新)') 
GO
INSERT INTO HtmlLabelInfo VALUES(18790,'工作安排单据(新)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18791,'安排说明',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18792,'考核员评分',7) 
GO
delete from  HtmlLabelIndex where id=18795
GO
delete from  HtmlLabelInfo where indexId=18795
GO
INSERT INTO HtmlLabelIndex values(17795,'工作内容') 
GO
INSERT INTO HtmlLabelInfo VALUES(17795,'工作内容',7) 
GO
delete from  HtmlLabelIndex where id=18149
GO
delete from  HtmlLabelInfo where indexId=18149
GO
delete from  HtmlLabelIndex where id=18148
GO
delete from  HtmlLabelInfo where indexId=18148
GO
delete from  HtmlLabelIndex where id=18150
GO
delete from  HtmlLabelInfo where indexId=18150
GO
INSERT INTO HtmlLabelIndex values(18149,'创建人评分') 
GO
INSERT INTO HtmlLabelIndex values(18150,'接收人评分') 
GO
INSERT INTO HtmlLabelIndex values(18148,'领导评分') 
GO
INSERT INTO HtmlLabelInfo VALUES(18148,'领导评分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18148,'vip grade',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18149,'创建人评分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18149,'creator grade',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18150,'接收人评分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18150,'accept grade',8) 
GO
delete from  HtmlLabelIndex where id=18177
GO
delete from  HtmlLabelInfo where indexId=18177
GO
delete from  HtmlLabelIndex where id=18178
GO
delete from  HtmlLabelInfo where indexId=18178
GO
delete from  HtmlLabelIndex where id=18194
GO
delete from  HtmlLabelInfo where indexId=18194
GO

INSERT INTO HtmlLabelIndex values(18177,'任务类型') 
GO
INSERT INTO HtmlLabelInfo VALUES(18177,'任务类型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18177,'Task type',8) 
GO

INSERT INTO HtmlLabelIndex values(18178,'重要程度') 
GO
INSERT INTO HtmlLabelInfo VALUES(18178,'重要程度',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18178,'Important Degree',8) 
GO

INSERT INTO HtmlLabelIndex values(18794,'任务所有接收人') 
GO
INSERT INTO HtmlLabelInfo VALUES(18794,'任务所有接收人',7) 
GO