delete from SystemRightDetail where rightid =1974
GO
delete from SystemRightsLanguage where id =1974
GO
delete from SystemRights where id =1974
GO
insert into SystemRights (id,rightdesc,righttype) values (1974,'ͳһ�������ļ���','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,7,'ͳһ�������ļ���','ͳһ�������ļ���') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,8,'Unified to-do center integration','Unified to-do center integration') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,9,'�yҼ���k���ļ���','�yҼ���k���ļ���') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,15,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43192,'ͳһ�������ļ���','ofs:ofssetting',1974) 
GO

delete from HtmlLabelIndex where id=127060 
GO
delete from HtmlLabelInfo where indexid=127060 
GO
INSERT INTO HtmlLabelIndex values(127060,'ͳһ����⼯��') 
GO
INSERT INTO HtmlLabelInfo VALUES(127060,'ͳһ����⼯��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127060,'Unified agent library integration',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127060,'�yҼ���k�켯��',9) 
GO

delete from HtmlLabelIndex where id=127357 
GO
delete from HtmlLabelInfo where indexid=127357 
GO
INSERT INTO HtmlLabelIndex values(127357,'ͳһ�������ļ���') 
GO
INSERT INTO HtmlLabelInfo VALUES(127357,'ͳһ�������ļ���',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127357,'Unified to-do center integration',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127357,'�yҼ���k���ļ���',9) 
GO

Delete from MainMenuInfo where id=10284
GO
EXECUTE MMConfig_U_ByInfoInsert 10110,19
GO
EXECUTE MMInfo_Insert 10284,127357,'ͳһ�������ļ���','/integration/integrationTab.jsp?urlType=101','mainFrame',10110,2,19,0,'',0,'',0,'','',0,'','',9
GO

delete from HtmlLabelIndex where id=127233 
GO
delete from HtmlLabelInfo where indexid=127233 
GO
INSERT INTO HtmlLabelIndex values(127233,'��ʶ�Ѿ�ʹ��!') 
GO
delete from HtmlLabelIndex where id=127234 
GO
delete from HtmlLabelInfo where indexid=127234 
GO
INSERT INTO HtmlLabelIndex values(127234,'����Ѿ�ʹ��!') 
GO
delete from HtmlLabelIndex where id=127235 
GO
delete from HtmlLabelInfo where indexid=127235 
GO
INSERT INTO HtmlLabelIndex values(127235,'ȫ���Ѿ�ʹ��!') 
GO
INSERT INTO HtmlLabelInfo VALUES(127235,'ȫ���Ѿ�ʹ��!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127235,'Full name already in use!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127235,'ȫ�Q�ѽ�ʹ�ã�',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(127234,'����Ѿ�ʹ��!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127234,'Have been used for short!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127234,'���Q�ѽ�ʹ�ã�',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(127233,'��ʶ�Ѿ�ʹ��!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127233,'Logo has been used!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127233,'���R�ѽ�ʹ�ã�',9) 
GO

delete from HtmlLabelIndex where id=127412 
GO
delete from HtmlLabelInfo where indexid=127412 
GO
INSERT INTO HtmlLabelIndex values(127412,'�칹ϵͳ��������') 
GO
INSERT INTO HtmlLabelInfo VALUES(127412,'�칹ϵͳ��������',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127412,'Heterogeneous system workflow data',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127412,'����ϵ�y���̔���',9) 
GO


delete from SystemLogItem where itemid ='168'
GO
insert into SystemLogItem(itemid,lableid,itemdesc,typeid) values('168','127412','�칹ϵͳ��������','')
GO