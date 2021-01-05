delete from SystemRightDetail where rightid =2022
/
delete from SystemRightsLanguage where id =2022
/
delete from SystemRights where id =2022
/
insert into SystemRights (id,rightdesc,righttype) values (2022,'成员评分查看','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2022,9,'成員評分查看','成員評分查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2022,7,'成员评分查看','成员评分查看') 
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

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43239,'成员评分查看','workflow_ratingview',2022) 
/


delete from HtmlLabelIndex where id=128664 
/
delete from HtmlLabelInfo where indexid=128664 
/
INSERT INTO HtmlLabelIndex values(128664,'优点') 
/
INSERT INTO HtmlLabelInfo VALUES(128664,'优点',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128664,'Advantage',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128664,'優點',9) 
/

delete from HtmlLabelIndex where id=128665 
/
delete from HtmlLabelInfo where indexid=128665 
/
INSERT INTO HtmlLabelIndex values(128665,'缺点') 
/
INSERT INTO HtmlLabelInfo VALUES(128665,'缺点',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128665,'Shortcoming',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128665,'缺點',9) 
/

delete from HtmlLabelIndex where id=128666 
/
delete from HtmlLabelInfo where indexid=128666 
/
INSERT INTO HtmlLabelIndex values(128666,'改进建议') 
/
INSERT INTO HtmlLabelInfo VALUES(128666,'改进建议',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128666,'Improvement suggestions',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128666,'改進建議',9) 
/

delete from HtmlLabelIndex where id=128691 
/
delete from HtmlLabelInfo where indexid=128691 
/
INSERT INTO HtmlLabelIndex values(128691,'被评价人姓名') 
/
INSERT INTO HtmlLabelInfo VALUES(128691,'被评价人姓名',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128691,'Name of the person being evaluated',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128691,'被評估人姓名',9) 
/