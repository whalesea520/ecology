
CREATE TABLE CRM_CustomerTypePersonal
	(
	userId          INT NULL,
	mainType        INT NULL,
	subType         INT NULL
	)
GO

CREATE TABLE CRM_Exchange_Info(
   sortid      INT NULL,
   type_n    CHAR (2) NULL,
   readDate  CHAR (10) NULL,
   readTime  CHAR (10) NULL,
   recentId INT NULL,
   userid INT NULL
)
GO


CREATE TABLE crm_selectitem
	(
	fieldid     INT NOT NULL,
	selectvalue INT NOT NULL,
	selectname  VARCHAR (250) NULL,
	fieldorder  INT NOT NULL,
	isdel INT
	)
GO

DELETE FROM LeftMenuConfig WHERE id IN 
	(SELECT t1.id FROM LeftMenuConfig  t1, LeftMenuInfo t2 WHERE t1.infoId = t2.id AND t2.parentId = 3)
GO

DELETE FROM LeftMenuInfo WHERE parentId = 3 AND id IN (24,25,26,27,28,29,30,31,32,33,34,103,104,105,106,279)
GO


Delete from MainMenuInfo where id=241
GO

Delete from MainMenuInfo where id=345
GO

Delete from MainMenuInfo where id=245
GO

UPDATE MainMenuInfo SET linkAddress = '/CRM/report/CRMContactLogRpFrame.jsp' WHERE id = 237
GO

UPDATE MainMenuInfo SET linkAddress = '/CRM/sellchance/SellChanceReportFrame.jsp' WHERE id = 330
GO

UPDATE MainMenuInfo SET linkAddress = '/CRM/sellchance/SellStatusRpSumFrame.jsp' WHERE id = 332
GO

UPDATE MainMenuInfo SET linkAddress = '/CRM/sellchance/SuccessRpSumFrame.jsp' WHERE id = 333
GO

UPDATE MainMenuInfo SET linkAddress = '/CRM/sellchance/FailureRpSumFrame.jsp' WHERE id = 334
GO

UPDATE MainMenuInfo SET linkAddress = '/CRM/sellchance/SellTimeRpSumFrame.jsp' WHERE id = 335
GO

UPDATE MainMenuInfo SET linkAddress = '/CRM/report/CRMModifyLogRpFrame.jsp' WHERE id = 346
GO

UPDATE MainMenuInfo SET linkAddress = '/CRM/report/CRMViewLogRpFrame.jsp' WHERE id = 347
GO


alter table CRM_CustomerContacter add projectrole varchar(100)
GO
alter table CRM_CustomerContacter add attitude varchar(50)
GO
alter table CRM_SellChance add selltype int
GO
alter table WorkPlan add sellchanceid int
GO
alter table WorkPlan add contacterid int
GO
alter table CRM_CustomerContacter add attention varchar(200)
GO

ALTER TABLE CRM_Log ADD id [INT] IDENTITY (1,1) NOT NULL
GO