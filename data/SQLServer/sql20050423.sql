/*根据用户 id 增加的用户左侧菜单配置信息*/
CREATE PROCEDURE LeftMenuConfig_InsertByUserId(
    @userId_1       int,
    @flag	int	output, 
    @msg	varchar(80)	output) 
AS
DECLARE @id_1 int,
        @defaultIndex_1 int

    DECLARE leftMenuInfo_cursor CURSOR FOR
    SELECT id, defaultIndex FROM LeftMenuInfo

    OPEN leftMenuInfo_cursor
    FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex) VALUES(@userId_1,@id_1,1,@defaultIndex_1)
        FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1
        
    END

    CLOSE leftMenuInfo_cursor
    DEALLOCATE leftMenuInfo_cursor

GO

/*根据用户 id 增加的用户主菜单配置信息*/
CREATE PROCEDURE MainMenuConfig_InsertByUserId(
    @userId_1         int,
    @flag	int	output, 
    @msg	varchar(80)	output) 
AS
DECLARE @id_1 int,
        @defaultParentId_1 int,
        @defaultIndex_1 int,
        @defaultLevel_1 int

    DECLARE mainMenuInfo_cursor CURSOR FOR
    SELECT id,defaultParentId, defaultIndex, defaultLevel FROM MainMenuInfo

    OPEN mainMenuInfo_cursor
    FETCH NEXT FROM mainMenuInfo_cursor INTO @id_1,@defaultParentId_1,@defaultIndex_1,@defaultLevel_1

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO MainMenuConfig (userId,infoId,visible,parentId,viewIndex,menuLevel) VALUES(@userId_1,@id_1,1,@defaultParentId_1,@defaultIndex_1,@defaultLevel_1)
        FETCH NEXT FROM mainMenuInfo_cursor INTO @id_1,@defaultParentId_1,@defaultIndex_1,@defaultLevel_1
        
    END

    CLOSE mainMenuInfo_cursor
    DEALLOCATE mainMenuInfo_cursor

GO

/*由于 LeftMenuInfo 表的增加，在 LeftMenuConfig 增加、一条记录 
  更新所有用户 ViewIndex 大于 LeftMenuConfig 增加的记录的 defaultIndex 的 LeftMenuConfig viewIndex 配置信息*/
CREATE PROCEDURE LeftMenuConfig_U_ByInfoInsert(
    @menuLevel_1      int,
    @parentId_1      int,
    @defaultIndex_1     int,
    @flag            int	output, 
    @msg             varchar(80)	output) 
AS
DECLARE @userId int;
    
