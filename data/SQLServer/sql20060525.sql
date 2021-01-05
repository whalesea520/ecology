insert into SystemRights (id,rightdesc,righttype,detachable) values (644,'总部菜单维护','7',1)
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (644,7,'总部菜单维护','总部菜单维护')
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (644,8,'headquarter menu maintain','headquarter menu maintain')
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4144,'总部菜单维护','HeadMenu:Maint',644)
GO

insert into SystemRights (id,rightdesc,righttype,detachable) values (645,'分部菜单维护','7',1)
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (645,7,'分部菜单维护','分部菜单维护')
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (645,8,'subcompany menu maintain','subcompany menu maintain')
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4145,'分部菜单维护','SubMenu:Maint',645)
GO

insert into SystemRightToGroup (groupid,rightid) values (1,644)
GO
insert into SystemRightToGroup (groupid,rightid) values (1,645)
GO



ALTER TABLE LeftMenuConfig ADD
    resourceid int NULL,
    resourcetype char(1) NULL,
    locked char(1) NULL,
    lockedById int NULL,
    useCustomName char(1) NULL,
    customName varchar(100) NULL
GO

UPDATE LeftMenuConfig SET resourceid = userid,resourcetype = 3,locked = 0,lockedById = 0,useCustomName = 0
WHERE resourceid is NULL
GO

UPDATE LeftMenuConfig SET useCustomName = '1',
LeftMenuConfig.customName = (SELECT customName FROM LeftMenuInfo WHERE id = LeftMenuConfig.infoid )
WHERE EXISTS (SELECT 1 FROM LeftMenuInfo WHERE id = LeftMenuConfig.infoid AND useCustomName > 0)
GO

CREATE INDEX INDEX_LeftMenuConfig ON LeftMenuConfig
(infoId,resourceid,resourcetype,userId,lockedById)
GO

INSERT INTO SequenceIndex(indexdesc,currentid) SELECT 'LeftMenuSysId',Max(Id) from LeftMenuInfo
GO

INSERT INTO HtmlLabelIndex values(18986,'功能菜单维护')
GO
INSERT INTO HtmlLabelInfo VALUES(18986,'功能菜单维护',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18986,'Left Menu Maintenance',8)
GO


EXECUTE MMConfig_U_ByInfoInsert 11,16
GO
EXECUTE MMInfo_Insert 478,18986,'功能菜单维护','/systeminfo/menuconfig/LeftMenuMaintenanceFrame.jsp','mainFrame',11,1,16,0,'',0,'',0,'','',0,'','',9
GO


