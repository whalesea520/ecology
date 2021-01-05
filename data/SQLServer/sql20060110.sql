/*增加iconUrl字段*/
ALTER TABLE MainMenuInfo ADD iconUrl VARCHAR(100) NULL
GO

/**/
ALTER TABLE LeftMenuInfo ADD isCustom CHAR(1) DEFAULT '0'
GO

/*登录模板表*/
CREATE TABLE [SystemLoginTemplate] (
	[loginTemplateId] [int] IDENTITY (1, 1) NOT NULL ,
	[loginTemplateName] [varchar] (100) NULL ,
	[loginTemplateTitle] [varchar] (50) NULL ,
	[templateType] [char] (1) NULL ,
	[imageId] [varchar] (100) NULL ,
	[isCurrent] [char] (1) NULL ,
)
GO

/*系统模板表*/
CREATE TABLE [SystemTemplate] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[templateName] [varchar] (50) NOT NULL ,
	[companyId] [int] NULL ,
	[logo] [varchar] (100) NULL ,
	[topBgColor] [varchar] (50) NULL ,
	[topBgImage] [varchar] (100) NULL ,
	[toolbarBgColor] [varchar] (50) NULL ,
	[toolbarBgImage] [varchar] (100) NULL ,
	[leftbarBgColor] [varchar] (50) NULL ,
	[leftbarBgImage] [varchar] (100) NULL ,
	[leftbarBgImageH] [varchar] (100) NULL ,
	[leftbarFontColor] [varchar] (50) NULL ,
	[leftMenuBgColor] [varchar] (50) NULL ,
	[leftMenuFontColor] [varchar] (50) NULL ,
	[menubarBgColor] [varchar] (50) NULL ,
	[menubtnBgColor] [varchar] (50) NULL ,
	[menubtnBgColorActive] [varchar] (50) NULL ,
	[menubtnBgColorHover] [varchar] (50) NULL ,
	[menubtnFontColor] [varchar] (50) NULL ,
	[menubtnBorderColorActive] [varchar] (50) NULL ,
	[menubtnBorderColorHover] [varchar] (50) NULL ,
	[templateTitle] [varchar] (50) NULL ,
	[isOpen] [char] (1) NULL ,
	[isShowMainMenu] [char] (1) NULL 
)
GO

/*系统模板用户表*/
CREATE TABLE [SystemTemplateUser] (
	[userId] [int] NOT NULL ,
	[templateId] [int] NOT NULL 
)
GO

/* 添加一个默认模板 */
INSERT INTO SystemTemplate (templateName,companyId,logo,topBgColor,topBgImage,toolbarBgColor,toolbarBgImage,leftbarBgColor,leftbarBgImage,leftbarBgImageH,leftbarFontColor,menubarBgColor,menubtnBgColor,menubtnBgColorActive,menubtnBgColorHover,menubtnFontColor,menubtnBorderColorActive,menubtnBorderColorHover,templateTitle,isOpen,isShowMainMenu) VALUES ('Ecology默认模板',0,'','#172971','','#DDDDDD','','#C4C4C4','','','#444444','#172971','#172971','#42549E','#42549E','#FFFFFF','#172971','#172971','高效源于协同','1','1')
GO

/* 为普通用户添加默认模板(HrmResource) */
DECLARE @c CURSOR, @userid int 
SET @c = CURSOR FORWARD_ONLY STATIC FOR SELECT id FROM HrmResource
OPEN @c
FETCH NEXT FROM @c INTO @userid
WHILE @@FETCH_STATUS=0
BEGIN
	INSERT INTO SystemTemplateUser (userId,templateId) VALUES (@userid,1)
	FETCH NEXT FROM @c INTO @userid
END
CLOSE @c
DEALLOCATE @c
GO
/* 为管理员添加默认模板(HrmResourceManager) */
DECLARE @c CURSOR, @userid int 

SET @c = CURSOR FORWARD_ONLY STATIC FOR SELECT id FROM HrmResourceManager
OPEN @c
FETCH NEXT FROM @c INTO @userid
WHILE @@FETCH_STATUS=0
BEGIN
	INSERT INTO SystemTemplateUser (userId,templateId) VALUES (@userid,1)
	FETCH NEXT FROM @c INTO @userid
END
CLOSE @c
DEALLOCATE @c
GO


/**/
INSERT INTO SystemModule (id,moduleName,moduleReleased) VALUES (12,'自定义菜单','1')
GO



/* 添加模板维护权限 */
insert into SystemRights (id,rightdesc,righttype) values (599,'模板维护','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (599,8,'TemplateManage','TemplateManage') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (599,7,'模板维护','模板维护') 
GO
/* 更新为可分权 */
UPDATE SystemRights SET detachable='1' WHERE id=599
GO

/* 添加模板维护权限详细 */
INSERT INTO SystemRightDetail (id,rightdetailname,rightdetail,rightid) VALUES (4098,'模板维护','SystemTemplate:Edit',599)
GO
