create table social_IMAttention (
  id int IDENTITY,
  userid int,
  targetid VARCHAR(100),
  targettype VARCHAR(20)
)
GO
create table social_IMChatResource (
  id int IDENTITY,
  resourceid int,
  resourcename varchar(100),
  resourcedesc varchar(100),
  resourcetype char(2),
  creatorid int,
  createtime varchar(100),
  targetid varchar(100),
  targettype varchar(20),
  memberids varchar(900)
)
GO
create table social_IMConversation (
	id int IDENTITY,
	userid int,
	targetid VARCHAR(100),
	targettype VARCHAR(20),
	targetPortrait VARCHAR(100),
	targetname VARCHAR(100),
	msgcontent VARCHAR(4000),
	unreadcnt int,
	istop CHAR(1),
	lasttime VARCHAR(100) 
)
GO
create TABLE social_IMMsgCount(
  id int IDENTITY,
  msgid VARCHAR(100),
  receiverid int,
  status int
)
GO

create TABLE social_IMRecent(
  id int IDENTITY,
  userid int,
  targetid VARCHAR(100),
  targetType int,
  lasttime varchar(20)
)
GO
create TABLE social_IMMsgRead(
  id int IDENTITY,
  msgid VARCHAR(100),
  receiverid int,
  status int
)
GO

CREATE INDEX social_IMMsgRead_index ON social_IMMsgRead (msgid DESC) 
GO

create TABLE im_MsgInitRecord(
  id int IDENTITY,
  msgid VARCHAR(100),
)
GO

CREATE INDEX im_MsgInitRecord_index ON im_MsgInitRecord (msgid DESC) 
GO

CREATE INDEX social_IMMsgCount_index ON im_MsgInitRecord (msgid DESC)
GO