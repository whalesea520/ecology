delete from HtmlLabelIndex where id=21274 
/
delete from HtmlLabelInfo where indexid=21274 
/
INSERT INTO HtmlLabelIndex values(21274,'协作附件设置') 
/
INSERT INTO HtmlLabelInfo VALUES(21274,'协作附件设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21274,'Accessory Setting Of Cowork',8) 
/

insert into SystemRights (id,rightdesc,righttype) values (772,'协作附件维护','7') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (772,7,'协作附件维护','协作附件维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (772,8,'Accessory Maintenance Of CoWork','Accessory Maintenance Of CoWork') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4281,'协作附件维护','CoWorkAccessory:Maintenance',772) 
/