DECLARE @updateId int;
DECLARE @updateIndex int;

    
    /*顶级菜单*/
    IF (@menuLevel_1 = 1) BEGIN
        
       
        /*系统管理员*/
        SET @updateIndex = @defaultIndex_1;

        DECLARE leftMenuConfig_cursor CURSOR FOR
        SELECT t2.id FROM LeftMenuInfo t1,LeftMenuConfig t2 
	     WHERE t1.id = t2.infoId 
           AND t2.userId = 1
           AND t1.parentId IS NULL
           AND t2.viewIndex >= @defaultIndex_1 
         ORDER BY defaultIndex
        
        OPEN leftMenuConfig_cursor
        FETCH NEXT FROM leftMenuConfig_cursor INTO @updateId

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @updateIndex = @updateIndex + 1;

            UPDATE LeftMenuConfig 
               SET viewIndex = @updateIndex
             WHERE id = @updateId
	       

            FETCH NEXT FROM leftMenuConfig_cursor INTO @updateId

        END

        CLOSE leftMenuConfig_cursor
        DEALLOCATE leftMenuConfig_cursor

        /*用户*/


        DECLARE hrmResource_cursor CURSOR FOR
        SELECT id FROM HrmResource order by id

        OPEN hrmResource_cursor
        FETCH NEXT FROM hrmResource_cursor INTO @userId

        WHILE @@FETCH_STATUS = 0
        BEGIN
            
            SET @updateIndex = @defaultIndex_1;
            DECLARE leftMenuConfig_cursor_1 CURSOR FOR
            SELECT t2.id FROM LeftMenuInfo t1,LeftMenuConfig t2 
	         WHERE t1.id = t2.infoId 
               AND t2.userId = @userId
               AND t1.parentId IS NULL
               AND t2.viewIndex >= @defaultIndex_1 
             ORDER BY defaultIndex
        
            OPEN leftMenuConfig_cursor_1
            FETCH NEXT FROM leftMenuConfig_cursor_1 INTO @updateId 

            WHILE @@FETCH_STATUS = 0
            BEGIN
		SET @updateIndex = @updateIndex + 1;
                UPDATE LeftMenuConfig 
                   SET viewIndex = @updateIndex
                 WHERE id = @updateId
                FETCH NEXT FROM leftMenuConfig_cursor_1 INTO @updateId
            END

            CLOSE leftMenuConfig_cursor_1
            DEALLOCATE leftMenuConfig_cursor_1
        
            FETCH NEXT FROM hrmResource_cursor INTO @userId
        END
        CLOSE hrmResource_cursor
        DEALLOCATE hrmResource_cursor

    END
    ELSE
    BEGIN
        
        /*系统管理员*/
        SET @updateIndex = @defaultIndex_1;
        DECLARE leftMenuConfig_cursor CURSOR FOR
        SELECT t2.id FROM LeftMenuInfo t1,LeftMenuConfig t2 
	     WHERE t1.id = t2.infoId 
           AND t2.userId = 1
           AND t1.parentId = @parentId_1
           AND t2.viewIndex >= @defaultIndex_1 
         ORDER BY defaultIndex
        
        OPEN leftMenuConfig_cursor
        FETCH NEXT FROM leftMenuConfig_cursor INTO @updateId

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @updateIndex = @updateIndex + 1;
            UPDATE LeftMenuConfig 
               SET viewIndex = @updateIndex 
             WHERE id = @updateId
            FETCH NEXT FROM leftMenuConfig_cursor INTO @updateId
        END

        CLOSE leftMenuConfig_cursor
        DEALLOCATE leftMenuConfig_cursor

        /*用户*/
        DECLARE hrmResource_cursor CURSOR FOR
        SELECT id FROM HrmResource order by id

        OPEN hrmResource_cursor
        FETCH NEXT FROM hrmResource_cursor INTO @userId

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @updateIndex = @defaultIndex_1;

            DECLARE leftMenuConfig_cursor_1 CURSOR FOR
            SELECT t2.id FROM LeftMenuInfo t1,LeftMenuConfig t2 
	         WHERE t1.id = t2.infoId 
               AND t2.userId = @userId
               AND t1.parentId = @parentId_1
               AND t2.viewIndex >= @defaultIndex_1 
             ORDER BY defaultIndex
        
            OPEN leftMenuConfig_cursor_1
            FETCH NEXT FROM leftMenuConfig_cursor_1 INTO @updateId

            WHILE @@FETCH_STATUS = 0
            BEGIN
                SET @updateIndex = @updateIndex + 1
                UPDATE LeftMenuConfig 
                   SET viewIndex = @updateIndex
                 WHERE id = @updateId
                FETCH NEXT FROM leftMenuConfig_cursor_1 INTO @updateId
            END

            CLOSE leftMenuConfig_cursor_1
            DEALLOCATE leftMenuConfig_cursor_1
        
            FETCH NEXT FROM hrmResource_cursor INTO @userId
        END
        CLOSE hrmResource_cursor
        DEALLOCATE hrmResource_cursor

    END

GO

/*选择个人功能区菜单配置信息 根据 Id*/
CREATE PROCEDURE LeftMenuInfo_SelectById(
    @id_1 	int ,
    @flag	int	output, 
    @msg	varchar(80)	output) 
AS
    SELECT id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId 
      FROM LeftMenuInfo 
     WHERE id = @id_1
       SET @flag = 1 
       SET @msg = 'ok'
GO

/*选择个人功能区菜单配置信息 根据 menuLevel*/
CREATE PROCEDURE LeftMenuInfo_SelectByLevel(
    @menuLevel_1 	int ,
    @flag	int	output, 
    @msg	varchar(80)	output) 
AS
    SELECT id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId 
      FROM LeftMenuInfo 
     WHERE menuLevel = @menuLevel_1
     ORDER BY id
       SET @flag = 1 
       SET @msg = 'ok'
GO

/*选择个人功能区菜单配置信息 根据 parentId 不是顶级菜单*/
CREATE PROCEDURE LeftMenuInfo_SelectByParentId(
    @parentId_1 	int ,
    @flag	int	output, 
    @msg	varchar(80)	output) 
AS
    SELECT id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId 
      FROM LeftMenuInfo 
     WHERE parentId = @parentId_1
     ORDER BY id
       SET @flag = 1 
       SET @msg = 'ok'
GO


/*增加个人功能区菜单配置信息*/
CREATE PROCEDURE LeftMenuInfo_Insert(
    @id_1 		int ,
    @labelId_1 		int ,
    @iconUrl_1		varchar(100),
    @linkAddress_1      varchar(100),
    @menuLevel_1	int,
    @parentId_1		int,
    @defaultIndex_1	int,
    @relatedModuleId_1  int,
    @flag		int	output, 
    @msg		varchar(80)	output) 
