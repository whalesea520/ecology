create table CRM_SellchanceAtt(
  id int IDENTITY,
  resourceid int,
  sellchanceid int
)
GO

CREATE TABLE CRM_SellchanceLabel (
	id int NOT NULL IDENTITY(1,1) ,
	userid int NULL ,
	name varchar(200) NULL ,
	labelColor  varchar(200) NULL ,
	createdate varchar(50) NULL ,
	createtime varchar(50) NULL ,
	isUsed int NULL ,
	labelOrder int NULL ,
	labelType varchar(100) NULL ,
	textColor varchar(20) NULL 
)
GO

CREATE TABLE CRM_Sellchance_label (
	id int NOT NULL IDENTITY(1,1) ,
	userid int null,
	sellchanceid int NULL ,
	labelid int NULL 
)
GO

