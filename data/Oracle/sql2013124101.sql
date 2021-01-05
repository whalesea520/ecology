delete from HtmlLabelIndex where id=30480 
/
delete from HtmlLabelInfo where indexid=30480 
/
INSERT INTO HtmlLabelIndex values(30480,'科目所属部门') 
/
INSERT INTO HtmlLabelInfo VALUES(30480,'科目所属部门',7) 
/
INSERT INTO HtmlLabelInfo VALUES(30480,'The subjects their respective departments',8) 
/
INSERT INTO HtmlLabelInfo VALUES(30480,'科目所屬部門',9) 
/

delete from HtmlLabelIndex where id=32389 
/
delete from HtmlLabelInfo where indexid=32389 
/
INSERT INTO HtmlLabelIndex values(32389,'是否虚拟部门') 
/
INSERT INTO HtmlLabelInfo VALUES(32389,'是否虚拟部门',7) 
/
INSERT INTO HtmlLabelInfo VALUES(32389,'Is Virtual',8) 
/
INSERT INTO HtmlLabelInfo VALUES(32389,'是否虛拟部門',9) 
/
alter table FnaExpenseInfo add shareRequestId VARCHAR(200)
/