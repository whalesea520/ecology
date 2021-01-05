create table social_IMSetting(
  id int IDENTITY,
  userid int,
  targetid VARCHAR(500),
  remindType int,
  targetType int
)
GO
create table social_IMFile(
  id int IDENTITY,
  userid int,
  targetid VARCHAR(500),
  targetType int,
  fileid int,
  fileName VARCHAR(500),
  fileSize int,
  fileType VARCHAR(10),
  createdate VARCHAR(20),
  downCount int DEFAULT 0
)
GO
create table social_IMFileShare(
  id int IDENTITY,
  userid int,
  fileid int
)
GO
