CREATE TABLE MeetingSet	(id   INT NOT NULL,timeRangeStart int	, timeRangeEnd int	)
/
CREATE SEQUENCE MeetingSet_id INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 START WITH 1 CACHE 20
/
CREATE OR REPLACE TRIGGER MEETINGSET_TRIGGER BEFORE INSERT ON MEETINGSET REFERENCING OLD AS "OLD" NEW AS "NEW" FOR EACH ROW begin select MeetingSet_id.nextval into :new.id from dual; end ;
/
ALTER TRIGGER MEETING_TRIGGER ENABLE
/
insert into MeetingSet(timeRangeStart,timeRangeEnd)values(0,23)	
/
Delete from MainMenuInfo where id=1306
/
CALL MMConfig_U_ByInfoInsert (502,3)
/
CALL MMInfo_Insert (1306,31811,'”¶”√≈‰÷√','/meeting/Maint/MeetingSetTab.jsp','mainFrame',502,2,3,0,'',0,'',0,'','',0,'','',9)
/