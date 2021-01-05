delete from workflow_browserurl where id=184
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 184,24168,'varchar(400)','/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MutilMeetingRoomBrowser.jsp?selectedids=','MeetingRoom','name','id','/meeting/Maint/MeetingRoom.jsp?id=')
/
alter table meetingroom add images varchar2(300)
/
alter table meeting add (addressnew varchar2(4000),addressnew2 varchar2(4000))
/
update meeting set addressnew=address,addressnew2=ck_address
/
alter table meeting drop column address
/
alter table meeting rename column addressnew to address
/
alter table meeting drop column ck_address
/
alter table meeting rename column addressnew2 to ck_address
/
alter table bill_meeting add addressnew varchar2(4000)
/
update bill_meeting set addressnew=address
/
alter table bill_meeting drop column address
/
alter table bill_meeting rename column addressnew to address
/
ALTER table MeetingRoom add  hrmids VARCHAR2(300)
/
update meetingroom set hrmids=hrmid
/
update workflow_billfield set type=184,fielddbtype='varchar2(4000)' where type=87 and fieldname='Address' and  billid=85
/
update meeting_formfield set fielddbtype='varchar2(4000)',type=184 where fieldname='address'
/
CREATE OR REPLACE PROCEDURE P_updateAddress
AS
billid integer;tablename VARCHAR2(2000);rs SYS_REFCURSOR;
begin
OPEN rs for SELECT billid,tablename FROM  meeting_bill where defined=1 and billid<>85;
loop
  fetch rs into billid,tablename;
  exit when rs%NOTFOUND;

  execute immediate 'alter table '||tablename||' add addressNew varchar2(4000)';

  execute immediate 'update '||tablename||' set addressNew=address';

  execute immediate 'alter table '||tablename||' drop column  address';
  
  execute immediate 'ALTER TABLE '||tablename||' RENAME COLUMN addressNew TO address';

  execute immediate 'update workflow_billfield set fielddbtype=''varchar(4000)'' , type=184 where fieldname=''address'' and billid='||to_char(billid);
end loop;
END;
/
call P_updateAddress()
/
drop PROCEDURE P_updateAddress
/
CREATE OR REPLACE PROCEDURE Meeting_Insert(meetingtype_1 integer, name_1 varchar2, caller_1 integer, contacter_1 integer, projectid_1 integer, address_1 varchar2, begindate_1 varchar2, begintime_1 varchar2, enddate_1 varchar2, endtime_1 varchar2, desc_n_1 varchar2, creater_1 integer, createdate_1 varchar2, createtime_1 varchar2, totalmember_1 integer, othermembers_1 clob, addressdesc_1 varchar2, description_1 varchar2, remindType_1 integer, remindBeforeStart_1 integer, remindBeforeEnd_1   integer, remindTimesBeforeStart_1 integer, remindTimesBeforeEnd_1 integer, customizeAddress_1 varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS begin INSERT INTO Meeting (meetingtype, name, caller, contacter, projectid, address, begindate, begintime, enddate, endtime, desc_n, creater, createdate, createtime, totalmember, othermembers, addressdesc, description, remindType, remindBeforeStart, remindBeforeEnd, remindTimesBeforeStart, remindTimesBeforeEnd, customizeAddress) VALUES (meetingtype_1, name_1, caller_1, contacter_1, projectid_1, address_1, begindate_1, begintime_1, enddate_1, endtime_1, desc_n_1, creater_1, createdate_1, createtime_1, totalmember_1, othermembers_1, addressdesc_1, description_1, remindType_1, remindBeforeStart_1, remindBeforeEnd_1, remindTimesBeforeStart_1, remindTimesBeforeEnd_1, customizeAddress_1); end;
/
CREATE OR REPLACE PROCEDURE Meeting_Update(meetingid_1 integer, name_1 varchar2, caller_1  integer, contacter_1 integer, projectid_1 integer, address_1 varchar2, begindate_1 varchar2, begintime_1 varchar2, enddate_1 varchar2, endtime_1 varchar2, desc_n_1  varchar2, totalmember_1 integer, othermembers_1 clob, addressdesc_1 varchar2, description_1 varchar2, remindType_1 integer, remindBeforeStart_1 integer, remindBeforeEnd_1 integer, remindTimesBeforeStart_1 integer, remindTimesBeforeEnd_1 integer, customizeAddress_1 varchar2, flag out integer, msg out varchar, thecursor IN OUT cursor_define.weavercursor) AS begin Update Meeting set name = name_1, caller  = caller_1, contacter = contacter_1, projectid = projectid_1, address = address_1, begindate = begindate_1, begintime = begintime_1, enddate = enddate_1, endtime = endtime_1, desc_n  = desc_n_1, totalmember = totalmember_1, othermembers = othermembers_1, addressdesc = addressdesc_1, description = description_1, remindType = remindType_1, remindBeforeStart= remindBeforeStart_1, remindBeforeEnd  = remindBeforeEnd_1, remindTimesBeforeStart=remindTimesBeforeStart_1, remindTimesBeforeEnd=remindTimesBeforeEnd_1, customizeAddress = customizeAddress_1 where id = meetingid_1; end;
/
update workflow_base set custompage='/meeting/template/MeetingSubmitRequestJs.jsp',custompage4Emoble='/meeting/template/MeetingSubmitRequestJs4Mobile.jsp' where id in(select id from workflow_base wb join meeting_bill mb on mb.billid=wb.formid where mb.billid<>85 and mb.defined=1)
/