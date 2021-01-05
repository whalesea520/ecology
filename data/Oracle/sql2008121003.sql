
ALTER TABLE HrmkqSystemSet	 ADD	 signIpScope varchar2(400) null
/

update HrmkqSystemSet set signIpScope='*.*.*.*'
/

CREATE TABLE HrmScheduleSign (
	id int  NOT NULL ,
        userId int NULL , 
        userType char(1) NULL ,
        signType char(1) NULL ,
        signDate char(10) NULL ,
        signTime char(8) NULL ,
        clientAddress varchar2(15) NULL ,
        isInCom char(1) NULL  
) 
/
create sequence HrmScheduleSign_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmScheduleSign_Trigger
before insert on HrmScheduleSign
for each row
begin
select HrmScheduleSign_id.nextval into :new.id from dual;
end;
/




INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(181,20064,'Bill_BoHaiEvection','','','','','','') 
/
 
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (181,'resourceId',413,'int',3,1,0,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (181,'departmentId',18939,'int',3,4,1,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (181,'fromDate',1322,'char(10)',3,2,2,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (181,'fromTime',17690,'char(8)',3,19,3,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (181,'toDate',741,'char(10)',3,2,4,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (181,'toTime',743,'char(8)',3,19,5,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (181,'evectionReason',20055,'varchar2(500)',2,0,6,0,'')
/ 


INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(182,20065,'Bill_BoHaiOut','','','','','','') 
/
 
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (182,'resourceId',413,'int',3,1,0,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (182,'departmentId',18939,'int',3,4,1,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (182,'applyDate',20056,'char(10)',3,2,2,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (182,'applyTime',20057,'char(8)',3,19,3,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (182,'fromDate',20058,'char(10)',3,2,4,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (182,'fromTime',20059,'char(8)',3,19,5,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (182,'toDate',20060,'char(10)',3,2,6,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (182,'toTime',20061,'char(8)',3,19,7,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (182,'outReason',20062,'varchar2(500)',2,0,8,0,'')
/


CREATE TABLE Bill_BoHaiEvection ( 
    id int NOT NULL,
    resourceId int,
    departmentId int,
    fromDate char(10),
    fromTime char(8),
    toDate char(10),
    toTime char(8),
    evectionReason varchar2(500),
    requestid int) 
/

create sequence Bill_BoHaiEvection_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger Bill_BoHaiEvection_Trigger
before insert on Bill_BoHaiEvection
for each row
begin
select Bill_BoHaiEvection_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Bill_BoHaiOut ( 
    id int NOT NULL,
    resourceId int,
    departmentId int,
    applyDate char(10),
    applyTime char(8),
    fromDate char(10),
    fromTime char(8),
    toDate char(10),
    toTime char(8),
    outReason varchar2(500),
    requestid int) 
/

create sequence Bill_BoHaiOut_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger Bill_BoHaiOut_Trigger
before insert on Bill_BoHaiOut
for each row
begin
select Bill_BoHaiOut_id.nextval into :new.id from dual;
end;
/




CREATE  INDEX Bill_BoHaiLeave_resourceId_in ON Bill_BoHaiLeave(resourceId)
/

CREATE  INDEX Bill_BoHaiLeave_requestId_in ON Bill_BoHaiLeave(requestId)
/

CREATE  INDEX Bill_BoHaiEvection_resId_in ON Bill_BoHaiEvection(resourceId)
/

CREATE  INDEX Bill_BoHaiEvection_reqId_in ON Bill_BoHaiEvection(requestId)
/

CREATE  INDEX Bill_BoHaiOut_resourceId_in ON Bill_BoHaiOut(resourceId)
/

CREATE  INDEX Bill_BoHaiOut_requestId_in ON Bill_BoHaiOut(requestId)
/

CREATE  INDEX HrmScheduleSign_userId_in ON HrmScheduleSign(userId)
/

CREATE  INDEX HrmScheduleSign_signType_in ON HrmScheduleSign(signType)
/

CREATE  INDEX HrmScheduleSign_signDate_in ON HrmScheduleSign(signDate)
/


update HrmSchedule set scheduleType='3' where validedateFrom is not null
/

CREATE or REPLACE PROCEDURE  HrmkqSystemSet_Update(
tosomeone_1  varchar2 ,
timeinterval_2  integer , 
getdatatype_3  integer , 
getdatavalue_4  varchar2 , 
avgworkhour_5  integer , 
salaryenddate_6  int , 
signIpScope_7  varchar2 ,
flag	out integer, 
msg   out	varchar2, 
thecursor IN OUT cursor_define.weavercursor ) 
AS 
recordCount integer;
begin
    select count(1) into recordCount  from  HrmkqSystemSet;
    if recordCount>0 then
        begin
	  update HrmkqSystemSet 
          set 
          tosomeone = tosomeone_1 , 
          timeinterval = timeinterval_2 ,
          getdatatype = getdatatype_3 , 
          getdatavalue = getdatavalue_4 , 
          avgworkhour = avgworkhour_5  ,
          salaryenddate = salaryenddate_6  ,
          signIpScope = signIpScope_7  ;
	end;
    else
        begin
	  insert into HrmkqSystemSet (tosomeone,timeinterval,getdatatype,getdatavalue,avgworkhour,salaryenddate,signIpScope)
	  values(tosomeone_1,timeinterval_2,getdatatype_3,getdatavalue_4,avgworkhour_5,salaryenddate_6,signIpScope_7);
	end;
    end if;


end ;


/

create or replace PROCEDURE HrmSchedule_Insert (
 relatedId_1 	integer ,
 monstarttime1_2 	char, 
 monendtime1_3 	char, 
 monstarttime2_4 	char, 
 monendtime2_5 	char, 
 tuestarttime1_6 	char, 
 tueendtime1_7 	char, 
 tuestarttime2_8 	char, 
 tueendtime2_9 	char, 
 wedstarttime1_10 	char, 
 wedendtime1_11 	char, 
 wedstarttime2_12 	char, 
 wedendtime2_13 	char, 
 thustarttime1_14 	char, 
 thuendtime1_15 	char, 
 thustarttime2_16 	char,
 thuendtime2_17 	char, 
 fristarttime1_18 	char, 
 friendtime1_19 	char, 
 fristarttime2_20 	char, 
 friendtime2_21 	char, 
 satstarttime1_22 	char, 
 satendtime1_23 	char, 
 satstarttime2_24 	char, 
 satendtime2_25 	char, 
 sunstarttime1_26 	char, 
 sunendtime1_27 	char, 
 sunstarttime2_28 	char, 
 sunendtime2_29 	char, 
 totaltime_30    char, 
 validedatefrom_31 	char, 
 validedateto_32 	char,
 scheduleType_33 	char,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
AS 
begin
INSERT INTO HrmSchedule (
            relatedId, 
            monstarttime1, 
            monendtime1, 
            monstarttime2, 
            monendtime2, 
            tuestarttime1, 
            tueendtime1, 
            tuestarttime2, 
            tueendtime2, 
            wedstarttime1, 
            wedendtime1, 
            wedstarttime2, 
            wedendtime2, 
            thustarttime1, 
            thuendtime1, 
            thustarttime2, 
            thuendtime2, 
            fristarttime1, 
            friendtime1, 
            fristarttime2, 
            friendtime2, 
            satstarttime1, 
            satendtime1, 
            satstarttime2, 
            satendtime2, 
            sunstarttime1, 
            sunendtime1, 
            sunstarttime2, 
            sunendtime2, 
            totaltime, 
            validedatefrom,
            validedateto,
            scheduleType
	    )  
VALUES ( 
            relatedId_1, 
            monstarttime1_2, 
            monendtime1_3, 
            monstarttime2_4, 
            monendtime2_5, 
            tuestarttime1_6, 
            tueendtime1_7, 
            tuestarttime2_8, 
            tueendtime2_9, 
            wedstarttime1_10, 
            wedendtime1_11, 
            wedstarttime2_12, 
            wedendtime2_13, 
            thustarttime1_14, 
            thuendtime1_15, 
            thustarttime2_16, 
            thuendtime2_17, 
            fristarttime1_18, 
            friendtime1_19, 
            fristarttime2_20, 
            friendtime2_21, 
            satstarttime1_22, 
            satendtime1_23, 
            satstarttime2_24, 
            satendtime2_25, 
            sunstarttime1_26, 
            sunendtime1_27,
            sunstarttime2_28, 
            sunendtime2_29, 
            totaltime_30, 
            validedatefrom_31,
            validedateto_32,
            scheduleType_33
	    );
open thecursor for
select max(id) from HrmSchedule ;
end;
/

create or replace PROCEDURE HrmSchedule_Update 
 (id_1 	integer, 
  relatedId_2 	integer,
  monstarttime1_3 	char, 
  monendtime1_4 	char, 
  monstarttime2_5 	char, 
  monendtime2_6 	char, 
  tuestarttime1_7 	char, 
  tueendtime1_8 	char, 
  tuestarttime2_9 	char, 
  tueendtime2_10 	char, 
  wedstarttime1_11 	char, 
  wedendtime1_12 	char, 
  wedstarttime2_13 	char, 
  wedendtime2_14 	char, 
  thustarttime1_15 	char, 
  thuendtime1_16 	char, 
  thustarttime2_17 	char, 
  thuendtime2_18 	char, 
  fristarttime1_19 	char, 
  friendtime1_20 	char, 
  fristarttime2_21 	char, 
  friendtime2_22 	char, 
  satstarttime1_23 	char, 
  satendtime1_24 	char, 
  satstarttime2_25 	char, 
  satendtime2_26 	char, 
  sunstarttime1_27 	char, 
  sunendtime1_28 	char, 
  sunstarttime2_29 	char, 
  sunendtime2_30 	char, 
  totaltime_31    char, 
  validedatefrom_32 	char, 
  validedateto_33 	char, 
  scheduleType_34 	char, 
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
UPDATE HrmSchedule  
SET  
relatedId= relatedId_2, 
monstarttime1= monstarttime1_3, 
monendtime1	 = monendtime1_4, 
monstarttime2= monstarttime2_5, 
monendtime2	 = monendtime2_6, 
tuestarttime1= tuestarttime1_7, 
tueendtime1	 = tueendtime1_8, 
tuestarttime2= tuestarttime2_9, 
tueendtime2	 = tueendtime2_10,
wedstarttime1= wedstarttime1_11, 
wedendtime1	 = wedendtime1_12, 
wedstarttime2= wedstarttime2_13, 
wedendtime2	 = wedendtime2_14, 
thustarttime1= thustarttime1_15, 
thuendtime1	 = thuendtime1_16, 
thustarttime2= thustarttime2_17, 
thuendtime2	 = thuendtime2_18,
fristarttime1= fristarttime1_19, 
friendtime1	 = friendtime1_20, 
fristarttime2= fristarttime2_21, 
friendtime2	 = friendtime2_22, 
satstarttime1= satstarttime1_23, 
satendtime1	 = satendtime1_24, 
satstarttime2= satstarttime2_25, 
satendtime2	 = satendtime2_26, 
sunstarttime1= sunstarttime1_27, 
sunendtime1	 = sunendtime1_28, 
sunstarttime2= sunstarttime2_29, 
sunendtime2	 = sunendtime2_30, 
totaltime    = totaltime_31, 
validedatefrom= validedatefrom_32,  
validedateto= validedateto_33 ,  
scheduleType= scheduleType_34 
WHERE ( id	 = id_1);
end;
/

create or replace PROCEDURE HrmSchedule_Select_Current 
 (currentdate_1 varchar2,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 open thecursor for
 select * from HrmSchedule where scheduleType='3' and validedatefrom <= currentdate_1 and validedateto >= currentdate_1;
 end;
/