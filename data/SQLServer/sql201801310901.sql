delete from HtmlLabelIndex where id=382353 
GO
delete from HtmlLabelInfo where indexid=382353 
GO
INSERT INTO HtmlLabelIndex values(382353,'计划任务类必须是类的全名，该类必须实现接口weaver.interfaces.schedule.BaseCronJob或weaver.interfaces.schedule.CronJob的方法public void execute() {}') 
GO
INSERT INTO HtmlLabelInfo VALUES(382353,'计划任务类必须是类的全名，该类必须实现接口weaver.interfaces.schedule.BaseCronJob或weaver.interfaces.schedule.CronJob的方法public void execute() {}',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382353,'Plan task class must be the full name of the class, the class must implement the interface weaver.interfaces.schedule.BaseCronJob or weaver.interfaces.schedule.CronJob methods public void execute () {}',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382353,'計劃任務類必須是類的全名，該類必須實現接口weaver.interfaces.schedule.BaseCronJob或weaver.interfaces.schedule.CronJob的方法public void execute() {}',9) 
GO