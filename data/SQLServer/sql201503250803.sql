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
VALUES ('outterSys','2','���ɵ�¼','resource/image/jobsinfo_wev8.gif',10,'2','getJobsInfoMore','���ɵ�¼','1','Integrated login','���ɵ�¼',0);
GO