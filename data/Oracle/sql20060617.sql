create or replace procedure LeftMenuConfig_InsertByUserId(userId_1 integer,
                                                          flag     out integer,
                                                          msg      out varchar2) as

  id_1           integer;
  defaultIndex_1 integer;
  subcompany_id  integer;
  locked         char(1);
  locked_by_id   integer;

  visible_1 char(1);
  viewIndex_1 integer;
  useCustomName_1 char(1);
  customName_1 varchar2(100);

  tmp_count_1 integer;
  tmp_count_2 integer;
  tmp_count_3 integer;
  tmp_count_4 integer;

  CURSOR leftMenuInfo_cursor IS
  /*只添加系统定义的左菜单*/ /*及管理员添加的维护菜单*/
    SELECT id, defaultIndex
      FROM LeftMenuInfo
     WHERE isCustom = '0'
        OR isCustom IS NULL
        OR isCustom = '2';

  CURSOR leftMenuInfo_cursor_1(c_userId_1 integer) IS
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

begin

  OPEN leftMenuInfo_cursor;
  LOOP
  
    FETCH leftMenuInfo_cursor
      INTO id_1, defaultIndex_1;
  
    EXIT WHEN leftMenuInfo_cursor%NOTFOUND;
  
    locked_by_id := 0;
    locked       := '0';
    
   	visible_1 := '1';
    viewIndex_1 := defaultIndex_1;
    useCustomName_1 := '0';
    customName_1 := '';
  
    /*管理员*/
    SELECT count(0)
      into tmp_count_1
      FROM HrmResourceManager
     WHERE id = userId_1;
    IF (tmp_count_1 > 0) THEN
      SELECT count(0)
        into tmp_count_2
        FROM LeftMenuConfig
       WHERE infoid = id_1
         AND resourceId = 1
         AND resourceType = '1'
         AND locked > 0;
    
      IF (tmp_count_2 > 0) THEN
        SELECT id
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
            SELECT id
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
              SELECT lockedbyid
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
      SELECT visible,viewIndex,useCustomName,customName INTO visible_1,viewIndex_1,useCustomName_1,customName_1 FROM LeftMenuConfig WHERE infoid = id_1 AND resourceType = '1' AND resourceId = 1;
    ELSE
      /*用户*/
      SELECT count(0)
        into tmp_count_1
        FROM LeftMenuConfig
       WHERE infoid = id_1
         AND resourceId = 1
         AND resourceType = '1'
         AND locked > 0;
      IF (tmp_count_1 > 0) THEN
        SELECT id
          INTO locked_by_id
          FROM LeftMenuConfig
         WHERE infoid = id_1
           AND resourceId = 1
           AND resourceType = '1';
      ELSE
        SELECT subcompanyid1
          into subcompany_id
          FROM HrmResource
         WHERE id = userId_1;
      
        SELECT count(0)
          into tmp_count_2
          FROM LeftMenuConfig
         WHERE infoid = id_1
           AND resourceId = subcompany_id
           AND resourceType = '2'
           AND locked > 0;
      
        IF (tmp_count_2 > 0) THEN
          SELECT id
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
            SELECT lockedbyid
              into locked_by_id
              FROM LeftMenuConfig
             WHERE infoid = id_1
               AND resourceId = subcompany_id
               AND resourceType = '2';
          END IF;
        END IF;
      END IF;
      SELECT visible,viewIndex,useCustomName,customName INTO visible_1,viewIndex_1,useCustomName_1,customName_1 FROM LeftMenuConfig WHERE infoid = id_1 AND resourceType = '2' AND resourceId = subcompany_id;
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

  flag := 1;
  msg  := 'ok';

end;
/