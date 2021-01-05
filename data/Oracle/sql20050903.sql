create or replace  PROCEDURE Prj_TaskProcess_Insert 
 (prjid_1 	integer,
 taskid_2 	integer, 
 wbscoding_3 	varchar2,
 subject_4 	varchar2 , 
 version_5 	smallint, 
 begindate_6 	varchar2,
 enddate_7 	varchar2, 
 workday_8  number,
 content_9 	varchar2,
 fixedcost_10  number ,
 parentid_11  integer, 
 parentids_12 varchar2, 
 parenthrmids_13 varchar2, 
 level_n_14 smallint,
 hrmid_15 integer,
 prefinish_16 varchar2,
 realManDays_17 number ,
 taskIndex_18 integer,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
dsporder_9 integer;
current_maxid integer;
current_maxids integer;
id_1 integer;
maxid_1 varchar2(10);
maxhrmid_1 varchar2(255);
begin

select count(id) into current_maxids from Prj_TaskProcess
where prjid = prjid_1 and version = version_5 and parentid = parentid_11 and isdelete!='1' ;

if current_maxids> 0 then
select max(dsporder) into current_maxid from Prj_TaskProcess 
    where prjid = prjid_1 and version = version_5 and parentid = parentid_11 and isdelete!='1' ;

end if;

if current_maxids= 0 then
select max(dsporder) into current_maxid from Prj_TaskProcess 
    where prjid = prjid_1 and version = version_5 and parentid = parentid_11 and isdelete!='1' ;

     current_maxid := 0;
     dsporder_9 := current_maxid + 1;

end if;







INSERT INTO Prj_TaskProcess 
(prjid, 
taskid , 
wbscoding,
subject , 
version , 
begindate, 
enddate, 
workday, 
content, 
fixedcost,
parentid, 
parentids, 
parenthrmids,
level_n, 
hrmid,
islandmark,
prefinish,
dsporder,
realManDays,
taskIndex
)  
VALUES 
( prjid_1,
taskid_2 ,
wbscoding_3,
subject_4 ,
version_5 ,
begindate_6,
enddate_7,
workday_8,
content_9,
fixedcost_10,
parentid_11,
parentids_12,
parenthrmids_13,
level_n_14, 
hrmid_15,
'0',
prefinish_16,
dsporder_9,
realManDays_17,
taskIndex_18);
select max(id) into id_1 from Prj_TaskProcess ;
 maxid_1 := concat(to_char(id_1) , ',');
 maxhrmid_1 := concat(concat(concat(concat('|' , to_char(id_1)) , ',' ),to_char(hrmid_15) ), '|');
 update Prj_TaskProcess set parentids =concat('''',parentids_12 +maxid_1,''''), parenthrmids = concat('''',parenthrmids_13+maxhrmid_1,'''') where 
id=id_1;
select max(id) into flag from  Prj_TaskProcess;
msg := 'OK!';
end;
/
