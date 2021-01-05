alter table workflow_groupdetail add jobobj varchar2(4000)
/
alter table workflow_groupdetail add jobfield varchar2(4000)
/
alter table Workflow_SharedScope add joblevel integer
/
alter table Workflow_SharedScope add jobid integer
/
alter table Workflow_SharedScope add jobobj varchar2(4000)
/
alter table workflow_urgerdetail add jobobj varchar2(4000)
/
alter table workflow_urgerdetail add jobfield varchar2(4000)
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl,typeid,useable,orderid) VALUES ( 278,27219,'varchar2(4000)','/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp','HrmJobTitles','jobtitlename','id','/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=',9,1,7)
/