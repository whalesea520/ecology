delete from HtmlLabelIndex where id in(15142,6083,614,6146,15236,1970,20782,20783)
GO
delete from HtmlLabelInfo where indexid in(15142,6083,614,6146,15236,1970,20782,20783)
GO

INSERT INTO HtmlLabelIndex values(15142,'合同名称') 
GO
INSERT INTO HtmlLabelInfo VALUES(15142,'合同名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(15142,'Contract Name',8) 
GO
 
INSERT INTO HtmlLabelIndex values(6083,'合同性质') 
GO
INSERT INTO HtmlLabelInfo VALUES(6083,'合同性质',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(6083,'Contract Character',8) 
GO

INSERT INTO HtmlLabelIndex values(614,'合同') 
GO
INSERT INTO HtmlLabelInfo VALUES(614,'Contract',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(614,'合同',7) 
GO
 
INSERT INTO HtmlLabelIndex values(6146,'合同金额') 
GO
INSERT INTO HtmlLabelInfo VALUES(6146,'合同金额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(6146,'Contract Sum',8) 
GO

INSERT INTO HtmlLabelIndex values(15236,'合同结束日期') 
GO
INSERT INTO HtmlLabelIndex values(1970,'合同开始日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(1970,'Contract start time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(1970,'合同开始日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(15236,'合同结束日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(15236,'Contract end date',8) 
GO



INSERT INTO HtmlLabelIndex values(20782,'产品使用单位') 
GO
INSERT INTO HtmlLabelInfo VALUES(20782,'产品使用单位',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20782,'using unit of product',8) 
GO

INSERT INTO HtmlLabelIndex values(20783,'其他金额') 
GO
INSERT INTO HtmlLabelInfo VALUES(20783,'其他金额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20783,'other money',8) 
GO

delete from HtmlLabelIndex where id in(20796,16501,1936)
GO
delete from HtmlLabelInfo where indexid in(20796,16501,1936)
GO

INSERT INTO HtmlLabelIndex values(20796,'合同正文') 
GO
INSERT INTO HtmlLabelInfo VALUES(20796,'合同正文',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20796,'Order Accessory',8) 
GO

INSERT INTO HtmlLabelIndex values(16501,'合同信用') 
GO
INSERT INTO HtmlLabelInfo VALUES(16501,'合同信用',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16501,'Contract Credit',8) 
GO

INSERT INTO HtmlLabelIndex values(1936,'合同开始时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(1936,'合同开始时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(1936,'Contract Start Time',8) 
GO