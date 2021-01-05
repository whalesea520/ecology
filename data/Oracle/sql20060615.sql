create or replace procedure LeftMenuConfig_Insert_All(flag out integer,
                                                      msg  out varchar2) as

  id_1           integer;
  defaultIndex_1 integer;
  userId         integer;

  CURSOR hrmCompany_cursor IS
    SELECT id FROM HrmCompany order by id;

  CURSOR leftMenuInfo_cursor IS
    SELECT id, defaultIndex FROM LeftMenuInfo;

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

  /*系统管理员*/

  OPEN hrmResourceManager_cursor;
  LOOP
  
    FETCH hrmResourceManager_cursor
      INTO userId;
    EXIT WHEN hrmResourceManager_cursor%NOTFOUND;
  
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
        (userId, id_1, 1, defaultIndex_1, userId, '3', 0, 0, 0);
    END LOOP;
  
    CLOSE leftMenuInfo_cursor;
  
  END LOOP;
  CLOSE hrmResourceManager_cursor;

  /*用户*/

  OPEN hrmResource_cursor;

  LOOP
  
    FETCH hrmResource_cursor
      INTO userId;
    EXIT WHEN hrmResource_cursor%NOTFOUND;
  
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
        (userId, id_1, 1, defaultIndex_1, userId, '3', 0, 0, 0);
    
    END LOOP;
  
    CLOSE leftMenuInfo_cursor;
  
  END LOOP;
  CLOSE hrmResource_cursor;
  
  flag := 1;
  msg  := 'ok';

end;
/