INSERT INTO HtmlLabelIndex values(19050,'即下级分部管理员以及用户都不可对该菜单进行维护，包括自定义名称、显示隐藏、编辑删除（指新建的菜单）操作。') 
GO
INSERT INTO HtmlLabelInfo VALUES(19050,'即下级分部管理员以及用户都不可对该菜单进行维护，包括自定义名称、显示隐藏、编辑删除（指新建的菜单）操作。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19050,'lower lever user cannot maintain the menu',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19051,'即下级分部管理员以及用户都不可对该菜单进行显示隐藏的操作') 
GO
INSERT INTO HtmlLabelInfo VALUES(19051,'即下级分部管理员以及用户都不可对该菜单进行显示隐藏的操作',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19051,'lower lever user cannot view the menu',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19052,'即下级分部管理员以及用户都不可对该菜单进行自定义名称的操作') 
GO
INSERT INTO HtmlLabelInfo VALUES(19052,'即下级分部管理员以及用户都不可对该菜单进行自定义名称的操作',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19052,'lower lever user cannot change the menu''s custom name',8) 
GO

INSERT INTO HtmlLabelIndex values(19053,'当前操作将会影响(总部或分部下)所有人员,包括当前维护人员') 
GO
INSERT INTO HtmlLabelInfo VALUES(19053,'当前操作将会影响(总部或分部下)所有人员,包括当前维护人员',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19053,'This operation will change all lower level user''s menu,involve current operator',8) 
GO
 


INSERT INTO HtmlLabelIndex values(19014,'同步信息') 
GO
INSERT INTO HtmlLabelInfo VALUES(19014,'同步信息',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19014,'Sync Info',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19016,'同步下级分部人员') 
GO
INSERT INTO HtmlLabelInfo VALUES(19016,'同步下级分部人员',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19016,'Synchronize subCompany user',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19048,'高级模式') 
GO
INSERT INTO HtmlLabelInfo VALUES(19048,'高级模式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19048,'Advanced',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19049,'模块') 
GO
INSERT INTO HtmlLabelInfo VALUES(19049,'模块',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19049,'module',8) 
GO
 
INSERT INTO HtmlLabelIndex values(19054,'菜单类型') 
GO
INSERT INTO HtmlLabelInfo VALUES(19054,'菜单类型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19054,'Menu Type',8) 
GO

INSERT INTO HtmlLabelIndex values(19056,'默认显示方式') 
GO
INSERT INTO HtmlLabelInfo VALUES(19056,'默认显示方式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19056,'default display usage',8) 
GO


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


IF (@countinsert > 0 AND @countdelete = 0) BEGIN

    SELECT @id_1 = id,@defaultIndex_1 = defaultIndex,@isCustom=isCustom,@useCustomName=useCustomName,@customName=customName FROM inserted

    if(@isCustom = 0 OR @isCustom IS NULL) BEGIN
    

	    DECLARE hrmCompany_cursor CURSOR FOR
	    SELECT id FROM HrmCompany order by id
	
	    OPEN hrmCompany_cursor
	    FETCH NEXT FROM hrmCompany_cursor INTO @userId
	
	    WHILE @@FETCH_STATUS = 0
	    BEGIN
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(@userId,@id_1,1,@defaultIndex_1,@userId,'1',0,0,@useCustomName,@customName)
	        FETCH NEXT FROM hrmCompany_cursor INTO @userId
	    END
	    CLOSE hrmCompany_cursor
	    DEALLOCATE hrmCompany_cursor
    
    

	    DECLARE hrmSubCompany_cursor CURSOR FOR
	    SELECT id FROM HrmSubCompany order by id
	
	    OPEN hrmSubCompany_cursor
	    FETCH NEXT FROM hrmSubCompany_cursor INTO @userId
	
	    WHILE @@FETCH_STATUS = 0
	    BEGIN
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(@userId,@id_1,1,@defaultIndex_1,@userId,'2',0,0,@useCustomName,@customName)
	        FETCH NEXT FROM hrmSubCompany_cursor INTO @userId
	    END
	    CLOSE hrmSubCompany_cursor
	    DEALLOCATE hrmSubCompany_cursor
    
    

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
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName) VALUES(@userId,@id_1,1,@defaultIndex_1,@userId,'1',0,0,0)
	        FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1
    	END

	    CLOSE leftMenuInfo_cursor
	    DEALLOCATE leftMenuInfo_cursor

		FETCH NEXT FROM hrmCompany_cursor INTO @userId
	END
    CLOSE hrmCompany_cursor
    DEALLOCATE hrmCompany_cursor



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
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName) VALUES(@userId,@id_1,1,@defaultIndex_1,@userId,'1',0,0,0)
	        FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1
    	END

	    CLOSE leftMenuInfo_cursor
	    DEALLOCATE leftMenuInfo_cursor

		FETCH NEXT FROM hrmSubCompany_cursor INTO @userId
	END
    CLOSE hrmSubCompany_cursor
    DEALLOCATE hrmSubCompany_cursor


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
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName) VALUES(@userId,@id_1,1,@defaultIndex_1,@userId,'1',0,0,0)
	        FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1
    	END

	    CLOSE leftMenuInfo_cursor
	    DEALLOCATE leftMenuInfo_cursor

		FETCH NEXT FROM hrmResourceManager_cursor INTO @userId
	END
    CLOSE hrmResourceManager_cursor
    DEALLOCATE hrmResourceManager_cursor
	


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
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName) VALUES(@userId,@id_1,1,@defaultIndex_1,@userId,'1',0,0,0)
	        FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1
    	END

	    CLOSE leftMenuInfo_cursor
	    DEALLOCATE leftMenuInfo_cursor

		FETCH NEXT FROM hrmResource_cursor INTO @userId
	END
    CLOSE hrmResource_cursor
    DEALLOCATE hrmResource_cursor

GO

ALTER PROCEDURE LeftMenuConfig_InsertByUserId(
    @userId_1       int,
    @flag	int	output, 
    @msg	varchar(80)	output) 
