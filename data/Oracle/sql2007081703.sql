alter table leftmenuconfig add  customName_e varchar2(100)
/

alter table leftmenuinfo add  customName_e varchar2(100)
/

update mainmenuinfo set linkaddress='/systeminfo/menuconfig/MenuMaintFrame.jsp?type=left' where id=478
/

insert into SystemModule (id,moduleName,moduleReleased) values(13,'门户管理',1)
/

delete mainmenuinfo where id in (541,429,565,519,515,615,478)
/

delete mainmenuconfig where infoid in (541,429,565,519,515,615,478)
/

alter table SystemLoginTemplate add   extendLoginid integer 
/

CREATE table extendLogin (
    id                integer              PRIMARY KEY NOT NULL,
    extendname Varchar2(20), 
    extenddesc Varchar2(200),
    extendurl varchar2(500),
    img varchar2(50)
)
/

CREATE SEQUENCE extendLogin_Id
    start with 1
    increment by 1
    nomaxvalue
    nocycle 
/

CREATE OR REPLACE TRIGGER extendLogin_Id_Trigger
	before insert on extendLogin
	for each row
	begin
	select extendLogin_Id.nextval into :new.id from dual;
	end ;
/

CREATE table extendHomepage (
    id integer ,
    extendname Varchar2(20), 
    extenddesc Varchar2(200),
    extendurl varchar2(500)     

)
/
insert into extendHomepage(id,extendname,extenddesc,extendurl) values (1,'网站模板','网站模板','/portal/plugin/homepage/web1')
/


CREATE table extendHpWeb1 (
    id                integer              PRIMARY KEY NOT NULL,
    templateId integer, 
    subcompanyid integer,
    navimg varchar2(100),		
    flash1 varchar2(100),
    flash2 varchar2(100),
    flash3 varchar2(100),
    flash4 varchar2(100),
    flash5 varchar2(100),
    copyinfo varchar2(1500)
)
/


CREATE SEQUENCE extendHpWeb1_Id
    start with 1
    increment by 1
    nomaxvalue
    nocycle 
/

CREATE OR REPLACE TRIGGER extendHpWeb1_Id_Trigger
	before insert on extendHpWeb1
	for each row
	begin
	select extendHpWeb1_Id.nextval into :new.id from dual;
	end ;
/

alter table SystemTemplate add   extendtempletid integer 
/

alter table SystemTemplate add   extendtempletvalueid integer 
/

update mainmenuinfo set defaultindex=0 where id=633
/
update mainmenuconfig set viewindex=0 where infoid=633
/
update mainmenuinfo set defaultindex=1 where id=625
/
update mainmenuconfig set viewindex=1 where infoid=625
/

alter table mainmenuinfo add  customName_e varchar2(100)
/

drop table mainmenuconfig
/

drop SEQUENCE mainmenuconfig_id
/

CREATE TABLE mainmenuconfig (
	id                integer      NOT NULL,
	userId int NULL ,
	infoId int NULL ,
	visible char (1)  NULL ,
	viewIndex int NULL ,
	resourceid int NULL ,
	resourcetype char (1)  NULL ,
	locked char (1)  NULL ,
	lockedById int NULL ,
	useCustomName char (1)  NULL ,
	customName varchar (100)  NULL ,
	customName_e varchar (100)  NULL 
) 
/

CREATE SEQUENCE mainmenuconfig_id
    start with 1
    increment by 1
    nomaxvalue
    nocycle 
/

CREATE OR REPLACE TRIGGER mainmenuconfig_Id_Trigger
	before insert on mainmenuconfig
	for each row
	begin
	select mainmenuconfig_Id.nextval into :new.id from dual;
	end ;
/

CREATE OR REPLACE  procedure initMenuConfig	
as
  	viewIndex_1        integer;
	useCustomName_1        integer;
	customName_1        varchar2(50);
	customName_e_1        varchar2(50);
	infoid_1        varchar2(50);
	
