CREATE OR REPLACE PROCEDURE Prj_TaskProcess_Update 
(id_1	integer, wbscoding_2 varchar2, subject_3 	varchar2 , begindate_4 	varchar2, enddate_5 	varchar2,
actualbegindate_15 	varchar2, actualenddate_16 	varchar2, workday_6     number, content_7 	varchar2,
fixedcost_8 number, hrmid_9 varchar2, oldhrmid_10 varchar2, finish_11 smallint, taskconfirm_12 char, islandmark_13 char, prefinish_1 varchar2, 
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