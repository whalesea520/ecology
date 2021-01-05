CREATE TABLE HRMSCHEDULESIGNIMP(
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[userId] [int] NULL,
	[userType] [char](1) NULL,
	[signType] [char](1) NULL,
	[signDate] [char](10) NULL,
	[signTime] [char](8) NULL,
	[clientAddress] [varchar](120) NULL,
	[isInCom] [char](1) NULL,
	[signFrom] [varchar](400) NULL,
	[LONGITUDE] [varchar](400) NULL,
	[LATITUDE] [varchar](400) NULL,
	[ADDR] [varchar](1000) NULL,
	[wxsignaddress] [varchar](1000) NULL,
	[eb_deviceid] [varchar](64) NULL,
	[eb_deviceid_change] [int] NULL,
	[importsql] [varchar](400) NULL,
	[impdatetime] [char](20) NULL,
	[suuid] [varchar](400) NULL,
	[uuid] [varchar](400) NULL,
  delflag           CHAR(1)
) 
GO

alter table HRMSCHEDULESIGN add  suuid VARCHAR(1000)
GO