begin
	
 	 for mInfoList in( select id,defaultindex,useCustomName,customName,customName_e from mainmenuinfo)
         loop 
             infoid_1:= mInfoList.id;
		     viewIndex_1:= mInfoList.defaultindex;
		     useCustomName_1:= mInfoList.useCustomName;
		     customName_1:= mInfoList.customName;
		     customName_e_1:= mInfoList.customName_e;

		      insert into mainmenuconfig(infoid,visible,viewIndex,resourceid,resourcetype,useCustomName,customName,customName_e) values (infoid_1,1, viewIndex_1,1,1,useCustomName_1,customName_1,customName_e_1);

		      insert into mainmenuconfig(infoid,visible,viewIndex,resourceid,resourcetype,useCustomName,customName,customName_e) select infoid_1,1,viewIndex_1,id,2,useCustomName_1,customName_1,customName_e_1 from hrmsubcompany;			
	     end loop;
end;
/


call initMenuConfig()
/

alter table mainmenuinfo add  isCustom integer default 0
/

alter table mainmenuinfo add  parentId integer
/

alter table mainmenuinfo add  menuLevel integer
/

alter table mainmenuinfo add  baseTarget varchar2(50)
/

update  mainmenuinfo set parentId=defaultparentid
/

create index mainmenuinfo_parentid on mainmenuinfo(parentid)
/


insert into SequenceIndex(indexdesc,currentid) values ('mainmenuid',-100)
/

CREATE OR REPLACE PROCEDURE MainMenuSequenceId_Get(flag      out integer,
                                                   msg       out varchar2,
                                                   thecursor IN OUT cursor_define.weavercursor) AS
  id_1    integer;
  count_1 integer;
begin
  SELECT count(*)
    into count_1
    FROM SequenceIndex
   WHERE indexdesc = 'mainmenuid';
  if count_1 > 0 then
    SELECT currentid
      into id_1
      FROM SequenceIndex
     WHERE indexdesc = 'mainmenuid';
  end if;
  UPDATE SequenceIndex
     SET currentid = currentid - 1
   WHERE indexdesc = 'mainmenuid';
  open thecursor for
    SELECT id_1 from dual;
end;
/

CREATE OR REPLACE   PROCEDURE MMConfig_U_ByInfoInsert
(
    	parentId_1	integer,
    	defaultIndex_1	integer
)
	
AS
begin
	UPDATE MainMenuConfig SET viewIndex=viewIndex+1 
	WHERE infoId IN (SELECT id FROM MainMenuInfo WHERE parentId=parentId_1) AND  viewIndex>=defaultIndex_1;
end;
/

CREATE or replace TRIGGER Tri_UMainMenuConfig_ByInfo  after  insert or update or delete  ON MainMenuInfo
for each row

Declare 
	id_1 integer;
        defaultIndex_1 integer;
        countdelete   integer;
        countinsert   integer;
        userId_1 integer;
		isCustom_1 char(1);
		useCustomName_1 char(1);
		customName_1 varchar2(100);


begin
    countdelete := :old.id;
    countinsert := :new.id;

    IF (countinsert > 0 AND countdelete is null) then
        id_1 := :new.id;
        defaultIndex_1 := :new.defaultIndex;
		isCustom_1 := :new.isCustom;
		useCustomName_1 := :new.useCustomName;
		customName_1 := :new.customName;
		
		if(isCustom_1 = '0' OR isCustom_1 IS NULL) then
			
			FOR hrmCompany_cursor in( 
			SELECT id FROM HrmCompany order by id)
			loop
				userId_1 := hrmCompany_cursor.id;
			INSERT INTO MainMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(0,id_1,1,defaultIndex_1,userId_1,'1',0,0,useCustomName_1,customName_1);
			END loop; 

			FOR hrmSubCompany_cursor in( 
			SELECT id FROM HrmSubCompany order by id)
			loop
				userId_1 := hrmSubCompany_cursor.id;
			INSERT INTO MainMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(0,id_1,1,defaultIndex_1,userId_1,'2',0,0,useCustomName_1,customName_1);
			END loop; 
			
			FOR hrmResourcemanager_cursor in( 
			SELECT id FROM HrmResourceManager order by id)
			loop
				userId_1 := hrmResourcemanager_cursor.id;
			INSERT INTO MainMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(userId_1,id_1,1,defaultIndex_1,userId_1,'3',0,0,useCustomName_1,customName_1);
			END loop; 
	
		end if;
    END if;

    IF (countinsert is null) then
       id_1 := :old.id;            
       DELETE FROM MainMenuConfig WHERE infoId = id_1;
    END if;
