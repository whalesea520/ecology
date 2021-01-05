


alter table leftmenuconfig add  customName_e varchar(100)
GO

alter table leftmenuinfo add  customName_e varchar(100)
GO


update mainmenuinfo set linkaddress='/systeminfo/menuconfig/MenuMaintFrame.jsp?type=left' where id=478
GO



insert into SystemModule (id,moduleName,moduleReleased) values(13,'门户管理',1)
GO

delete mainmenuinfo where id in (541,429,565,519,515,615,478)
Go

delete mainmenuconfig where infoid in (541,429,565,519,515,615,478)
Go






alter table SystemLoginTemplate add   extendLoginid int 
GO
CREATE table extendLogin (
    id int IDENTITY(1,1),
    extendname Varchar(20), 
    extenddesc Varchar(200),
    extendurl varchar(500),
    img varchar(50)
)
GO

CREATE table extendHomepage (
    id int ,
    extendname Varchar(20), 
    extenddesc Varchar(200),
    extendurl varchar(500)     

)
GO
insert into extendHomepage(id,extendname,extenddesc,extendurl) values (1,'网站模板','网站模板','/portal/plugin/homepage/web1')
GO


CREATE table extendHpWeb1 (
    id int IDENTITY(1,1),
    templateId int, 
    subcompanyid int,
    navimg varchar(100),		
    flash1 varchar(100),
    flash2 varchar(100),
    flash3 varchar(100),
    flash4 varchar(100),
    flash5 varchar(100),
    copyinfo varchar(1500)
)
GO






alter table SystemTemplate add   extendtempletid int 
GO


alter table SystemTemplate add   extendtempletvalueid int 
GO


update mainmenuinfo set defaultindex=0 where id=633
GO
update mainmenuconfig set viewindex=0 where infoid=633
GO
update mainmenuinfo set defaultindex=1 where id=625
GO
update mainmenuconfig set viewindex=1 where infoid=625
GO


alter table mainmenuinfo add  customName_e varchar(100)
GO


drop table mainmenuconfig
GO


CREATE TABLE mainmenuconfig (
	id int IDENTITY (1, 1) NOT NULL ,
	userId int NULL ,
	infoId int NULL ,
	visible char (1)  NULL ,
	viewIndex int NULL ,
	resourceid int NULL ,
	resourcetype char (1)  NULL ,
	locked char (1)  NULL ,
	lockedById int NULL ,
	useCustomName char (1)  NULL ,
	customName varchar (100)  NULL ,
	customName_e varchar (100)  NULL 
) 
GO

Create  procedure _initMenuConfig	
	@flag		int	output, 
	@msg		varchar(80) output
as
	declare @viewIndex int
	declare @useCustomName int
	declare @customName  varchar(50)
	declare @customName_e varchar(50)
	declare @infoid varchar(50)

	declare mainmenu_cursor cursor for   select id,defaultindex,useCustomName,customName,customName_e from mainmenuinfo


	open mainmenu_cursor 
	fetch next from mainmenu_cursor into @infoid,@viewIndex,@useCustomName,@customName,@customName_e
	while @@fetch_status=0   
	begin

	    insert into mainmenuconfig(infoid,visible,viewIndex,resourceid,resourcetype,useCustomName,customName,customName_e) values (@infoid,1, @viewIndex,1,1,@useCustomName,@customName,@customName_e)

	    insert into mainmenuconfig(infoid,visible,viewIndex,resourceid,resourcetype,useCustomName,customName,customName_e) select @infoid,1,@viewIndex,id,2,@useCustomName,@customName,@customName_e from hrmsubcompany
			   
	    fetch next from mainmenu_cursor into @infoid,@viewIndex,@useCustomName,@customName,@customName_e	
	end 
	
	close mainmenu_cursor 
	deallocate mainmenu_cursor   
GO

_initMenuConfig '',''
GO



alter table mainmenuinfo add  isCustom int default 0
GO

alter table mainmenuinfo add  parentId int
GO

alter table mainmenuinfo add  menuLevel int
GO


alter table mainmenuinfo add  baseTarget varchar(50)
GO


update  mainmenuinfo set parentId=defaultparentid
GO



create index mainmenuinfo_parentid on mainmenuinfo(parentid)
GO
create index mainmenuinfo_type_id on mainmenuconfig(resourcetype,resourceid)
GO


insert into SequenceIndex(indexdesc,currentid) values ('mainmenuid',-100)
GO

Create PROCEDURE MMConfig_U_ByInfoInsert(	
    	@parentId_1	int,
    	@defaultIndex_1	int
) 
AS
begin
	UPDATE MainMenuConfig SET viewIndex=viewIndex+1 
	WHERE infoId IN (SELECT id FROM MainMenuInfo WHERE parentId=@parentId_1) AND viewIndex>=@defaultIndex_1
END

GO

CREATE PROCEDURE MainMenuSequenceId_Get(
	@flag int output, 
	@msg varchar(60) output
)
AS 
DECLARE @id_1 INT
SELECT @id_1=currentid FROM SequenceIndex WHERE indexdesc='mainmenuid'
UPDATE SequenceIndex SET currentid=currentid-1 WHERE indexdesc='mainmenuid'
SELECT @id_1
GO

CREATE TRIGGER Tri_UMainMenuConfig_ByInfo ON MainMenuInfo
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

	        INSERT INTO MainMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(0,@id_1,1,@defaultIndex_1,@userId,'1',0,0,@useCustomName,@customName)
		
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
	        INSERT INTO MainMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(0,@id_1,1,@defaultIndex_1,@userId,'2',0,0,@useCustomName,@customName)
	        FETCH NEXT FROM hrmSubCompany_cursor INTO @userId
	    END
	    CLOSE hrmSubCompany_cursor
	    DEALLOCATE hrmSubCompany_cursor


     end
END


IF (@countinsert = 0) BEGIN

    SELECT @id_1 = id FROM deleted
    
    DELETE FROM MainMenuConfig WHERE infoId = @id_1
END

GO




Alter PROCEDURE MMInfo_Insert(
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
    @relatedModuleId_1 int) 
AS

    DECLARE @updateId int;
    DECLARE @updateIndex int;

    SET @updateIndex = @defaultIndex_1;

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
        parentId,
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
        @defaultParentId_1 ,
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
	parentId,
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
	@defaultParentId_1 ,
        @relatedModuleId_1
    ) 
    END

GO



