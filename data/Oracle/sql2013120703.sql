alter table meeting_decision add (hrmid02_temp varchar(10))
/
update meeting_decision set hrmid02_temp=hrmid02
/
alter table meeting_decision drop(hrmid02)
/                        
alter table meeting_decision rename column hrmid02_temp to hrmid02
/
CREATE OR REPLACE 
PROCEDURE Meeting_Decision_Insert (meetingid_1 integer, requestid_1 integer, coding_1 varchar2 ,	subject_1 varchar2 , hrmid01_1 varchar2 , hrmid02_1 varchar2, begindate_1 varchar2  , begintime_1 varchar2  , enddate_1 varchar2  , endtime_1 varchar2 , flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS begin INSERT INTO Meeting_Decision ( meetingid ,requestid , coding, subject, hrmid01, hrmid02, begindate, begintime, enddate, endtime ) VALUES ( meetingid_1 , requestid_1 , coding_1, subject_1, hrmid01_1, hrmid02_1, begindate_1, begintime_1, enddate_1, endtime_1  ); end;
/