AS


        DECLARE @updateId int;
        DECLARE @updateIndex int;

    /*顶级菜单*/
    IF (@menuLevel_1 = 1) BEGIN

	SET @updateIndex = @defaultIndex_1;
        /*更新大于插入记录Index 的 defaultIndex 加1*/

	    DECLARE leftMenuInfo_cursor CURSOR FOR
	    SELECT id FROM LeftMenuInfo 
	     WHERE parentId IS NULL
	       AND defaultIndex >= @defaultIndex_1 
             ORDER BY defaultIndex

	    OPEN leftMenuInfo_cursor
        FETCH NEXT FROM leftMenuInfo_cursor INTO @updateId

        WHILE @@FETCH_STATUS = 0
        BEGIN
	    SET @updateIndex = @updateIndex + 1;
            UPDATE LeftMenuInfo 
               SET defaultIndex = @updateIndex
             WHERE id = @updateId
            FETCH NEXT FROM leftMenuInfo_cursor INTO @updateId
        END

        CLOSE leftMenuInfo_cursor
        DEALLOCATE leftMenuInfo_cursor

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
            @id_1,
	        @labelId_1,
	        NULL,
	        NULL,
	        @menuLevel_1,
	        NULL,
	        @defaultIndex_1,
	        @relatedModuleId_1
	    )
    END
    ELSE 
    BEGIN

    	SET @updateIndex = @defaultIndex_1;
    /*更新大于插入记录Index 的 defaultIndex 加1*/
	    DECLARE leftMenuInfo_cursor CURSOR FOR
	    SELECT id FROM LeftMenuInfo 
	     WHERE parentId = @parentId_1
	       AND defaultIndex >= @defaultIndex_1
             ORDER BY defaultIndex

	    OPEN leftMenuInfo_cursor
        FETCH NEXT FROM leftMenuInfo_cursor INTO @updateId

        WHILE @@FETCH_STATUS = 0
        BEGIN
	    SET @updateIndex = @updateIndex + 1;

            UPDATE LeftMenuInfo 
               SET defaultIndex = @updateIndex
             WHERE id = @updateId
            FETCH NEXT FROM leftMenuInfo_cursor INTO @updateId
        END

        CLOSE leftMenuInfo_cursor
        DEALLOCATE leftMenuInfo_cursor

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
            @id_1,
	        @labelId_1,
	        @iconUrl_1,
	        @linkAddress_1,
	        @menuLevel_1,
	        @parentId_1,
	        @defaultIndex_1,
	        @relatedModuleId_1
    	) 
    END
 

    SET @flag = 1 
    SET @msg = 'ok'
	
GO

/*删除个人功能区菜单配置信息*/
CREATE PROCEDURE LeftMenuInfo_DeleteById(
    @id_1 	int ,
    @flag	int	output, 
    @msg	varchar(80)	output) 
AS
    DECLARE @menuLevel int
    DECLARE @updateId int
    DECLARE @updateIndex int
    DECLARE @defaultIndex int
    DECLARE @parentId int

    SELECT @menuLevel = menuLevel ,@parentId = parentId,@defaultIndex = defaultIndex 
      FROM LeftMenuInfo 
     WHERE id = @id_1

    DELETE FROM LeftMenuInfo 
     WHERE id = @id_1

       SET @updateIndex = @defaultIndex;

    /*顶级菜单*/
    IF (@menuLevel = 1) BEGIN
        /*更新大于插入记录Index 的 defaultIndex 减1*/

	    DECLARE leftMenuInfo_cursor CURSOR FOR
	    SELECT id FROM LeftMenuInfo 
	     WHERE parentId IS NULL
	       AND defaultIndex > @defaultIndex 
         ORDER BY defaultIndex

	    OPEN leftMenuInfo_cursor
        FETCH NEXT FROM leftMenuInfo_cursor INTO @updateId 

        WHILE @@FETCH_STATUS = 0
        BEGIN

            UPDATE LeftMenuInfo 
               SET defaultIndex = @updateIndex
             WHERE id = @updateId
            
            SET @updateIndex = @updateIndex + 1;

            FETCH NEXT FROM leftMenuInfo_cursor INTO @updateId
        END

        CLOSE leftMenuInfo_cursor
        DEALLOCATE leftMenuInfo_cursor
    END
    ELSE 
    BEGIN

        /*更新大于插入记录Index 的 defaultIndex 减1*/
	    DECLARE leftMenuInfo_cursor CURSOR FOR
	    SELECT id FROM LeftMenuInfo 
	     WHERE parentId = @parentId
	       AND defaultIndex > @defaultIndex 
         ORDER BY defaultIndex

	    OPEN leftMenuInfo_cursor
        FETCH NEXT FROM leftMenuInfo_cursor INTO @updateId

        WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE LeftMenuInfo 
               SET defaultIndex = @updateIndex
             WHERE id = @updateId

            SET @updateIndex = @updateIndex + 1;

            FETCH NEXT FROM leftMenuInfo_cursor INTO @updateId 
        END

        CLOSE leftMenuInfo_cursor
        DEALLOCATE leftMenuInfo_cursor
    END
       
    SET @flag = 1 
    SET @msg = 'ok'

