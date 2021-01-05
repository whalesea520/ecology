ALTER PROCEDURE LeftMenuConfig_InsertByUserId(
    @userId_1       int,
    @flag	int	output, 
    @msg	varchar(80)	output) 
AS
DECLARE @id_1 int,
        @defaultIndex_1 int,
        @subcompany_id int,
        @locked char(1),
        @locked_by_id int,
        @visible_1 char(1),
        @viewIndex_1 int,
        @useCustomName_1 char(1),
        @customName_1 varchar(100)
        

	DECLARE leftMenuInfo_cursor CURSOR FOR
    /*只添加系统定义的左菜单*//*及管理员添加的维护菜单*/
    SELECT id, defaultIndex FROM LeftMenuInfo WHERE isCustom='0' OR isCustom IS NULL OR isCustom='2'

    OPEN leftMenuInfo_cursor
    FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1

    WHILE @@FETCH_STATUS = 0
    BEGIN
    	SET @locked = '0'
    	SET @locked_by_id = 0

    	SET @visible_1 = '1'
    	SET @viewIndex_1 = @defaultIndex_1
    	SET @useCustomName_1 = '0'
    	SET @customName_1 = ''
    	
        /*管理员*/
        IF EXISTS (SELECT 1 FROM HrmResourceManager WHERE id = @userId_1)
        BEGIN
           	IF EXISTS (SELECT 1 FROM LeftMenuConfig WHERE infoid = @id_1 AND resourceId = 1 AND resourceType = '1' AND locked > 0 )
           	BEGIN
           		SELECT @locked_by_id = id FROM LeftMenuConfig WHERE infoid = @id_1 AND resourceId = 1 AND resourceType = '1'
           	END
            ELSE
            BEGIN
	            DECLARE leftMenuInfo_cursor_1 CURSOR FOR
	        	select subcompanyid
				from SysRoleSubcomRight 
				where roleid in(select a.roleid 
				from HrmRoleMembers a,SystemRightRoles b
				where a.roleid=b.roleid and a.resourceid=@userId_1
				and b.rightid =(select rightid from SystemRightDetail where rightdetail='SubMenu:Maint')
				)
				group by subcompanyid
			
	            OPEN leftMenuInfo_cursor_1
	            FETCH NEXT FROM leftMenuInfo_cursor_1 INTO @subcompany_id
	            
	            WHILE @@FETCH_STATUS = 0
	            BEGIN
	            	IF EXISTS (SELECT 1 FROM LeftMenuConfig WHERE infoid = @id_1 AND resourceId = @subcompany_id AND resourceType = '2' AND locked > 0 )
	            	BEGIN
	             		SELECT @locked_by_id = id FROM LeftMenuConfig WHERE infoid = @id_1 AND resourceId = @subcompany_id AND resourceType = '2'
	             		BREAK
	             	END
	             	ELSE
	             	BEGIN
		             	IF EXISTS (SELECT 1 FROM LeftMenuConfig WHERE infoid = @id_1 AND resourceId = @subcompany_id AND resourceType = '2' AND lockedbyid > 0 )
		             	BEGIN
		             		SELECT @locked_by_id = lockedbyid FROM LeftMenuConfig WHERE infoid = @id_1 AND resourceId = @subcompany_id AND resourceType = '2'
		             		BREAK
		             	END
	             	END
	             	FETCH NEXT FROM leftMenuInfo_cursor_1 INTO @subcompany_id
	            END

			    CLOSE leftMenuInfo_cursor_1
			    DEALLOCATE leftMenuInfo_cursor_1
	            
			END
        	SELECT @visible_1 = visible,@viewIndex_1=viewIndex,@useCustomName_1=useCustomName,@customName_1=customName FROM LeftMenuConfig WHERE infoid = @id_1 AND resourceType = '1' AND resourceId = 1
        END
        ELSE
        BEGIN
		/*用户*/
       		SELECT @subcompany_id = subcompanyid1 FROM HrmResource WHERE id = @userId_1

           	IF EXISTS (SELECT 1 FROM LeftMenuConfig WHERE infoid = @id_1 AND resourceId = 1 AND resourceType = '1' AND locked > 0 )
           	BEGIN
           		SELECT @locked_by_id = id FROM LeftMenuConfig WHERE infoid = @id_1 AND resourceId = 1 AND resourceType = '1'
           	END
            ELSE
            BEGIN
	            IF EXISTS (SELECT 1 FROM LeftMenuConfig WHERE infoid = @id_1 AND resourceId = @subcompany_id AND resourceType = '2' AND locked > 0 )
	            BEGIN
	            	SELECT @locked_by_id = id FROM LeftMenuConfig WHERE infoid = @id_1 AND resourceId = @subcompany_id AND resourceType = '2'
	            END
	            ELSE
	            BEGIN
		           	IF EXISTS (SELECT 1 FROM LeftMenuConfig WHERE infoid = @id_1 AND resourceId = @subcompany_id AND resourceType = '2' AND lockedbyid > 0 )
		           	BEGIN
		           		SELECT @locked_by_id = lockedbyid FROM LeftMenuConfig WHERE infoid = @id_1 AND resourceId = @subcompany_id AND resourceType = '2'
		           	END
	            END
        	END
        	SELECT @visible_1 = visible,@viewIndex_1=viewIndex,@useCustomName_1=useCustomName,@customName_1=customName FROM LeftMenuConfig WHERE infoid = @id_1 AND resourceType = '2' AND resourceId = @subcompany_id
        END
        
        IF @locked_by_id > 0
        SET @locked = '1'
        
	
        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName)
        VALUES(@userId_1,@id_1,@visible_1,@viewIndex_1,@userId_1,'3',@locked,@locked_by_id,@useCustomName_1,@customName_1)
        
        FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1
        
    END

    CLOSE leftMenuInfo_cursor
    DEALLOCATE leftMenuInfo_cursor
GO