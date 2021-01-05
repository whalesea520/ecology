CREATE OR REPLACE PROCEDURE Prj_Plan_SaveFromProcess 
(prjid_1 	integer, version_1	smallint,creater_1 integer,createdate_1 varchar2,createtime_1 varchar2, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor  ) 
AS taskid_1 	integer; wbscoding_1 	varchar2(4000); subject_1 	varchar2(4000); begindate_1 	varchar2(4000); enddate_1 	varchar2(4000); workday_1        number (10,1); content_1 	varchar2(4000); fixedcost_1	number(10,2); parentid_1	integer; parentids_1	varchar2(4000); parenthrmids_1	varchar2(4000); level_1		smallint; hrmid_1		integer;taskindex_1		integer;
realManDays_1 number(6,1);actualBeginDate_1 varchar2(10);actualEndDate_1 varchar2(10);finish_1 integer;islandmark_1 char(1);  CURSOR all_cursor is select  id , wbscoding, subject , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid,taskindex
,realManDays,actualBeginDate,actualEndDate,finish,islandmark from Prj_TaskProcess where prjid = prjid_1;  begin open all_cursor; loop fetch all_cursor INTO taskid_1,wbscoding_1,subject_1,begindate_1,enddate_1, workday_1,content_1,fixedcost_1,parentid_1,parentids_1,parenthrmids_1,level_1,hrmid_1,taskindex_1
,realManDays_1,actualBeginDate_1,actualEndDate_1,finish_1,islandmark_1; exit when all_cursor%NOTFOUND;  INSERT INTO Prj_TaskInfo ( prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid,taskindex
,realManDays,actualBeginDate,actualEndDate,finish,islandmark, isactived, version,creater,createdate,createtime) VALUES (  prjid_1, taskid_1 , wbscoding_1, subject_1 , begindate_1, enddate_1, workday_1, content_1, fixedcost_1, parentid_1, parentids_1, parenthrmids_1, level_1, hrmid_1,taskindex_1
,realManDays_1,actualBeginDate_1,actualEndDate_1,finish_1,islandmark_1,'1',version_1,creater_1,createdate_1,createtime_1); end  loop;   CLOSE all_cursor; end;
/
CREATE OR REPLACE FUNCTION getPrjTaskInfoBeginDate
(i_prjid int,i_version varchar2)
RETURN char IS
o_mindate char(10);
BEGIN
  SELECT MIN(begindate) into o_mindate  FROM Prj_TaskInfo WHERE prjid=i_prjid and version=i_version;
  Return o_mindate;
END;
/

CREATE OR REPLACE FUNCTION getPrjTaskInfoEndDate
(i_prjid int,i_version varchar2)
RETURN char IS
o_maxdate char(10);
BEGIN
	SELECT MAX(enddate) into o_maxdate  FROM Prj_TaskInfo WHERE prjid=i_prjid and version=i_version;
	Return o_maxdate;
END;
/
CREATE OR REPLACE FUNCTION getPrjTaskInfoFinish (i_prjid int,i_version varchar2) RETURN int IS i_sumWorkday decimal(9); i_finish int default 0; BEGIN SELECT SUM(workday) into i_sumWorkday FROM Prj_TaskInfo WHERE ( prjid = i_prjid and parentid = '0' and isdelete<>'1' and version=i_version) ; IF i_sumWorkday<>0 then SELECT (sum(finish*workday)/sum(workday)) into i_finish  FROM Prj_TaskInfo WHERE ( prjid = i_prjid and parentid = '0' and isdelete<>'1' and version=i_version) ; END IF; Return i_finish; END;
/
CREATE OR REPLACE PROCEDURE Prj_Plan_Approve (prjid_1 	integer,creater_1 integer,createdate_1 varchar2,createtime_1 varchar2, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor  ) 
AS  taskid_1 	integer; wbscoding_1 	varchar2(4000); subject_1 	varchar2(4000); begindate_1 	varchar2(4000); enddate_1 	varchar2(4000); workday_1        number (10,1); content_1 	varchar2(4000); fixedcost_1	number(18,2); parentid_1	integer; parentids_1	varchar2(4000); parenthrmids_1	varchar2(4000); level_1		smallint; 
hrmid_1		integer;taskindex_1 integer; realManDays_1 decimal(6,1);actualBeginDate_1 varchar2(10);actualEndDate_1 varchar2(10);finish_1 integer;islandmark_1 char(1);   CURSOR all_cursor is select   id , wbscoding, subject , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n
, hrmid,taskindex,realManDays,actualBeginDate,actualEndDate,finish,islandmark from Prj_TaskProcess where prjid = prjid_1;  begin open all_cursor; loop fetch all_cursor INTO taskid_1,wbscoding_1,subject_1,begindate_1,enddate_1, workday_1,content_1,fixedcost_1,parentid_1,parentids_1,parenthrmids_1,level_1
,hrmid_1,taskindex_1,realManDays_1,actualBeginDate_1,actualEndDate_1,finish_1,islandmark_1; exit when all_cursor%NOTFOUND;  INSERT INTO Prj_TaskInfo (  prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid,taskindex,realManDays,actualBeginDate,actualEndDate,finish,islandmark, isactived, version,creater,createdate,createtime) VALUES (  prjid_1, taskid_1,wbscoding_1,subject_1,begindate_1,enddate_1, workday_1,content_1,fixedcost_1,parentid_1,parentids_1,parenthrmids_1,level_1
,hrmid_1,taskindex_1,realManDays_1,actualBeginDate_1,actualEndDate_1,finish_1,islandmark_1,2,1,creater_1,createdate_1,createtime_1); end  loop;  CLOSE all_cursor; end;
/