GO
/*更新个人功能区菜单配置信息*/
CREATE PROCEDURE LeftMenuInfo_Update(
    @id_1 		int,
    @oldIndex_1		int,
    @labelId_1 		int,
    @iconUrl_1		varchar(100),
    @linkAddress_1      varchar(100),
    @menuLevel_1	int,
    @parentId_1		int,
    @defaultIndex_1	int,
    @relatedModuleId_1  int,
    @flag		int	output, 
    @msg		varchar(80)	output) 
AS


        DECLARE @updateId int;
        DECLARE @updateIndex int;
	

    
    /*顶级菜单*/
    IF (@menuLevel_1 = 1) BEGIN

        /*更新 更新记录 defaultIndex 和原记录 defaultIndex之间 的 defaultIndex 加1*/

	IF (@defaultIndex_1<@oldIndex_1) BEGIN

	    SET @updateIndex = @defaultIndex_1;
 
            DECLARE leftMenuInfo_cursor CURSOR FOR
	    SELECT id FROM LeftMenuInfo 
	     WHERE parentId IS NULL
	       AND defaultIndex >= @defaultIndex_1 
	       AND defaultIndex <  @oldIndex_1
         ORDER BY defaultIndex

            OPEN leftMenuInfo_cursor
            FETCH NEXT FROM leftMenuInfo_cursor INTO @updateId

            WHILE @@FETCH_STATUS = 0
            BEGIN
	        SET @updateIndex = @updateIndex + 1;
	
                UPDATE LeftMenuInfo 
                   SET defaultIndex = @updateIndex
                 WHERE id = @updateId
                FETCH NEXT FROM leftMenuInfo_cursor INTO @updateId
            END

            CLOSE leftMenuInfo_cursor
            DEALLOCATE leftMenuInfo_cursor

             UPDATE LeftMenuInfo 
                SET labelId = @labelId_1,
                    defaultIndex = @defaultIndex_1,
                    relatedModuleId = @relatedModuleId_1 
              WHERE id = @id_1
    END
	IF (@defaultIndex_1>@oldIndex_1) BEGIN

	    SET @updateIndex = @oldIndex_1;

            DECLARE leftMenuInfo_cursor CURSOR FOR
	    SELECT id FROM LeftMenuInfo 
	     WHERE parentId IS NULL
	       AND defaultIndex > @oldIndex_1 
	       AND defaultIndex <= @defaultIndex_1
         ORDER BY defaultIndex

            OPEN leftMenuInfo_cursor
            FETCH NEXT FROM leftMenuInfo_cursor INTO @updateId

            WHILE @@FETCH_STATUS = 0
            BEGIN
                UPDATE LeftMenuInfo 
                   SET defaultIndex = @updateIndex
                 WHERE id = @updateId
	        SET @updateIndex = @updateIndex + 1;
                FETCH NEXT FROM leftMenuInfo_cursor INTO @updateId
            END

            CLOSE leftMenuInfo_cursor
            DEALLOCATE leftMenuInfo_cursor

             UPDATE LeftMenuInfo 
                SET labelId = @labelId_1,
                    defaultIndex = @defaultIndex_1-1,
                    relatedModuleId = @relatedModuleId_1 
              WHERE id = @id_1
	END
    END
    ELSE 
    BEGIN

        /*更新 更新记录 defaultIndex 和原记录 defaultIndex 之间的 defaultIndex 加1*/

	IF (@defaultIndex_1<@oldIndex_1) BEGIN

	    SET @updateIndex = @defaultIndex_1;
 
            DECLARE leftMenuInfo_cursor CURSOR FOR
	    SELECT id FROM LeftMenuInfo 
	     WHERE parentId = @parentId_1 
	       AND defaultIndex >= @defaultIndex_1 
	       AND defaultIndex <  @oldIndex_1
         ORDER BY defaultIndex

	    OPEN leftMenuInfo_cursor
            FETCH NEXT FROM leftMenuInfo_cursor INTO @updateId
 
            WHILE @@FETCH_STATUS = 0
            BEGIN

	        SET @updateIndex = @updateIndex + 1;
                UPDATE LeftMenuInfo 
                   SET defaultIndex = @updateIndex
                 WHERE id = @updateId
                FETCH NEXT FROM leftMenuInfo_cursor INTO @updateId
            END

            CLOSE leftMenuInfo_cursor
            DEALLOCATE leftMenuInfo_cursor
            UPDATE LeftMenuInfo 
               SET labelId = @labelId_1,
                   iconUrl = @iconUrl_1,
                   linkAddress = @linkAddress_1,
                   parentId = @parentId_1,
                   defaultIndex = @defaultIndex_1,
                   relatedModuleId = @relatedModuleId_1 
             WHERE id = @id_1	
	END
	IF (@defaultIndex_1>@oldIndex_1) BEGIN

	    SET @updateIndex = @oldIndex_1;

            DECLARE leftMenuInfo_cursor CURSOR FOR
	    SELECT id FROM LeftMenuInfo 
	     WHERE parentId = @parentId_1
	       AND defaultIndex > @oldIndex_1 
	       AND defaultIndex <= @defaultIndex_1
         ORDER BY defaultIndex

	    OPEN leftMenuInfo_cursor
            FETCH NEXT FROM leftMenuInfo_cursor INTO @updateId
 
            WHILE @@FETCH_STATUS = 0
            BEGIN

                UPDATE LeftMenuInfo 
                   SET defaultIndex = @updateIndex
                 WHERE id = @updateId
	        SET @updateIndex = @updateIndex + 1;
                FETCH NEXT FROM leftMenuInfo_cursor INTO @updateId
            END

            CLOSE leftMenuInfo_cursor
            DEALLOCATE leftMenuInfo_cursor

            UPDATE LeftMenuInfo 
               SET labelId = @labelId_1,
                   iconUrl = @iconUrl_1,
                   linkAddress = @linkAddress_1,
                   parentId = @parentId_1,
                   defaultIndex = @defaultIndex_1-1,
                   relatedModuleId = @relatedModuleId_1 
             WHERE id = @id_1	
    END


    END
 

    SET @flag = 1 
    SET @msg = 'ok'

