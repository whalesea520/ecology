delete from SystemRightDetail where rightid =2011
/
delete from SystemRightsLanguage where id =2011
/
delete from SystemRights where id =2011
/
insert into SystemRights (id,rightdesc,righttype) values (2011,'�ɹ�Ȩ��','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,9,'�ɹ�����','�ɹ�����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,7,'�ɹ�Ȩ��','�ɹ�Ȩ��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,8,'Dispatching authority','Dispatching authority') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,15,'','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43229,'�ɹ�Ȩ��','workflow:Dispatching',2011) 
/


delete from HtmlLabelIndex where id=128468 
/
delete from HtmlLabelInfo where indexid=128468 
/
INSERT INTO HtmlLabelIndex values(128468,'�ֶ�') 
/
INSERT INTO HtmlLabelInfo VALUES(128468,'�ֶ�',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128468,'Manually',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128468,'�ք�',9) 
/

delete from HtmlLabelIndex where id=128469 
/
delete from HtmlLabelInfo where indexid=128469 
/
INSERT INTO HtmlLabelIndex values(128469,'�ɹ�') 
/
INSERT INTO HtmlLabelInfo VALUES(128469,'�ɹ�',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128469,'Dispatching',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128469,'�ɹ�',9) 
/