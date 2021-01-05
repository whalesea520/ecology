
delete from HtmlLabelIndex where id=20158
go
delete from HtmlLabelInfo where indexid=20158
go

INSERT INTO HtmlLabelIndex values(20158,'计划删除日志') 
GO
INSERT INTO HtmlLabelInfo VALUES(20158,'计划删除日志',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20158,'delte plan log',8) 
GO



insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (703,8,'view delete plan log','view delete plan log') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (703,7,'计划删除日志查看','计划删除日志查看') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4211,'删除计划日志查看','VIEW PLAN LOG',703) 
GO