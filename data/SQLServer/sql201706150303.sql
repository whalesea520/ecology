EXEC sp_rename 'HrmGroupMembers',   'tempHrmGroupMembers'
GO
CREATE TABLE HrmGroupMembers
(
id INT PRIMARY KEY IDENTITY NOT NULL,
groupid int NOT NULL,
sharetype int NULL,
userid int NULL,
usertype char (1),
seclevel int NULL,
seclevelto int NULL,
rolelevel int NULL,
sharelevel int NULL,
subcompanyid int NULL,
departmentid int NULL,
roleid int NULL,
foralluser int NULL,
jobtitleid int NULL,
jobtitlelevel int NULL,
scopeid varchar (4000) NULL,
dsporder decimal(18, 2) NULL
)
GO
INSERT INTO HrmGroupMembers (groupid,userid,usertype,dsporder)
SELECT groupid,userid,usertype,dsporder FROM tempHrmGroupMembers
GO
UPDATE HrmGroupMembers SET sharetype=1
GO
ALTER TABLE HrmGroup
ADD orggroupid INT NULL
GO
ALTER TABLE HrmGroupMembers
ADD orggroupid INT NULL
GO
INSERT INTO HrmGroup
        ( orggroupid, name, type, owner, sn )
SELECT id, orgGroupName, 1, 1, showOrder from HrmOrgGroup WHERE isDelete <> 1
GO
INSERT INTO HrmGroupMembers( orggroupid ,groupid,sharetype ,subcompanyid,seclevel ,seclevelto )
SELECT orgGroupId,-10000,type,content,secLevelFrom,secLevelTo FROM HrmOrgGroupRelated WHERE
orgGroupId in (SELECT id from HrmOrgGroup WHERE isDelete <> 1) and type=2
GO
INSERT INTO HrmGroupMembers( orggroupid ,groupid,sharetype ,departmentid,seclevel ,seclevelto )
SELECT orgGroupId,-10000,type,content,secLevelFrom,secLevelTo FROM HrmOrgGroupRelated WHERE 
orgGroupId in (SELECT id from HrmOrgGroup WHERE isDelete <> 1) and type=3
GO
UPDATE HrmGroupMembers SET groupid=(SELECT DISTINCT id FROM HrmGroup WHERE HrmGroupMembers.orggroupid=HrmGroup.orggroupid)
WHERE groupid=-10000
GO
INSERT INTO HrmGroupShare( groupid , sharetype , foralluser, seclevel ,seclevelto)
SELECT id,5,1,0,100 FROM HrmGroup WHERE orggroupid IS NOT NULL
GO
