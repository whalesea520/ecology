delete from HtmlLabelIndex where id=32948 
/
delete from HtmlLabelInfo where indexid=32948 
/
INSERT INTO HtmlLabelIndex values(32948,'�ʼ�����') 
/
INSERT INTO HtmlLabelInfo VALUES(32948,'�ʼ�����',7) 
/
INSERT INTO HtmlLabelInfo VALUES(32948,'Email reports',8) 
/
INSERT INTO HtmlLabelInfo VALUES(32948,'�]�����',9) 
/

delete from SystemRightDetail where rightid =1642
/
delete from SystemRightsLanguage where id =1642
/
delete from SystemRights where id =1642
/
insert into SystemRights (id,rightdesc,righttype) values (1642,'�ʼ�����','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1642,8,'Email reports','Email reports') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1642,7,'�ʼ�����','�ʼ�����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1642,9,'�]�����','�]�����') 
/

delete from SystemRightDetail where rightid =1642
/
delete from SystemRightsLanguage where id =1642
/
delete from SystemRights where id =1642
/
insert into SystemRights (id,rightdesc,righttype) values (1642,'�ʼ�����Ȩ��','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1642,8,'Email reports','Email reports') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1642,7,'�ʼ�����Ȩ��','�ʼ�����Ȩ��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1642,9,'�]��������','�]��������') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42874,'�ʼ�����Ȩ��','email:report',1642) 
/