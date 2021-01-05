/*由于 新建用户 HrmResource 表的更改 ，更新该用户 LeftMenuConfig MainMenuConfig 配置信息*/
CREATE or replace TRIGGER Tri_UMMInfo_ByHrmResource after  insert ON HrmResource 
for each row
when(new.id<>'' or new.id <> null )
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