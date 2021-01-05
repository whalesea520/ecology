/*由于 LeftMenuInfo 表的更改，更新所有用户 LeftMenuConfig 配置信息*/
ALTER TRIGGER Tri_ULeftMenuConfig_ByInfo ON LeftMenuInfo
FOR INSERT, UPDATE, DELETE 
AS
Declare @id_1 int,
        @defaultIndex_1 int,
        @countdelete   int,
        @countinsert   int,
        @userId int,
		@isCustom char(1),
		@useCustomName char(1),
		@customName varchar(100)


SELECT @countdelete = count(*) FROM deleted
SELECT @countinsert = count(*) FROM inserted

/*插入时 @countinsert >0 AND @countdelete = 0 */
/*删除时 @countinsert =0 */
/*更新时 @countinsert >0 AND @countdelete > 0 */

/*插入*/
IF (@countinsert > 0 AND @countdelete = 0) BEGIN

    SELECT @id_1 = id,@defaultIndex_1 = defaultIndex,@isCustom=isCustom,@useCustomName=useCustomName,@customName=customName FROM inserted

    if(@isCustom = 0 OR @isCustom IS NULL) BEGIN
    
	    /*总部*/
	    DECLARE hrmCompany_cursor CURSOR FOR
	    SELECT id FROM HrmCompany order by id
	
	    OPEN hrmCompany_cursor
	    FETCH NEXT FROM hrmCompany_cursor INTO @userId
	
	    WHILE @@FETCH_STATUS = 0
	    BEGIN
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(0,@id_1,1,@defaultIndex_1,@userId,'1',0,0,@useCustomName,@customName)
	        FETCH NEXT FROM hrmCompany_cursor INTO @userId
	    END
	    CLOSE hrmCompany_cursor
	    DEALLOCATE hrmCompany_cursor
    
    
	    /*分部*/
	    DECLARE hrmSubCompany_cursor CURSOR FOR
	    SELECT id FROM HrmSubCompany order by id
	
	    OPEN hrmSubCompany_cursor
	    FETCH NEXT FROM hrmSubCompany_cursor INTO @userId
	
	    WHILE @@FETCH_STATUS = 0
	    BEGIN
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(0,@id_1,1,@defaultIndex_1,@userId,'2',0,0,@useCustomName,@customName)
	        FETCH NEXT FROM hrmSubCompany_cursor INTO @userId
	    END
	    CLOSE hrmSubCompany_cursor
	    DEALLOCATE hrmSubCompany_cursor
    
    
	    /*系统管理员*/
	    DECLARE hrmResourcemanager_cursor CURSOR FOR
	    SELECT id FROM HrmResourceManager order by id
	
	    OPEN hrmResourcemanager_cursor
	    FETCH NEXT FROM hrmResourcemanager_cursor INTO @userId
	
	    WHILE @@FETCH_STATUS = 0
	    BEGIN
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(@userId,@id_1,1,@defaultIndex_1,@userId,'3',0,0,@useCustomName,@customName)
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
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(@userId,@id_1,1,@defaultIndex_1,@userId,'3',0,0,@useCustomName,@customName)
	        FETCH NEXT FROM hrmResource_cursor INTO @userId
	    END
	    CLOSE hrmResource_cursor
	    DEALLOCATE hrmResource_cursor
     end
END

/*删除*/
IF (@countinsert = 0) BEGIN

    SELECT @id_1 = id FROM deleted
    
    DELETE FROM LeftMenuConfig WHERE infoId = @id_1
END

GO


alter PROCEDURE LeftMenuConfig_Insert_All(
    @flag	int	output, 
    @msg	varchar(80)	output) 
