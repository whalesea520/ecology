update HtmlLabelIndex set indexDesc='室编件号' where id=19124
/

update HtmlLabelInfo  set labelName='室编件号' where indexId=19124 and languageId=7
/

update HtmlLabelInfo  set labelName='Room Code' where indexId=19124 and languageId=8
/
update HtmlLabelIndex set indexDesc='起止件号' where id=19128
/

update HtmlLabelInfo  set labelName='起止件号' where indexId=19128 and languageId=7
/

update HtmlLabelInfo  set labelName='BeginEnd Archival Code' where indexId=19128 and languageId=8
/

INSERT INTO HtmlLabelIndex values(19933,'借阅日期') 
/
INSERT INTO HtmlLabelInfo VALUES(19933,'借阅日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19933,'Borrow Date',8) 
/

INSERT INTO HtmlLabelIndex values(19942,'备考查询') 
/
INSERT INTO HtmlLabelInfo VALUES(19942,'备考查询',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19942,'For Reference Inquiry',8) 
/

INSERT INTO HtmlLabelIndex values(19963,'按文档目录') 
/
INSERT INTO HtmlLabelInfo VALUES(19963,'按文档目录',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19963,'By Catalog',8) 
/

delete from HtmlLabelIndex  where id=19689
/

delete from HtmlLabelInfo   where indexId=19689
/

INSERT INTO HtmlLabelIndex values(19689,'请先选择操作的记录！') 
/
INSERT INTO HtmlLabelInfo VALUES(19689,'请先选择操作的记录！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19689,'Please choose the operated record first!',8) 
/
delete from HtmlLabelIndex where id=18412
/
delete from HtmlLabelInfo where indexId=18412
/
INSERT INTO HtmlLabelIndex values(18412,'组合查询') 
/
INSERT INTO HtmlLabelInfo VALUES(18412,'组合查询',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18412,'Condition Search',8) 
/