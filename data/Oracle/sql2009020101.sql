delete from SystemRights where id = 816
/
delete from SystemRightsLanguage where id = 816
/
delete from SystemRightDetail where id = 4327
/
insert into SystemRights (id,rightdesc,righttype) values (816,'外部XML报表权限','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (816,8,'Xml Report Role','Xml Report Role') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (816,7,'外部XML报表权限','外部XML报表权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (816,9,'外部XML報表權限','外部XML報表權限') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4327,'XML报表共享设置','XmlReportSetting:Edit',816) 
/

delete from HtmlLabelIndex where id=22375 
/
delete from HtmlLabelInfo where indexid=22375 
/
INSERT INTO HtmlLabelIndex values(22375,'报表类型') 
/
INSERT INTO HtmlLabelInfo VALUES(22375,'报表类型',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22375,'Report Type',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22375,'報表類型',9) 
/

delete from HtmlLabelIndex where id=22376 
/
delete from HtmlLabelInfo where indexid=22376 
/
INSERT INTO HtmlLabelIndex values(22376,'报表日期') 
/
INSERT INTO HtmlLabelInfo VALUES(22376,'报表日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22376,'Report Date',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22376,'報表日期',9) 
/

delete from HtmlLabelIndex where id=22377 
/
delete from HtmlLabelInfo where indexid=22377 
/
INSERT INTO HtmlLabelIndex values(22377,'外部XML报表') 
/
INSERT INTO HtmlLabelInfo VALUES(22377,'外部XML报表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22377,'Xml Report Outside',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22377,'外部XML報表',9) 
/

delete from HtmlLabelIndex where id=22378 
/
delete from HtmlLabelInfo where indexid=22378 
/
INSERT INTO HtmlLabelIndex values(22378,'季报') 
/
INSERT INTO HtmlLabelInfo VALUES(22378,'季报',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22378,'Season Report',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22378,'季報',9) 
/

delete from HtmlLabelIndex where id=22379 
/
delete from HtmlLabelInfo where indexid=22379 
/
INSERT INTO HtmlLabelIndex values(22379,'半年报') 
/
INSERT INTO HtmlLabelInfo VALUES(22379,'半年报',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22379,'semiyearly',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22379,'半年報',9) 
/

delete from HtmlLabelIndex where id=22383 
/
delete from HtmlLabelInfo where indexid=22383 
/
INSERT INTO HtmlLabelIndex values(22383,'配置文件错误') 
/
INSERT INTO HtmlLabelInfo VALUES(22383,'配置文件错误',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22383,'Setting Error',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22383,'配置文件錯誤',9) 
/

delete from HtmlLabelIndex where id=22384 
/
delete from HtmlLabelInfo where indexid=22384 
/
INSERT INTO HtmlLabelIndex values(22384,'请选择报表名称') 
/
INSERT INTO HtmlLabelInfo VALUES(22384,'请选择报表名称',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22384,'Please select a report name',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22384,'請選擇報表名稱',9) 
/

delete from HtmlLabelIndex where id=22385 
/
delete from HtmlLabelInfo where indexid=22385 
/
INSERT INTO HtmlLabelIndex values(22385,'报表前缀') 
/
INSERT INTO HtmlLabelInfo VALUES(22385,'报表前缀',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22385,'File Flag',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22385,'報表前綴',9) 
/
