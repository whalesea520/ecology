DROP INDEX IX_Prj_TaskInfo_parentids
/
alter table Prj_TaskInfo modify fixedcost number(18,2)
/

alter table Prj_TaskInfo modify parenthrmids varchar2(4000)
/

alter table Prj_TaskInfo modify parentids varchar2(4000)
/

alter table Prj_TaskInfo modify content varchar2(4000)
/

alter table Prj_TaskInfo modify enddate varchar2(50)
/

alter table Prj_TaskInfo modify begindate varchar2(50)
/

alter table Prj_TaskInfo modify subject varchar2(500)
/

alter table Prj_TaskInfo modify wbscoding varchar2(200)
/

CREATE or REPLACE PROCEDURE Prj_Plan_Approve 
(prjid_1 	integer,  
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor  )  
 AS 
 
		taskid_1 	integer;
		wbscoding_1 	varchar2(200); 
		subject_1 	varchar2(500);
		begindate_1 	varchar2(50); 
		enddate_1 	varchar2(50);
		workday_1        number (10,1); 
		content_1 	varchar2(4000); 
		fixedcost_1	number(18,2);
		parentid_1	integer;
		parentids_1	varchar2(4000);
		parenthrmids_1	varchar2(4000);
		level_1		smallint;
		hrmid_1		integer;
		

CURSOR all_cursor is	
select   id , wbscoding, subject , begindate, enddate, workday, content, fixedcost,
parentid, parentids, parenthrmids, level_n, hrmid from Prj_TaskProcess where prjid = prjid_1; 

begin
open all_cursor;
loop
	fetch all_cursor INTO taskid_1,wbscoding_1,subject_1,begindate_1,enddate_1,
	workday_1,content_1,fixedcost_1,parentid_1,parentids_1,parenthrmids_1,level_1,hrmid_1;
	exit when all_cursor%NOTFOUND;	

	INSERT INTO Prj_TaskInfo (  prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content, fixedcost, parentid,
	parentids, parenthrmids, level_n, hrmid, isactived, version)  
	VALUES (  prjid_1, taskid_1,wbscoding_1,subject_1,begindate_1,enddate_1,
	workday_1,content_1,fixedcost_1,parentid_1,parentids_1,parenthrmids_1,level_1,hrmid_1,2,1);
end  loop;
 
CLOSE all_cursor;
end;
/
