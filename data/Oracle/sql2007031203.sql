create or replace trigger Tri_UMMInfo_ByHrmResource
  after insert ON HRMRESOURCE
  FOR each row
DECLARE
  userId_1 integer;

  id_1           int;
  defaultIndex_1 int;
  subcompany_id  int;
  locked         char(1);
  locked_by_id   int;

  visible_1       char(1);
  viewIndex_1     int;
  useCustomName_1 char(1);
  customName_1    varchar2(100);

  tmp_count_1 int;
  tmp_count_2 int;
  tmp_count_3 int;
  tmp_count_4 int;

  CURSOR leftMenuInfo_cursor IS
    SELECT id, defaultIndex
      FROM LeftMenuInfo
     WHERE isCustom = '0'
        OR isCustom IS NULL
        OR isCustom = '2';

  defaultParentId_1 integer;
  defaultLevel_1 integer;

BEGIN
  userId_1      := :new.id;
  subcompany_id := :new.subcompanyid1;

  FOR mainMenuInfo_cursor in (SELECT id,
                                     defaultParentId,
                                     defaultIndex,
                                     defaultLevel
                                FROM MainMenuInfo) loop
    id_1              := mainMenuInfo_cursor.id;
    defaultParentId_1 := mainMenuInfo_cursor.defaultParentId;
    defaultIndex_1    := mainMenuInfo_cursor.defaultIndex;
    defaultLevel_1    := mainMenuInfo_cursor.defaultLevel;
    INSERT INTO MainMenuConfig
      (userId, infoId, visible, parentId, viewIndex, menuLevel)
    VALUES
      (userId_1,
       id_1,
       1,
       defaultParentId_1,
       defaultIndex_1,
       defaultLevel_1);
  END loop;

END;
/



create or replace trigger Tri_UMMInfo_ByHRManager
  after insert ON HrmResourceManager
  FOR each row
DECLARE
  userId_1 integer;

  id_1           int;
  defaultIndex_1 int;
  subcompany_id  int;
  locked         char(1);
  locked_by_id   int;

  visible_1       char(1);
  viewIndex_1     int;
  useCustomName_1 char(1);
  customName_1    varchar2(100);

  tmp_count_1 int;
  tmp_count_2 int;
  tmp_count_3 int;
  tmp_count_4 int;

  CURSOR leftMenuInfo_cursor IS
    SELECT id, defaultIndex
      FROM LeftMenuInfo
     WHERE isCustom = '0'
        OR isCustom IS NULL
        OR isCustom = '2';

  CURSOR leftMenuInfo_cursor_1(c_userId_1 int) IS
    select subcompanyid
      from SysRoleSubcomRight
     where roleid in
           (select a.roleid
              from HrmRoleMembers a, SystemRightRoles b
             where a.roleid = b.roleid
               and a.resourceid = c_userId_1
               and b.rightid =
                   (select rightid
                      from SystemRightDetail
                     where rightdetail = 'SubMenu:Maint'))
     group by subcompanyid;

  defaultParentId_1 integer;
  defaultLevel_1 integer;

BEGIN
  userId_1 := :new.id;


  FOR mainMenuInfo_cursor in (SELECT id,
                                     defaultParentId,
                                     defaultIndex,
                                     defaultLevel
                                FROM MainMenuInfo) loop
    id_1              := mainMenuInfo_cursor.id;
    defaultParentId_1 := mainMenuInfo_cursor.defaultParentId;
    defaultIndex_1    := mainMenuInfo_cursor.defaultIndex;
    defaultLevel_1    := mainMenuInfo_cursor.defaultLevel;
    INSERT INTO MainMenuConfig
      (userId, infoId, visible, parentId, viewIndex, menuLevel)
    VALUES
      (userId_1,
       id_1,
       1,
       defaultParentId_1,
       defaultIndex_1,
       defaultLevel_1);
  END loop;

END;
/



