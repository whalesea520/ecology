/* 左侧菜单自定义 */
CREATE TABLE LeftMenuConfig ( 
    id int NOT NULL IDENTITY (1, 1),
    userId int,
    infoId int,
    visible char(1),
    viewIndex int) 
GO

CREATE TABLE LeftMenuInfo ( 
    id int NOT NULL ,
    labelId int,
    iconUrl Varchar(100),
    linkAddress Varchar(100),
    menuLevel int,
    parentId int,
    defaultIndex int,
    useCustomName char(1),
    customName Varchar(100),
    relatedModuleId int) 
GO

/* 主菜单自定义 */
CREATE TABLE MainMenuConfig ( 
    id int NOT NULL IDENTITY (1, 1),
    userId int,
    infoId int,
    visible char(1),
    parentId int,
    viewIndex int,
    menuLevel int) 
GO

CREATE TABLE MainMenuInfo ( 
    id int NOT NULL ,
    labelId int,
    menuName Varchar(100),
    linkAddress Varchar(100),
    parentFrame Varchar(100),
    defaultParentId int,
    defaultLevel int,
    defaultIndex int,
    needRightToVisible char(1),
    rightDetailToVisible Varchar(100),
    needRightToView char(1),
    rightDetailToView Varchar(100),
    needSwitchToVisible char(1),
    switchClassNameToVisible Varchar(100),
    switchMethodNameToVisible Varchar(100),
    needSwitchToView char(1),
    switchClassNameToView Varchar(100),
    switchMethodNameToView Varchar(100),
    useCustomName char(1),
    customName Varchar(100),
    relatedModuleId int) 
GO

/*系统模块信息表*/
CREATE TABLE SystemModule ( 
    id int NOT NULL ,
    moduleName Varchar(100),
    moduleReleased char(1)) 
GO
