alter table Meeting add roomType int
GO
alter table Meeting add repeatType int
GO
alter table Meeting add repeatdays int
GO

alter table Meeting add repeatweeks int
GO

alter table Meeting add rptWeekDays varchar(20)
GO

alter table Meeting add repeatmonths int
GO

alter table Meeting add repeatmonthdays int
GO

alter table Meeting add repeatbegindate varchar(10)
GO

alter table Meeting add repeatenddate varchar(10)
GO

alter table Meeting add decisionwfids varchar(500)
GO

alter table Meeting add decisioncrmids varchar(500)
GO

alter table Meeting add decisionprjids varchar(500)
GO

alter table Meeting add decisiontskids varchar(500)
GO

alter table Meeting add decisionatchids varchar(500)
GO

alter table Meeting add repeatStrategy int
GO

alter table Meeting add repeatMeetingId int
GO


alter table Meeting_Type add dsporder decimal(4,1)
GO


alter table MeetingRoom add status varchar(1)
GO
alter table MeetingRoom add equipment varchar(1000)
GO
alter table MeetingRoom add dsporder decimal(4,1)
GO

alter table MeetingRoom_share add roleid int
GO
alter table MeetingRoom_share add rolelevel int
GO
alter table MeetingRoom_share add roleseclevel int
GO
alter table MeetingRoom_share add roleseclevelMax int
GO

alter table MeetingType_share add roleid int
GO
alter table MeetingType_share add rolelevel int
GO
alter table MeetingType_share add roleseclevel int
GO
alter table MeetingType_share add roleseclevelMax int
GO

alter table Meeting_Member add roleid int
GO
alter table Meeting_Member add rolelevel int
GO
alter table Meeting_Member add seclevel int
GO
alter table Meeting_Member add seclevelMax int
GO
alter table Meeting_Member add departmentid int
GO
alter table Meeting_Member add subcompanyid int
GO

alter table MeetingCaller add subcompanyid int
GO
alter table MeetingCaller add seclevelMax int
GO


UPDATE workflow_billfield SET fieldlabel = 2168 WHERE id = 625
GO
alter table Bill_Meeting add repeatType int
GO
alter table Bill_Meeting add repeatdays int
GO

alter table Bill_Meeting add repeatweeks int
GO

alter table Bill_Meeting add rptWeekDays varchar(20)
GO

alter table Bill_Meeting add repeatmonths int
GO

alter table Bill_Meeting add repeatmonthdays int
GO

INSERT INTO workflow_billfield(billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype,type,viewtype,fromuser,dsporder,detailtable)
VALUES(85,'repeatType',32578,'int','5',1,0,'1',3.1,'')
GO
INSERT INTO workflow_SelectItem(fieldid,isbill,selectvalue,selectname,listorder,isdefault) select max(id),1,0,'不重复',0,'n' from workflow_billfield where billid=85 and fieldname='repeatType'
GO
INSERT INTO workflow_SelectItem(fieldid,isbill,selectvalue,selectname,listorder,isdefault) select max(id),1,1,'按天重复',1,'n' from workflow_billfield where billid=85 and fieldname='repeatType'
GO
INSERT INTO workflow_SelectItem(fieldid,isbill,selectvalue,selectname,listorder,isdefault) select max(id),1,2,'按周重复',2,'n' from workflow_billfield where billid=85 and fieldname='repeatType'
GO
INSERT INTO workflow_SelectItem(fieldid,isbill,selectvalue,selectname,listorder,isdefault) select max(id),1,3,'按月重复',3,'n' from workflow_billfield where billid=85 and fieldname='repeatType'
GO
INSERT INTO workflow_billfield(billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype,type,viewtype,fromuser,dsporder,detailtable)
VALUES(85,'repeatdays',32579,'int','1',2,0,'1',3.2,'')
GO
INSERT INTO workflow_billfield(billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype,type,viewtype,fromuser,dsporder,detailtable)
VALUES(85,'repeatweeks',32580,'int','1',2,0,'1',3.3,'')
GO
INSERT INTO workflow_billfield(billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype,type,viewtype,fromuser,dsporder,detailtable)
VALUES(85,'rptWeekDays',32582,'varchar(20)','1',1,0,'1',3.4,'')
GO
INSERT INTO workflow_billfield(billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype,type,viewtype,fromuser,dsporder,detailtable)
VALUES(85,'repeatmonths',32581,'int','1',2,0,'1',3.5,'')
GO

INSERT INTO workflow_billfield(billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype,type,viewtype,fromuser,dsporder,detailtable)
VALUES(85,'repeatmonthdays',32583,'int','1',2,0,'1',3.6,'')
GO
INSERT INTO workflow_billfield(billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype,type,viewtype,fromuser,dsporder,detailtable)
VALUES(85,'crmsNumber',32591,'int','1',2,0,'1',10.1,'')
GO
alter table Bill_Meeting add crmsNumber int
GO
alter table Bill_Meeting add services varchar(2000)
GO

alter table MeetingSet add subcompanyid int
GO
alter table MeetingSet add dscsDoc int
GO
alter table MeetingSet add dscsWf int
GO
alter table MeetingSet add dscsCrm int
GO
alter table MeetingSet add dscsPrj int
GO
alter table MeetingSet add dscsTsk int
GO
alter table MeetingSet add dscsAttch int
GO
alter table MeetingSet add dscsAttchCtgry varchar(255)
GO
alter table MeetingSet add tpcDoc int
GO
alter table MeetingSet add tpcWf int
GO
alter table MeetingSet add tpcCrm int
GO
alter table MeetingSet add tpcPrj int
GO
alter table MeetingSet add tpcTsk int
GO
alter table MeetingSet add tpcAttch int
GO
alter table MeetingSet add tpcAttchCtgry varchar(255)
GO
alter table MeetingSet add mtngAttchCtgry varchar(255)
GO
alter table MeetingSet add callerPrm int
GO
alter table MeetingSet add contacterPrm int
GO
alter table MeetingSet add createrPrm int
GO
alter table MeetingSet add memberConflictChk int
GO
alter table MeetingSet add memberConflict int
GO
alter table MeetingSet add tpcprjflg int
GO
alter table MeetingSet add tpccrmflg int
GO
alter table MeetingSet add days int
GO

UPDATE MeetingSet SET subcompanyid = -1,
dscsDoc=1,
dscsWf=1,
dscsCrm=1,
dscsPrj=1,
dscsTsk=1,
dscsAttch=0,
dscsAttchCtgry='',
tpcDoc=1,
tpcWf=1,
tpcCrm=1,
tpcPrj=1,
tpcTsk=1,
tpcAttch=1,
tpcAttchCtgry='',
mtngAttchCtgry='',
callerPrm=1,
contacterPrm=1,
createrPrm=1,
memberConflictChk=1,
memberConflict=1,
tpcprjflg=1,
tpccrmflg=1,
days=1
GO