insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc) values ('考勤报表','',7,'看下我本月的考勤情况','/fullsearch/img/checkInReport_wev8.png')
GO
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc) values ('假期情况','',8,'我还有几天年假','/fullsearch/img/holiday_wev8.png')
GO
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc) values ('导航','',9,'怎么去东方明珠','/fullsearch/img/navigation_wev8.png')
GO
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc) values ('查代办流程','',10,'我有多少待办事宜','/fullsearch/img/agencyFlow_wev8.png')
GO
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc) values ('查人员上下级','',11,'赵静的上级是谁','/fullsearch/img/upperLower_wev8.png')
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'看下我本月的考勤情况',0 from FullSearch_FixedInst where instructionName = '考勤报表'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'查一下我本周的考勤数据',1 from FullSearch_FixedInst where instructionName = '考勤报表'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'我要看考勤报表',2 from FullSearch_FixedInst where instructionName = '考勤报表'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'我最近的考勤记录',3 from FullSearch_FixedInst where instructionName = '考勤报表'
GO

insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'我还有几天年假',0 from FullSearch_FixedInst where instructionName = '假期情况'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'我还可以请几天假',1 from FullSearch_FixedInst where instructionName = '假期情况'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'我还可以请假吗',2 from FullSearch_FixedInst where instructionName = '假期情况'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'还剩几天假可以请',3 from FullSearch_FixedInst where instructionName = '假期情况'
GO

insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'怎么去东方明珠',0 from FullSearch_FixedInst where instructionName = '导航'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'我要去东方明珠怎么走',1 from FullSearch_FixedInst where instructionName = '导航'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'导航到东方明珠',2 from FullSearch_FixedInst where instructionName = '导航'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'我要到东方明珠',3 from FullSearch_FixedInst where instructionName = '导航'
GO


insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'我有多少待办事宜',0 from FullSearch_FixedInst where instructionName = '查代办流程'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'我还有多少事情没做',1 from FullSearch_FixedInst where instructionName = '查代办流程'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'列出我的待办事宜',2 from FullSearch_FixedInst where instructionName = '查代办流程'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'我的待办',3 from FullSearch_FixedInst where instructionName = '查代办流程'
GO


insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'赵静的上级是谁',0 from FullSearch_FixedInst where instructionName = '查人员上下级'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'谁是赵静的领导',1 from FullSearch_FixedInst where instructionName = '查人员上下级'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'赵静有哪些下属',2 from FullSearch_FixedInst where instructionName = '查人员上下级'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'赵静的下级都有谁',3 from FullSearch_FixedInst where instructionName = '查人员上下级'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'我的下属',4 from FullSearch_FixedInst where instructionName = '查人员上下级'
GO