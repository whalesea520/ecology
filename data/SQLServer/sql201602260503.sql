alter table workflow_groupdetail add jobobj varchar(4000)
go
alter table workflow_groupdetail add jobfield varchar(4000)
go
alter table Workflow_SharedScope add joblevel int
go
alter table Workflow_SharedScope add jobid int
go
alter table Workflow_SharedScope add jobobj varchar(4000)
go
alter table workflow_urgerdetail add jobobj varchar(4000)
go
alter table workflow_urgerdetail add jobfield varchar(4000)
go
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 278,27219,'varchar(4000)','/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp','HrmJobTitles','jobtitlename','id','/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=')
GO