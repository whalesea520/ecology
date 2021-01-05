
delete from HtmlLabelIndex where id=20158
/
delete from HtmlLabelInfo where indexid=20158
/

INSERT INTO HtmlLabelIndex values(20158,'计划删除日志') 
/
INSERT INTO HtmlLabelInfo VALUES(20158,'计划删除日志',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20158,'delte plan log',8) 
/


insert into SystemRights (id,rightdesc,righttype) values (703,'计划删除日志查看','3') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (703,8,'view delete plan log','view delete plan log') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (703,7,'计划删除日志查看','计划删除日志查看') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4211,'删除计划日志查看','VIEW PLAN LOG',703) 
/