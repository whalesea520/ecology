/*由于 LeftMenuInfo 表的更改，更新所有用户 LeftMenuConfig 配置信息*/
CREATE TRIGGER Tri_ULeftMenuConfig_ByInfo ON LeftMenuInfo WITH ENCRYPTION
FOR INSERT, UPDATE, DELETE 
AS
Declare @id_1 int,
        @defaultIndex_1 int,
        @countdelete   int,
        @countinsert   int,
        @userId int


SELECT @countdelete = count(*) FROM deleted
SELECT @countinsert = count(*) FROM inserted

/*插入时 @countinsert >0 AND @countdelete = 0 */
/*删除时 @countinsert =0 */
/*更新时 @countinsert >0 AND @countdelete > 0 */

/*插入*/
IF (@countinsert > 0 AND @countdelete = 0) BEGIN

    SELECT @id_1 = id , @defaultIndex_1 = defaultIndex FROM inserted
    /*系统管理员*/
    INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex) VALUES(1,@id_1,1,@defaultIndex_1)

    /*用户*/    
    DECLARE hrmResource_cursor CURSOR FOR
    SELECT id FROM HrmResource order by id

    OPEN hrmResource_cursor
    FETCH NEXT FROM hrmResource_cursor INTO @userId

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex) VALUES(@userId,@id_1,1,@defaultIndex_1)
        FETCH NEXT FROM hrmResource_cursor INTO @userId
    END
    CLOSE hrmResource_cursor
    DEALLOCATE hrmResource_cursor

END

/*删除*/
IF (@countinsert = 0) BEGIN

    SELECT @id_1 = id FROM deleted
    
    DELETE FROM LeftMenuConfig WHERE infoId = @id_1
END

GO

/*由于 MainMenuInfo 表的更改，更新所有用户 MainMenuConfig 配置信息*/
CREATE TRIGGER Tri_UMainMenuConfig_ByInfo ON MainMenuInfo WITH ENCRYPTION
FOR INSERT, UPDATE, DELETE 
AS
Declare @id_1 int,
        @defaultParentId_1 int,
        @defaultIndex_1 int,
        @defaultLevel_1 int,
        @countdelete   int,
        @countinsert   int,
        @userId int


SELECT @countdelete = count(*) FROM deleted
SELECT @countinsert = count(*) FROM inserted

/*插入时 @countinsert >0 AND @countdelete = 0 */
/*删除时 @countinsert =0 */
/*更新时 @countinsert >0 AND @countdelete > 0 */

/*插入*/
IF (@countinsert > 0 AND @countdelete = 0) BEGIN

    SELECT @id_1 = id , @defaultParentId_1 = defaultParentId , @defaultIndex_1 = defaultIndex ,@defaultLevel_1 = defaultLevel 
      FROM inserted
    /*系统管理员*/

    INSERT INTO MainMenuConfig (userId,infoId,visible,parentId,viewIndex,menuLevel) VALUES(1,@id_1,1,@defaultParentId_1,@defaultIndex_1,@defaultLevel_1)

    /*用户*/    
    DECLARE hrmResource_cursor CURSOR FOR
    SELECT id FROM HrmResource order by id

    OPEN hrmResource_cursor
    FETCH NEXT FROM hrmResource_cursor INTO @userId

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO MainMenuConfig (userId,infoId,visible,parentId,viewIndex,menuLevel) VALUES(@userId,@id_1,1,@defaultParentId_1,@defaultIndex_1,@defaultLevel_1)
        FETCH NEXT FROM hrmResource_cursor INTO @userId
    END
    CLOSE hrmResource_cursor
    DEALLOCATE hrmResource_cursor

END

/*删除*/
IF (@countinsert = 0) BEGIN

    SELECT @id_1 = id FROM deleted
    
    DELETE FROM MainMenuConfig WHERE infoId = @id_1
END

GO