GO

/*选择主菜单配置信息 根据 id*/
CREATE PROCEDURE MainMenuInfo_SelectById(
    @id_1 	int ,
    @flag	int	output, 
    @msg	varchar(80)	output) 
AS    
    SELECT id,labelId,menuName,linkAddress,parentFrame,defaultParentId,
     defaultLevel,defaultIndex,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,
     needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,
     needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId 
      FROM MainMenuInfo 
     WHERE id = @id_1
       SET @flag = 1 
       SET @msg = 'ok'

GO

/*选择主菜单配置信息 根据 menuLevel*/
CREATE PROCEDURE MainMenuInfo_SelectByLevel(
    @menuLevel_1 	int ,
    @flag	int	output, 
    @msg	varchar(80)	output) 
AS
    SELECT id,labelId,menuName,linkAddress,parentFrame,defaultParentId,
     defaultLevel,defaultIndex,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,
     needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,
     needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId 
      FROM MainMenuInfo 
     WHERE defaultLevel = @menuLevel_1
     ORDER BY id
       SET @flag = 1 
       SET @msg = 'ok'
GO

/*选择主菜单配置信息 根据 parentId 不是系统级菜单*/
CREATE PROCEDURE MainMenuInfo_SelectByParentId(
    @parentId_1 	int ,
    @flag	int	output, 
    @msg	varchar(80)	output) 
AS
    SELECT id,labelId,menuName,linkAddress,parentFrame,defaultParentId,
     defaultLevel,defaultIndex,needRightToVisible,rightDetailToVisible,needRightToView,rightDetailToView,
     needSwitchToVisible,switchClassNameToVisible,switchMethodNameToVisible,
     needSwitchToView,switchClassNameToView,switchMethodNameToView,relatedModuleId 
      FROM MainMenuInfo 
     WHERE defaultParentId = @parentId_1
     ORDER BY id
       SET @flag = 1 
       SET @msg = 'ok'
GO

/*由于 MainMenuInfo 表的增加，在 MainMenuConfig 增加、一条记录 
  更新所有用户 ViewIndex 大于 MainMenuConfig 增加的记录的 defaultIndex 的 MainMenuConfig viewIndex 配置信息*/
