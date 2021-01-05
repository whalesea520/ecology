create or replace procedure LMConfig_U_ByInfoInsert(menuLevel_1    integer,
                                                    parentId_1     integer,
                                                    defaultIndex_1 integer) AS
  old_updateId      integer;
  old_resourceId    integer;
  old_resourceType  char(1);
  old_parentId      integer;
  curr_updateId     integer;
  curr_resourceId   integer;
  curr_resourceType char(1);
  curr_parentId     integer;
  indexCount        integer;

  CURSOR leftmenuviewindex_cursor1(c_defaultIndex_1 integer) IS
    SELECT t2.id, t2.resourceId, t2.resourceType, t1.parentid
      FROM LeftMenuInfo t1, LeftMenuConfig t2
     WHERE t1.id = t2.infoId
       AND (t1.parentid IS NULL OR t1.parentid = 0)
       AND t2.viewIndex >= c_defaultIndex_1
     ORDER BY resourceid,
              resourcetype,
              parentId,
              viewindex,
              defaultIndex,
              infoid desc;

  CURSOR leftmenuviewindex_cursor2(c_parentId_1 integer, c_defaultIndex_1 integer) IS
    SELECT t2.id, t2.resourceId, t2.resourceType, t1.parentid
      FROM LeftMenuInfo t1, LeftMenuConfig t2
     WHERE t1.id = t2.infoId
       AND t1.parentId = c_parentId_1
       AND t2.viewIndex >= c_defaultIndex_1
     ORDER BY resourceid,
              resourcetype,
              parentId,
              viewindex,
              defaultIndex,
              infoid desc;

begin

  /*¶¥¼¶²Ëµ¥*/
  IF (menuLevel_1 = 1) THEN
  
    IF (defaultIndex_1 < 1) THEN
      indexCount := 1;
    ELSE
      indexCount := defaultIndex_1;
    END IF;
  
    OPEN leftmenuviewindex_cursor1(defaultIndex_1);
    LOOP
    
      FETCH leftmenuviewindex_cursor1
        INTO curr_updateId, curr_resourceId, curr_resourceType, curr_parentId;
      EXIT WHEN leftmenuviewindex_cursor1%NOTFOUND;
    
      IF (curr_resourceId = old_resourceId AND
         curr_resourceType = old_resourceType AND
         (curr_parentId = old_parentId OR
         (curr_parentId IS NULL AND old_parentId IS NULL)) AND
         curr_updateId != old_updateId) THEN
      
        indexCount := indexCount + 1;
      
        UPDATE LeftMenuConfig SET viewIndex = indexCount WHERE id = curr_updateId;
      
      ELSE
      
        IF (defaultIndex_1 < 1) THEN
          indexCount := 1;
        ELSE
          indexCount := defaultIndex_1;
        END IF;
      
        UPDATE LeftMenuConfig SET viewIndex = indexCount WHERE id = curr_updateId;
      
      END IF;
    
      old_updateId     := curr_updateId;
      old_resourceId   := curr_resourceId;
      old_resourceType := curr_resourceType;
      old_parentId     := curr_parentId;
    
    END LOOP;
  
    CLOSE leftmenuviewindex_cursor1;
  
  ELSE
  
    IF (defaultIndex_1 < 1) THEN
      indexCount := 1;
    ELSE
      indexCount := defaultIndex_1;
    END IF;
  
    OPEN leftmenuviewindex_cursor2(parentId_1, defaultIndex_1);
    LOOP
    
      FETCH leftmenuviewindex_cursor2
        INTO curr_updateId, curr_resourceId, curr_resourceType, curr_parentId;
      EXIT WHEN leftmenuviewindex_cursor2%NOTFOUND;
    
      IF (curr_resourceId = old_resourceId AND
         curr_resourceType = old_resourceType AND
         (curr_parentId = old_parentId OR
         (curr_parentId IS NULL AND old_parentId IS NULL)) AND
         curr_updateId != old_updateId) THEN
      
        indexCount := indexCount + 1;
      
        UPDATE LeftMenuConfig SET viewIndex = indexCount WHERE id = curr_updateId;
      
      ELSE
      
        IF (defaultIndex_1 < 1) THEN
          indexCount := 1;
        ELSE
          indexCount := defaultIndex_1;
        END IF;
      
        UPDATE LeftMenuConfig SET viewIndex = indexCount WHERE id = curr_updateId;
      
      END IF;
    
      old_updateId     := curr_updateId;
      old_resourceId   := curr_resourceId;
      old_resourceType := curr_resourceType;
      old_parentId     := curr_parentId;
    
    END LOOP;
  
    CLOSE leftmenuviewindex_cursor2;
  
  END IF;
end ;
/