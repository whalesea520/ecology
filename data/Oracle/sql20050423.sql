/*根据用户 id 增加的用户左侧菜单配置信息*/
create or replace PROCEDURE LeftMenuConfig_InsertByUserId(
    userId_1  integer
        )
AS
	id_1 integer;
	defaultIndex_1 integer;
begin
    FOR leftMenuInfo_cursor in( 
    SELECT id, defaultIndex FROM LeftMenuInfo)
    loop
		id_1:=leftMenuInfo_cursor.id;
		defaultIndex_1:=leftMenuInfo_cursor.defaultIndex;
        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex) VALUES(userId_1,id_1,1,defaultIndex_1);
    END loop;
end;
/

/*根据用户 id 增加的用户主菜单配置信息*/
create or replace PROCEDURE MainMenuConfig_InsertByUserId(
    userId_1   integer
    )
AS
        id_1 integer;
        defaultParentId_1 integer;
        defaultIndex_1 integer;
        defaultLevel_1 integer;
begin
    FOR mainMenuInfo_cursor in( 
    SELECT id,defaultParentId, defaultIndex, defaultLevel FROM MainMenuInfo)

    loop
         id_1:=mainMenuInfo_cursor.id;
         defaultParentId_1:=mainMenuInfo_cursor.defaultParentId;
         defaultIndex_1:=mainMenuInfo_cursor.defaultIndex;
         defaultLevel_1:=mainMenuInfo_cursor.defaultLevel;

        INSERT INTO MainMenuConfig (userId,infoId,visible,parentId,viewIndex,menuLevel) VALUES(userId_1,id_1,1,defaultParentId_1,defaultIndex_1,defaultLevel_1);
        
    END loop;
end;
/

/*由于 LeftMenuInfo 表的增加，在 LeftMenuConfig 增加、一条记录 
  更新所有用户 ViewIndex 大于 LeftMenuConfig 增加的记录的 defaultIndex 的 LeftMenuConfig viewIndex 配置信息*/
