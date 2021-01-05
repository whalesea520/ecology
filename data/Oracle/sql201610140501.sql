delete from SystemRightDetail where rightid =2024
/
delete from SystemRightsLanguage where id =2024
/
delete from SystemRights where id =2024
/
insert into SystemRights (id,rightdesc,righttype) values (2024,'已发生借款导入','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,7,'已发生借款导入','已发生借款导入') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,8,'Borrowed import','Borrowed import') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,9,'已發生借款導入','已發生借款導入') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,15,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43241,'已发生借款导入','BorroweImport:add',2024) 
/



delete from HtmlLabelIndex where id=128759 
/
delete from HtmlLabelInfo where indexid=128759 
/
INSERT INTO HtmlLabelIndex values(128759,'已发生借款导入') 
/
INSERT INTO HtmlLabelInfo VALUES(128759,'已发生借款导入',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128759,'Borrowed import',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128759,'已發生借款導入',9) 
/

delete from HtmlLabelIndex where id=128760 
/
delete from HtmlLabelInfo where indexid=128760 
/
INSERT INTO HtmlLabelIndex values(128760,'借款人') 
/
INSERT INTO HtmlLabelInfo VALUES(128760,'借款人',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128760,'Borrower',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128760,'借款人',9) 
/

delete from HtmlLabelIndex where id=128761 
/
delete from HtmlLabelInfo where indexid=128761 
/
INSERT INTO HtmlLabelIndex values(128761,'借款人重复验证字段') 
/
INSERT INTO HtmlLabelInfo VALUES(128761,'借款人重复验证字段',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128761,'Borrower verification field',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128761,'借款人重複驗證字段',9) 
/

delete from HtmlLabelIndex where id=128762 
/
delete from HtmlLabelInfo where indexid=128762 
/
INSERT INTO HtmlLabelIndex values(128762,'生成借款对应流程') 
/
INSERT INTO HtmlLabelInfo VALUES(128762,'生成借款对应流程',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128762,'Generate loan correspondence process',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128762,'生成借款對應流程',9) 
/

delete from HtmlLabelIndex where id=128763 
/
delete from HtmlLabelInfo where indexid=128763 
/
INSERT INTO HtmlLabelIndex values(128763,'借款人名称') 
/
INSERT INTO HtmlLabelInfo VALUES(128763,'借款人名称',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128763,'Borrower name',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128763,'借款人名稱',9) 
/

delete from HtmlLabelIndex where id=128764 
/
delete from HtmlLabelInfo where indexid=128764 
/
INSERT INTO HtmlLabelIndex values(128764,'借款人工号') 
/
INSERT INTO HtmlLabelInfo VALUES(128764,'借款人工号',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128764,'Loan number',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128764,'借款人工号',9) 
/

delete from HtmlLabelIndex where id=128765 
/
delete from HtmlLabelInfo where indexid=128765 
/
INSERT INTO HtmlLabelIndex values(128765,'借款类型') 
/
INSERT INTO HtmlLabelInfo VALUES(128765,'借款类型',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128765,'Loan type',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128765,'借款類型',9) 
/

delete from HtmlLabelIndex where id=128766 
/
delete from HtmlLabelInfo where indexid=128766 
/
INSERT INTO HtmlLabelIndex values(128766,'借款额度') 
/
INSERT INTO HtmlLabelInfo VALUES(128766,'借款额度',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128766,'Loan amount',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128766,'借款額度',9) 
/

delete from HtmlLabelIndex where id=128767 
/
delete from HtmlLabelInfo where indexid=128767 
/
INSERT INTO HtmlLabelIndex values(128767,'借款类型只能是：0、1') 
/
INSERT INTO HtmlLabelInfo VALUES(128767,'借款类型只能是：0、1',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128767,'The type of loan can only be: 0, 1',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128767,'借款類型隻能是：0、1',9) 
/

delete from HtmlLabelIndex where id=128768 
/
delete from HtmlLabelInfo where indexid=128768 
/
INSERT INTO HtmlLabelIndex values(128768,'填写不正确') 
/
INSERT INTO HtmlLabelInfo VALUES(128768,'填写不正确',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128768,'Fill is not correct',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128768,'填寫不正确',9) 
/

delete from HtmlLabelIndex where id=128774 
/
delete from HtmlLabelInfo where indexid=128774 
/
INSERT INTO HtmlLabelIndex values(128774,'关联流程不是借款流程，请重新关联！') 
/
INSERT INTO HtmlLabelInfo VALUES(128774,'关联流程不是借款流程，请重新关联！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128774,'The associated process is not a borrowing process!',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128774,'關聯流程不是借款流程，請重新關聯！',9) 
/

delete from HtmlLabelIndex where id=128776 
/
delete from HtmlLabelInfo where indexid=128776 
/
INSERT INTO HtmlLabelIndex values(128776,'借款类型只能是：个人借款、公务借款') 
/
INSERT INTO HtmlLabelInfo VALUES(128776,'借款类型只能是：个人借款、公务借款',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128776,'The type of loan can only be: personal loans, business loans',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128776,'借款類型隻能是：個人借款、公務借款',9) 
/