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

  OPEN leftMenuInfo_cursor;
  LOOP
  
    FETCH leftMenuInfo_cursor
      INTO id_1, defaultIndex_1;
  
    EXIT WHEN leftMenuInfo_cursor%NOTFOUND;
  
    locked_by_id := 0;
    locked       := '0';
  
    visible_1       := '1';
    viewIndex_1     := defaultIndex_1;
    useCustomName_1 := '0';
    customName_1    := '';
  
    SELECT count(0)
      into tmp_count_2
      FROM LeftMenuConfig
     WHERE infoid = id_1
       AND resourceId = 1
       AND resourceType = '1'
       AND locked > 0;
  
    IF (tmp_count_2 > 0) THEN
      SELECT distinct id
        INTO locked_by_id
        FROM LeftMenuConfig
       WHERE infoid = id_1
         AND resourceId = 1
         AND resourceType = '1';
    ELSE
    
      OPEN leftMenuInfo_cursor_1(userId_1);
      LOOP
        FETCH leftMenuInfo_cursor_1
          INTO subcompany_id;
      
        EXIT WHEN leftMenuInfo_cursor_1%NOTFOUND;
      
        SELECT count(0)
          into tmp_count_3
          FROM LeftMenuConfig
         WHERE infoid = id_1
           AND resourceId = subcompany_id
           AND resourceType = '2'
           AND locked > 0;
      
        IF (tmp_count_3 > 0) THEN
          SELECT distinct id
            INTO locked_by_id
            FROM LeftMenuConfig
           WHERE infoid = id_1
             AND resourceId = subcompany_id
             AND resourceType = '2';
          EXIT;
        ELSE
          SELECT count(0)
            into tmp_count_4
            FROM LeftMenuConfig
           WHERE infoid = id_1
             AND resourceId = subcompany_id
             AND resourceType = '2'
             AND lockedbyid > 0;
        
          IF (tmp_count_4 > 0) THEN
            SELECT distinct lockedbyid
              INTO locked_by_id
              FROM LeftMenuConfig
             WHERE infoid = id_1
               AND resourceId = subcompany_id
               AND resourceType = '2';
            EXIT;
          END IF;
        END IF;
      END LOOP;
      CLOSE leftMenuInfo_cursor_1;
    END IF;
    
    SELECT count(0)
      INTO tmp_count_1
      FROM LeftMenuConfig
     WHERE infoid = id_1
       AND resourceType = '1'
       AND resourceId = 1;
    
    IF (tmp_count_1 > 0) THEN
    
    SELECT distinct visible, viewIndex, useCustomName, customName
      INTO visible_1, viewIndex_1, useCustomName_1, customName_1
      FROM LeftMenuConfig
     WHERE infoid = id_1
       AND resourceType = '1'
       AND resourceId = 1;

    END IF;
  
    IF (locked_by_id > 0) THEN
      locked := '1';
    END IF;
  
    INSERT INTO LeftMenuConfig
      (userId,
       infoId,
       visible,
       viewIndex,
       resourceid,
       resourcetype,
       locked,
       lockedById,
       useCustomName,
       customName)
    VALUES
      (userId_1,
       id_1,
       visible_1,
       viewIndex_1,
       userId_1,
       '3',
       locked,
       locked_by_id,
       useCustomName_1,
       customName_1);
  
  END LOOP;

  CLOSE leftMenuInfo_cursor;


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


  OPEN leftMenuInfo_cursor;
  LOOP
  
    FETCH leftMenuInfo_cursor
      INTO id_1, defaultIndex_1;
  
    EXIT WHEN leftMenuInfo_cursor%NOTFOUND;
  
    locked_by_id := 0;
    locked       := '0';
  
    visible_1       := '1';
    viewIndex_1     := defaultIndex_1;
    useCustomName_1 := '0';
    customName_1    := '';
  
    SELECT count(0)
      into tmp_count_1
      FROM LeftMenuConfig
     WHERE infoid = id_1
       AND resourceId = 1
       AND resourceType = '1'
       AND locked > 0;
    IF (tmp_count_1 > 0) THEN
      SELECT distinct id
        INTO locked_by_id
        FROM LeftMenuConfig
       WHERE infoid = id_1
         AND resourceId = 1
         AND resourceType = '1';
    ELSE
      SELECT count(0)
        into tmp_count_2
        FROM LeftMenuConfig
       WHERE infoid = id_1
         AND resourceId = subcompany_id
         AND resourceType = '2'
         AND locked > 0;
    
      IF (tmp_count_2 > 0) THEN
        SELECT distinct id
          into locked_by_id
          FROM LeftMenuConfig
         WHERE infoid = id_1
           AND resourceId = subcompany_id
           AND resourceType = '2';
      ELSE
        SELECT count(0)
          into tmp_count_3
          FROM LeftMenuConfig
         WHERE infoid = id_1
           AND resourceId = subcompany_id
           AND resourceType = '2'
           AND lockedbyid > 0;
        IF (tmp_count_3 > 0) THEN
          SELECT distinct lockedbyid
            into locked_by_id
            FROM LeftMenuConfig
           WHERE infoid = id_1
             AND resourceId = subcompany_id
             AND resourceType = '2';
        END IF;
      END IF;
    END IF;
    
    SELECT count(0)
      into tmp_count_4
      FROM LeftMenuConfig
     WHERE infoid = id_1
       AND resourceType = '2'
       AND resourceId = subcompany_id;
    
    IF (tmp_count_4 > 0) THEN
    
    SELECT distinct visible, viewIndex, useCustomName, customName
      INTO visible_1, viewIndex_1, useCustomName_1, customName_1
      FROM LeftMenuConfig
     WHERE infoid = id_1
       AND resourceType = '2'
       AND resourceId = subcompany_id;
       
    END IF;
  
    IF (locked_by_id > 0) THEN
      locked := '1';
    END IF;
  
    INSERT INTO LeftMenuConfig
      (userId,
       infoId,
       visible,
       viewIndex,
       resourceid,
       resourcetype,
       locked,
       lockedById,
       useCustomName,
       customName)
    VALUES
      (userId_1,
       id_1,
       visible_1,
       viewIndex_1,
       userId_1,
       '3',
       locked,
       locked_by_id,
       useCustomName_1,
       customName_1);
  
  END LOOP;

  CLOSE leftMenuInfo_cursor;

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