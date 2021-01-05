delete from SystemRightDetail where rightid =1611
GO
delete from SystemRightsLanguage where id =1611
GO
delete from SystemRights where id =1611
GO
insert into SystemRights (id,rightdesc,righttype) values (1611,'新建客户权限','0') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1611,9,'新建客戶權限','新建客戶權限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1611,7,'新建客户权限','新建客户权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1611,8,'New customer rights','New customer rights') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42841,'新建客户权限','crm:addMenu',1611) 
GO


delete from HtmlLabelIndex where id=32493 
GO
delete from HtmlLabelInfo where indexid=32493 
GO
INSERT INTO HtmlLabelIndex values(32493,'营业执照') 
GO
INSERT INTO HtmlLabelInfo VALUES(32493,'营业执照',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32493,'business license',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32493,'營業執照',9) 
GO

delete from HtmlLabelIndex where id=32494 
GO
delete from HtmlLabelInfo where indexid=32494 
GO
INSERT INTO HtmlLabelIndex values(32494,'加工许可证') 
GO
INSERT INTO HtmlLabelInfo VALUES(32494,'加工许可证',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32494,'Processing License',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32494,'加工許可證',9) 
GO

delete from HtmlLabelIndex where id=32495 
GO
delete from HtmlLabelInfo where indexid=32495 
GO
INSERT INTO HtmlLabelIndex values(32495,'组织结构代码证') 
GO
INSERT INTO HtmlLabelInfo VALUES(32495,'组织结构代码证',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32495,'Organization Code Certificate',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32495,'組織結構代碼證',9) 
GO

delete from HtmlLabelIndex where id=32497 
GO
delete from HtmlLabelInfo where indexid=32497 
GO
INSERT INTO HtmlLabelIndex values(32497,'企业类型') 
GO
INSERT INTO HtmlLabelInfo VALUES(32497,'企业类型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32497,'type of enterprise',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32497,'企業類型',9) 
GO

delete from HtmlLabelIndex where id=31187 
GO
delete from HtmlLabelInfo where indexid=31187 
GO
INSERT INTO HtmlLabelIndex values(31187,'最多只能上传5个附件') 
GO
INSERT INTO HtmlLabelInfo VALUES(31187,'最多只能上传5个附件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(31187,'Can only upload up to five attachments',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(31187,'最多隻能上傳5個附件',9) 
GO

