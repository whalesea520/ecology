alter table outter_sys add  urlencodeflag char(1)
GO
alter table outter_sys add  urllinkimagid int
GO
 
CREATE TABLE shareoutter(
	[id] [int] IDENTITY(1,1) NOT NULL,
	[sysid]  [varchar](1000)  NOT NULL,
	[type] [int] NOT NULL,
	[content] [int] NOT NULL,
	[seclevel] [int] NOT NULL,
	[sharelevel] [int] NOT NULL,
	[seclevelmax] [varchar](1000) NULL
)
GO
INSERT INTO hpBaseElement (id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc,isuse,titleen,titlethk,loginview)
VALUES ('outterSys','2','集成登录','resource/image/jobsinfo_wev8.gif',10,'2','getJobsInfoMore','集成登录','1','Integrated login','集成登录',0);
GO
