ALTER table  HrmCareerApplyOtherInfo  ADD test varchar2(200)
/
update   HrmCareerApplyOtherInfo set test = salaryneed
/
ALTER table  HrmCareerApplyOtherInfo  drop column salaryneed
/
ALTER TABLE HrmCareerApplyOtherInfo RENAME COLUMN test TO salaryneed
/


ALTER table  HrmCareerApplyOtherInfo  ADD test2 varchar2(200)
/
update   HrmCareerApplyOtherInfo set test2 = salarynow
/
ALTER table  HrmCareerApplyOtherInfo  drop column salarynow
/
ALTER TABLE HrmCareerApplyOtherInfo RENAME COLUMN test2 TO salarynow
/

CREATE or REPLACE PROCEDURE HrmCareerApplyOtherIndo_In
	(applyid_2 	integer,
	category_3 	char,
	contactor_4 	varchar2,
	salarynow_5 	varchar2,
	worktime_6 		integer,
	salaryneed_7 	varchar2,
	currencyid_8 	integer,
	reason_9 	varchar2,
	otherrequest_10 	varchar2,
	selfcomment_11 	varchar2,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
AS
begin
INSERT INTO HrmCareerApplyOtherInfo 
	 (applyid,
	 category,
	 contactor,
	 salarynow,
	 worktime,
	 salaryneed,
	 currencyid,
	 reason,
	 otherrequest,
	 selfcomment) 
 
VALUES 
	(applyid_2,
	 category_3,
	 contactor_4,
	 salarynow_5,
	 worktime_6,
	 salaryneed_7,
	 currencyid_8,
	 reason_9,
	 otherrequest_10,
	 selfcomment_11);
end;
/

CREATE or replace  PROCEDURE HrmCareerApplyOtherInfo_Upd
	(applyid_2 	integer,
	 category_3 	char,
	 contactor_4 	varchar2,
	 salarynow_5 	varchar2,
	 worktime_6 	integer,
	 salaryneed_7 	varchar2,
	 currencyid_8 	integer,
	 reason_9 	varchar2,
	 otherrequest_10 	varchar2,
	 selfcomment_11 	Varchar2,
 flag out integer,
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
UPDATE HrmCareerApplyOtherInfo SET
	 category =category_3,
	 contactor=contactor_4,
	 salarynow=salarynow_5,
	 worktime=worktime_6,
	 salaryneed=salaryneed_7,
	 currencyid=currencyid_8,
	 reason=reason_9,
	 otherrequest=otherrequest_10,
	 selfcomment= selfcomment_11
WHERE applyid = applyid_2;
 end;

/