CREATE PROCEDURE MainMenuConfig_U_ByInfoInsert(
    @defaultParentId_1      int,
    @defaultIndex_1     int,
    @flag            int	output, 
    @msg             varchar(80)	output) 
AS
DECLARE @userId int;
    
DECLARE @updateId int;
DECLARE @updateIndex int;

    
       
        /*系统管理员*/
        SET @updateIndex = @defaultIndex_1;

        DECLARE mainMenuConfig_cursor CURSOR FOR
        SELECT t2.id FROM MainMenuInfo t1,MainMenuConfig t2 
	     WHERE t1.id = t2.infoId 
           AND t2.userId = 1
           AND t1.defaultParentId = @defaultParentId_1
           AND t2.viewIndex >= @defaultIndex_1 
         ORDER BY defaultIndex
        
        OPEN mainMenuConfig_cursor
        FETCH NEXT FROM mainMenuConfig_cursor INTO @updateId

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @updateIndex = @updateIndex + 1;

            UPDATE MainMenuConfig 
               SET viewIndex = @updateIndex
             WHERE id = @updateId
	       

            FETCH NEXT FROM mainMenuConfig_cursor INTO @updateId

        END

        CLOSE mainMenuConfig_cursor
        DEALLOCATE mainMenuConfig_cursor

        /*用户*/


        DECLARE hrmResource_cursor CURSOR FOR
        SELECT id FROM HrmResource order by id

        OPEN hrmResource_cursor
        FETCH NEXT FROM hrmResource_cursor INTO @userId

        WHILE @@FETCH_STATUS = 0
        BEGIN
            
            SET @updateIndex = @defaultIndex_1;
            DECLARE mainMenuConfig_cursor_1 CURSOR FOR
            SELECT t2.id FROM MainMenuInfo t1,MainMenuConfig t2 
	         WHERE t1.id = t2.infoId 
               AND t2.userId = @userId
               AND t1.defaultParentId = @defaultParentId_1
               AND t2.viewIndex >= @defaultIndex_1 
             ORDER BY defaultIndex
        
            OPEN mainMenuConfig_cursor_1
            FETCH NEXT FROM mainMenuConfig_cursor_1 INTO @updateId 

            WHILE @@FETCH_STATUS = 0
            BEGIN
		SET @updateIndex = @updateIndex + 1;
                UPDATE MainMenuConfig 
                   SET viewIndex = @updateIndex
                 WHERE id = @updateId
                FETCH NEXT FROM mainMenuConfig_cursor_1 INTO @updateId
            END

            CLOSE mainMenuConfig_cursor_1
            DEALLOCATE mainMenuConfig_cursor_1
        
            FETCH NEXT FROM hrmResource_cursor INTO @userId
        END
        CLOSE hrmResource_cursor
        DEALLOCATE hrmResource_cursor


GO

/*增加主菜单配置信息*/
CREATE PROCEDURE MainMenuInfo_Insert(
    @id_1 int,
    @labelId_1 int,
    @menuName_1 Varchar(100),
    @linkAddress_1 Varchar(100),
    @parentFrame_1 Varchar(100),
    @defaultParentId_1 int,
    @defaultLevel_1 int,
    @defaultIndex_1 int,
    @needRightToVisible_1 char(1),
    @rightDetailToVisible_1 Varchar(100),
    @needRightToView_1 char(1),
    @rightDetailToView_1 Varchar(100),
    @needSwitchToVisible_1 char(1),
    @switchClassNameToVisible_1 Varchar(100),
    @switchMethodNameToVisible_1 Varchar(100),
    @needSwitchToView_1 char(1),
    @switchClassNameToView_1 Varchar(100),
    @switchMethodNameToView_1 Varchar(100),
    @relatedModuleId_1 int, 
    @flag	int	output, 
    @msg	varchar(80)	output) 
