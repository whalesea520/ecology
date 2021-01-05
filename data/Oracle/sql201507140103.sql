create table Prj_TemplateTask_bak as select * from Prj_TemplateTask
/
update Prj_TemplateTask set taskmanager=null
/
alter table Prj_TemplateTask modify(taskmanager varchar2(300))
/
UPDATE Prj_TemplateTask a 
SET taskmanager = (SELECT b.taskmanager FROM Prj_TemplateTask_bak b WHERE b.id = a.id)
WHERE EXISTS (SELECT * FROM Prj_TemplateTask_bak b WHERE b.id = a.id)
/
drop table Prj_TemplateTask_bak
/


create table Prj_TaskProcess_bak as select * from Prj_TaskProcess
/
update Prj_TaskProcess set hrmid=null
/
alter table Prj_TaskProcess modify(hrmid varchar2(300))
/
UPDATE Prj_TaskProcess a 
SET hrmid = (SELECT b.hrmid FROM Prj_TaskProcess_bak b WHERE b.id = a.id)
WHERE EXISTS (SELECT * FROM Prj_TaskProcess_bak b WHERE b.id = a.id)
/
drop table Prj_TaskProcess_bak
/


CREATE OR REPLACE PROCEDURE Prj_TaskProcess_Insert 
(prjid_1 	integer, taskid_2 	integer, wbscoding_3 	varchar2, 
subject_4 	varchar2 , version_5 	smallint, begindate_6 	varchar2, enddate_7 	varchar2, 
workday_8  number, content_9 	varchar2, fixedcost_10  number , parentid_11  integer, parentids_12 varchar2, 
parenthrmids_13 varchar2, level_n_14 smallint, hrmid_15 varchar2, prefinish_16 varchar2, realManDays_17 number , 
taskIndex_18 integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
AS dsporder_9 integer; current_maxid integer; 
current_maxids integer; id_1 integer; 
maxid_1 varchar2(4000); 
maxhrmid_1 varchar2(4000); 
begin  select count(id) into current_maxids from Prj_TaskProcess where prjid = prjid_1 and version = version_5 
and parentid = parentid_11 and isdelete!='1' ;  if current_maxids> 0 then select max(dsporder) 
into current_maxid from Prj_TaskProcess where prjid = prjid_1 and version = version_5 and parentid = parentid_11 
and isdelete!='1' ; dsporder_9 := current_maxid + 1; end if;  if current_maxids= 0 then select max(dsporder) into current_maxid 
from Prj_TaskProcess where prjid = prjid_1 and version = version_5 and parentid = parentid_11 and isdelete!='1' ;  
current_maxid := 0; dsporder_9 := current_maxid + 1;  end if;  INSERT INTO Prj_TaskProcess (prjid, taskid , wbscoding, subject , 
version , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid, islandmark, prefinish, 
dsporder, realManDays, taskIndex ) VALUES ( prjid_1, taskid_2 , wbscoding_3, subject_4 , version_5 , begindate_6, enddate_7, workday_8, 
content_9, fixedcost_10, parentid_11, parentids_12, parenthrmids_13, level_n_14, hrmid_15, '0', prefinish_16, dsporder_9, realManDays_17, 
taskIndex_18); select max(id) into id_1 from Prj_TaskProcess ; maxid_1 := concat(to_char(id_1) , ','); 
maxhrmid_1 := concat(concat(concat(concat('|' , to_char(id_1)) , ',' ),to_char(hrmid_15) ), '|'); 
update Prj_TaskProcess set parentids =concat(concat('',concat(parentids_12,maxid_1)),''),
parenthrmids = concat(concat('''',concat(parenthrmids_13,maxhrmid_1)),'''') where id=id_1; select max(id) into flag from  Prj_TaskProcess; msg := 'OK!';
end;
/

ALTER TABLE prj_taskmodifylog MODIFY hrmid null
/
create table Prj_TaskModifyLog_bak as select * from Prj_TaskModifyLog
/
update Prj_TaskModifyLog set hrmid=null
/
alter table Prj_TaskModifyLog modify(hrmid varchar2(300))
/
UPDATE Prj_TaskModifyLog a 
SET hrmid = (SELECT b.hrmid FROM Prj_TaskModifyLog_bak b WHERE b.id = a.id)
WHERE EXISTS (SELECT * FROM Prj_TaskModifyLog_bak b WHERE b.id = a.id)
/
drop table Prj_TaskModifyLog_bak
/


CREATE OR REPLACE PROCEDURE Prj_TaskModifyLog_Insert
(ProjID_1        integer, TaskID_1        integer, Subject_1       VARCHAR2, HrmID_1         VARCHAR2, BeginDate_1     VARCHAR2, EndDate_1       VARCHAR2,
WorkDay_1       number, FixedCost_1     number, Finish_1        smallint, ParentID_1      integer, Prefinish_1     VARCHAR2, IsLandMark_1    Char,
ModifyDate_1    VARCHAR2, ModifyTime_1    VARCHAR2, ModifyBy_1      integer, Status_1        smallint, OperationType_1 smallint, ClientIP_1      Varchar2,
realManDays     number, flag            out integer, msg             out varchar2, thecursor       IN OUT cursor_define.weavercursor)
AS begin INSERT INTO Prj_TaskModifyLog (ProjID, TaskID, Subject, HrmID, BeginDate, EndDate, WorkDay, FixedCost, Finish, ParentID, Prefinish, IsLandMark,
ModifyDate, ModifyTime, ModifyBy, Status, OperationType, ClientIP, realManDays) VALUES (ProjID_1, TaskID_1, Subject_1, HrmID_1, BeginDate_1,
EndDate_1, WorkDay_1, FixedCost_1, Finish_1, ParentID_1, Prefinish_1, IsLandMark_1, ModifyDate_1, ModifyTime_1, ModifyBy_1, Status_1, OperationType_1,
ClientIP_1, realManDays); 
end;
/

CREATE OR REPLACE PROCEDURE Prj_TaskProcess_Update 
(id_1	integer, wbscoding_2 varchar2, subject_3 	varchar2 , begindate_4 	varchar2, enddate_5 	varchar2,
actualbegindate_15 	varchar2, actualenddate_16 	varchar2, workday_6     number, content_7 	varchar2,
fixedcost_8 number, hrmid_9 varchar2, oldhrmid_10 integer, finish_11 smallint, taskconfirm_12 char, islandmark_13 char, prefinish_1 varchar2, 
realManDays_14 number , flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
AS currenthrmid varchar2(255); currentoldhrmid varchar2(255);  begin UPDATE Prj_TaskProcess SET wbscoding = wbscoding_2, subject = subject_3 ,
begindate = begindate_4, enddate = enddate_5 	,  actualbegindate = actualbegindate_15, actualenddate = actualenddate_16 ,
workday = workday_6, content = content_7, fixedcost = fixedcost_8, hrmid = hrmid_9, finish = finish_11 , taskconfirm = taskconfirm_12,
islandmark = islandmark_13, prefinish = prefinish_1, realManDays = realManDays_14 WHERE ( id = id_1) ;  if hrmid_9 <>oldhrmid_10 then 
currenthrmid := concat(concat(concat(concat('|' ,to_char(id_1)) ,',') ,to_char(hrmid_9)) ,'|'); 
currentoldhrmid:= concat(concat(concat(concat('|' ,to_char(id_1)) , ',' ) , to_char(oldhrmid_10)) , '|');  
UPDATE Prj_TaskProcess set parenthrmids = replace(parenthrmids,currentoldhrmid,currenthrmid) where (parenthrmids like concat(concat('%',currentoldhrmid),'%'));
end if; end;
/


create table Prj_TaskInfo_bak as select * from Prj_TaskInfo
/
update Prj_TaskInfo set hrmid=null
/
alter table Prj_TaskInfo modify(hrmid varchar2(300))
/
UPDATE Prj_TaskInfo a 
SET hrmid = (SELECT b.hrmid FROM Prj_TaskInfo_bak b WHERE b.id = a.id)
WHERE EXISTS (SELECT * FROM Prj_TaskInfo_bak b WHERE b.id = a.id)
/
drop table Prj_TaskInfo_bak
/

CREATE OR REPLACE PROCEDURE Prj_Plan_SaveFromProcess
(prjid_1 	integer, version_1	smallint,creater_1 integer,createdate_1 varchar2,createtime_1 varchar2, flag out integer ,
msg out varchar2, thecursor IN OUT cursor_define.weavercursor  )
AS
taskid_1 	integer;
wbscoding_1 	varchar2(4000);
subject_1 	varchar2(4000);
begindate_1 	varchar2(4000);
enddate_1 	varchar2(4000);
workday_1        number (10,1);
content_1 	varchar2(4000);
fixedcost_1	number(10,2);
parentid_1	integer;
parentids_1	varchar2(4000);
parenthrmids_1	varchar2(4000);
level_1		smallint;
hrmid_1		varchar2(300);
taskindex_1		integer;
realManDays_1 number(6,1);
actualBeginDate_1 varchar2(10);
actualEndDate_1 varchar2(10);
finish_1 integer;
islandmark_1 char(1);
begintime_1 	varchar2(10);
endtime_1 	varchar2(10);
actualbegintime_1 varchar2(10);
actualendtime_1 varchar2(10);
CURSOR all_cursor is select  id , wbscoding, subject , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid,taskindex ,realManDays,actualBeginDate,actualEndDate,finish,islandmark,begintime,endtime,actualbegintime,actualendtime from Prj_TaskProcess where prjid = prjid_1;  begin open all_cursor; loop fetch all_cursor INTO taskid_1,wbscoding_1,subject_1,begindate_1,enddate_1, workday_1,content_1,fixedcost_1,parentid_1,parentids_1,parenthrmids_1,level_1,hrmid_1,taskindex_1 ,realManDays_1,actualBeginDate_1,actualEndDate_1,finish_1,islandmark_1,begintime_1,endtime_1,actualbegintime_1,actualendtime_1; exit when all_cursor%NOTFOUND;  INSERT INTO Prj_TaskInfo ( prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid,taskindex ,realManDays,actualBeginDate,actualEndDate,finish,islandmark, isactived, version,creater,createdate,createtime,begintime,endtime,actualbegintime,actualendtime) VALUES (  prjid_1, taskid_1 , wbscoding_1, subject_1 , begindate_1, enddate_1, workday_1, content_1, fixedcost_1, parentid_1, parentids_1, parenthrmids_1, level_1, hrmid_1,taskindex_1 ,realManDays_1,actualBeginDate_1,actualEndDate_1,finish_1,islandmark_1,'1',version_1,creater_1,createdate_1,createtime_1,begintime_1,endtime_1,actualbegintime_1,actualendtime_1); end  loop;   CLOSE all_cursor; end;
/