delete from HtmlLabelIndex where id in (19081,17795)
go
delete from HtmlLabelInfo where indexid in (19081,17795)
go
delete from HtmlLabelIndex where id in (20109,18507,20110,20111,20112,20121,20122,20123,20124,20125)
go
delete from HtmlLabelInfo where indexid in (20109,18507,20110,20111,20112,20121,20122,20123,20124,20125)
go
delete from HtmlLabelIndex where id between 20126 and 20138
go
delete from HtmlLabelInfo where indexid between 20126 and 20138
go

INSERT INTO HtmlLabelIndex values(20109,'工作写实') 
GO
INSERT INTO HtmlLabelInfo VALUES(20109,'工作写实',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20109,'DailyNote',8) 
GO
INSERT INTO HtmlLabelIndex values(18507,'计划审批') 
GO
INSERT INTO HtmlLabelInfo VALUES(18507,'计划审批',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18507,'PLAN PROVE',8) 
GO
INSERT INTO HtmlLabelIndex values(20110,'计划报表') 
GO
INSERT INTO HtmlLabelInfo VALUES(20110,'计划报表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20110,'Plan Report',8) 
GO
INSERT INTO HtmlLabelIndex values(20111,'写实报表') 
GO
INSERT INTO HtmlLabelInfo VALUES(20111,'写实报表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20111,'DailyNote Report',8) 
GO
INSERT INTO HtmlLabelIndex values(20112,'计划查询') 
GO
INSERT INTO HtmlLabelInfo VALUES(20112,'计划查询',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20112,'Search Plan',8) 
GO



INSERT INTO HtmlLabelIndex values(20121,'计划日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(20121,'计划日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20121,'PlanDate',8) 
GO
INSERT INTO HtmlLabelIndex values(20122,'计划完成情况') 
GO
INSERT INTO HtmlLabelInfo VALUES(20122,'计划完成情况',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20122,'PlanStatus',8) 
GO
INSERT INTO HtmlLabelIndex values(20124,'未开展') 
GO
INSERT INTO HtmlLabelIndex values(20125,'用时不足') 
GO
INSERT INTO HtmlLabelIndex values(20123,'全部工作') 
GO
INSERT INTO HtmlLabelInfo VALUES(20123,'全部工作',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20123,'All',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20124,'未开展',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20124,'UnStart',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20125,'用时不足',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20125,'TimeNotEnough',8) 
GO
INSERT INTO HtmlLabelIndex values(20126,'计划用时') 
GO
INSERT INTO HtmlLabelIndex values(20128,'实际进度') 
GO
INSERT INTO HtmlLabelIndex values(20129,'工作写实详细') 
GO
INSERT INTO HtmlLabelIndex values(20127,'累计用时') 
GO
INSERT INTO HtmlLabelInfo VALUES(20126,'计划用时',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20126,'PlanTime',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20127,'累计用时',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20127,'SumTime',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20128,'实际进度',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20128,'Process',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20129,'工作写实详细',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20129,'WorkNoteDetail',8) 
GO
INSERT INTO HtmlLabelIndex values(20132,'常规工作') 
GO
INSERT INTO HtmlLabelIndex values(20130,'工作起止时间') 
GO
INSERT INTO HtmlLabelIndex values(20131,'工作状态') 
GO
INSERT INTO HtmlLabelInfo VALUES(20130,'工作起止时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20130,'WorkTime',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20131,'工作状态',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20131,'WorkStatus',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20132,'常规工作',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20132,'General Work',8) 
GO
INSERT INTO HtmlLabelIndex values(20133,'协助人') 
GO
INSERT INTO HtmlLabelInfo VALUES(20133,'协助人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20133,'coadjutant',8) 
GO
INSERT INTO HtmlLabelIndex values(20134,'写实') 
GO
INSERT INTO HtmlLabelInfo VALUES(20134,'写实',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20134,'Note',8) 
GO
INSERT INTO HtmlLabelIndex values(20135,'工时统计') 
GO
INSERT INTO HtmlLabelInfo VALUES(20135,'工时统计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20135,'Time Statistic',8) 
GO
INSERT INTO HtmlLabelIndex values(20136,'今日工时') 
GO
INSERT INTO HtmlLabelIndex values(20137,'累计次数') 
GO
INSERT INTO HtmlLabelInfo VALUES(20136,'今日工时',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20136,'Today Work Time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20137,'累计次数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20137,'Num',8) 
GO
INSERT INTO HtmlLabelIndex values(20138,'东昌集团员工工作写实记录表') 
GO
INSERT INTO HtmlLabelInfo VALUES(20138,'东昌集团员工工作写实记录表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20138,'Work Note Report',8) 
GO







INSERT INTO HtmlLabelIndex values(20139,'作业班次') 
GO
INSERT INTO HtmlLabelIndex values(20141,'截止今日进展情况') 
GO
INSERT INTO HtmlLabelIndex values(20142,'工作内容简要阐述') 
GO
INSERT INTO HtmlLabelIndex values(20143,'何部门或何人参与') 
GO
INSERT INTO HtmlLabelIndex values(20144,'该工作计划总用时') 
GO
INSERT INTO HtmlLabelIndex values(20145,'截至今日累计用时') 
GO
INSERT INTO HtmlLabelIndex values(20146,'每日工作用时自我统计') 
GO
INSERT INTO HtmlLabelIndex values(20147,'今日小计') 
GO
INSERT INTO HtmlLabelIndex values(20148,'签名') 
GO
INSERT INTO HtmlLabelIndex values(20140,'第几次做') 
GO
INSERT INTO HtmlLabelInfo VALUES(20139,'作业班次',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20139,'Work Num',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20140,'第几次做',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20140,'Num',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20141,'截止今日进展情况',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20141,'Process',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20142,'工作内容简要阐述',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20142,'content',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20143,'何部门或何人参与',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20143,'Participator',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20144,'该工作计划总用时',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20144,'Sum Time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20145,'截至今日累计用时',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20145,'Total Time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20146,'每日工作用时自我统计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20146,'Day Time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20147,'今日小计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20147,'Subtotal',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20148,'签名',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20148,'underwrite',8) 
GO
INSERT INTO HtmlLabelIndex values(20149,'请至少选择一条记录。') 
GO
INSERT INTO HtmlLabelInfo VALUES(20149,'请至少选择一条记录。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20149,'please select a record.',8) 
GO

INSERT INTO HtmlLabelIndex values(19081,'超时') 
GO
INSERT INTO HtmlLabelInfo VALUES(19081,'超时',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19081,'Overtime',8) 
GO
INSERT INTO HtmlLabelIndex values(17795,'工作内容') 
GO
INSERT INTO HtmlLabelInfo VALUES(17795,'工作内容',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17795,'Content',8) 
GO