end;
/

CREATE or replace PROCEDURE MMInfo_Insert(
    id_1 integer,
    labelId_1 integer,
    menuName_1 Varchar2,
    linkAddress_1 Varchar2,
    parentFrame_1 Varchar2,
    defaultParentId_1 integer,
    defaultLevel_1 integer,
    defaultIndex_1 integer,
    needRightToVisible_1 char,
    rightDetailToVisible_1 Varchar2,
    needRightToView_1 char,
    rightDetailToView_1 Varchar2,
    needSwitchToVisible_1 char,
    switchClassNameToVisible_1 Varchar2,
    switchMethodNameToVisible_1 Varchar2,
    needSwitchToView_1 char ,
    switchClassNameToView_1 Varchar2,
    switchMethodNameToView_1 Varchar2,
    relatedModuleId_1 integer)
AS
    updateId integer;
    updateIndex integer;
    updateId_1 integer;
    updateIndex_1 integer;
begin
    updateIndex := defaultIndex_1;

    FOR mainMenuInfo_cursor in( 
    SELECT id FROM MainMenuInfo 
     WHERE defaultParentId = defaultParentId_1
       AND defaultIndex >= defaultIndex_1 
     ORDER BY defaultIndex)
    loop
        updateId :=mainMenuInfo_cursor.id;
        updateIndex := updateIndex + 1;
        UPDATE MainMenuInfo 
           SET defaultIndex = updateIndex
         WHERE id = updateId;
    END loop;
    
    IF(linkAddress_1 is null)
    then
    INSERT INTO MainMenuInfo (
        id,
        labelId,
        menuName,
        linkAddress,
        parentFrame,
        defaultParentId,
        defaultLevel,
        defaultIndex,
        needRightToVisible,
        rightDetailToVisible,
        needRightToView,
        rightDetailToView,
        needSwitchToVisible,
        switchClassNameToVisible,
        switchMethodNameToVisible,
        needSwitchToView,
        switchClassNameToView,
        switchMethodNameToView,
	parentid,
        relatedModuleId) 
    VALUES (
        id_1,
        labelId_1,
        menuName_1,
        NULL ,
        parentFrame_1 ,
        defaultParentId_1 ,
        defaultLevel_1 ,
        defaultIndex_1 ,
        needRightToVisible_1 ,
        rightDetailToVisible_1 ,
        needRightToView_1 ,
        rightDetailToView_1 ,
        needSwitchToVisible_1 ,
        switchClassNameToVisible_1 ,
        switchMethodNameToVisible_1 ,
        needSwitchToView_1 ,
        switchClassNameToView_1 ,
        switchMethodNameToView_1 ,
	defaultParentId_1,
        relatedModuleId_1
    ); 
    ELSE
    INSERT INTO MainMenuInfo (
        id,
        labelId,
        menuName,
        linkAddress,
        parentFrame,
        defaultParentId,
        defaultLevel,
        defaultIndex,
        needRightToVisible,
        rightDetailToVisible,
        needRightToView,
        rightDetailToView,
        needSwitchToVisible,
        switchClassNameToVisible,
        switchMethodNameToVisible,
        needSwitchToView,
        switchClassNameToView,
        switchMethodNameToView,
	parentid,
        relatedModuleId) 
    VALUES (
        id_1,
        labelId_1,
        menuName_1,
        linkAddress_1 ,
        parentFrame_1 ,
        defaultParentId_1 ,
        defaultLevel_1 ,
        defaultIndex_1 ,
        needRightToVisible_1 ,
        rightDetailToVisible_1 ,
        needRightToView_1 ,
        rightDetailToView_1 ,
        needSwitchToVisible_1 ,
        switchClassNameToVisible_1 ,
        switchMethodNameToVisible_1 ,
        needSwitchToView_1 ,
        switchClassNameToView_1 ,
        switchMethodNameToView_1 ,
	defaultParentId_1,
        relatedModuleId_1
    );
    END if;
end;
/
create index mainmenuinfo_type_id on mainmenuconfig(resourcetype,resourceid)
/