AS

    DECLARE @updateId int;
    DECLARE @updateIndex int;

    SET @updateIndex = @defaultIndex_1;


    /*更新大于插入记录Index 的 defaultIndex 加1*/
    DECLARE @updateId_1 int
    DECLARE @updateIndex_1 int
    DECLARE mainMenuInfo_cursor CURSOR FOR
    SELECT id FROM MainMenuInfo 
     WHERE defaultParentId = @defaultParentId_1
       AND defaultIndex >= @defaultIndex_1 
     ORDER BY defaultIndex

    OPEN mainMenuInfo_cursor
    FETCH NEXT FROM mainMenuInfo_cursor INTO @updateId

    WHILE @@FETCH_STATUS = 0
    BEGIN
	SET @updateIndex = @updateIndex + 1;
        UPDATE MainMenuInfo 
           SET defaultIndex = @updateIndex
         WHERE id = @updateId
        FETCH NEXT FROM mainMenuInfo_cursor INTO @updateId
    END

    CLOSE mainMenuInfo_cursor
    DEALLOCATE mainMenuInfo_cursor

    IF(@linkAddress_1 = '')
    BEGIN
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
        @id_1,
        @labelId_1,
        @menuName_1,
        NULL ,
        @parentFrame_1 ,
        @defaultParentId_1 ,
        @defaultLevel_1 ,
        @defaultIndex_1 ,
        @needRightToVisible_1 ,
        @rightDetailToVisible_1 ,
        @needRightToView_1 ,
        @rightDetailToView_1 ,
        @needSwitchToVisible_1 ,
        @switchClassNameToVisible_1 ,
        @switchMethodNameToVisible_1 ,
        @needSwitchToView_1 ,
        @switchClassNameToView_1 ,
        @switchMethodNameToView_1 ,
        @relatedModuleId_1
    ) 
    END
    ELSE
    BEGIN
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
        @id_1,
        @labelId_1,
        @menuName_1,
        @linkAddress_1 ,
        @parentFrame_1 ,
        @defaultParentId_1 ,
        @defaultLevel_1 ,
        @defaultIndex_1 ,
        @needRightToVisible_1 ,
        @rightDetailToVisible_1 ,
        @needRightToView_1 ,
        @rightDetailToView_1 ,
        @needSwitchToVisible_1 ,
        @switchClassNameToVisible_1 ,
        @switchMethodNameToVisible_1 ,
        @needSwitchToView_1 ,
        @switchClassNameToView_1 ,
        @switchMethodNameToView_1 ,
        @relatedModuleId_1
    ) 
    END
    

    SET @flag = 1 
    SET @msg = 'ok'

GO
/*删除主菜单菜单配置信息*/
CREATE PROCEDURE MainMenuInfo_DeleteById(
    @id_1 	int ,
    @flag	int	output, 
    @msg	varchar(80)	output) 
AS
    DECLARE @defaultLevel int
    DECLARE @updateId int
    DECLARE @updateIndex int
    DECLARE @defaultIndex int
    DECLARE @defaultParentId int

    SELECT @defaultLevel = defaultLevel ,@defaultParentId = defaultParentId , @defaultIndex = defaultIndex 
      FROM MainMenuInfo 
     WHERE id = @id_1


    DELETE FROM MainMenuInfo 
     WHERE id = @id_1

    SET @updateIndex = @defaultIndex;


    /*更新大于删除记录Index 的 defaultIndex 减1*/
    DECLARE mainMenuInfo_cursor CURSOR FOR
    SELECT id FROM MainMenuInfo 
     WHERE defaultParentId = @defaultParentId
       AND defaultIndex > @defaultIndex 
     ORDER BY defaultIndex

    OPEN mainMenuInfo_cursor
    FETCH NEXT FROM mainMenuInfo_cursor INTO @updateId

    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE MainMenuInfo 
           SET defaultIndex = @updateIndex
         WHERE id = @updateId

        SET @updateIndex = @updateIndex + 1;

        FETCH NEXT FROM mainMenuInfo_cursor INTO @updateId
    END

    CLOSE mainMenuInfo_cursor
    DEALLOCATE mainMenuInfo_cursor
GO

/*更新主菜单配置信息*/
CREATE PROCEDURE MainMenuInfo_Update(
        @id_1 		int,
        @oldIndex_1     int,
        @labelId_1	int,
        @menuName_1	Varchar(100),
        @linkAddress_1  Varchar(100),
        @parentFrame_1  Varchar(100),
        @defaultParentId_1 int,
        @defaultLevel_1 int,
        @defaultIndex_1 int,
        @needRightToVisible_1 char(1),
        @rightDetailToVisible_1 Varchar(100),
        @needRightToView_1 char(1),
        @rightDetailToView_1 Varchar(100),
        @needSwitchToVisible_1 char(1),
        @switchClassNameToVisible_1 Varchar(100),
        @switchMethodNameToVisible_1 Varchar(100),
        @needSwitchToView_1 char(1),
        @switchClassNameToView_1 Varchar(100),
        @switchMethodNameToView_1 Varchar(100),
        @relatedModuleId_1 int,
    @flag		int	output, 
    @msg		varchar(80)	output) 