CREATE or replace TRIGGER Tri_ULeftMenuConfig_ByInfo after  insert or update or delete ON LeftMenuInfo 
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
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(0,id_1,1,defaultIndex_1,userId_1,'1',0,0,useCustomName_1,customName_1);
		END loop; 


		
		FOR hrmSubCompany_cursor in( 
		SELECT id FROM HrmSubCompany order by id)
		loop
			userId_1 := hrmSubCompany_cursor.id;
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(0,id_1,1,defaultIndex_1,userId_1,'2',0,0,useCustomName_1,customName_1);
		END loop; 
		
		
		end if;
    END if;

  
    IF (countinsert is null) then
       id_1 := :old.id;            
       DELETE FROM LeftMenuConfig WHERE infoId = id_1;
    END if;
end;
/








delete leftmenuconfig where  resourcetype=3 and infoid>0
/



delete leftmenuconfig where  resourcetype=3 and infoid in
 (select infoid from leftmenuconfig where resourcetype=1 and infoid<0)
/

delete leftmenuconfig where resourcetype=3 and infoid in
 (select infoid from leftmenuconfig where resourcetype=2 and infoid<0)
/



update leftmenuconfig set resourcetype=3,resourceid=userid where resourcetype is null
/



delete leftmenuconfig where infoid in (
select b.infoid from leftmenuinfo a right join leftmenuconfig b  on a.id=b.infoid  where a.id is null
)

/


create or replace procedure LeftMenuConfig_Sys_init 
as

  id_1           integer;
  defaultIndex_1 integer;
  userId         integer;

  CURSOR hrmCompany_cursor IS
    SELECT id FROM HrmCompany order by id;

  CURSOR leftMenuInfo_cursor IS
    SELECT id, defaultIndex FROM LeftMenuInfo where iscustom=0 or iscustom is null;

  CURSOR hrmSubCompany_cursor IS
    SELECT id FROM HrmSubCompany order by id;

  CURSOR hrmResourceManager_cursor IS
    SELECT id FROM HrmResourceManager order by id;

  CURSOR hrmResource_cursor IS
    SELECT id FROM HrmResource order by id;

begin

  /*总部*/

  OPEN hrmCompany_cursor;
  LOOP
  
    FETCH hrmCompany_cursor
      INTO userId;
    EXIT WHEN hrmCompany_cursor%NOTFOUND;
  
    OPEN leftMenuInfo_cursor;
    LOOP
      FETCH leftMenuInfo_cursor
        INTO id_1, defaultIndex_1;
      EXIT WHEN leftMenuInfo_cursor%NOTFOUND;
    
      INSERT INTO LeftMenuConfig
        (userId,
         infoId,
         visible,
         viewIndex,
         resourceid,
         resourcetype,
         locked,
         lockedById,
         useCustomName)
      VALUES
        (0, id_1, 1, defaultIndex_1, userId, '1', 0, 0, 0);
    
    END LOOP;
  
    CLOSE leftMenuInfo_cursor;
  
  END LOOP;
  CLOSE hrmCompany_cursor;

  /*分部*/

  OPEN hrmSubCompany_cursor;

  LOOP
    FETCH hrmSubCompany_cursor
      INTO userId;
    EXIT WHEN hrmSubCompany_cursor%NOTFOUND;
  
    OPEN leftMenuInfo_cursor;
    LOOP
      FETCH leftMenuInfo_cursor
        INTO id_1, defaultIndex_1;
      EXIT WHEN leftMenuInfo_cursor%NOTFOUND;
    
      INSERT INTO LeftMenuConfig
        (userId,
         infoId,
         visible,
         viewIndex,
         resourceid,
         resourcetype,
         locked,
         lockedById,
         useCustomName)
      VALUES
        (0, id_1, 1, defaultIndex_1, userId, '2', 0, 0, 0);
    
    END LOOP;
  
    CLOSE leftMenuInfo_cursor;
  
  END LOOP;
  CLOSE hrmSubCompany_cursor;
end;
/

 
delete LeftMenuConfig where infoid  in (select id from leftmenuinfo where iscustom=0 or iscustom is null)
/ 

call LeftMenuConfig_Sys_init()
/


CREATE INDEX leftmenuconfig_type_id ON leftmenuconfig  (resourcetype, resourceid)
/



