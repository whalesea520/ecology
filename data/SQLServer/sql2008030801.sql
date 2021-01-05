delete from HtmlLabelIndex where id=21274 
GO
delete from HtmlLabelInfo where indexid=21274 
GO
INSERT INTO HtmlLabelIndex values(21274,'协作附件设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(21274,'协作附件设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21274,'Accessory Setting Of Cowork',8) 
GO

insert into SystemRights (id,rightdesc,righttype) values (772,'协作附件维护','7') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (772,7,'协作附件维护','协作附件维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (772,8,'Accessory Maintenance Of CoWork','Accessory Maintenance Of CoWork') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4281,'协作附件维护','CoWorkAccessory:Maintenance',772) 
GO
