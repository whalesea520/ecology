delete from SystemRights where id=397
/
delete from SystemRightsLanguage where id=397
/
delete from SystemRightDetail where id=3086
/
insert into SystemRights (id,rightdesc,righttype) values (397,'数据中心维护','0') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (397,7,'数据中心维护','数据中心维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (397,8,'','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3086,'数据中心维护','DataCenter:Maintenance',397) 
/
delete from HtmlLabelIndex where id=16889
/
delete from  HtmlLabelInfo where indexid= 16889
/
INSERT INTO HtmlLabelIndex values(16889,'日') 
/
INSERT INTO HtmlLabelInfo VALUES(16889,'日',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16889,'',8) 
/
delete from HtmlLabelIndex where id=16890
/
delete from  HtmlLabelInfo where indexid= 16890
/

INSERT INTO HtmlLabelIndex values(16890,'统计项维护') 
/
INSERT INTO HtmlLabelInfo VALUES(16890,'统计项维护',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16890,'',8) 
/

INSERT INTO HtmlLabelIndex values(16894,'按时间分列') 
/
INSERT INTO HtmlLabelInfo VALUES(16894,'按时间分列',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16894,'',8) 
/
delete from HtmlLabelIndex where id=16895
/
delete from  HtmlLabelInfo where indexid= 16895
/
delete from HtmlLabelIndex where id=16896
/
delete from  HtmlLabelInfo where indexid= 16896
/
INSERT INTO HtmlLabelIndex values(16895,'基层企业') 
/
INSERT INTO HtmlLabelInfo VALUES(16895,'基层企业',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16895,'',8) 
/
INSERT INTO HtmlLabelIndex values(16896,'取前') 
/
INSERT INTO HtmlLabelInfo VALUES(16896,'取前',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16896,'',8) 
/

delete from HtmlLabelIndex where id in (16901,16902,16903)
/
delete from  HtmlLabelInfo where indexid in (16901,16902,16903)
/
INSERT INTO HtmlLabelIndex values(16901,'统计图形') 
/
INSERT INTO HtmlLabelInfo VALUES(16901,'统计图形',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16901,'',8) 
/
INSERT INTO HtmlLabelIndex values(16902,'基层单位') 
/
INSERT INTO HtmlLabelInfo VALUES(16902,'基层单位',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16902,'',8) 
/
INSERT INTO HtmlLabelIndex values(16903,'横坐标') 
/
INSERT INTO HtmlLabelInfo VALUES(16903,'横坐标',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16903,'',8) 
/

delete from HtmlLabelIndex where id in (17028,17029)
/
delete from  HtmlLabelInfo where indexid in (17028,17029)
/
INSERT INTO HtmlLabelIndex values(17028,'上月') 
/
INSERT INTO HtmlLabelInfo VALUES(17028,'上月',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17028,'last month',8) 
/
INSERT INTO HtmlLabelIndex values(17029,'上年') 
/
INSERT INTO HtmlLabelInfo VALUES(17029,'上年',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17029,'last year',8) 
/
delete from HtmlLabelIndex where id in (17030,17031,17032)
/
delete from  HtmlLabelInfo where indexid in (17030,17031,17032)
/
INSERT INTO HtmlLabelIndex values(17030,'填报修正') 
/
INSERT INTO HtmlLabelInfo VALUES(17030,'填报修正',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17030,'Input modify',8) 
/
INSERT INTO HtmlLabelIndex values(17031,'月修正') 
/
INSERT INTO HtmlLabelInfo VALUES(17031,'月修正',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17031,'Monthly modify',8) 
/
INSERT INTO HtmlLabelIndex values(17032,'年修正') 
/
INSERT INTO HtmlLabelInfo VALUES(17032,'年修正',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17032,'Year modify',8) 
/

delete HtmlLabelIndex where id = 16538 
/
delete HtmlLabelInfo where indexid = 16538 
/
INSERT INTO HtmlLabelIndex values(16538,'明细报表') 
/
INSERT INTO HtmlLabelInfo VALUES(16538,'明细报表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16538,'Detail Report',8) 
/
delete HtmlLabelIndex where id = 17070 
/
delete HtmlLabelInfo where indexid = 17070 
/
INSERT INTO HtmlLabelIndex values(17070,'排序报表') 
/
INSERT INTO HtmlLabelInfo VALUES(17070,'排序报表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17070,'Ordinal Report',8) 
/

delete from HtmlLabelIndex where id=17496
/
delete from  HtmlLabelInfo where indexid= 17496
/

INSERT INTO HtmlLabelIndex values(17496,'模板设计') 
/
INSERT INTO HtmlLabelInfo VALUES(17496,'模板设计',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17496,'Mould Design',8) 
/

delete from HtmlLabelIndex where id=16892
/
delete from  HtmlLabelInfo where indexid= 16892
/
delete from HtmlLabelIndex where id=16893
/
delete from  HtmlLabelInfo where indexid= 16893
/
INSERT INTO HtmlLabelIndex values(16892,'报表统计项') 
/
INSERT INTO HtmlLabelInfo VALUES(16892,'报表统计项',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16892,'',8) 
/
INSERT INTO HtmlLabelIndex values(16893,'统计项') 
/
INSERT INTO HtmlLabelInfo VALUES(16893,'统计项',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16893,'',8) 
/
delete from HtmlLabelIndex where id=16894
/
delete from  HtmlLabelInfo where indexid= 16894
/