AS
DECLARE @id_1 int,
        @defaultIndex_1 int,
        @userId int

    /*总部*/
    DECLARE hrmCompany_cursor CURSOR FOR
    SELECT id FROM HrmCompany order by id

    OPEN hrmCompany_cursor
    FETCH NEXT FROM hrmCompany_cursor INTO @userId

    WHILE @@FETCH_STATUS = 0
    BEGIN
	    DECLARE leftMenuInfo_cursor CURSOR FOR
	    SELECT id, defaultIndex FROM LeftMenuInfo
    	
	    OPEN leftMenuInfo_cursor
	    FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1
    	
        WHILE @@FETCH_STATUS = 0
        BEGIN
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName) VALUES(0,@id_1,1,@defaultIndex_1,@userId,'1',0,0,0)
	        FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1
    	END

	    CLOSE leftMenuInfo_cursor
	    DEALLOCATE leftMenuInfo_cursor

		FETCH NEXT FROM hrmCompany_cursor INTO @userId
	END
    CLOSE hrmCompany_cursor
    DEALLOCATE hrmCompany_cursor


    /*分部*/
    DECLARE hrmSubCompany_cursor CURSOR FOR
    SELECT id FROM HrmSubCompany order by id

    OPEN hrmSubCompany_cursor
    FETCH NEXT FROM hrmSubCompany_cursor INTO @userId

    WHILE @@FETCH_STATUS = 0
    BEGIN
	    DECLARE leftMenuInfo_cursor CURSOR FOR
	    SELECT id, defaultIndex FROM LeftMenuInfo
    	
	    OPEN leftMenuInfo_cursor
	    FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1
    	
        WHILE @@FETCH_STATUS = 0
        BEGIN
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName) VALUES(0,@id_1,1,@defaultIndex_1,@userId,'2',0,0,0)
	        FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1
    	END

	    CLOSE leftMenuInfo_cursor
	    DEALLOCATE leftMenuInfo_cursor

		FETCH NEXT FROM hrmSubCompany_cursor INTO @userId
	END
    CLOSE hrmSubCompany_cursor
    DEALLOCATE hrmSubCompany_cursor

    /*系统管理员*/
    DECLARE hrmResourceManager_cursor CURSOR FOR
    SELECT id FROM HrmResourceManager order by id

    OPEN hrmResourceManager_cursor
    FETCH NEXT FROM hrmResourceManager_cursor INTO @userId

    WHILE @@FETCH_STATUS = 0
    BEGIN
	    DECLARE leftMenuInfo_cursor CURSOR FOR
	    SELECT id, defaultIndex FROM LeftMenuInfo
    	
	    OPEN leftMenuInfo_cursor
	    FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1
    	
        WHILE @@FETCH_STATUS = 0
        BEGIN
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName) VALUES(@userId,@id_1,1,@defaultIndex_1,@userId,'3',0,0,0)
	        FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1
    	END

	    CLOSE leftMenuInfo_cursor
	    DEALLOCATE leftMenuInfo_cursor

		FETCH NEXT FROM hrmResourceManager_cursor INTO @userId
	END
    CLOSE hrmResourceManager_cursor
    DEALLOCATE hrmResourceManager_cursor
	

    /*用户*/
    DECLARE hrmResource_cursor CURSOR FOR
    SELECT id FROM HrmResource order by id

    OPEN hrmResource_cursor
    FETCH NEXT FROM hrmResource_cursor INTO @userId

    WHILE @@FETCH_STATUS = 0
    BEGIN
	    DECLARE leftMenuInfo_cursor CURSOR FOR
	    SELECT id, defaultIndex FROM LeftMenuInfo
    	
	    OPEN leftMenuInfo_cursor
	    FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1
    	
        WHILE @@FETCH_STATUS = 0
        BEGIN
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName) VALUES(@userId,@id_1,1,@defaultIndex_1,@userId,'3',0,0,0)
	        FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1
    	END

	    CLOSE leftMenuInfo_cursor
	    DEALLOCATE leftMenuInfo_cursor

		FETCH NEXT FROM hrmResource_cursor INTO @userId
	END
    CLOSE hrmResource_cursor
    DEALLOCATE hrmResource_cursor

GO