AS
DECLARE @id_1 int,
        @defaultIndex_1 int,
        @subcompany_id int,
        @locked char(1),
        @locked_by_id int
        

	DECLARE leftMenuInfo_cursor CURSOR FOR

    SELECT id, defaultIndex FROM LeftMenuInfo WHERE isCustom='0' OR isCustom IS NULL OR isCustom='2'

    OPEN leftMenuInfo_cursor
    FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1

    WHILE @@FETCH_STATUS = 0
    BEGIN
    	SET @locked_by_id = 0
    	SET @locked = '0'


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
			END
        END
        ELSE
        BEGIN

           	IF EXISTS (SELECT 1 FROM LeftMenuConfig WHERE infoid = @id_1 AND resourceId = 1 AND resourceType = '1' AND locked > 0 )
           	BEGIN
           		SELECT @locked_by_id = id FROM LeftMenuConfig WHERE infoid = @id_1 AND resourceId = 1 AND resourceType = '1'
           	END
            ELSE
            BEGIN
        		SELECT @subcompany_id = subcompanyid1 FROM HrmResource WHERE id = @userId_1
        		
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
        END
        
        IF @locked_by_id > 0
        SET @locked = '1'
        

        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName)
        VALUES(@userId_1,@id_1,1,@defaultIndex_1,@userId_1,'3',@locked,@locked_by_id,'0')
        
        FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1
        
    END

    CLOSE leftMenuInfo_cursor
    DEALLOCATE leftMenuInfo_cursor
GO

alter PROCEDURE LeftMenuConfig_U_ByInfoInsert(
    @menuLevel_1     int,
    @parentId_1      int,
    @defaultIndex_1  int,
    @flag            int	output,
    @msg             varchar(80)	output) 
AS

	DECLARE @old_updateId int,
			@old_resourceId int,
			@old_resourceType char(1),
			@old_parentId int,
			@curr_updateId int,
			@curr_resourceId int,
			@curr_resourceType char(1),
			@curr_parentId int,
			@indexCount int

	/*顶级菜单*/
    IF (@menuLevel_1 = 1) BEGIN

	DECLARE leftmenuviewindex_cursor CURSOR FOR
	 SELECT t2.id,t2.resourceId,t2.resourceType,t1.parentid
	   FROM LeftMenuInfo t1,LeftMenuConfig t2
	  WHERE t1.id = t2.infoId
        AND (t1.parentid IS NULL OR t1.parentid = 0)
        AND t2.viewIndex >= @defaultIndex_1
      ORDER BY resourceid,resourcetype,parentId,defaultIndex,viewindex,infoid
    
	END ELSE BEGIN

	DECLARE leftmenuviewindex_cursor CURSOR FOR
	 SELECT t2.id,t2.resourceId,t2.resourceType,t1.parentid
	   FROM LeftMenuInfo t1,LeftMenuConfig t2
	  WHERE t1.id = t2.infoId
        AND t1.parentId = @parentId_1
		AND t2.viewIndex >= @defaultIndex_1
      ORDER BY resourceid,resourcetype,parentId,defaultIndex,viewindex,infoid
	
	END
    
    OPEN leftmenuviewindex_cursor
    FETCH NEXT FROM leftmenuviewindex_cursor INTO @curr_updateId,@curr_resourceId,@curr_resourceType,@curr_parentId
    
    IF(@defaultIndex_1<1) SET @indexCount = 1;
    ELSE SET @indexCount = @defaultIndex_1
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
    	IF (@curr_resourceId = @old_resourceId AND @curr_resourceType = @old_resourceType AND (@curr_parentId = @old_parentId OR (@curr_parentId IS NULL AND @old_parentId IS NULL)) AND @curr_updateId != @old_updateId) BEGIN
    		
    		SET @indexCount = @indexCount + 1

    		UPDATE LeftMenuConfig SET viewIndex = @indexCount WHERE id = @curr_updateId
    	
    	END ELSE BEGIN
    		
		    IF(@defaultIndex_1<1) SET @indexCount = 1;
		    ELSE SET @indexCount = @defaultIndex_1
    	
    		UPDATE LeftMenuConfig SET viewIndex = @indexCount WHERE id = @curr_updateId
    		
    	END
    	
    	SET @old_updateId = @curr_updateId
    	SET @old_resourceId = @curr_resourceId
    	SET @old_resourceType = @curr_resourceType
    	SET @old_parentId = @curr_parentId
    	
    	FETCH NEXT FROM leftmenuviewindex_cursor INTO @curr_updateId,@curr_resourceId,@curr_resourceType,@curr_parentId
    END
    	
    CLOSE leftmenuviewindex_cursor
    DEALLOCATE leftmenuviewindex_cursor

    SET @flag = 1 
    SET @msg = 'ok'
	
GO

alter PROCEDURE LeftMenuInfo_Insert(
    @id_1 				int ,
    @labelId_1 			int ,
    @iconUrl_1			varchar(100),
    @linkAddress_1      varchar(250),
    @menuLevel_1		int,
    @parentId_1			int,
    @defaultIndex_1		int,
    @useCustomName_1	char(1),
    @customName_1		varchar(100),
    @relatedModuleId_1  int,
    @isCustom_1			char(1),
    @flag				int	output, 
    @msg				varchar(80)	output) 
