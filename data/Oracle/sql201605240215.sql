delete from SystemRightDetail where rightid =1974
/
delete from SystemRightsLanguage where id =1974
/
delete from SystemRights where id =1974
/
insert into SystemRights (id,rightdesc,righttype) values (1974,'ͳһ�������ļ���','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,7,'ͳһ�������ļ���','ͳһ�������ļ���') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,8,'Unified to-do center integration','Unified to-do center integration') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,9,'�yҼ���k���ļ���','�yҼ���k���ļ���') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,15,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43192,'ͳһ�������ļ���','ofs:ofssetting',1974) 
/

delete from HtmlLabelIndex where id=127060 
/
delete from HtmlLabelInfo where indexid=127060 
/
INSERT INTO HtmlLabelIndex values(127060,'ͳһ����⼯��') 
/
INSERT INTO HtmlLabelInfo VALUES(127060,'ͳһ����⼯��',7) 
/
INSERT INTO HtmlLabelInfo VALUES(127060,'Unified agent library integration',8) 
/
INSERT INTO HtmlLabelInfo VALUES(127060,'�yҼ���k�켯��',9) 
/

delete from HtmlLabelIndex where id=127357 
/
delete from HtmlLabelInfo where indexid=127357 
/
INSERT INTO HtmlLabelIndex values(127357,'ͳһ�������ļ���') 
/
INSERT INTO HtmlLabelInfo VALUES(127357,'ͳһ�������ļ���',7) 
/
INSERT INTO HtmlLabelInfo VALUES(127357,'Unified to-do center integration',8) 
/
INSERT INTO HtmlLabelInfo VALUES(127357,'�yҼ���k���ļ���',9) 
/

Delete from MainMenuInfo where id=10284
/
call MMConfig_U_ByInfoInsert (10110,19)
/
call MMInfo_Insert (10284,127357,'ͳһ�������ļ���','/integration/integrationTab.jsp?urlType=101','mainFrame',10110,2,19,0,'',0,'',0,'','',0,'','',9)
/

delete from HtmlLabelIndex where id=127233 
/
delete from HtmlLabelInfo where indexid=127233 
/
INSERT INTO HtmlLabelIndex values(127233,'��ʶ�Ѿ�ʹ��!') 
/
delete from HtmlLabelIndex where id=127234 
/
delete from HtmlLabelInfo where indexid=127234 
/
INSERT INTO HtmlLabelIndex values(127234,'����Ѿ�ʹ��!') 
/
delete from HtmlLabelIndex where id=127235 
/
delete from HtmlLabelInfo where indexid=127235 
/
INSERT INTO HtmlLabelIndex values(127235,'ȫ���Ѿ�ʹ��!') 
/
INSERT INTO HtmlLabelInfo VALUES(127235,'ȫ���Ѿ�ʹ��!',7) 
/
INSERT INTO HtmlLabelInfo VALUES(127235,'Full name already in use!',8) 
/
INSERT INTO HtmlLabelInfo VALUES(127235,'ȫ�Q�ѽ�ʹ�ã�',9) 
/
INSERT INTO HtmlLabelInfo VALUES(127234,'����Ѿ�ʹ��!',7) 
/
INSERT INTO HtmlLabelInfo VALUES(127234,'Have been used for short!',8) 
/
INSERT INTO HtmlLabelInfo VALUES(127234,'���Q�ѽ�ʹ�ã�',9) 
/
INSERT INTO HtmlLabelInfo VALUES(127233,'��ʶ�Ѿ�ʹ��!',7) 
/
INSERT INTO HtmlLabelInfo VALUES(127233,'Logo has been used!',8) 
/
INSERT INTO HtmlLabelInfo VALUES(127233,'���R�ѽ�ʹ�ã�',9) 
/

delete from HtmlLabelIndex where id=127412 
/
delete from HtmlLabelInfo where indexid=127412 
/
INSERT INTO HtmlLabelIndex values(127412,'�칹ϵͳ��������') 
/
INSERT INTO HtmlLabelInfo VALUES(127412,'�칹ϵͳ��������',7) 
/
INSERT INTO HtmlLabelInfo VALUES(127412,'Heterogeneous system workflow data',8) 
/
INSERT INTO HtmlLabelInfo VALUES(127412,'����ϵ�y���̔���',9) 
/


delete from SystemLogItem where itemid ='168'
/
insert into SystemLogItem(itemid,lableid,itemdesc,typeid) values('168','127412','�칹ϵͳ��������','')
/