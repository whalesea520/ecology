/*由于新闻页的变化 DocFrontpage 表的更改，更新 MainMenuInfo 配置信息*/
drop TRIGGER Tri_UMMInfo_ByDocFrontpage
go
create TRIGGER Tri_UMMInfo_ByDocFrontpage ON DocFrontpage WITH ENCRYPTION
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
IF (@countinsert > 0 and  @countdelete = 0) BEGIN

    SELECT @id_1 = id , @frontpagename_1 = frontpagename , @isactive_1 = isactive ,@publishtype_1 = publishtype 
      FROM inserted

    SELECT @defaultIndex_1 = COUNT(defaultIndex) 
      FROM MainMenuInfo 
     WHERE defaultparentId =1   
    IF (@isactive_1 = 1 AND @publishtype_1 = 1) BEGIN
        
        SET @linkAddress_1 = '/docs/news/NewsDsp.jsp?id='+CAST(@id_1 AS varchar(12))

   
        
        INSERT INTO MainMenuInfo (
            id,
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
            @id_1*-1,
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

/*如果做update操作*/

IF (@countinsert > 0 and  @countdelete >0) BEGIN

    SELECT @id_1 = id , @frontpagename_1 = frontpagename , @isactive_1 = isactive ,@publishtype_1 = publishtype 
      FROM inserted

    SELECT @defaultIndex_1 = COUNT(defaultIndex) 
      FROM MainMenuInfo 
     WHERE defaultparentId =1   

        SET @linkAddress_1 = '/docs/news/NewsDsp.jsp?id='+CAST(@id_1 AS varchar(12))
        update  MainMenuInfo set menuName=@frontpagename_1,linkAddress=@linkAddress_1,defaultIndex=@defaultIndex_1 where id =  @id_1*-1      

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
