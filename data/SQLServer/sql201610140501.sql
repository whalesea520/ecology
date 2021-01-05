delete from SystemRightDetail where rightid =2024
GO
delete from SystemRightsLanguage where id =2024
GO
delete from SystemRights where id =2024
GO
insert into SystemRights (id,rightdesc,righttype) values (2024,'�ѷ�������','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,7,'�ѷ�������','�ѷ�������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,8,'Borrowed import','Borrowed import') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,9,'�Ѱl������','�Ѱl������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,15,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43241,'�ѷ�������','BorroweImport:add',2024) 
GO



delete from HtmlLabelIndex where id=128759 
GO
delete from HtmlLabelInfo where indexid=128759 
GO
INSERT INTO HtmlLabelIndex values(128759,'�ѷ�������') 
GO
INSERT INTO HtmlLabelInfo VALUES(128759,'�ѷ�������',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128759,'Borrowed import',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128759,'�Ѱl������',9) 
GO

delete from HtmlLabelIndex where id=128760 
GO
delete from HtmlLabelInfo where indexid=128760 
GO
INSERT INTO HtmlLabelIndex values(128760,'�����') 
GO
INSERT INTO HtmlLabelInfo VALUES(128760,'�����',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128760,'Borrower',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128760,'�����',9) 
GO

delete from HtmlLabelIndex where id=128761 
GO
delete from HtmlLabelInfo where indexid=128761 
GO
INSERT INTO HtmlLabelIndex values(128761,'������ظ���֤�ֶ�') 
GO
INSERT INTO HtmlLabelInfo VALUES(128761,'������ظ���֤�ֶ�',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128761,'Borrower verification field',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128761,'��������}��C�ֶ�',9) 
GO

delete from HtmlLabelIndex where id=128762 
GO
delete from HtmlLabelInfo where indexid=128762 
GO
INSERT INTO HtmlLabelIndex values(128762,'���ɽ���Ӧ����') 
GO
INSERT INTO HtmlLabelInfo VALUES(128762,'���ɽ���Ӧ����',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128762,'Generate loan correspondence process',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128762,'���ɽ�������',9) 
GO

delete from HtmlLabelIndex where id=128763 
GO
delete from HtmlLabelInfo where indexid=128763 
GO
INSERT INTO HtmlLabelIndex values(128763,'���������') 
GO
INSERT INTO HtmlLabelInfo VALUES(128763,'���������',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128763,'Borrower name',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128763,'��������Q',9) 
GO

delete from HtmlLabelIndex where id=128764 
GO
delete from HtmlLabelInfo where indexid=128764 
GO
INSERT INTO HtmlLabelIndex values(128764,'����˹���') 
GO
INSERT INTO HtmlLabelInfo VALUES(128764,'����˹���',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128764,'Loan number',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128764,'����˹���',9) 
GO

delete from HtmlLabelIndex where id=128765 
GO
delete from HtmlLabelInfo where indexid=128765 
GO
INSERT INTO HtmlLabelIndex values(128765,'�������') 
GO
INSERT INTO HtmlLabelInfo VALUES(128765,'�������',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128765,'Loan type',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128765,'������',9) 
GO

delete from HtmlLabelIndex where id=128766 
GO
delete from HtmlLabelInfo where indexid=128766 
GO
INSERT INTO HtmlLabelIndex values(128766,'�����') 
GO
INSERT INTO HtmlLabelInfo VALUES(128766,'�����',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128766,'Loan amount',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128766,'����~��',9) 
GO

delete from HtmlLabelIndex where id=128767 
GO
delete from HtmlLabelInfo where indexid=128767 
GO
INSERT INTO HtmlLabelIndex values(128767,'�������ֻ���ǣ�0��1') 
GO
INSERT INTO HtmlLabelInfo VALUES(128767,'�������ֻ���ǣ�0��1',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128767,'The type of loan can only be: 0, 1',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128767,'�������b���ǣ�0��1',9) 
GO

delete from HtmlLabelIndex where id=128768 
GO
delete from HtmlLabelInfo where indexid=128768 
GO
INSERT INTO HtmlLabelIndex values(128768,'��д����ȷ') 
GO
INSERT INTO HtmlLabelInfo VALUES(128768,'��д����ȷ',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128768,'Fill is not correct',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128768,'�����ȷ',9) 
GO

delete from HtmlLabelIndex where id=128774 
GO
delete from HtmlLabelInfo where indexid=128774 
GO
INSERT INTO HtmlLabelIndex values(128774,'�������̲��ǽ�����̣������¹�����') 
GO
INSERT INTO HtmlLabelInfo VALUES(128774,'�������̲��ǽ�����̣������¹�����',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128774,'The associated process is not a borrowing process!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128774,'�P���̲��ǽ�����̣�Ո�����P��',9) 
GO

delete from HtmlLabelIndex where id=128776 
GO
delete from HtmlLabelInfo where indexid=128776 
GO
INSERT INTO HtmlLabelIndex values(128776,'�������ֻ���ǣ����˽�������') 
GO
INSERT INTO HtmlLabelInfo VALUES(128776,'�������ֻ���ǣ����˽�������',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128776,'The type of loan can only be: personal loans, business loans',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128776,'�������b���ǣ����˽����ս��',9) 
GO