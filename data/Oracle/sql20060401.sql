ALTER TABLE Prj_TaskProcess rename column fixedcost to fixedcosttemp
/
ALTER TABLE Prj_TaskProcess add fixedcost number(18,2)
/
update  Prj_TaskProcess set fixedcost = fixedcosttemp
/
ALTER TABLE Prj_TaskProcess drop column fixedcosttemp
/

ALTER TABLE Prj_TaskModifyLog rename column fixedcost to fixedcosttemp
/
ALTER TABLE Prj_TaskModifyLog add fixedcost number(18,2)
/
update  Prj_TaskModifyLog set fixedcost = fixedcosttemp
/
ALTER TABLE Prj_TaskModifyLog drop column fixedcosttemp
/

create or replace  PROCEDURE Prj_TaskProcess_Update 
 (id_1	integer,
 wbscoding_2 varchar2,
 subject_3 	varchar2 ,
 begindate_4 	varchar2,
 enddate_5 	varchar2, 
 /* added by hubo, 2005/09/01 */
 actualbegindate_15 	varchar2,
 actualenddate_16 	varchar2, 
 workday_6     number, 
 content_7 	varchar2,
 fixedcost_8 number, 
 hrmid_9 integer, 
 oldhrmid_10 integer, 
 finish_11 smallint, 
 taskconfirm_12 char,
 islandmark_13 char,
 prefinish_1 varchar2,
 realManDays_14 number ,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
currenthrmid varchar2(255);
currentoldhrmid varchar2(255);

begin
UPDATE Prj_TaskProcess  
SET  
wbscoding = wbscoding_2, 
subject = subject_3 ,
begindate = begindate_4,
enddate = enddate_5 	,
/* added by hubo, 2005/09/01 */
actualbegindate = actualbegindate_15,
actualenddate = actualenddate_16 ,
workday = workday_6, 
content = content_7,
fixedcost = fixedcost_8,
hrmid = hrmid_9, 
finish = finish_11 ,
taskconfirm = taskconfirm_12,
islandmark = islandmark_13,
prefinish = prefinish_1,
realManDays = realManDays_14 
WHERE ( id = id_1) ;

if hrmid_9 <>oldhrmid_10 then
currenthrmid := concat(concat(concat(concat('|' ,to_char(id_1)) ,',') ,to_char(hrmid_9)) ,'|');
currentoldhrmid:= concat(concat(concat(concat('|' ,to_char(id_1)) , ',' ) , to_char(oldhrmid_10)) , '|');

UPDATE Prj_TaskProcess set parenthrmids = replace(parenthrmids,currentoldhrmid,currenthrmid) 
where (parenthrmids like concat(concat('%',currentoldhrmid),'%'));
end if;
end;
/
create or replace  PROCEDURE Prj_TaskModifyLog_Insert 
  (
ProjID_1	   integer ,
TaskID_1	   integer ,
Subject_1	   VARCHAR2,
HrmID_1	   integer ,
BeginDate_1  VARCHAR2 ,
EndDate_1	   VARCHAR2 ,
WorkDay_1	   number  ,
FixedCost_1  number ,
Finish_1	   smallint ,
ParentID_1 integer,
Prefinish_1  VARCHAR2  ,
IsLandMark_1 Char ,
ModifyDate_1 VARCHAR2,
ModifyTime_1 VARCHAR2,
ModifyBy_1   integer ,
Status_1	   smallint ,
OperationType_1	smallint,
ClientIP_1	Varchar2,
realManDays number,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO Prj_TaskModifyLog (
ProjID	   ,
TaskID	   ,
Subject	   ,
HrmID	   ,
BeginDate  ,
EndDate	   ,
WorkDay	   ,
FixedCost  ,
Finish	   ,
ParentID   ,
Prefinish  ,
IsLandMark ,
ModifyDate ,
ModifyTime ,
ModifyBy   ,
Status	   ,
OperationType	,
ClientIP,
realManDays
)
VALUES(
ProjID_1	   ,
TaskID_1	   ,
Subject_1	   ,
HrmID_1	   ,
BeginDate_1       ,
EndDate_1	   ,
WorkDay_1	   ,
FixedCost_1       ,
Finish_1	   ,
ParentID_1        ,
Prefinish_1  ,
IsLandMark_1 ,
ModifyDate_1 ,
ModifyTime_1 ,
ModifyBy_1   ,
Status_1	   ,
OperationType_1	,
ClientIP_1,
realManDays
);
end;
/