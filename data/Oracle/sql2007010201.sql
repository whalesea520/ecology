
delete from  HtmlLabelIndex  where id=20155
/


delete from  HtmlLabelInfo  where indexid=20155
/


INSERT INTO HtmlLabelIndex values(20155,'工时标准设置') 
/
INSERT INTO HtmlLabelInfo VALUES(20155,'工时标准设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20155,'set Type of G',8) 
/


insert into SystemRights (id,rightdesc,righttype) values (702,'工时标准设置','3') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (702,7,'工时标准设置','工时标准设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (702,8,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4210,'工时标准设置','TIMESET',702) 
/


