CREATE OR REPLACE PROCEDURE HrmScheduleMain_Insert (diffid_1 	integer, resourceid_2 	integer, startdate_3 	char, starttime_4 	char, enddate_5 	char, endtime_6 	char, memo_7 	Varchar2, createtype_8 	integer, createrid_9 	integer, createdate_10 	char, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor)  AS begin INSERT INTO HrmScheduleMaintance ( diffid, resourceid, startdate, starttime, enddate, endtime, memo, createtype, createrid, createdate)  VALUES ( diffid_1, resourceid_2, startdate_3, starttime_4, enddate_5, endtime_6, memo_7, createtype_8, createrid_9, createdate_10); open thecursor for select max(id) from HrmScheduleMaintance; end;
/