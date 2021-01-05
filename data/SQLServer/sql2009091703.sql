create table bill_hrmtimedetail(
id int IDENTITY(1,1) primary key CLUSTERED,
requestid int,
name varchar(50),
resourceid int,
accepterid text,
begindate char(10),
begintime char(8),
enddate char(10),
endtime char(8),
wakedate char(10),
delaydate char(10),
crmid int,
projectid int,
relatedrequestid int,
isopen int,
remark text,
alldoc text,
requestlevel int
)
GO
alter table bill_HrmTime alter COLUMN resourceid int null
GO
