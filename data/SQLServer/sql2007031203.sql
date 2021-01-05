Alter TRIGGER Tri_UMMInfo_ByHrmResource ON HrmResource WITH ENCRYPTION
FOR INSERT 
AS
    DECLARE @userId_1 int
	DECLARE @flag_1 int
	DECLARE @msg_1 varchar(80)


    SELECT @userId_1 = id FROM inserted

    /*EXEC LeftMenuConfig_InsertByUserId @userId_1,@flag = @flag_1 OUTPUT,@msg = @msg_1 OUTPUT*/

    EXEC MainMenuConfig_InsertByUserId @userId_1,@flag = @flag_1 OUTPUT,@msg = @msg_1 OUTPUT

GO

Alter TRIGGER Tri_UMMInfo_ByHrmResourceManager ON HrmResourceManager WITH ENCRYPTION
FOR INSERT 
AS
    DECLARE @userId_1 int
	DECLARE @flag_1 int
	DECLARE @msg_1 varchar(80)


    SELECT @userId_1 = id FROM inserted

    /*EXEC LeftMenuConfig_InsertByUserId @userId_1,@flag = @flag_1 OUTPUT,@msg = @msg_1 OUTPUT*/

    EXEC MainMenuConfig_InsertByUserId @userId_1,@flag = @flag_1 OUTPUT,@msg = @msg_1 OUTPUT

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

/*插入时 @countinsert >0 AND @countdelete = 0 */
/*删除时 @countinsert =0 */
/*更新时 @countinsert >0 AND @countdelete > 0 */

/*插入*/
IF (@countinsert > 0 AND @countdelete = 0) BEGIN

    SELECT @id_1 = id,@defaultIndex_1 = defaultIndex,@isCustom=isCustom,@useCustomName=useCustomName,@customName=customName FROM inserted

    if(@isCustom = 0 OR @isCustom IS NULL) BEGIN
    
	    
	    DECLARE hrmCompany_cursor CURSOR FOR
	    SELECT id FROM HrmCompany order by id
	
	    OPEN hrmCompany_cursor
	    FETCH NEXT FROM hrmCompany_cursor INTO @userId
	
	    WHILE @@FETCH_STATUS = 0
	    BEGIN
		/*总部*/
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


     end
END

/*删除*/
IF (@countinsert = 0) BEGIN

    SELECT @id_1 = id FROM deleted
    
    DELETE FROM LeftMenuConfig WHERE infoId = @id_1
END

GO



drop index leftmenuconfig.leftmenuconfig_id
GO

drop index leftmenuconfig.leftmenuconfig_infoid
GO


delete leftmenuconfig where  resourcetype=3 and infoid>0
GO



delete leftmenuconfig where  resourcetype=3 and infoid in
 (select infoid from leftmenuconfig where resourcetype=1 and infoid<0)
GO

delete leftmenuconfig where resourcetype=3 and infoid in
 (select infoid from leftmenuconfig where resourcetype=2 and infoid<0)
GO



update leftmenuconfig set resourcetype=3,resourceid=userid where resourcetype is null
GO



delete leftmenuconfig where infoid in (
select b.infoid from leftmenuinfo a right join leftmenuconfig b  on a.id=b.infoid  where a.id is null
)


delete LeftMenuConfig where infoid  in (select id from leftmenuinfo where iscustom=0 or iscustom is null)
GO


DECLARE @id_1 int,
   @defaultIndex_1 int,
   @userId int


DECLARE hrmCompany_cursor CURSOR FOR    SELECT id FROM HrmCompany order by id /*总部*/
OPEN hrmCompany_cursor    FETCH NEXT FROM hrmCompany_cursor INTO @userId
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE leftMenuInfo_cursor CURSOR FOR
    SELECT id, defaultIndex FROM LeftMenuInfo where iscustom=0 or iscustom is null
	
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



DECLARE hrmSubCompany_cursor CURSOR FOR  /*分部*/
SELECT id FROM HrmSubCompany order by id

OPEN hrmSubCompany_cursor
FETCH NEXT FROM hrmSubCompany_cursor INTO @userId

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE leftMenuInfo_cursor CURSOR FOR
    SELECT id, defaultIndex FROM LeftMenuInfo where iscustom=0 or iscustom is null
	
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
GO


CREATE INDEX leftmenuconfig_type_id ON leftmenuconfig  (resourcetype, resourceid)
GO
