delete from SystemRightDetail where rightid =1974
GO
delete from SystemRightsLanguage where id =1974
GO
delete from SystemRights where id =1974
GO
insert into SystemRights (id,rightdesc,righttype) values (1974,'统一待办中心集成','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,7,'统一待办中心集成','统一待办中心集成') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,8,'Unified to-do center integration','Unified to-do center integration') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,9,'統壹待辦中心集成','統壹待辦中心集成') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,15,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43192,'统一待办中心集成','ofs:ofssetting',1974) 
GO

delete from HtmlLabelIndex where id=127060 
GO
delete from HtmlLabelInfo where indexid=127060 
GO
INSERT INTO HtmlLabelIndex values(127060,'统一待办库集成') 
GO
INSERT INTO HtmlLabelInfo VALUES(127060,'统一待办库集成',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127060,'Unified agent library integration',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127060,'統壹待辦庫集成',9) 
GO

delete from HtmlLabelIndex where id=127357 
GO
delete from HtmlLabelInfo where indexid=127357 
GO
INSERT INTO HtmlLabelIndex values(127357,'统一待办中心集成') 
GO
INSERT INTO HtmlLabelInfo VALUES(127357,'统一待办中心集成',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127357,'Unified to-do center integration',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127357,'統壹待辦中心集成',9) 
GO

Delete from MainMenuInfo where id=10284
GO
EXECUTE MMConfig_U_ByInfoInsert 10110,19
GO
EXECUTE MMInfo_Insert 10284,127357,'统一待办中心集成','/integration/integrationTab.jsp?urlType=101','mainFrame',10110,2,19,0,'',0,'',0,'','',0,'','',9
GO

delete from HtmlLabelIndex where id=127233 
GO
delete from HtmlLabelInfo where indexid=127233 
GO
INSERT INTO HtmlLabelIndex values(127233,'标识已经使用!') 
GO
delete from HtmlLabelIndex where id=127234 
GO
delete from HtmlLabelInfo where indexid=127234 
GO
INSERT INTO HtmlLabelIndex values(127234,'简称已经使用!') 
GO
delete from HtmlLabelIndex where id=127235 
GO
delete from HtmlLabelInfo where indexid=127235 
GO
INSERT INTO HtmlLabelIndex values(127235,'全称已经使用!') 
GO
INSERT INTO HtmlLabelInfo VALUES(127235,'全称已经使用!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127235,'Full name already in use!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127235,'全稱已經使用！',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(127234,'简称已经使用!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127234,'Have been used for short!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127234,'簡稱已經使用！',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(127233,'标识已经使用!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127233,'Logo has been used!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127233,'標識已經使用！',9) 
GO

delete from HtmlLabelIndex where id=127412 
GO
delete from HtmlLabelInfo where indexid=127412 
GO
INSERT INTO HtmlLabelIndex values(127412,'异构系统流程数据') 
GO
INSERT INTO HtmlLabelInfo VALUES(127412,'异构系统流程数据',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127412,'Heterogeneous system workflow data',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127412,'異構系統流程數據',9) 
GO


delete from SystemLogItem where itemid ='168'
GO
insert into SystemLogItem(itemid,lableid,itemdesc,typeid) values('168','127412','异构系统流程数据','')
GO
