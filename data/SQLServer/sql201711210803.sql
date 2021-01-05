alter table FullSearch_FixedInst add isCast integer
GO
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc,isCast) values ('新建会议','','12','新建会议','/fullsearch/img/meeting_wev8.png',0)
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'新建会议',1 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'帮我申请一个会议室',2 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'明天下午两点半去复星公司开会',3 from FullSearch_FixedInst
GO


insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc,isCast) values ('微博','','13','写微博','/fullsearch/img/blog_wev8.png',0)
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'写微博',1 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'补交昨天的微博',2 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'我想看赵静的微博',3 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'请查一下部门今天的微博填写情况',4 from FullSearch_FixedInst
GO

insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc,isCast) values ('请假','','14','我要请假','/fullsearch/img/leave_wev8.png',0)
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'我要请假',1 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'下周一请假2天外出旅游',2 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'我身体不舒服要请个病假',3 from FullSearch_FixedInst
GO

insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc,isCast) values ('出差','','15','我要出差','/fullsearch/img/travel_wev8.png',0)
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'我要出差',1 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'帮我提交一个出差申请',2 from FullSearch_FixedInst
GO


insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc,isCast) values ('报销','','16','我要报销','/fullsearch/img/reimburse_wev8.png',0)
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'我要报销',1 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'帮我报销昨天的交通费30块',2 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'给我报一下上个月的200块钱话费',3 from FullSearch_FixedInst
GO


insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc,isCast) values ('应用','','17','打开日程','/fullsearch/img/v_app_wev8.png',0)
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'打开日程',1 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'直接说出应用名称',2 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'打开外勤签到',3 from FullSearch_FixedInst
GO