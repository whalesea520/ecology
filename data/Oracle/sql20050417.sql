/* 左侧菜单自定义 */
CREATE TABLE LeftMenuConfig ( 
    id integer NOT NULL ,
    userId integer,
    infoId integer,
    visible char(1),
    viewIndex integer) 
/
create sequence LeftMenuConfig_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger LeftMenuConfig_Trigger
before insert on LeftMenuConfig
for each row
begin
select LeftMenuConfig_id.nextval into :new.id from dual;
end;
/

CREATE TABLE LeftMenuInfo ( 
    id integer NOT NULL ,
    labelId integer,
    iconUrl Varchar2(100),
    linkAddress Varchar2(100),
    menuLevel integer,
    parentId integer,
    defaultIndex integer,
    useCustomName char(1),
    customName Varchar2(100),
    relatedModuleId integer) 
/

/* 主菜单自定义 */
CREATE TABLE MainMenuConfig ( 
    id integer NOT NULL ,
    userId integer,
    infoId integer,
    visible char(1),
    parentId integer,
    viewIndex integer,
    menuLevel integer) 
/
create sequence MainMenuConfig_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger MainMenuConfig_Trigger
before insert on MainMenuConfig
for each row
begin
select MainMenuConfig_id.nextval into :new.id from dual;
end;
/

CREATE TABLE MainMenuInfo ( 
    id integer NOT NULL ,
    labelId integer,
    menuName Varchar2(100),
    linkAddress Varchar2(100),
    parentFrame Varchar2(100),
    defaultParentId integer,
    defaultLevel integer,
    defaultIndex integer,
    needRightToVisible char(1),
    rightDetailToVisible Varchar2(100),
    needRightToView char(1),
    rightDetailToView Varchar2(100),
    needSwitchToVisible char(1),
    switchClassNameToVisible Varchar2(100),
    switchMethodNameToVisible Varchar2(100),
    needSwitchToView char(1),
    switchClassNameToView Varchar2(100),
    switchMethodNameToView Varchar2(100),
    useCustomName char(1),
    customName Varchar2(100),
    relatedModuleId integer) 
/

/*系统模块信息表*/
CREATE TABLE SystemModule ( 
    id integer NOT NULL ,
    moduleName Varchar2(100),
    moduleReleased char(1)) 
/