AS


    DECLARE @updateId int;
    DECLARE @updateIndex int;
	

    
    /*更新 更新记录 defaultIndex 和原记录 defaultIndex之间 的 defaultIndex 加1*/

	IF (@defaultIndex_1<@oldIndex_1) BEGIN

	    SET @updateIndex = @defaultIndex_1;
 
            DECLARE mainMenuInfo_cursor CURSOR FOR
	    SELECT id FROM MainMenuInfo 
	     WHERE defaultParentId = @defaultParentId_1
	       AND defaultIndex >= @defaultIndex_1 
	       AND defaultIndex <  @oldIndex_1
         ORDER BY defaultIndex

            OPEN mainMenuInfo_cursor
            FETCH NEXT FROM mainMenuInfo_cursor INTO @updateId

            WHILE @@FETCH_STATUS = 0
            BEGIN
	        SET @updateIndex = @updateIndex + 1;
	
                UPDATE MainMenuInfo 
                   SET defaultIndex = @updateIndex
                 WHERE id = @updateId
                FETCH NEXT FROM mainMenuInfo_cursor INTO @updateId
            END

            CLOSE mainMenuInfo_cursor
            DEALLOCATE mainMenuInfo_cursor
	END
	IF (@defaultIndex_1>@oldIndex_1) BEGIN

	    SET @updateIndex = @oldIndex_1;

            DECLARE mainMenuInfo_cursor CURSOR FOR
	    SELECT id FROM MainMenuInfo 
	     WHERE defaultParentId = @defaultParentId_1
	       AND defaultIndex > @oldIndex_1 
	       AND defaultIndex <= @defaultIndex_1
         ORDER BY defaultIndex

            OPEN mainMenuInfo_cursor
            FETCH NEXT FROM mainMenuInfo_cursor INTO @updateId

            WHILE @@FETCH_STATUS = 0
            BEGIN
                UPDATE MainMenuInfo 
                   SET defaultIndex = @updateIndex
                 WHERE id = @updateId
	        SET @updateIndex = @updateIndex + 1;
                FETCH NEXT FROM mainMenuInfo_cursor INTO @updateId
            END

            CLOSE mainMenuInfo_cursor
            DEALLOCATE mainMenuInfo_cursor
	END

        UPDATE MainMenuInfo 
	   SET labelId = @labelId_1,
	       menuName = @menuName_1,
	       linkAddress = @linkAddress_1 ,
	       parentFrame = @parentFrame_1 ,
	       defaultParentId = @defaultParentId_1 ,
	       defaultLevel = @defaultLevel_1 ,
	       defaultIndex = @defaultIndex_1-1 ,
	       needRightToVisible = @needRightToVisible_1 ,
	       rightDetailToVisible = @rightDetailToVisible_1 ,
	       needRightToView = @needRightToView_1 ,
	       rightDetailToView = @rightDetailToView_1 ,
	       needSwitchToVisible = @needSwitchToVisible_1 ,
	       switchClassNameToVisible = @switchClassNameToVisible_1 ,
	       switchMethodNameToVisible = @switchMethodNameToVisible_1, 
	       needSwitchToView = @needSwitchToView_1 ,
	       switchClassNameToView = @switchClassNameToView_1 ,
    	   switchMethodNameToView = @switchMethodNameToView_1, 
	       relatedModuleId = @relatedModuleId_1 

	 WHERE id = @id_1


    SET @flag = 1 
    SET @msg = 'ok'

GO


/*插入系统模块信息*/
CREATE PROCEDURE SystemModule_Insert(
        @id_1 int,
	    @moduleName_1     Varchar(100),
        @moduleReleased_1   char(1),
        @flag		int	output, 
        @msg		varchar(80)	output) 

AS
    INSERT INTO SystemModule (
        id,
        moduleName,
        moduleReleased
        ) 
    VALUES (
        @id_1,
        @moduleName_1,
        @moduleReleased_1
    ) 
    
    SET @flag = 1 
    SET @msg = 'ok'
GO

/*删除系统模块信息*/
CREATE PROCEDURE SystemModule_Delete(
        @id_1       int,
        @flag		int	output, 
        @msg		varchar(80)	output) 
        

AS

    DELETE FROM SystemModule WHERE id = @id_1

    SET @flag = 1 
    SET @msg = 'ok'

GO
/*更新系统模块信息*/
CREATE PROCEDURE SystemModule_UPDATE(
        @id_1       int,
	    @moduleName_1     Varchar(100),
        @moduleReleased_1   char(1),
        @flag		int	output, 
        @msg		varchar(80)	output) 
        
AS

    UPDATE SystemModule 
	   SET moduleName = @moduleName_1,
	       moduleReleased = @moduleReleased_1

	 WHERE id = @id_1


    SET @flag = 1 
    SET @msg = 'ok'
GO