delete from HtmlLabelIndex where id=81869 
/
delete from HtmlLabelInfo where indexid=81869 
/
INSERT INTO HtmlLabelIndex values(81869,'已经被使用') 
/
INSERT INTO HtmlLabelInfo VALUES(81869,'已经被使用',7) 
/
INSERT INTO HtmlLabelInfo VALUES(81869,'has been used',8) 
/
INSERT INTO HtmlLabelInfo VALUES(81869,'已經被使用',9) 
/

delete from HtmlLabelIndex where id=127156 
/
delete from HtmlLabelInfo where indexid=127156 
/
INSERT INTO HtmlLabelIndex values(127156,'异构系统注册') 
/
delete from HtmlLabelIndex where id=127157 
/
delete from HtmlLabelInfo where indexid=127157 
/
INSERT INTO HtmlLabelIndex values(127157,'流程类型注册') 
/
INSERT INTO HtmlLabelInfo VALUES(127157,'流程类型注册',7) 
/
INSERT INTO HtmlLabelInfo VALUES(127157,'Flow type registration',8) 
/
INSERT INTO HtmlLabelInfo VALUES(127157,'流程類型注册',9) 
/
INSERT INTO HtmlLabelInfo VALUES(127156,'异构系统注册',7) 
/
INSERT INTO HtmlLabelInfo VALUES(127156,'Heterogeneous system registration',8) 
/
INSERT INTO HtmlLabelInfo VALUES(127156,'異構系統注册',9) 
/

delete from SystemLogItem where itemid='164'
/
insert into SystemLogItem(itemid,lableid,itemdesc,typeid) values('164','127156','异构系统注册','0')
/

delete from SystemLogItem where itemid='165'
/
insert into SystemLogItem(itemid,lableid,itemdesc,typeid) values('165','127157','流程类型注册','0')
/