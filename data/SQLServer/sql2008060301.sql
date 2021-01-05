delete from SystemRights where id=397
go
delete from SystemRightsLanguage where id=397
go
delete from SystemRightDetail where id=3086
go

insert into SystemRights (id,rightdesc,righttype) values (397,'数据中心维护','0') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (397,7,'数据中心维护','数据中心维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (397,8,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3086,'数据中心维护','DataCenter:Maintenance',397) 
GO
 
delete from HtmlLabelIndex where id=16889
go
delete from  HtmlLabelInfo where indexid= 16889
go
INSERT INTO HtmlLabelIndex values(16889,'日') 
GO
INSERT INTO HtmlLabelInfo VALUES(16889,'日',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16889,'',8) 
GO

delete from HtmlLabelIndex where id=16890
go
delete from  HtmlLabelInfo where indexid= 16890
go

INSERT INTO HtmlLabelIndex values(16890,'统计项维护') 
GO
INSERT INTO HtmlLabelInfo VALUES(16890,'统计项维护',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16890,'',8) 
GO

delete from HtmlLabelIndex where id=16892
go
delete from  HtmlLabelInfo where indexid= 16892
go
delete from HtmlLabelIndex where id=16893
go
delete from  HtmlLabelInfo where indexid= 16893
go
INSERT INTO HtmlLabelIndex values(16892,'报表统计项') 
GO
INSERT INTO HtmlLabelInfo VALUES(16892,'报表统计项',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16892,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16893,'统计项') 
GO
INSERT INTO HtmlLabelInfo VALUES(16893,'统计项',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16893,'',8) 
GO

delete from HtmlLabelIndex where id=16894
go
delete from  HtmlLabelInfo where indexid= 16894
go

INSERT INTO HtmlLabelIndex values(16894,'按时间分列') 
GO
INSERT INTO HtmlLabelInfo VALUES(16894,'按时间分列',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16894,'',8) 
GO
 

delete from HtmlLabelIndex where id=16895
go
delete from  HtmlLabelInfo where indexid= 16895
go
delete from HtmlLabelIndex where id=16896
go
delete from  HtmlLabelInfo where indexid= 16896
go
INSERT INTO HtmlLabelIndex values(16895,'基层企业') 
GO
INSERT INTO HtmlLabelInfo VALUES(16895,'基层企业',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16895,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16896,'取前') 
GO
INSERT INTO HtmlLabelInfo VALUES(16896,'取前',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16896,'',8) 
GO

delete from HtmlLabelIndex where id in (16901,16902,16903)
go
delete from  HtmlLabelInfo where indexid in (16901,16902,16903)
go
INSERT INTO HtmlLabelIndex values(16901,'统计图形') 
GO
INSERT INTO HtmlLabelInfo VALUES(16901,'统计图形',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16901,'',8) 
GO
 
INSERT INTO HtmlLabelIndex values(16902,'基层单位') 
GO
INSERT INTO HtmlLabelInfo VALUES(16902,'基层单位',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16902,'',8) 
GO


INSERT INTO HtmlLabelIndex values(16903,'横坐标') 
GO
INSERT INTO HtmlLabelInfo VALUES(16903,'横坐标',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16903,'',8) 
GO

delete from HtmlLabelIndex where id in (17028,17029)
go
delete from  HtmlLabelInfo where indexid in (17028,17029)
go
INSERT INTO HtmlLabelIndex values(17028,'上月') 
GO
INSERT INTO HtmlLabelInfo VALUES(17028,'上月',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17028,'last month',8) 
GO
 
INSERT INTO HtmlLabelIndex values(17029,'上年') 
GO
INSERT INTO HtmlLabelInfo VALUES(17029,'上年',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17029,'last year',8) 
GO


delete from HtmlLabelIndex where id in (17030,17031,17032)
go
delete from  HtmlLabelInfo where indexid in (17030,17031,17032)
go


INSERT INTO HtmlLabelIndex values(17030,'填报修正') 
GO
INSERT INTO HtmlLabelInfo VALUES(17030,'填报修正',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17030,'Input modify',8) 
GO

INSERT INTO HtmlLabelIndex values(17031,'月修正') 
GO
INSERT INTO HtmlLabelInfo VALUES(17031,'月修正',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17031,'Monthly modify',8) 
GO

INSERT INTO HtmlLabelIndex values(17032,'年修正') 
GO
INSERT INTO HtmlLabelInfo VALUES(17032,'年修正',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17032,'Year modify',8) 
GO

delete HtmlLabelIndex where id = 16538 
GO

delete HtmlLabelInfo where indexid = 16538 
GO

INSERT INTO HtmlLabelIndex values(16538,'明细报表') 
GO
INSERT INTO HtmlLabelInfo VALUES(16538,'明细报表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16538,'Detail Report',8) 
GO

delete HtmlLabelIndex where id = 17070 
GO

delete HtmlLabelInfo where indexid = 17070 
GO

INSERT INTO HtmlLabelIndex values(17070,'排序报表') 
GO
INSERT INTO HtmlLabelInfo VALUES(17070,'排序报表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17070,'Ordinal Report',8) 
GO

delete from HtmlLabelIndex where id=17496
go
delete from  HtmlLabelInfo where indexid= 17496
go

INSERT INTO HtmlLabelIndex values(17496,'模板设计') 
GO
INSERT INTO HtmlLabelInfo VALUES(17496,'模板设计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17496,'Mould Design',8) 
GO
