delete from SystemRightDetail where rightid =2022
/
delete from SystemRightsLanguage where id =2022
/
delete from SystemRights where id =2022
/
insert into SystemRights (id,rightdesc,righttype) values (2022,'��Ա���ֲ鿴','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2022,9,'�ɆT�u�ֲ鿴','�ɆT�u�ֲ鿴') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2022,7,'��Ա���ֲ鿴','��Ա���ֲ鿴') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2022,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2022,15,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2022,8,'View member ratings','View member ratings') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2022,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2022,12,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43239,'��Ա���ֲ鿴','workflow_ratingview',2022) 
/


delete from HtmlLabelIndex where id=128664 
/
delete from HtmlLabelInfo where indexid=128664 
/
INSERT INTO HtmlLabelIndex values(128664,'�ŵ�') 
/
INSERT INTO HtmlLabelInfo VALUES(128664,'�ŵ�',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128664,'Advantage',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128664,'���c',9) 
/

delete from HtmlLabelIndex where id=128665 
/
delete from HtmlLabelInfo where indexid=128665 
/
INSERT INTO HtmlLabelIndex values(128665,'ȱ��') 
/
INSERT INTO HtmlLabelInfo VALUES(128665,'ȱ��',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128665,'Shortcoming',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128665,'ȱ�c',9) 
/

delete from HtmlLabelIndex where id=128666 
/
delete from HtmlLabelInfo where indexid=128666 
/
INSERT INTO HtmlLabelIndex values(128666,'�Ľ�����') 
/
INSERT INTO HtmlLabelInfo VALUES(128666,'�Ľ�����',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128666,'Improvement suggestions',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128666,'���M���h',9) 
/

delete from HtmlLabelIndex where id=128691 
/
delete from HtmlLabelInfo where indexid=128691 
/
INSERT INTO HtmlLabelIndex values(128691,'������������') 
/
INSERT INTO HtmlLabelInfo VALUES(128691,'������������',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128691,'Name of the person being evaluated',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128691,'���u��������',9) 
/