delete from HtmlLabelIndex where id=20116
go
delete from HtmlLabelInfo where indexid=20116
go

INSERT INTO HtmlLabelIndex values(20116,'如因工作原因异常考勤请提交相应流程') 
go
INSERT INTO HtmlLabelInfo VALUES(20116,'如因工作原因异常考勤请提交相应流程',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20116,'Please submit related workflow if schedule abnormally because of work reason',8) 
go
