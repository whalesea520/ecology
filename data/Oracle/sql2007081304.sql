delete from HtmlLabelIndex where id in(15142,6083,614,6146,15236,1970,20782,20783)
/
delete from HtmlLabelInfo where indexid in(15142,6083,614,6146,15236,1970,20782,20783)
/

INSERT INTO HtmlLabelIndex values(15142,'合同名称') 
/
INSERT INTO HtmlLabelInfo VALUES(15142,'合同名称',7) 
/
INSERT INTO HtmlLabelInfo VALUES(15142,'Contract Name',8) 
/
 
INSERT INTO HtmlLabelIndex values(6083,'合同性质') 
/
INSERT INTO HtmlLabelInfo VALUES(6083,'合同性质',7) 
/
INSERT INTO HtmlLabelInfo VALUES(6083,'Contract Character',8) 
/

INSERT INTO HtmlLabelIndex values(614,'合同') 
/
INSERT INTO HtmlLabelInfo VALUES(614,'Contract',8) 
/
INSERT INTO HtmlLabelInfo VALUES(614,'合同',7) 
/
 
INSERT INTO HtmlLabelIndex values(6146,'合同金额') 
/
INSERT INTO HtmlLabelInfo VALUES(6146,'合同金额',7) 
/
INSERT INTO HtmlLabelInfo VALUES(6146,'Contract Sum',8) 
/

INSERT INTO HtmlLabelIndex values(15236,'合同结束日期') 
/
INSERT INTO HtmlLabelIndex values(1970,'合同开始日期') 
/
INSERT INTO HtmlLabelInfo VALUES(1970,'Contract start time',8) 
/
INSERT INTO HtmlLabelInfo VALUES(1970,'合同开始日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(15236,'合同结束日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(15236,'Contract end date',8) 
/



INSERT INTO HtmlLabelIndex values(20782,'产品使用单位') 
/
INSERT INTO HtmlLabelInfo VALUES(20782,'产品使用单位',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20782,'using unit of product',8) 
/

INSERT INTO HtmlLabelIndex values(20783,'其他金额') 
/
INSERT INTO HtmlLabelInfo VALUES(20783,'其他金额',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20783,'other money',8) 
/

delete from HtmlLabelIndex where id in(20796,16501,1936)
/
delete from HtmlLabelInfo where indexid in(20796,16501,1936)
/

INSERT INTO HtmlLabelIndex values(20796,'合同正文') 
/
INSERT INTO HtmlLabelInfo VALUES(20796,'合同正文',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20796,'Order Accessory',8) 
/

INSERT INTO HtmlLabelIndex values(16501,'合同信用') 
/
INSERT INTO HtmlLabelInfo VALUES(16501,'合同信用',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16501,'Contract Credit',8) 
/

INSERT INTO HtmlLabelIndex values(1936,'合同开始时间') 
/
INSERT INTO HtmlLabelInfo VALUES(1936,'合同开始时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(1936,'Contract Start Time',8) 
/
