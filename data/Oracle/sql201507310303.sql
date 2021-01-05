CREATE OR REPLACE PROCEDURE Prj_TaskInfo_Sum 
(prjid1 integer, version1 integer, 	 flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
AS begin open thecursor for 
SELECT sum(workday)   workday, min(begindate)   begindate, max(enddate)   enddate,min(actualBeginDate)  actualBeginDate,
max(actualEndDate)   actualEndDate FROM Prj_TaskInfo WHERE ( prjid = prjid1 and parentid = '0' and version = version1   and isdelete<>'1');
end;
/



alter table Prj_TaskInfo add( temprealmandays  number(15,2))     
/
update Prj_TaskInfo set temprealmandays = realmandays 
/
update Prj_TaskInfo set realmandays = '' 
/
ALTER TABLE Prj_TaskInfo modify realmandays  number(15,2)
/
update Prj_TaskInfo set realmandays = temprealmandays 
/
alter table Prj_TaskInfo drop column temprealmandays
/

alter table Prj_TaskInfo add( tempworkday  number(15,2))     
/
update Prj_TaskInfo set tempworkday = workday 
/
update Prj_TaskInfo set workday = '' 
/
ALTER TABLE Prj_TaskInfo modify workday  number(15,2)
/
update Prj_TaskInfo set workday = tempworkday 
/
alter table Prj_TaskInfo drop column tempworkday
/


CREATE OR REPLACE PROCEDURE Prj_Plan_SaveFromProcess 
(prjid_1 	integer, version_1	smallint,creater_1 integer,createdate_1 varchar2,
createtime_1 varchar2, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor  ) 
AS taskid_1 	integer; wbscoding_1 	varchar2(4000); subject_1 	varchar2(4000); begindate_1 	varchar2(4000);
enddate_1 	varchar2(4000); workday_1        number (15,2); content_1 	varchar2(4000); 
fixedcost_1	number(10,2); parentid_1	integer; parentids_1	varchar2(4000); parenthrmids_1	varchar2(4000);
level_1		smallint; hrmid_1		varchar2(300); taskindex_1		integer; realManDays_1 number(15,2); 
actualBeginDate_1 varchar2(10); actualEndDate_1 varchar2(10); finish_1 integer; islandmark_1 char(1); begintime_1 	varchar2(10); 
endtime_1 	varchar2(10); actualbegintime_1 varchar2(10); actualendtime_1 varchar2(10); 
CURSOR all_cursor is 
select  id , wbscoding, subject , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n,
hrmid,taskindex ,realManDays,actualBeginDate,actualEndDate,finish,islandmark,begintime,endtime,actualbegintime,actualendtime 
from Prj_TaskProcess where prjid = prjid_1;  begin open all_cursor; loop fetch all_cursor INTO 
taskid_1,wbscoding_1,subject_1,begindate_1,enddate_1, workday_1,content_1,fixedcost_1,parentid_1,parentids_1,parenthrmids_1,
level_1,hrmid_1,taskindex_1 ,realManDays_1,actualBeginDate_1,actualEndDate_1,finish_1,islandmark_1,begintime_1,endtime_1,
actualbegintime_1,actualendtime_1; exit when all_cursor%NOTFOUND;  INSERT INTO Prj_TaskInfo ( prjid, taskid , wbscoding, 
subject ,begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid,taskindex ,
realManDays,actualBeginDate,actualEndDate,finish,islandmark, isactived, version,creater,createdate,createtime,begintime,
endtime,actualbegintime,actualendtime) VALUES (  prjid_1, taskid_1 , wbscoding_1, subject_1 , begindate_1, enddate_1, workday_1, 
content_1, fixedcost_1, parentid_1, parentids_1, parenthrmids_1, level_1, hrmid_1,taskindex_1 ,realManDays_1,actualBeginDate_1,
actualEndDate_1,finish_1,islandmark_1,'1',version_1,creater_1,createdate_1,createtime_1,begintime_1,endtime_1,actualbegintime_1,
actualendtime_1); end  loop;   CLOSE all_cursor; end;
/