CREATE or replace PROCEDURE LeftMenuConfig_U_ByInfoInsert(
    menuLevel_1 integer,
    parentId_1 integer,
    defaultIndex_1 integer,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS
 userId integer;   
 updateId integer;
 updateIndex integer;
begin   
    /*顶级菜单*/
    IF (menuLevel_1 = 1) 
		then      
        /*系统管理员*/
        updateIndex := defaultIndex_1;
        FOR leftMenuConfig_cursor in( 
        SELECT t2.id FROM LeftMenuInfo t1,LeftMenuConfig t2 
	     WHERE t1.id = t2.infoId 
           AND t2.userId = 1
           AND t1.parentId IS NULL
           AND t2.viewIndex >= defaultIndex_1 
         ORDER BY defaultIndex)
            loop
                updateId :=leftMenuConfig_cursor.id;
                updateIndex := updateIndex + 1;
                UPDATE LeftMenuConfig 
                   SET viewIndex = updateIndex
                 WHERE id = updateId;
            END loop;
       /*用户*/
        FOR hrmResource_cursor in(
        SELECT id FROM HrmResource order by id)
        loop
            userId :=  hrmResource_cursor.id;
            updateIndex := defaultIndex_1;
            FOR leftMenuConfig_cursor_1 in(
            SELECT t2.id FROM LeftMenuInfo t1,LeftMenuConfig t2 
	            WHERE t1.id = t2.infoId 
                AND t2.userId = userId
                AND t1.parentId IS NULL
                AND t2.viewIndex >= defaultIndex_1 
                ORDER BY defaultIndex)
                loop
                    updateId :=leftMenuConfig_cursor_1.id;
                    updateIndex := updateIndex + 1;
                    UPDATE LeftMenuConfig SET viewIndex = updateIndex WHERE id = updateId;
                END loop;
       END loop;
    ELSE
           /*系统管理员*/
        updateIndex := defaultIndex_1;
        FOR leftMenuConfig_cursor in( 
        SELECT t2.id FROM LeftMenuInfo t1,LeftMenuConfig t2 
	     WHERE t1.id = t2.infoId 
           AND t2.userId = 1
           AND t1.parentId = parentId_1
           AND t2.viewIndex >= defaultIndex_1 
         ORDER BY defaultIndex)
        loop    
            updateId :=leftMenuConfig_cursor.id;
            updateIndex := updateIndex + 1;
            UPDATE LeftMenuConfig 
               SET viewIndex = updateIndex 
             WHERE id = updateId;
        END loop;
        /*用户*/
        FOR hrmResource_cursor in( 
        SELECT id FROM HrmResource order by id)
        loop
            userId :=hrmResource_cursor.id;
            updateIndex := defaultIndex_1;
            FOR leftMenuConfig_cursor_1 in( 
            SELECT t2.id FROM LeftMenuInfo t1,LeftMenuConfig t2 
	         WHERE t1.id = t2.infoId 
               AND t2.userId = userId
               AND t1.parentId = parentId_1
               AND t2.viewIndex >= defaultIndex_1 
             ORDER BY defaultIndex)
            loop
                updateId:=leftMenuConfig_cursor_1.id;
                updateIndex := updateIndex + 1;
                UPDATE LeftMenuConfig 
                   SET viewIndex = updateIndex
                 WHERE id = updateId;
            END loop;
        END loop;
    END if;
end;
/

CREATE or replace PROCEDURE LMConfig_U_ByInfoInsert(
    menuLevel_1 integer,
    parentId_1 integer,
    defaultIndex_1 integer)
AS
 userId integer;   
 updateId integer;
 updateIndex integer;
begin   
    /*顶级菜单*/
    IF (menuLevel_1 = 1) 
		then      
        /*系统管理员*/
        updateIndex := defaultIndex_1;
        FOR leftMenuConfig_cursor in( 
        SELECT t2.id FROM LeftMenuInfo t1,LeftMenuConfig t2 
	     WHERE t1.id = t2.infoId 
           AND t2.userId = 1
           AND t1.parentId IS NULL
           AND t2.viewIndex >= defaultIndex_1 
         ORDER BY defaultIndex)
            loop
                updateId :=leftMenuConfig_cursor.id;
                updateIndex := updateIndex + 1;
                UPDATE LeftMenuConfig 
                   SET viewIndex = updateIndex
                 WHERE id = updateId;
            END loop;
       /*用户*/
        FOR hrmResource_cursor in(
        SELECT id FROM HrmResource order by id)
        loop
            userId :=  hrmResource_cursor.id;
            updateIndex := defaultIndex_1;
            FOR leftMenuConfig_cursor_1 in(
            SELECT t2.id FROM LeftMenuInfo t1,LeftMenuConfig t2 
	            WHERE t1.id = t2.infoId 
                AND t2.userId = userId
                AND t1.parentId IS NULL
                AND t2.viewIndex >= defaultIndex_1 
                ORDER BY defaultIndex)
                loop
                    updateId :=leftMenuConfig_cursor_1.id;
                    updateIndex := updateIndex + 1;
                    UPDATE LeftMenuConfig SET viewIndex = updateIndex WHERE id = updateId;
                END loop;
       END loop;
    ELSE
           /*系统管理员*/
        updateIndex := defaultIndex_1;
        FOR leftMenuConfig_cursor in( 
        SELECT t2.id FROM LeftMenuInfo t1,LeftMenuConfig t2 
	     WHERE t1.id = t2.infoId 
           AND t2.userId = 1
           AND t1.parentId = parentId_1
           AND t2.viewIndex >= defaultIndex_1 
         ORDER BY defaultIndex)
        loop    
            updateId :=leftMenuConfig_cursor.id;
            updateIndex := updateIndex + 1;
            UPDATE LeftMenuConfig 
               SET viewIndex = updateIndex 
             WHERE id = updateId;
        END loop;
        /*用户*/
        FOR hrmResource_cursor in( 
        SELECT id FROM HrmResource order by id)
        loop
            userId :=hrmResource_cursor.id;
            updateIndex := defaultIndex_1;
            FOR leftMenuConfig_cursor_1 in( 
            SELECT t2.id FROM LeftMenuInfo t1,LeftMenuConfig t2 
	         WHERE t1.id = t2.infoId 
               AND t2.userId = userId
               AND t1.parentId = parentId_1
               AND t2.viewIndex >= defaultIndex_1 
             ORDER BY defaultIndex)
            loop
                updateId:=leftMenuConfig_cursor_1.id;
                updateIndex := updateIndex + 1;
                UPDATE LeftMenuConfig 
                   SET viewIndex = updateIndex
                 WHERE id = updateId;
            END loop;
        END loop;
    END if;
end;
/


/*选择个人功能区菜单配置信息 根据 Id*/
CREATE or replace PROCEDURE LeftMenuInfo_SelectById(
    id_1 	integer ,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS
begin
    open thecursor for
    SELECT id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId 
      FROM LeftMenuInfo WHERE id = id_1;
end;
/
/*选择个人功能区菜单配置信息 根据 menuLevel*/
CREATE or replace PROCEDURE LeftMenuInfo_SelectByLevel(
    menuLevel_1 integer,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS
begin
    open thecursor for
    SELECT id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId 
      FROM LeftMenuInfo 
     WHERE menuLevel = menuLevel_1
     ORDER BY id;
end;
/

/*选择个人功能区菜单配置信息 根据 parentId 不是顶级菜单*/
CREATE or replace PROCEDURE LeftMenuInfo_SelectByParentId(
    parentId_1 integer,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS
begin
    open thecursor for
    SELECT id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId 
      FROM LeftMenuInfo 
     WHERE parentId = parentId_1
     ORDER BY id;
end;
/


/*增加个人功能区菜单配置信息*/
CREATE or replace PROCEDURE LeftMenuInfo_Insert(
    id_1 		integer ,
    labelId_1 		integer ,
    iconUrl_1		varchar2,
    linkAddress_1      varchar2,
    menuLevel_1	integer,
    parentId_1		integer,
    defaultIndex_1	integer,
    relatedModuleId_1  integer,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor) 
AS
    updateId integer;
    updateIndex integer;
begin
    /*顶级菜单*/
    IF (menuLevel_1 = 1) 
        then
	    updateIndex := defaultIndex_1;
        /*更新大于插入记录Index 的 defaultIndex 加1*/
	    FOR leftMenuInfo_cursor in(
	    SELECT id FROM LeftMenuInfo 
	     WHERE parentId IS NULL
	       AND defaultIndex >= defaultIndex_1 
             ORDER BY defaultIndex)
        loop
            updateId:=leftMenuInfo_cursor.id;
            updateIndex := updateIndex + 1;
            UPDATE LeftMenuInfo 
                   SET defaultIndex = updateIndex
                 WHERE id = updateId;
        END loop;
	    INSERT INTO LeftMenuInfo (
            id,
	        labelId,
	        iconUrl,
	        linkAddress,
	        menuLevel,
	        parentId,
	        defaultIndex,
	        relatedModuleId) 
	    VALUES (
            id_1,
	        labelId_1,
	        NULL,
	        NULL,
	        menuLevel_1,
	        NULL,
	        defaultIndex_1,
	        relatedModuleId_1
	    );
    ELSE 
      	updateIndex := defaultIndex_1;
    /*更新大于插入记录Index 的 defaultIndex 加1*/
	    FOR leftMenuInfo_cursor  in( 
	    SELECT id FROM LeftMenuInfo 
	     WHERE parentId = parentId_1
	       AND defaultIndex >= defaultIndex_1
             ORDER BY defaultIndex)
        loop    
            updateId:=leftMenuInfo_cursor.id ;
            updateIndex := updateIndex + 1;
                UPDATE LeftMenuInfo 
                   SET defaultIndex = updateIndex
                 WHERE id = updateId;
        END loop;
	    INSERT INTO LeftMenuInfo (
            id,
	        labelId,
	        iconUrl,
	        linkAddress,
	        menuLevel,
	        parentId,
	        defaultIndex,
	        relatedModuleId) 
	    VALUES (
            id_1,
	        labelId_1,
	        iconUrl_1,
	        linkAddress_1,
	        menuLevel_1,
	        parentId_1,
	        defaultIndex_1,
	        relatedModuleId_1
    	); 
    END if;
end;
/

CREATE or replace PROCEDURE LMInfo_Insert(
    id_1 		integer ,
    labelId_1 		integer ,
    iconUrl_1		varchar2,
    linkAddress_1      varchar2,
    menuLevel_1	integer,
    parentId_1		integer,
    defaultIndex_1	integer,
    relatedModuleId_1  integer) 
AS
    updateId integer;
    updateIndex integer;
begin
    /*顶级菜单*/
    IF (menuLevel_1 = 1) 
        then
	    updateIndex := defaultIndex_1;
        /*更新大于插入记录Index 的 defaultIndex 加1*/
	    FOR leftMenuInfo_cursor in(
	    SELECT id FROM LeftMenuInfo 
	     WHERE parentId IS NULL
	       AND defaultIndex >= defaultIndex_1 
             ORDER BY defaultIndex)
        loop
            updateId:=leftMenuInfo_cursor.id;
            updateIndex := updateIndex + 1;
            UPDATE LeftMenuInfo 
                   SET defaultIndex = updateIndex
                 WHERE id = updateId;
        END loop;
	    INSERT INTO LeftMenuInfo (
            id,
	        labelId,
	        iconUrl,
	        linkAddress,
	        menuLevel,
	        parentId,
	        defaultIndex,
	        relatedModuleId) 
	    VALUES (
            id_1,
	        labelId_1,
	        NULL,
	        NULL,
	        menuLevel_1,
	        NULL,
	        defaultIndex_1,
	        relatedModuleId_1
	    );
    ELSE 
      	updateIndex := defaultIndex_1;
    /*更新大于插入记录Index 的 defaultIndex 加1*/
	    FOR leftMenuInfo_cursor  in( 
	    SELECT id FROM LeftMenuInfo 
	     WHERE parentId = parentId_1
	       AND defaultIndex >= defaultIndex_1
             ORDER BY defaultIndex)
        loop    
            updateId:=leftMenuInfo_cursor.id ;
            updateIndex := updateIndex + 1;
                UPDATE LeftMenuInfo 
                   SET defaultIndex = updateIndex
                 WHERE id = updateId;
        END loop;
	    INSERT INTO LeftMenuInfo (
            id,
	        labelId,
	        iconUrl,
	        linkAddress,
	        menuLevel,
	        parentId,
	        defaultIndex,
	        relatedModuleId) 
	    VALUES (
            id_1,
	        labelId_1,
	        iconUrl_1,
	        linkAddress_1,
	        menuLevel_1,
	        parentId_1,
	        defaultIndex_1,
	        relatedModuleId_1
    	); 
    END if;
end;
/

/*删除个人功能区菜单配置信息*/
CREATE or replace PROCEDURE LeftMenuInfo_DeleteById(
    id_1 	integer ,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)  
AS
     menuLevel_1 integer;
     updateId_2 integer;
     updateIndex_3 integer;
     defaultIndex_4 integer;
     parentId_5 integer;
begin
    SELECT menuLevel,parentId,defaultIndex into menuLevel_1,parentId_5,defaultIndex_4 
      FROM LeftMenuInfo   WHERE id = id_1;
    DELETE FROM LeftMenuInfo  WHERE id = id_1;
    updateIndex_3 := defaultIndex_4;
    /*顶级菜单*/
    IF (menuLevel_1 = 1) then
        /*更新大于插入记录Index 的 defaultIndex 减1*/
	    FOR leftMenuInfo_cursor in(
	    SELECT id FROM LeftMenuInfo 
	     WHERE parentId IS NULL
	       AND defaultIndex > defaultIndex_4 
         ORDER BY defaultIndex)
        loop
            updateId_2:=leftMenuInfo_cursor.id;
            UPDATE LeftMenuInfo 
               SET defaultIndex = updateIndex_3
             WHERE id = updateId_2;
           updateIndex_3 := updateIndex_3 + 1;
        END loop;
    ELSE 
        /*更新大于插入记录Index 的 defaultIndex 减1*/
	    FOR leftMenuInfo_cursor in( 
	    SELECT id FROM LeftMenuInfo 
	     WHERE parentId = parentId_5
	       AND defaultIndex > defaultIndex_4 
         ORDER BY defaultIndex)
        loop
            updateId_2:=leftMenuInfo_cursor.id;
            UPDATE LeftMenuInfo 
               SET defaultIndex = updateIndex_3
             WHERE id = updateId_2;
            updateIndex_3:= updateIndex_3 + 1;
        END loop; 
    END if;
end;
/
/*更新个人功能区菜单配置信息*/
CREATE or replace PROCEDURE LeftMenuInfo_Update(
    id_1 		integer,
    oldIndex_1		integer,
    labelId_1 		integer,
    iconUrl_1		varchar2,
    linkAddress_1      varchar2,
    menuLevel_1	integer,
    parentId_1		integer,
    defaultIndex_1	integer,
    relatedModuleId_1  integer,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS
    updateId integer;
    updateIndex integer;  
  
    begin
    /*顶级菜单*/
    IF (menuLevel_1 = 1) then

        /*更新 更新记录 defaultIndex 和原记录 defaultIndex之间 的 defaultIndex 加1*/

        IF (defaultIndex_1<oldIndex_1) then

            updateIndex := defaultIndex_1;
     
            FOR leftMenuInfo_cursor in( 
                SELECT id FROM LeftMenuInfo 
                 WHERE parentId IS NULL
                   AND defaultIndex >= defaultIndex_1 
                   AND defaultIndex <  oldIndex_1
                 ORDER BY defaultIndex)
            loop
                updateId:=leftMenuInfo_cursor.id;
                updateIndex := updateIndex + 1;
                UPDATE LeftMenuInfo  SET defaultIndex = updateIndex WHERE id = updateId;
            END loop;
            UPDATE LeftMenuInfo 
                SET labelId = labelId_1,
                    defaultIndex = defaultIndex_1,
                    relatedModuleId = relatedModuleId_1 
              WHERE id = id_1;
        END if;

        IF (defaultIndex_1>oldIndex_1) then

            updateIndex := oldIndex_1;
            FOR leftMenuInfo_cursor in( 
                SELECT id FROM LeftMenuInfo 
                 WHERE parentId IS NULL
                   AND defaultIndex > oldIndex_1 
                   AND defaultIndex <= defaultIndex_1
                 ORDER BY defaultIndex)
            loop
                updateId:=leftMenuInfo_cursor.id;
                UPDATE LeftMenuInfo 
                     SET defaultIndex = updateIndex
                     WHERE id = updateId;
                updateIndex := updateIndex + 1;
            END loop;
            UPDATE LeftMenuInfo 
                SET labelId = labelId_1,
                    defaultIndex = defaultIndex_1-1,
                    relatedModuleId = relatedModuleId_1 
              WHERE id = id_1;
        END if;
    ELSE 
    /*更新 更新记录 defaultIndex 和原记录 defaultIndex 之间的 defaultIndex 加1*/

        IF (defaultIndex_1<oldIndex_1) then

            updateIndex := defaultIndex_1;
     
            FOR leftMenuInfo_cursor in( 
                SELECT id FROM LeftMenuInfo 
                 WHERE parentId = parentId_1 
                   AND defaultIndex >= defaultIndex_1 
                   AND defaultIndex <  oldIndex_1
                 ORDER BY defaultIndex)
                loop
                    updateId :=leftMenuInfo_cursor.id;
                    updateIndex := updateIndex + 1;
                    UPDATE LeftMenuInfo 
                           SET defaultIndex = updateIndex
                         WHERE id = updateId;
                END loop;
            UPDATE LeftMenuInfo 
               SET labelId = labelId_1,
                   iconUrl = iconUrl_1,
                   linkAddress = linkAddress_1,
                   parentId = parentId_1,
                   defaultIndex = defaultIndex_1,
                   relatedModuleId = relatedModuleId_1 
             WHERE id = id_1;	
        END if;
        IF (defaultIndex_1>oldIndex_1) then

            updateIndex := oldIndex_1;

            FOR leftMenuInfo_cursor in( 
            SELECT id FROM LeftMenuInfo 
             WHERE parentId = parentId_1
               AND defaultIndex > oldIndex_1 
               AND defaultIndex <= defaultIndex_1
             ORDER BY defaultIndex)
                loop
                    updateId:=leftMenuInfo_cursor.id;
                    UPDATE LeftMenuInfo 
                           SET defaultIndex = updateIndex
                         WHERE id = updateId;
                    updateIndex := updateIndex + 1;
                END loop;
            UPDATE LeftMenuInfo 
               SET labelId = labelId_1,
                   iconUrl = iconUrl_1,
                   linkAddress = linkAddress_1,
                   parentId = parentId_1,
                   defaultIndex = defaultIndex_1-1,
                   relatedModuleId = relatedModuleId_1 
             WHERE id = id_1;	
        END if;
    END if;
end;
/
/*选择主菜单配置信息 根据 id*/
CREATE or replace PROCEDURE MainMenuInfo_SelectById(
    id_1 	integer ,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor) 
AS
begin
open thecursor for
    SELECT id,labelId,menuName,linkAddress,parentFrame,defaultParentId,
     defaultLevel,defaultIndex,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,
     needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,
     needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId 
      FROM MainMenuInfo 
     WHERE id = id_1;
end;
/

/*选择主菜单配置信息 根据 menuLevel*/
CREATE or replace PROCEDURE MainMenuInfo_SelectByLevel(
    menuLevel_1 integer,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)  
AS
begin
open thecursor for
    SELECT id,labelId,menuName,linkAddress,parentFrame,defaultParentId,
     defaultLevel,defaultIndex,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,
     needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,
     needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId 
      FROM MainMenuInfo 
     WHERE defaultLevel = menuLevel_1
     ORDER BY id;
end;
/

/*选择主菜单配置信息 根据 parentId 不是系统级菜单*/
CREATE or replace PROCEDURE MainMenuInfo_SelectByParentId(
    parentId_1 	integer ,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
    SELECT id,labelId,menuName,linkAddress,parentFrame,defaultParentId,
     defaultLevel,defaultIndex,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,
     needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,
     needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId 
      FROM MainMenuInfo 
     WHERE defaultParentId = parentId_1
     ORDER BY id;
end;
/

/*由于 MainMenuInfo 表的增加，在 MainMenuConfig 增加、一条记录 
  更新所有用户 ViewIndex 大于 MainMenuConfig 增加的记录的 defaultIndex 的 MainMenuConfig viewIndex 配置信息*/
CREATE or replace PROCEDURE MainMenuConfig_U_ByInfoInsert(
    defaultParentId_1      integer,
    defaultIndex_1     integer,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS
 userId integer;   
 updateId integer;
 updateIndex integer;
begin    
        /*系统管理员*/
        updateIndex := defaultIndex_1;

        FOR mainMenuConfig_cursor in( 
        SELECT t2.id FROM MainMenuInfo t1,MainMenuConfig t2 
	     WHERE t1.id = t2.infoId 
           AND t2.userId = 1
           AND t1.defaultParentId = defaultParentId_1
           AND t2.viewIndex >= defaultIndex_1 
         ORDER BY defaultIndex)
        loop
            updateId:=mainMenuConfig_cursor.id;
            updateIndex := updateIndex + 1;

            UPDATE MainMenuConfig 
               SET viewIndex = updateIndex
             WHERE id = updateId;
        END loop;

        /*用户*/

        FOR hrmResource_cursor in( 
        SELECT id FROM HrmResource order by id)
        loop
            userId:=hrmResource_cursor.id;
            updateIndex := defaultIndex_1;
            FOR mainMenuConfig_cursor_1 in( 
            SELECT t2.id FROM MainMenuInfo t1,MainMenuConfig t2 
	         WHERE t1.id = t2.infoId 
               AND t2.userId = userId
               AND t1.defaultParentId = defaultParentId_1
               AND t2.viewIndex >= defaultIndex_1 
             ORDER BY defaultIndex)
            loop
                updateId :=mainMenuConfig_cursor_1.id;
                updateIndex := updateIndex + 1;
                UPDATE MainMenuConfig 
                           SET viewIndex = updateIndex
                         WHERE id = updateId;
            END loop;
        END loop;
end;
/

CREATE or replace PROCEDURE MMConfig_U_ByInfoInsert(
    defaultParentId_1      integer,
    defaultIndex_1     integer)
AS
 userId integer;   
 updateId integer;
 updateIndex integer;
begin    
        /*系统管理员*/
        updateIndex := defaultIndex_1;

        FOR mainMenuConfig_cursor in( 
        SELECT t2.id FROM MainMenuInfo t1,MainMenuConfig t2 
	     WHERE t1.id = t2.infoId 
           AND t2.userId = 1
           AND t1.defaultParentId = defaultParentId_1
           AND t2.viewIndex >= defaultIndex_1 
         ORDER BY defaultIndex)
        loop
            updateId:=mainMenuConfig_cursor.id;
            updateIndex := updateIndex + 1;

            UPDATE MainMenuConfig 
               SET viewIndex = updateIndex
             WHERE id = updateId;
        END loop;

        /*用户*/

        FOR hrmResource_cursor in( 
        SELECT id FROM HrmResource order by id)
        loop
            userId:=hrmResource_cursor.id;
            updateIndex := defaultIndex_1;
            FOR mainMenuConfig_cursor_1 in( 
            SELECT t2.id FROM MainMenuInfo t1,MainMenuConfig t2 
	         WHERE t1.id = t2.infoId 
               AND t2.userId = userId
               AND t1.defaultParentId = defaultParentId_1
               AND t2.viewIndex >= defaultIndex_1 
             ORDER BY defaultIndex)
            loop
                updateId :=mainMenuConfig_cursor_1.id;
                updateIndex := updateIndex + 1;
                UPDATE MainMenuConfig 
                           SET viewIndex = updateIndex
                         WHERE id = updateId;
            END loop;
        END loop;
end;
/

/*增加主菜单配置信息*/
CREATE or replace PROCEDURE MainMenuInfo_Insert(
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
    relatedModuleId_1 integer,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS
    updateId integer;
    updateIndex integer;
    updateId_1 integer;
    updateIndex_1 integer;
begin
    updateIndex := defaultIndex_1;
    /*更新大于插入记录Index 的 defaultIndex 加1*/
  
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
        relatedModuleId_1
    );
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
    /*更新大于插入记录Index 的 defaultIndex 加1*/
  
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
        relatedModuleId_1
    );
    END if;
end;
/

/*删除主菜单菜单配置信息*/
CREATE or replace PROCEDURE MainMenuInfo_DeleteById(
    id_1 	integer ,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS
     defaultLevel_1 integer;
     updateId_2 integer;
     updateIndex_3 integer;
     defaultIndex_4 integer;
     defaultParentId_5 integer;
begin
    SELECT defaultLevel,defaultParentId,defaultIndex into defaultLevel_1,defaultParentId_5,defaultIndex_4
      FROM MainMenuInfo 
     WHERE id = id_1;
    DELETE FROM MainMenuInfo 
     WHERE id = id_1;
    updateIndex_3 := defaultIndex_4;

    /*更新大于删除记录Index 的 defaultIndex 减1*/
    FOR mainMenuInfo_cursor in( 
    SELECT id FROM MainMenuInfo 
     WHERE defaultParentId = defaultParentId_5
       AND defaultIndex > defaultIndex_4
     ORDER BY defaultIndex)
    loop
        updateId_2:=mainMenuInfo_cursor.id;
        UPDATE MainMenuInfo 
           SET defaultIndex = updateIndex_3
         WHERE id = updateId_2;
        updateIndex_3 := updateIndex_3 + 1;
    END loop;
end;
/

/*更新主菜单配置信息*/
CREATE or replace PROCEDURE MainMenuInfo_Update(
    id_1 		integer,
    oldIndex_1     integer,
    labelId_1	integer,
    menuName_1	Varchar2 ,
    linkAddress_1  Varchar2 ,
    parentFrame_1  Varchar2 ,
    defaultParentId_1 integer,
    defaultLevel_1 integer,
    defaultIndex_1 integer,
    needRightToVisible_1 char ,
    rightDetailToVisible_1 Varchar2 ,
    needRightToView_1 char ,
    rightDetailToView_1 Varchar2 ,
    needSwitchToVisible_1 char ,
    switchClassNameToVisible_1 Varchar2 ,
    switchMethodNameToVisible_1 Varchar2 ,
    needSwitchToView_1 char ,
    switchClassNameToView_1 Varchar2 ,
    switchMethodNameToView_1 Varchar2 ,
    relatedModuleId_1 integer,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor) 
AS
   updateId integer;
   updateIndex integer;
	
begin   
    /*更新 更新记录 defaultIndex 和原记录 defaultIndex之间 的 defaultIndex 加1*/

	IF (defaultIndex_1<oldIndex_1)
        then

            updateIndex := defaultIndex_1;
     
            FOR mainMenuInfo_cursor in( 
                SELECT id FROM MainMenuInfo 
                 WHERE defaultParentId = defaultParentId_1
                   AND defaultIndex >= defaultIndex_1 
                   AND defaultIndex <  oldIndex_1
                 ORDER BY defaultIndex)

             loop
                updateId := mainMenuInfo_cursor.id;
                updateIndex := updateIndex + 1;
                UPDATE MainMenuInfo 
                       SET defaultIndex = updateIndex
                     WHERE id = updateId;
                   
             END loop;
    END if;
    IF (defaultIndex_1>oldIndex_1)
        then

            updateIndex := oldIndex_1;

            FOR mainMenuInfo_cursor in( 
                SELECT id FROM MainMenuInfo 
                WHERE defaultParentId = defaultParentId_1
                AND defaultIndex > oldIndex_1 
                AND defaultIndex <= defaultIndex_1
                ORDER BY defaultIndex)
            loop
                updateId:=mainMenuInfo_cursor.id;
                UPDATE MainMenuInfo 
                   SET defaultIndex = updateIndex
                 WHERE id = updateId;
                updateIndex := updateIndex + 1;
               
            END loop;

    END if;

   UPDATE MainMenuInfo 
   SET labelId = labelId_1,
       menuName = menuName_1,
       linkAddress = linkAddress_1 ,
       parentFrame = parentFrame_1 ,
       defaultParentId = defaultParentId_1 ,
       defaultLevel = defaultLevel_1 ,
       defaultIndex = defaultIndex_1-1 ,
       needRightToVisible = needRightToVisible_1 ,
       rightDetailToVisible = rightDetailToVisible_1 ,
       needRightToView = needRightToView_1 ,
       rightDetailToView = rightDetailToView_1 ,
       needSwitchToVisible = needSwitchToVisible_1 ,
       switchClassNameToVisible = switchClassNameToVisible_1 ,
       switchMethodNameToVisible = switchMethodNameToVisible_1, 
       needSwitchToView = needSwitchToView_1 ,
       switchClassNameToView = switchClassNameToView_1 ,
       switchMethodNameToView = switchMethodNameToView_1, 
       relatedModuleId = relatedModuleId_1 
     WHERE id = id_1;
end;
/


/*插入系统模块信息*/
CREATE or replace PROCEDURE SystemModule_Insert(
    id_1 integer,
    moduleName_1    Varchar2,
    moduleReleased_1   char,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor) 

AS
begin
    INSERT INTO SystemModule (
        id,
        moduleName,
        moduleReleased
        ) 
    VALUES (
        id_1,
        moduleName_1,
        moduleReleased_1
    ); 
end;
/

/*删除系统模块信息*/
CREATE or replace PROCEDURE SystemModule_Delete(
    id_1  integer,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)        
AS
begin
    DELETE FROM SystemModule WHERE id = id_1;
end;
/

/*更新系统模块信息*/
CREATE or replace PROCEDURE SystemModule_UPDATE(
        id_1       integer,
	    moduleName_1     Varchar2,
        moduleReleased_1   char,
    flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)  
        
AS
begin
    UPDATE SystemModule 
	   SET moduleName = moduleName_1,
	       moduleReleased = moduleReleased_1
	 WHERE id = id_1;
end;
/