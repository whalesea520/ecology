delete from SystemRightDetail where rightid =2024
/
delete from SystemRightsLanguage where id =2024
/
delete from SystemRights where id =2024
/
insert into SystemRights (id,rightdesc,righttype) values (2024,'�ѷ�������','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,7,'�ѷ�������','�ѷ�������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,8,'Borrowed import','Borrowed import') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,9,'�Ѱl������','�Ѱl������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2024,15,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43241,'�ѷ�������','BorroweImport:add',2024) 
/



delete from HtmlLabelIndex where id=128759 
/
delete from HtmlLabelInfo where indexid=128759 
/
INSERT INTO HtmlLabelIndex values(128759,'�ѷ�������') 
/
INSERT INTO HtmlLabelInfo VALUES(128759,'�ѷ�������',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128759,'Borrowed import',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128759,'�Ѱl������',9) 
/

delete from HtmlLabelIndex where id=128760 
/
delete from HtmlLabelInfo where indexid=128760 
/
INSERT INTO HtmlLabelIndex values(128760,'�����') 
/
INSERT INTO HtmlLabelInfo VALUES(128760,'�����',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128760,'Borrower',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128760,'�����',9) 
/

delete from HtmlLabelIndex where id=128761 
/
delete from HtmlLabelInfo where indexid=128761 
/
INSERT INTO HtmlLabelIndex values(128761,'������ظ���֤�ֶ�') 
/
INSERT INTO HtmlLabelInfo VALUES(128761,'������ظ���֤�ֶ�',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128761,'Borrower verification field',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128761,'��������}��C�ֶ�',9) 
/

delete from HtmlLabelIndex where id=128762 
/
delete from HtmlLabelInfo where indexid=128762 
/
INSERT INTO HtmlLabelIndex values(128762,'���ɽ���Ӧ����') 
/
INSERT INTO HtmlLabelInfo VALUES(128762,'���ɽ���Ӧ����',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128762,'Generate loan correspondence process',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128762,'���ɽ�������',9) 
/

delete from HtmlLabelIndex where id=128763 
/
delete from HtmlLabelInfo where indexid=128763 
/
INSERT INTO HtmlLabelIndex values(128763,'���������') 
/
INSERT INTO HtmlLabelInfo VALUES(128763,'���������',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128763,'Borrower name',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128763,'��������Q',9) 
/

delete from HtmlLabelIndex where id=128764 
/
delete from HtmlLabelInfo where indexid=128764 
/
INSERT INTO HtmlLabelIndex values(128764,'����˹���') 
/
INSERT INTO HtmlLabelInfo VALUES(128764,'����˹���',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128764,'Loan number',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128764,'����˹���',9) 
/

delete from HtmlLabelIndex where id=128765 
/
delete from HtmlLabelInfo where indexid=128765 
/
INSERT INTO HtmlLabelIndex values(128765,'�������') 
/
INSERT INTO HtmlLabelInfo VALUES(128765,'�������',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128765,'Loan type',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128765,'������',9) 
/

delete from HtmlLabelIndex where id=128766 
/
delete from HtmlLabelInfo where indexid=128766 
/
INSERT INTO HtmlLabelIndex values(128766,'�����') 
/
INSERT INTO HtmlLabelInfo VALUES(128766,'�����',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128766,'Loan amount',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128766,'����~��',9) 
/

delete from HtmlLabelIndex where id=128767 
/
delete from HtmlLabelInfo where indexid=128767 
/
INSERT INTO HtmlLabelIndex values(128767,'�������ֻ���ǣ�0��1') 
/
INSERT INTO HtmlLabelInfo VALUES(128767,'�������ֻ���ǣ�0��1',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128767,'The type of loan can only be: 0, 1',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128767,'�������b���ǣ�0��1',9) 
/

delete from HtmlLabelIndex where id=128768 
/
delete from HtmlLabelInfo where indexid=128768 
/
INSERT INTO HtmlLabelIndex values(128768,'��д����ȷ') 
/
INSERT INTO HtmlLabelInfo VALUES(128768,'��д����ȷ',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128768,'Fill is not correct',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128768,'�����ȷ',9) 
/

delete from HtmlLabelIndex where id=128774 
/
delete from HtmlLabelInfo where indexid=128774 
/
INSERT INTO HtmlLabelIndex values(128774,'�������̲��ǽ�����̣������¹�����') 
/
INSERT INTO HtmlLabelInfo VALUES(128774,'�������̲��ǽ�����̣������¹�����',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128774,'The associated process is not a borrowing process!',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128774,'�P���̲��ǽ�����̣�Ո�����P��',9) 
/

delete from HtmlLabelIndex where id=128776 
/
delete from HtmlLabelInfo where indexid=128776 
/
INSERT INTO HtmlLabelIndex values(128776,'�������ֻ���ǣ����˽�������') 
/
INSERT INTO HtmlLabelInfo VALUES(128776,'�������ֻ���ǣ����˽�������',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128776,'The type of loan can only be: personal loans, business loans',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128776,'�������b���ǣ����˽����ս��',9) 
/