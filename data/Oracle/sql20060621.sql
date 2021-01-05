INSERT INTO HtmlLabelIndex values(19314,'资产导入') 
/
INSERT INTO HtmlLabelInfo VALUES(19314,'资产导入',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19314,'capital auto loading',8) 
/
INSERT INTO HtmlLabelIndex values(19316,'服务器正在处理资产导入，请稍等...') 
/
INSERT INTO HtmlLabelIndex values(19317,'资产导入成功！') 
/
INSERT INTO HtmlLabelInfo VALUES(19316,'服务器正在处理资产导入，请稍等...',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19316,'capital loading,please wait...',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19317,'资产导入成功！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19317,'capital load success!',8) 
/
INSERT INTO HtmlLabelIndex values(19320,'资产资料导入') 
/
INSERT INTO HtmlLabelInfo VALUES(19320,'资产资料导入',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19320,'capital type load',8) 
/
INSERT INTO HtmlLabelIndex values(19322,'资产资料编号') 
/
INSERT INTO HtmlLabelInfo VALUES(19322,'资产资料编号',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19322,'capital type no',8) 
/
INSERT INTO HtmlLabelIndex values(19326,'资产资料导入成功！') 
/
INSERT INTO HtmlLabelInfo VALUES(19326,'资产资料导入成功！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19326,'capital type load success!',8) 
/

INSERT INTO HtmlLabelIndex values(19364,'服务器正在处理资产资料导入，请稍等...') 
/
INSERT INTO HtmlLabelInfo VALUES(19364,'服务器正在处理资产资料导入，请稍等...',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19364,'capital type loading,please wait...',8) 
/

INSERT INTO HtmlLabelIndex values(17342,'入库单价') 
/
INSERT INTO HtmlLabelInfo VALUES(17342,'入库单价',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17342,'',8) 
/


call MMConfig_U_ByInfoInsert (8,4)
/
call MMInfo_Insert (511,19320,'资产资料导入','/cpt/capital/CapitalExcelToDB.jsp','mainFrame',8,1,4,0,'',1,'Capital:Maintenance',0,'','',0,'','',7)
/

ALTER TABLE cptcapital rename column capitalnum to capitalnumtemp
/
ALTER TABLE cptcapital add capitalnum number(18,1)
/
update  cptcapital set capitalnum = capitalnumtemp
/
ALTER TABLE cptcapital drop column capitalnumtemp
/


