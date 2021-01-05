INSERT INTO HtmlLabelIndex values(18551,'目标已发布') 
GO
INSERT INTO HtmlLabelInfo VALUES(18551,'目标已发布',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18551,'Goal has been released',8) 
GO
alter table HrmPerformanceSchemeContent
 alter column percent_n varchar(5)
go

alter table HrmPerformanceSchemeDetail
 alter column percent_n varchar(5)
go

alter table HrmPerformanceSchemePercent
 alter column percent_n varchar(5)
go

alter table HrmPerformanceCheckDetail
 alter column percent_n varchar(5)
go

alter table WorkPlan
 alter column percent_n varchar(5)
go

alter table HrmPerformanceReport
 alter column percent_n varchar(5)
go

alter table HrmPerformanceReport
alter column pointSelf varchar(10)
go

alter table WorkPlan
alter column percent_n varchar(5)
go

alter table HrmPerformanceGoal
alter column percent_n varchar(5)
go
