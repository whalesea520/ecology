CREATE TABLE workflow_urgerdetail(
    id int NOT NULL IDENTITY (1, 1),
    workflowid int,/*工作流ID*/
    utype int,/*督办人类型*/
    objid int,/*操作对象ID*/
    level_n int,/*层级1*/
    level2_n int,/*层级2*/
    conditions varchar(1000),/*条件*/
    conditioncn varchar(1000)/*条件中文*/
)
GO

alter table workflow_monitor_bound add isview int default(0)
GO
