


CREATE TABLE wechat_platform (
[id] int NOT NULL IDENTITY(1,1) ,
[publicid] varchar(100) NOT NULL ,
[appid] varchar(100) NOT NULL ,
[appSecret] varchar(100) NOT NULL ,
[name] varchar(100) NULL ,
[description] varchar(100) NULL ,
[state] char(1) NULL ,
[accessToken] varchar(400) NULL ,
[expires] decimal(20) NULL DEFAULT ((0)) ,
[tokenLock] char(1) NULL ,
[subcompanyid] int NULL ,
[isdelete] char(1) NOT NULL DEFAULT ((0)),
[defaultReminder] char(1) NOT NULL DEFAULT ((0)),
[suffix] varchar(50) NULL,
[autoReply] char(1) NOT NULL DEFAULT ((0)) ,
[welcomeMsg] varchar(200) NULL 
)
GO

ALTER TABLE wechat_platform ADD PRIMARY KEY ([id])
GO


CREATE TABLE wechat_share (
[id] int NOT NULL IDENTITY(1,1) ,
[platformid] int NOT NULL ,
[permissiontype] int NULL ,
[typevalue] int NULL ,
[seclevel] int NULL ,
[seclevelMax] int NULL 
)
GO
ALTER TABLE wechat_share ADD PRIMARY KEY ([id])
GO


CREATE TABLE wechat_band  (
[id] int NOT NULL IDENTITY(1,1) ,
[publicid] varchar(100) NOT NULL ,
[openid] varchar(100) NULL ,
[userid] int NOT NULL ,
[usertype] int NOT NULL ,
[bandtime] varchar(19) NULL ,
[activetime] varchar(19) NULL ,
[ticket] varchar(255) NULL ,
[expires] decimal(20) NOT NULL DEFAULT ((0)) 
)
GO
ALTER TABLE wechat_band ADD PRIMARY KEY ([id])
GO


CREATE TABLE wechat_action (
[id] int NOT NULL IDENTITY(1,1) ,
[publicid] varchar(100) NULL ,
[msgtype] varchar(50) NULL ,
[eventtype] varchar(50) NULL ,
[eventkey] varchar(50) NULL ,
[classname] varchar(255) NULL ,
[type] char(1) NOT NULL DEFAULT ((1)) 
)
GO
ALTER TABLE wechat_action ADD PRIMARY KEY ([id])
GO
INSERT INTO wechat_action ([publicid], [msgtype], [eventtype], [eventkey], [classname], [type]) VALUES (null, 'event', 'scan', null, 'weaver.wechat.receive.ScanAction', '1');
GO
INSERT INTO wechat_action ( [publicid], [msgtype], [eventtype], [eventkey], [classname], [type]) VALUES (null, 'event', 'subscribe', null, 'weaver.wechat.receive.ScanAction', '1');
GO
INSERT INTO wechat_action ( [publicid], [msgtype], [eventtype], [eventkey], [classname], [type]) VALUES ( null, 'text', null, null, 'weaver.wechat.receive.TextAction', '1');
GO



CREATE TABLE wechat_msg(
[id] int NOT NULL IDENTITY(1,1) ,
[publicid] varchar(100) NOT NULL ,
[userid] int NULL ,
[usertype] int NULL ,
[msg] varchar(4000) NULL ,
[msgtype] int NULL ,
[touserid] int NULL ,
[tousertype] int NULL ,
[state] char(1) NULL ,
[createtime] char(19) NULL ,
[sendtime] char(19) NULL ,
[result] varchar(200) NULL ,
[msgId] varchar(200) NULL,
[isdelete] char(1) NOT NULL DEFAULT ((0))
)
GO
ALTER TABLE wechat_msg ADD PRIMARY KEY ([id])
GO






CREATE TABLE wechat_receive_event(
[id] int NOT NULL IDENTITY(1,1) ,
[event] varchar(200) NULL 
)
GO
ALTER TABLE wechat_receive_event ADD PRIMARY KEY ([id])
GO
ALTER TABLE wechat_receive_event ADD UNIQUE ([event] ASC)
GO

CREATE TABLE wechat_reply(
[id] int NOT NULL IDENTITY(1,1) ,
[publicid] varchar(100) NOT NULL ,
[name] varchar(100) NOT NULL ,
[replytype] char(1) NOT NULL ,
[replymsg] varchar(4000) NULL ,
[classname] varchar(100) NULL ,
[sort] decimal(11,2) NULL ,
[state] char(1) NOT NULL DEFAULT ((0)) 
)
GO
ALTER TABLE wechat_reply ADD PRIMARY KEY ([id])
GO
CREATE TABLE wechat_reply_rule (
[id] int NOT NULL IDENTITY(1,1) ,
[replyid] int NOT NULL ,
[keyword] varchar(100) NOT NULL ,
[keytype] char(1) NOT NULL DEFAULT ((0)) 
)
GO
ALTER TABLE wechat_reply_rule ADD PRIMARY KEY ([id])
GO


alter table wechat_band add token VARCHAR(200)
go
alter table wechat_band add tokenExpires decimal(20) DEFAULT 0 not null
GO


CREATE table wechat_set(
  id int NOT NULL PRIMARY key,
  oaUrl VARCHAR(200) null,
  mobileUrl VARCHAR(200) null,
  signPostion char(1) DEFAULT 1,
  username char(1)  DEFAULT 1,
  userid char(1)  DEFAULT 0,
  dept char(1) DEFAULT 0,
  subcomp char(1) DEFAULT 0
)
GO
INSERT into wechat_set(id) values(1)
go







CREATE table wechat_reminder_mode(
  modekey VARCHAR(50) PRIMARY key,
  modename VARCHAR(200) not null
)
GO
CREATE table wechat_reminder_type(
  type VARCHAR(50) PRIMARY key,
  typename VARCHAR(200) not null,
  modekey VARCHAR(50) not null
)
GO
CREATE table wechat_reminder_set(
  id int NOT NULL IDENTITY(1,1) PRIMARY key,
  prefix VARCHAR(200) null,
  prefixConnector VARCHAR(10) null,
  suffix VARCHAR(200) null,
  suffixConnector VARCHAR(10) null,
  type VARCHAR(100) not null,
  def char(1) not null
)
GO

