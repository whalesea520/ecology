rename HrmGroupMembers to tempHrmGroupMembers
/
CREATE TABLE HrmGroupMembers
(
id integer ,
groupid integer NOT NULL,
sharetype integer NULL,
userid integer NULL,
usertype char (1),
seclevel integer NULL,
seclevelto integer NULL,
rolelevel integer NULL,
sharelevel integer NULL,
subcompanyid integer NULL,
departmentid integer NULL,
roleid integer NULL,
foralluser integer NULL,
jobtitleid integer NULL,
jobtitlelevel integer NULL,
scopeid varchar (4000) NULL,
dsporder NUMBER(18,2) NULL
)
/
create sequence HrmGroupMembers_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 50
order
/
CREATE OR REPLACE TRIGGER HRMGROUPMEMBERS_TRIGGER before insert on HrmGroupMembers for each row
begin select HrmGroupMembers_ID.nextval INTO :new.id from dual; end;
/
drop trigger HRMGROUPMEMBERTIMESTAMP_TRI
/ 
CREATE OR REPLACE TRIGGER HRMGROUPMEMBERTIMESTAMP_TRI AFTER INSERT OR DELETE OR UPDATE ON HRMGROUPMEMBERS FOR EACH ROW
BEGIN
  if INSERTING or DELETING then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='HrmGroupMember';
  elsif NVL(:new.groupid,0)<>NVL(:old.groupid,0) or NVL(:new.userid,0)<>NVL(:old.userid,0) then
    update mobileSyncInfo set syncLastTime=(SYSDATE - TO_DATE('1970-1-1', 'YYYY-MM-DD')) * 86400 where syncTable='HrmGroupMember';
  end if;
END;
/
INSERT INTO HrmGroupMembers (groupid,userid,usertype,dsporder)
SELECT groupid,userid,usertype,dsporder FROM tempHrmGroupMembers
/
UPDATE HrmGroupMembers SET sharetype=1
/
ALTER TABLE HrmGroup
ADD orggroupid INT NULL
/
ALTER TABLE HrmGroupMembers
ADD orggroupid INT NULL
/
INSERT INTO HrmGroup( orggroupid, name, type, owner, sn )
SELECT id, orgGroupName, 1, 1, showOrder from HrmOrgGroup WHERE isDelete <> 1
/
INSERT INTO HrmGroupMembers( orggroupid ,groupid,sharetype ,subcompanyid,seclevel ,seclevelto )
SELECT orgGroupId,-10000,type,content,secLevelFrom,secLevelTo FROM HrmOrgGroupRelated WHERE
orgGroupId in (SELECT id from HrmOrgGroup WHERE isDelete <> 1) and type=2
/
INSERT INTO HrmGroupMembers( orggroupid ,groupid,sharetype ,departmentid,seclevel ,seclevelto )
SELECT orgGroupId,-10000,type,content,secLevelFrom,secLevelTo FROM HrmOrgGroupRelated WHERE 
orgGroupId in (SELECT id from HrmOrgGroup WHERE isDelete <> 1) and type=3
/
UPDATE HrmGroupMembers SET groupid=(SELECT DISTINCT id FROM HrmGroup WHERE HrmGroupMembers.orggroupid=HrmGroup.orggroupid)
WHERE groupid=-10000
/
INSERT INTO HrmGroupShare( groupid , sharetype , foralluser, seclevel ,seclevelto)
SELECT id,5,1,0,100 FROM HrmGroup WHERE orggroupid IS NOT NULL
/
