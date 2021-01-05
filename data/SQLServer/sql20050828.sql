
INSERT INTO HtmlLabelIndex values(17869,'管理员设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(17869,'管理员设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17869,'SysadminSet',8) 
GO

EXECUTE MMConfig_U_ByInfoInsert 11,9
GO
EXECUTE MMInfo_Insert 383,17869,'管理员设置','/systeminfo/sysadmin/sysadminList.jsp','mainFrame',11,1,9,0,'',0,'',0,'','',0,'','',9
GO

INSERT INTO HtmlLabelIndex values(17870,'管理员帐号') 
GO
INSERT INTO HtmlLabelInfo VALUES(17870,'管理员帐号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17870,'Manager Account',8) 
GO

alter table HrmResourceManager add description varchar(255)
GO
update HrmResourceManager set description='e-cology默认系统管理员' where loginid='sysadmin'
GO

insert into HtmlNoteIndex (id,indexdesc) values (64,'帐号重复') 
GO
insert into HtmlNoteInfo (indexid,notename,languageid) values (64, '该帐号已经存在，请填写一个新的帐号！', 7) 
GO
insert into HtmlNoteInfo (indexid,notename,languageid) values (64, 'Sorry,this account has bean registered.Please choose a new one!', 8) 
GO



alter PROCEDURE HrmResource_SByLoginIDPass ( @loginid   varchar(60), @password  varchar(100), @flag	int	output, @msg	varchar(80)	output ) AS declare @count int 
begin 
	select @count = count(id) from HrmResource where loginid= @loginid 
	if @count <> 0 
		begin 
			select @count = count(id) from HrmResource where loginid= @loginid and password = @password 
			if @count <> 0 
				select * from HrmResource where loginid= @loginid 
			else 
				select 0 
		end 
	else 
		begin 
			select @count = count(id) from HrmResourceManager where loginid= @loginid 
			if @count <> 0 
				begin 
					select @count = count(id) from HrmResourceManager where loginid = @loginid and password = @password 
					if @count <> 0 
						select * from HrmResourceManager where loginid= @loginid 
					else 
						select 0 
				end 
		end 
end
GO

/*由于 LeftMenuInfo 表的增加，在 LeftMenuConfig 增加、一条记录 
  更新所有用户 ViewIndex 大于 LeftMenuConfig 增加的记录的 defaultIndex 的 LeftMenuConfig viewIndex 配置信息*/



alter PROCEDURE LMConfig_U_ByInfoInsert(
    @menuLevel_1      int,
    @parentId_1      int,
    @defaultIndex_1     int) 
AS
DECLARE @userId int;
    
DECLARE @updateId int;
DECLARE @updateIndex int;

    
    /*顶级菜单*/
    IF (@menuLevel_1 = 1) BEGIN
        
        DECLARE hrmResourcemanager_cursor CURSOR FOR
        SELECT id FROM HrmResourceManager order by id

        OPEN hrmResourcemanager_cursor
        FETCH NEXT FROM hrmResourcemanager_cursor INTO @userId

        WHILE @@FETCH_STATUS = 0
        BEGIN
        /*系统管理员*/
	        SET @updateIndex = @defaultIndex_1;
	
	        DECLARE leftMenuConfig_cursor CURSOR FOR
	        SELECT t2.id FROM LeftMenuInfo t1,LeftMenuConfig t2 
		     WHERE t1.id = t2.infoId 
	           AND t2.userId = @userId
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
	        
            FETCH NEXT FROM hrmResourcemanager_cursor INTO @userId
        END
        CLOSE hrmResourcemanager_cursor
        DEALLOCATE hrmResourcemanager_cursor
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
    
        DECLARE hrmResourcemanager_cursor CURSOR FOR
        SELECT id FROM HrmResourceManager order by id

        OPEN hrmResourcemanager_cursor
        FETCH NEXT FROM hrmResourcemanager_cursor INTO @userId

        WHILE @@FETCH_STATUS = 0
        BEGIN
	        /*系统管理员*/
	        SET @updateIndex = @defaultIndex_1;
	        DECLARE leftMenuConfig_cursor CURSOR FOR
	        SELECT t2.id FROM LeftMenuInfo t1,LeftMenuConfig t2 
		     WHERE t1.id = t2.infoId 
	           AND t2.userId = @userId
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
	        
            FETCH NEXT FROM hrmResourcemanager_cursor INTO @userId
        END
        CLOSE hrmResourcemanager_cursor
        DEALLOCATE hrmResourcemanager_cursor
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

/*由于 MainMenuInfo 表的增加，在 MainMenuConfig 增加、一条记录 
  更新所有用户 ViewIndex 大于 MainMenuConfig 增加的记录的 defaultIndex 的 MainMenuConfig viewIndex 配置信息*/
  


alter PROCEDURE MMConfig_U_ByInfoInsert(
    @defaultParentId_1      int,
    @defaultIndex_1     int) 
AS
DECLARE @userId int;
    
DECLARE @updateId int;
DECLARE @updateIndex int;

    
        DECLARE hrmResourcemanager_cursor CURSOR FOR
        SELECT id FROM HrmResourceManager order by id

        OPEN hrmResourcemanager_cursor
        FETCH NEXT FROM hrmResourcemanager_cursor INTO @userId

        WHILE @@FETCH_STATUS = 0
        BEGIN
	        /*系统管理员*/
	        SET @updateIndex = @defaultIndex_1;
	
	        DECLARE mainMenuConfig_cursor CURSOR FOR
	        SELECT t2.id FROM MainMenuInfo t1,MainMenuConfig t2 
		     WHERE t1.id = t2.infoId 
	           AND t2.userId = @userId
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
	        
            FETCH NEXT FROM hrmResourcemanager_cursor INTO @userId
        END
        CLOSE hrmResourcemanager_cursor
        DEALLOCATE hrmResourcemanager_cursor
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

/*由于 新建管理员 HrmResourceManager 表的更改 ，更新该管理员 LeftMenuConfig MainMenuConfig 配置信息*/
CREATE TRIGGER Tri_UMMInfo_ByHrmResourceManager ON HrmResourceManager WITH ENCRYPTION
FOR INSERT 
AS
    DECLARE @userId_1 int
	DECLARE @flag_1 int
	DECLARE @msg_1 varchar(80)


    SELECT @userId_1 = id FROM inserted

    EXEC LeftMenuConfig_InsertByUserId @userId_1,@flag = @flag_1 OUTPUT,@msg = @msg_1 OUTPUT

    EXEC MainMenuConfig_InsertByUserId @userId_1,@flag = @flag_1 OUTPUT,@msg = @msg_1 OUTPUT

GO

/*由于 MainMenuInfo 表的更改，更新所有用户 MainMenuConfig 配置信息*/
ALTER TRIGGER Tri_UMainMenuConfig_ByInfo ON MainMenuInfo WITH ENCRYPTION
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
    DECLARE hrmResourcemanager_cursor CURSOR FOR
    SELECT id FROM HrmResourceManager order by id

    OPEN hrmResourcemanager_cursor
    FETCH NEXT FROM hrmResourcemanager_cursor INTO @userId

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO MainMenuConfig (userId,infoId,visible,parentId,viewIndex,menuLevel) VALUES(@userId,@id_1,1,@defaultParentId_1,@defaultIndex_1,@defaultLevel_1)
        FETCH NEXT FROM hrmResourcemanager_cursor INTO @userId
    END
    CLOSE hrmResourcemanager_cursor
    DEALLOCATE hrmResourcemanager_cursor

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

/*由于 LeftMenuInfo 表的更改，更新所有用户 LeftMenuConfig 配置信息*/
AlTER TRIGGER Tri_ULeftMenuConfig_ByInfo ON LeftMenuInfo WITH ENCRYPTION
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
    DECLARE hrmResourcemanager_cursor CURSOR FOR
    SELECT id FROM HrmResourceManager order by id

    OPEN hrmResourcemanager_cursor
    FETCH NEXT FROM hrmResourcemanager_cursor INTO @userId

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex) VALUES(@userId,@id_1,1,@defaultIndex_1)
        FETCH NEXT FROM hrmResourcemanager_cursor INTO @userId
    END
    CLOSE hrmResourcemanager_cursor
    DEALLOCATE hrmResourcemanager_cursor

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