AS

        DECLARE @updateId int;
        DECLARE @updateIndex int;


    IF (@menuLevel_1 = 1) BEGIN

	SET @updateIndex = @defaultIndex_1;


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
	        useCustomName,
	        customName,
	        relatedModuleId,
	        isCustom) 
	    VALUES (
            @id_1,
	        @labelId_1,
	        NULL,
	        NULL,
	        @menuLevel_1,
	        NULL,
	        @defaultIndex_1,
	        @useCustomName_1,
	        @customName_1,
	        @relatedModuleId_1,
	        @isCustom_1
	    )
    END
    ELSE 
    BEGIN

    	SET @updateIndex = @defaultIndex_1;

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
	        useCustomName,
	        customName,
	        relatedModuleId,
	        isCustom) 
	    VALUES (
            @id_1,
	        @labelId_1,
	        @iconUrl_1,
	        @linkAddress_1,
	        @menuLevel_1,
	        @parentId_1,
	        @defaultIndex_1,
	        @useCustomName_1,
	        @customName_1,
	        @relatedModuleId_1,
	        @isCustom_1
    	) 
    END
 

    SET @flag = 1 
    SET @msg = 'ok'
	
GO

ALTER PROCEDURE LMConfig_U_ByInfoInsert(
	@menuLevel_1	int,
    @parentId_1	int,
    @defaultIndex_1	int
) 
AS
	DECLARE @old_updateId int,
			@old_resourceId int,
			@old_resourceType char(1),
			@old_parentId int,
			@curr_updateId int,
			@curr_resourceId int,
			@curr_resourceType char(1),
			@curr_parentId int,
			@indexCount int

	/*顶级菜单*/
    IF (@menuLevel_1 = 1) BEGIN

	DECLARE leftmenuviewindex_cursor CURSOR FOR
	 SELECT t2.id,t2.resourceId,t2.resourceType,t1.parentid
	   FROM LeftMenuInfo t1,LeftMenuConfig t2
	  WHERE t1.id = t2.infoId
        AND (t1.parentid IS NULL OR t1.parentid = 0)
        AND t2.viewIndex >= @defaultIndex_1
      ORDER BY resourceid,resourcetype,parentId,viewindex,defaultIndex,infoid desc
    
	END ELSE BEGIN

	DECLARE leftmenuviewindex_cursor CURSOR FOR
	 SELECT t2.id,t2.resourceId,t2.resourceType,t1.parentid
	   FROM LeftMenuInfo t1,LeftMenuConfig t2
	  WHERE t1.id = t2.infoId
        AND t1.parentId = @parentId_1
		AND t2.viewIndex >= @defaultIndex_1
      ORDER BY resourceid,resourcetype,parentId,viewindex,defaultIndex,infoid desc
	
	END
    
    OPEN leftmenuviewindex_cursor
    FETCH NEXT FROM leftmenuviewindex_cursor INTO @curr_updateId,@curr_resourceId,@curr_resourceType,@curr_parentId
    
    IF(@defaultIndex_1<1) SET @indexCount = 1;
    ELSE SET @indexCount = @defaultIndex_1
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
    	IF (@curr_resourceId = @old_resourceId AND @curr_resourceType = @old_resourceType AND (@curr_parentId = @old_parentId OR (@curr_parentId IS NULL AND @old_parentId IS NULL)) AND @curr_updateId != @old_updateId) BEGIN
    		
    		SET @indexCount = @indexCount + 1

    		UPDATE LeftMenuConfig SET viewIndex = @indexCount WHERE id = @curr_updateId
    	
    	END ELSE BEGIN
    		
		    IF(@defaultIndex_1<1) SET @indexCount = 1;
		    ELSE SET @indexCount = @defaultIndex_1
    	
    		UPDATE LeftMenuConfig SET viewIndex = @indexCount WHERE id = @curr_updateId
    		
    	END
    	
    	SET @old_updateId = @curr_updateId
    	SET @old_resourceId = @curr_resourceId
    	SET @old_resourceType = @curr_resourceType
    	SET @old_parentId = @curr_parentId
    	
    	FETCH NEXT FROM leftmenuviewindex_cursor INTO @curr_updateId,@curr_resourceId,@curr_resourceType,@curr_parentId
    END
    	
    CLOSE leftmenuviewindex_cursor
    DEALLOCATE leftmenuviewindex_cursor

GO