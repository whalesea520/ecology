CREATE TABLE HrmAnnualLeaveInfo (
	id int NOT NULL ,
	requestid   int  NULL ,
	resourceid   int  NULL ,
	startdate   varchar  (30) NULL ,
	starttime   varchar  (30) NULL ,
	enddate   varchar  (30) NULL ,
	endtime   varchar  (30) NULL ,
	leavetime   float  NULL ,
	occurdate   varchar  (30) NULL ,
	otherleavetype   int  NULL ,
        leavetype   int  NULL,        
	status int NULL 
)
/

create sequence HrmAnnualLeaveInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmAnnualLeaveInfo_Trigger
before insert on HrmAnnualLeaveInfo
for each row
begin
select HrmAnnualLeaveInfo_id.nextval into :new.id from dual;
end;
/

create table hrmLeaveTypeColor(
   id int not null,
   itemid int null,
   color varchar(30),
   subcompanyid int
)
/
create sequence hrmLeaveTypeColor_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger hrmLeaveTypeColor_Trigger
before insert on hrmLeaveTypeColor
for each row
begin
select hrmLeaveTypeColor_id.nextval into :new.id from dual;
end;
/


create table HrmAnnualManagement(
   id int not null,
   resourceid int,   
   annualyear varchar(30),   
   annualdays float,
   status int
)
/
create sequence HrmAnnualManagement_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmAnnualManagement_Trigger
before insert on HrmAnnualManagement
for each row
begin
select HrmAnnualManagement_id.nextval into :new.id from dual;
end;
/

create table HrmAnnualBatchProcess(
   id int not null,
   workingage float,
   annualdays float,
   subcompanyid int     
)
/
create sequence HrmAnnualBatchProcess_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmAnnualBatchProcess_Trigger
before insert on HrmAnnualBatchProcess
for each row
begin
select HrmAnnualBatchProcess_id.nextval into :new.id from dual;
end;
/
create table HrmAnnualPeriod(
   id int not null,
   annualyear varchar(30),
   startdate varchar(30),
   enddate varchar(30),
   subcompanyid int   
)
/
create sequence HrmAnnualPeriod_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmAnnualPeriod_Trigger
before insert on HrmAnnualPeriod
for each row
begin
select HrmAnnualPeriod_id.nextval into :new.id from dual;
end;
/


CREATE TABLE Bill_BoHaiLeave ( 
    id int not null,
    resourceId int,
    departmentId int,
    leaveType int,
    otherLeaveType int,
    fromDate char(10),
    fromTime char(8),
    toDate char(10),
    toTime char(8),
    leaveDays float,
    leaveReason varchar(500),
    requestid int) 
/
create sequence Bill_BoHaiLeave_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Bill_BoHaiLeave_Trigger
before insert on Bill_BoHaiLeave
for each row
begin
select Bill_BoHaiLeave_id.nextval into :new.id from dual;
end;
/

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(180,20063,'Bill_BoHaiLeave','AddBillBoHaiLeave.jsp','ManageBillBoHaiLeave.jsp','ViewBillBoHaiLeave.jsp','','','BillBoHaiLeaveOperation.jsp') 
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'resourceId',413,'int',3,1,0,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'departmentId',124,'int',3,4,1,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'leaveType',1881,'char(2)',5,0,2,0,'')
/

INSERT INTO workflow_SelectItem(fieldid,isbill,selectvalue,selectname,listorder,isdefault) select max(id),1,1,'ÊÂ¼Ù',1,'n' from workflow_billfield where fieldname='leaveType'
/
INSERT INTO workflow_SelectItem(fieldid,isbill,selectvalue,selectname,listorder,isdefault) select max(id),1,2,'²¡¼Ù',2,'n' from workflow_billfield where fieldname='leaveType'
/
INSERT INTO workflow_SelectItem(fieldid,isbill,selectvalue,selectname,listorder,isdefault) select max(id),1,3,'ÆäËü·Ç´øÐ½¼Ù',3,'n' from workflow_billfield where fieldname='leaveType'
/
INSERT INTO workflow_SelectItem(fieldid,isbill,selectvalue,selectname,listorder,isdefault) select max(id),1,4,'ÆäËü´øÐ½¼Ù',4,'n' from workflow_billfield where fieldname='leaveType'
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'otherLeaveType',20053,'char(2)',5,0,3,0,'')
/

INSERT INTO workflow_SelectItem(fieldid,isbill,selectvalue,selectname,listorder,isdefault) select max(id),1,1,'Ì½Ç×¼Ù',1,'n' from workflow_billfield where fieldname='otherLeaveType'
/
INSERT INTO workflow_SelectItem(fieldid,isbill,selectvalue,selectname,listorder,isdefault) select max(id),1,2,'Äê¼Ù',2,'n' from workflow_billfield where fieldname='otherLeaveType'
/
INSERT INTO workflow_SelectItem(fieldid,isbill,selectvalue,selectname,listorder,isdefault) select max(id),1,3,'»é¼Ù',3,'n' from workflow_billfield where fieldname='otherLeaveType'
/
INSERT INTO workflow_SelectItem(fieldid,isbill,selectvalue,selectname,listorder,isdefault) select max(id),1,4,'²ú¼Ù¼°¿´»¤¼Ù',4,'n' from workflow_billfield where fieldname='otherLeaveType'
/
INSERT INTO workflow_SelectItem(fieldid,isbill,selectvalue,selectname,listorder,isdefault) select max(id),1,5,'²¸Èé¼Ù',5,'n' from workflow_billfield where fieldname='otherLeaveType'
/
INSERT INTO workflow_SelectItem(fieldid,isbill,selectvalue,selectname,listorder,isdefault) select max(id),1,6,'É¥¼Ù',6,'n' from workflow_billfield where fieldname='otherLeaveType'
/
INSERT INTO workflow_SelectItem(fieldid,isbill,selectvalue,selectname,listorder,isdefault) select max(id),1,7,'¶ùÍ¯Åã»¤¼Ù',7,'n' from workflow_billfield where fieldname='otherLeaveType'
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'fromDate',1322,'char(10)',3,2,4,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'fromTime',17690,'char(8)',3,19,5,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'toDate',741,'char(10)',3,2,6,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'toTime',743,'char(8)',3,19,7,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'leaveDays',828,'float',1,3,8,0,'')
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'lastyearannualdays',21614,'float',1,3,8,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'thisyearannualdays',21615,'float',1,3,8,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'allannualdays',21616,'float',1,3,8,0,'')
/ 
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'leaveReason',20054,'varchar(500)',2,0,9,0,'')
/ 

alter table bill_bohaileave add lastyearannualdays float
/
alter table bill_bohaileave add thisyearannualdays float
/
alter table bill_bohaileave add allannualdays float
/