CREATE TABLE blog_app
	(
	id       INT IDENTITY NOT NULL,
	name     VARCHAR (20) NULL,
	isActive INT NULL,
	appType  VARCHAR (50) NULL,
	sort     INT NULL,
	iconPath VARCHAR (255) NULL
	)
GO

INSERT INTO blog_app (name, isActive, appType, sort, iconPath)
VALUES ('26769', 1, 'mood', 1, 'images/crm.png')
GO

INSERT INTO blog_app (name, isActive, appType, sort, iconPath)
VALUES ('58', 1, 'doc', 2, 'images/app-doc.png')
GO

INSERT INTO blog_app (name, isActive, appType, sort, iconPath)
VALUES ('18015', 1, 'workflow', 3, 'images/app-wl.png')
GO

INSERT INTO blog_app (name, isActive, appType, sort, iconPath)
VALUES ('136', 1, 'crm', 4, 'images/app-crm.png')
GO

INSERT INTO blog_app (name, isActive, appType, sort, iconPath)
VALUES ('101', 1, 'project', 5, 'images/app-project.png')
GO

INSERT INTO blog_app (name, isActive, appType, sort, iconPath)
VALUES ('1332', 1, 'task', 6, 'images/app-task.png')
GO


CREATE TABLE blog_appDatas
	(
	id         INT IDENTITY NOT NULL,
	userid     INT NOT NULL,
	workDate   VARCHAR (10) NOT NULL,
	createDate VARCHAR (10) NOT NULL,
	createTime VARCHAR (10) NOT NULL,
	discussid  INT NOT NULL,
	appItemId  INT NOT NULL
	)
GO

CREATE TABLE blog_AppItem
	(
	id       INT IDENTITY NOT NULL,
	itemName VARCHAR (20) NULL,
	value    INT NOT NULL,
	type     VARCHAR (20) NOT NULL,
	face     VARCHAR (500) NULL
	)
GO

INSERT INTO blog_AppItem (itemName, value, type, face)
VALUES ('26917', 4, 'mood', '/blog/images/mood-happy.png')
GO

INSERT INTO blog_AppItem (itemName, value, type, face)
VALUES ('26918', 2, 'mood', '/blog/images/mood-unhappy.png')
GO

CREATE TABLE blog_attention
	(
	id          INT IDENTITY NOT NULL,
	userid      INT NULL,
	attentionid INT NULL
	)
GO

CREATE TABLE blog_cancelAttention
	(
	id          INT IDENTITY NOT NULL,
	userid      INT NULL,
	attentionid INT NULL
	)
GO

CREATE TABLE blog_discuss
	(
	id             INT IDENTITY NOT NULL,
	userid         INT NULL,
	createdate     VARCHAR (10) NULL,
	createtime     VARCHAR (10) NULL,
	content        TEXT NULL,
	lastUpdatetime VARCHAR (50) NULL,
	isReplenish    INT NULL,
	workdate       VARCHAR (10) NULL
	)
GO

CREATE TABLE blog_read
	(
	id     INT IDENTITY NOT NULL,
	userid INT NULL,
	blogid INT NULL
	)
GO

CREATE TABLE blog_remind
	(
	id          INT IDENTITY NOT NULL,
	remindid    INT NULL,
	relatedid   INT NULL,
	remindType  INT NULL,
	remindValue VARCHAR (100) NULL,
	status      INT NULL,
	createdate  VARCHAR (10) NULL,
	createtime  VARCHAR (10) NULL
	)
GO

CREATE TABLE blog_reportTemp
	(
	id        INT IDENTITY NOT NULL,
	userid    INT NULL,
	tempName  VARCHAR (50) NULL,
	isDisplay INT NULL,
	isDefault INT NULL,
	sort      INT NULL
	)
GO

CREATE TABLE blog_setting
	(
	id           INT IDENTITY NOT NULL,
	userid       INT NULL,
	isReceive    INT NULL,
	maxAttention INT NULL,
	isThumbnail  INT NULL
	)
GO

CREATE TABLE blog_share
	(
	id         INT IDENTITY NOT NULL,
	blogid     INT NULL,
	type       INT NULL,
	content    VARCHAR (4000) NULL,
	seclevel   INT NULL,
	sharelevel INT NULL
	)
GO

CREATE TABLE blog_sysSetting
	(
	id           INT IDENTITY NOT NULL,
	allowRequest INT NULL,
	enableDate   VARCHAR (10) NULL,
	isSingRemind INT NULL
	)
GO

INSERT INTO blog_sysSetting (allowRequest, enableDate,isSingRemind)
VALUES (1, '2011-09-01',0)
GO

CREATE TABLE blog_tempCondition
	(
	id      INT IDENTITY NOT NULL,
	tempid  INT NULL,
	type    INT NULL,
	content VARCHAR (50) NULL
	)
GO

CREATE TABLE blog_visit
	(
	id        INT IDENTITY NOT NULL,
	userid    INT NULL,
	blogid    INT NULL,
	visitdate VARCHAR (10) NULL,
	visittime VARCHAR (10) NULL
	)
GO
CREATE TABLE blog_reply
	(
	id         INT IDENTITY NOT NULL,
	userid     INT NULL,
	discussid  INT NULL,
	createdate VARCHAR (10) NULL,
	createtime VARCHAR (10) NULL,
	content    TEXT NULL
	)
GO

UPDATE LeftMenuInfo SET module='blog' WHERE id=392
GO

UPDATE MainMenuInfo SET module='blog' WHERE id=1047
GO