/*由于新闻页的变化 DocFrontpage 表的更改，更新 MainMenuInfo 配置信息*/
CREATE TRIGGER Tri_UMainMenuInfo_ByDocFrontpage ON DocFrontpage WITH ENCRYPTION
FOR INSERT, UPDATE, DELETE 
AS
Declare @id_1 int,
        @frontpagename_1 varchar(200),
        @isactive_1 char(1),
        @publishtype_1 int,
        @linkAddress_1 varchar(100),
        @defaultIndex_1 int,
        @countdelete   int,
        @countinsert   int,
        @updateId int,
        @updateIndex int


SELECT @countdelete = count(*) FROM deleted
SELECT @countinsert = count(*) FROM inserted

/*插入时 @countinsert >0 AND @countdelete = 0 */
/*删除时 @countinsert =0 */
/*更新时 @countinsert >0 AND @countdelete > 0 */

/*插入 或 更新 如果增加、更新的新闻页 是活跃状态(isactive = 1) 并且是发布类型是用户(publishType = 1) 那么在 MainMenuInfo 中增加一个 新闻页的菜单 信息*/
IF (@countinsert > 0) BEGIN

    SELECT @id_1 = id , @frontpagename_1 = frontpagename , @isactive_1 = isactive ,@publishtype_1 = publishtype 
      FROM inserted

    SELECT @defaultIndex_1 = COUNT(defaultIndex) 
      FROM MainMenuInfo 
     WHERE defaultparentId =1 
       

    IF (@isactive_1 = 1 AND @publishtype_1 = 1) BEGIN
        
        SET @linkAddress_1 = '/docs/news/NewsDsp.jsp?id='+CAST(@id_1 AS varchar(12))

        INSERT INTO MainMenuInfo (
            menuName , 
            linkAddress , 
            parentFrame ,
            defaultParentId ,
            defaultLevel , 
            defaultIndex , 
            needRightToVisible , 
            needRightToView , 
            needSwitchToVisible , 
            relatedModuleId
        )
        VALUES (
            @frontpagename_1,
            @linkAddress_1,
            'mainFrame',
            1,
            1,
            @defaultIndex_1,
            0,
            0,
            0,
            9
        ) 

        /*更新新闻设置的顺序号*/
        UPDATE MainMenuInfo
           SET defaultIndex = @defaultIndex_1 + 1
         WHERE defaultparentId =1
           AND labelId IS NOT NULL

    END
END

/*删除 如果删除的新闻页 是活跃状态(isactive = 1) 并且是发布类型是用户(publishType = 1) 那么在 MainMenuInfo 中删除相应的 新闻页的菜单 信息*/
IF (@countinsert = 0) BEGIN

    SELECT @id_1 = id FROM deleted

    SELECT @defaultIndex_1 = defaultIndex 
      FROM MainMenuInfo 
     WHERE linkAddress = '/docs/news/NewsDsp.jsp?id='+CAST(@id_1 AS varchar(12))
    
    DELETE FROM MainMenuInfo WHERE linkAddress = '/docs/news/NewsDsp.jsp?id='+CAST(@id_1 AS varchar(12))

    /*更新大于删除记录Index 的 defaultIndex 减1*/
    DECLARE mainMenuInfo_cursor CURSOR FOR
    SELECT id FROM MainMenuInfo 
     WHERE defaultParentId = 1
       AND defaultIndex > @defaultIndex_1 

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

GO

/*由于 新建用户 HrmResource 表的更改 ，更新该用户 LeftMenuConfig MainMenuConfig 配置信息*/
CREATE TRIGGER Tri_UMainMenuInfo_ByHrmResource ON HrmResource WITH ENCRYPTION
FOR INSERT 
AS
    DECLARE @userId_1 int
	DECLARE @flag_1 int
	DECLARE @msg_1 varchar(80)


    SELECT @userId_1 = id FROM inserted

    EXEC LeftMenuConfig_InsertByUserId @userId_1,@flag = @flag_1 OUTPUT,@msg = @msg_1 OUTPUT

    EXEC MainMenuConfig_InsertByUserId @userId_1,@flag = @flag_1 OUTPUT,@msg = @msg_1 OUTPUT

GO
