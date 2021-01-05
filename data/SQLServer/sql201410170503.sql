create table cpt_cptcardtab(
id int IDENTITY (1, 1) not null,
groupname varchar(60) null,
grouplabel int null,
dsporder decimal(10,2) null,
isopen char(1) null,
ismand char(1) null,
isused char(1) null,
issystem char(1) null,
linkurl varchar(2000)
)
go

create table prj_prjcardtab(
id int IDENTITY (1, 1) not null,
groupname varchar(60) null,
grouplabel int null,
dsporder decimal(10,2) null,
isopen char(1) null,
ismand char(1) null,
isused char(1) null,
issystem char(1) null,
linkurl varchar(2000)
)
go


SET IDENTITY_INSERT cpt_cptcardtab ON
go
insert into cpt_cptcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(1,'资产信息',15806,1,'1','1','1','1','/cpt/capital/CptCapital.jsp')
go
insert into cpt_cptcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(2,'共享设置',2112,1,'1','1','1','1','/cpt/capital/CptCapitalShareDsp.jsp')
go
insert into cpt_cptcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(3,'流转日志',34253,1,'1','1','1','1','/cpt/capital/CptCapitalFlowView.jsp')
go
insert into cpt_cptcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(4,'变更记录',19765,1,'1','1','1','1','/cpt/capital/CptCapitalModifyView.jsp')
go
insert into cpt_cptcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(5,'统计报告',15296,1,'1','1','1','1','/cpt/capital/CptCapitalStatistics.jsp')
go
SET IDENTITY_INSERT cpt_cptcardtab OFF
go


SET IDENTITY_INSERT prj_prjcardtab ON
go
insert into prj_prjcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(1,'项目信息',16290,1,'1','1','1','1','/proj/data/ViewProject.jsp')
go
insert into prj_prjcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(2,'任务列表',18505,1,'1','1','1','1','/proj/process/ViewProcess.jsp')
go
insert into prj_prjcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(3,'子项目',846,1,'1','1','1','1','/proj/data/ViewProjectSub.jsp')
go
insert into prj_prjcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(4,'相关交流',15153,1,'1','1','1','1','/proj/process/ViewPrjDiscuss.jsp')
go
insert into prj_prjcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(5,'共享设置',2112,1,'1','1','1','1','/proj/data/PrjShareDsp.jsp')
go
insert into prj_prjcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(6,'统计报告',15296,1,'1','1','1','1','/proj/data/ViewProjectStastics.jsp')
go
SET IDENTITY_INSERT prj_prjcardtab OFF
go