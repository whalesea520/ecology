INSERT INTO HtmlLabelIndex values(18866,'请选中你要添加子任务的位置!') 
GO
INSERT INTO HtmlLabelIndex values(18865,'其子任务也将被删除,是否继续?') 
GO
INSERT INTO HtmlLabelInfo VALUES(18865,'其子任务也将被删除,是否继续?',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18865,'Its children task will be deleted yet,are you sure?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18866,'请选中你要添加子任务的位置!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18866,'select the location you will add!',8) 
GO
INSERT INTO HtmlLabelIndex values(18876,'培训教材')
GO
INSERT INTO HtmlLabelInfo VALUES(18876,'培训教材',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18876,'training stuff',8)
GO
alter table HrmTrainPlanDay add starttime char(5)
go
alter table HrmTrainPlanDay add endtime char(5)
go
alter table HrmTrainPlan add traindocs varchar(2000)
go

