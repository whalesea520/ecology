alter table prj_projectinfo add guid1 char(36)
GO
alter table prj_projectinfo add isfromws char(1)
GO
alter table prj_projectinfo add ws_other varchar(4000)
GO
alter table prj_projectinfo add ws_coworkid int
GO
alter table Prj_ProjectType add guid1 char(36)
GO
alter table Prj_WorkType add guid1 char(36)
GO