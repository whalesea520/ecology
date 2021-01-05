delete from SystemRightDetail where rightid =2024
GO
delete from SystemRightsLanguage where id =2024
GO
delete from SystemRights where id =2024
GO
insert into SystemRights (id,rightdesc,righttype) values (2024,'已发生借款导入','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,7,'已发生借款导入','已发生借款导入') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,8,'Borrowed import','Borrowed import') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,9,'已發生借款導入','已發生借款導入') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,15,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43241,'已发生借款导入','BorroweImport:add',2024) 
GO



delete from HtmlLabelIndex where id=128759 
GO
delete from HtmlLabelInfo where indexid=128759 
GO
INSERT INTO HtmlLabelIndex values(128759,'已发生借款导入') 
GO
INSERT INTO HtmlLabelInfo VALUES(128759,'已发生借款导入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128759,'Borrowed import',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128759,'已發生借款導入',9) 
GO

delete from HtmlLabelIndex where id=128760 
GO
delete from HtmlLabelInfo where indexid=128760 
GO
INSERT INTO HtmlLabelIndex values(128760,'借款人') 
GO
INSERT INTO HtmlLabelInfo VALUES(128760,'借款人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128760,'Borrower',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128760,'借款人',9) 
GO

delete from HtmlLabelIndex where id=128761 
GO
delete from HtmlLabelInfo where indexid=128761 
GO
INSERT INTO HtmlLabelIndex values(128761,'借款人重复验证字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(128761,'借款人重复验证字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128761,'Borrower verification field',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128761,'借款人重複驗證字段',9) 
GO

delete from HtmlLabelIndex where id=128762 
GO
delete from HtmlLabelInfo where indexid=128762 
GO
INSERT INTO HtmlLabelIndex values(128762,'生成借款对应流程') 
GO
INSERT INTO HtmlLabelInfo VALUES(128762,'生成借款对应流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128762,'Generate loan correspondence process',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128762,'生成借款對應流程',9) 
GO

delete from HtmlLabelIndex where id=128763 
GO
delete from HtmlLabelInfo where indexid=128763 
GO
INSERT INTO HtmlLabelIndex values(128763,'借款人名称') 
GO
INSERT INTO HtmlLabelInfo VALUES(128763,'借款人名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128763,'Borrower name',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128763,'借款人名稱',9) 
GO

delete from HtmlLabelIndex where id=128764 
GO
delete from HtmlLabelInfo where indexid=128764 
GO
INSERT INTO HtmlLabelIndex values(128764,'借款人工号') 
GO
INSERT INTO HtmlLabelInfo VALUES(128764,'借款人工号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128764,'Loan number',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128764,'借款人工号',9) 
GO

delete from HtmlLabelIndex where id=128765 
GO
delete from HtmlLabelInfo where indexid=128765 
GO
INSERT INTO HtmlLabelIndex values(128765,'借款类型') 
GO
INSERT INTO HtmlLabelInfo VALUES(128765,'借款类型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128765,'Loan type',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128765,'借款類型',9) 
GO

delete from HtmlLabelIndex where id=128766 
GO
delete from HtmlLabelInfo where indexid=128766 
GO
INSERT INTO HtmlLabelIndex values(128766,'借款额度') 
GO
INSERT INTO HtmlLabelInfo VALUES(128766,'借款额度',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128766,'Loan amount',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128766,'借款額度',9) 
GO

delete from HtmlLabelIndex where id=128767 
GO
delete from HtmlLabelInfo where indexid=128767 
GO
INSERT INTO HtmlLabelIndex values(128767,'借款类型只能是：0、1') 
GO
INSERT INTO HtmlLabelInfo VALUES(128767,'借款类型只能是：0、1',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128767,'The type of loan can only be: 0, 1',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128767,'借款類型隻能是：0、1',9) 
GO

delete from HtmlLabelIndex where id=128768 
GO
delete from HtmlLabelInfo where indexid=128768 
GO
INSERT INTO HtmlLabelIndex values(128768,'填写不正确') 
GO
INSERT INTO HtmlLabelInfo VALUES(128768,'填写不正确',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128768,'Fill is not correct',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128768,'填寫不正确',9) 
GO

delete from HtmlLabelIndex where id=128774 
GO
delete from HtmlLabelInfo where indexid=128774 
GO
INSERT INTO HtmlLabelIndex values(128774,'关联流程不是借款流程，请重新关联！') 
GO
INSERT INTO HtmlLabelInfo VALUES(128774,'关联流程不是借款流程，请重新关联！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128774,'The associated process is not a borrowing process!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128774,'關聯流程不是借款流程，請重新關聯！',9) 
GO

delete from HtmlLabelIndex where id=128776 
GO
delete from HtmlLabelInfo where indexid=128776 
GO
INSERT INTO HtmlLabelIndex values(128776,'借款类型只能是：个人借款、公务借款') 
GO
INSERT INTO HtmlLabelInfo VALUES(128776,'借款类型只能是：个人借款、公务借款',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128776,'The type of loan can only be: personal loans, business loans',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128776,'借款類型隻能是：個人借款、公務借款',9) 
GO