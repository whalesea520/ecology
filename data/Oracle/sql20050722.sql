/*由于 MainMenuInfo 表的更改，更新所有用户 MainMenuConfig 配置信息*/
CREATE or replace TRIGGER Tri_UMainMenuConfig_ByInfo after  insert or update or delete ON MainMenuInfo 
for each row
Declare 
        id_1 integer;
        defaultParentId_1 integer;
        defaultIndex_1 integer;
        defaultLevel_1 integer;
        countdelete   integer;
        countinsert   integer;
        userId integer;
begin

    countdelete := :old.id;
    countinsert := :new.id;
/*插入时 countinsert >0 AND countdelete = 0 */
/*删除时 countinsert =0 */
/*更新时 countinsert >0 AND countdelete > 0 */

/*插入*/
IF (countdelete is null) then
    
    id_1 := :new.id;
    defaultParentId_1 := :new.defaultParentId;
    defaultIndex_1 := :new.defaultIndex;
    defaultLevel_1 := :new.defaultLevel;
    /*系统管理员*/

    INSERT INTO MainMenuConfig (userId,infoId,visible,parentId,viewIndex,menuLevel) VALUES(1,id_1,1,defaultParentId_1,defaultIndex_1,defaultLevel_1);

    /*用户*/    
    FOR hrmResource_cursor in( 
    SELECT id FROM HrmResource order by id)

    loop
        userId :=hrmResource_cursor.id;
        INSERT INTO MainMenuConfig (userId,infoId,visible,parentId,viewIndex,menuLevel) VALUES(userId,id_1,1,defaultParentId_1,defaultIndex_1,defaultLevel_1);

    END loop;
END if;

/*删除*/
IF (countinsert is null) then

    id_1 := :old.id; 
    
    DELETE FROM MainMenuConfig WHERE infoId = id_1;
END if;
end;
/


/*由于 新建用户 HrmResource 表的更改 ，更新该用户 LeftMenuConfig MainMenuConfig 配置信息*/
CREATE or replace TRIGGER Tri_UMMInfo_ByHrmResource after  insert ON HrmResource 
for each row
when(new.id<>'' or new.id is not null )
DECLARE 
    userId_1 integer;
    id_1   integer;
    defaultIndex_1   integer;
    defaultParentId_1  integer;
    defaultLevel_1  integer;
begin   
    userId_1:=:new.id ;

   for leftMenuInfo_cursor in (SELECT id, defaultIndex FROM LeftMenuInfo )
    loop
	  	id_1:=leftMenuInfo_cursor.id;
		defaultIndex_1:=leftMenuInfo_cursor.defaultIndex;
         INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex) VALUES(userId_1,id_1,1,defaultIndex_1);
    end loop ;   
 
   
   FOR mainMenuInfo_cursor in( SELECT id,defaultParentId, defaultIndex, defaultLevel FROM MainMenuInfo)
    loop
         id_1:=mainMenuInfo_cursor.id;
         defaultIndex_1:=mainMenuInfo_cursor.defaultIndex;
         defaultParentId_1:=mainMenuInfo_cursor.defaultParentId;       
         defaultLevel_1:=mainMenuInfo_cursor.defaultLevel;

        INSERT INTO MainMenuConfig (userId,infoId,visible,parentId,viewIndex,menuLevel) VALUES(userId_1,id_1,1,defaultParentId_1,defaultIndex_1,defaultLevel_1);
        
    END loop;
end;
/
