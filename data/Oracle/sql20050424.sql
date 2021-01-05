/*由于 LeftMenuInfo 表的更改，更新所有用户 LeftMenuConfig 配置信息*/
CREATE or replace TRIGGER Tri_ULeftMenuConfig_ByInfo after  insert or update or delete ON LeftMenuInfo 
for each row
Declare 
        id_1 integer;
        defaultIndex_1 integer;
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
    IF (countinsert > 0 AND countdelete = 0) then
        id_1 := :new.id;
        defaultIndex_1 := :new.defaultIndex;
          /*系统管理员*/
        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex) VALUES(1,id_1,1,defaultIndex_1);
        /*用户*/    
        FOR hrmResource_cursor in( 
        SELECT id FROM HrmResource order by id)   
        loop
            userId:=hrmResource_cursor.id;
            INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex) VALUES(userId,id_1,1,defaultIndex_1);
        END loop;
    END if;

    /*删除*/
    IF (countinsert = 0) then
       id_1 := :old.id;            
       DELETE FROM LeftMenuConfig WHERE infoId = id_1;
    END if;
end;
/

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
IF (countinsert > 0 AND countdelete = 0) then
    
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
IF (countinsert = 0) then

    id_1 := :old.id; 
    
    DELETE FROM MainMenuConfig WHERE infoId = id_1;
END if;
end;
/

/*由于新闻页的变化 DocFrontpage 表的更改，更新 MainMenuInfo 配置信息*/
CREATE or replace TRIGGER Tri_UMMInfo_ByDocFrontpage after  insert or update or delete ON DocFrontpage 
for each row
Declare id_1 integer;
        frontpagename_1 varchar2(200);
        isactive_1 char(1);
        publishtype_1 integer;
        linkAddress_1 varchar2(100);
        defaultIndex_1 integer;
        countdelete   integer;
        countinsert   integer;
        updateId integer;
        updateIndex integer;
begin
    countdelete :=:old.id;
    countinsert :=:new.id;

/*插入时 countinsert >0 AND countdelete = 0 */
/*删除时 countinsert =0 */
/*更新时 countinsert >0 AND countdelete > 0 */

/*插入 或 更新 如果增加、更新的新闻页 是活跃状态(isactive = 1) 并且是发布类型是用户(publishType = 1) 那么在 MainMenuInfo 中增加一个 新闻页的菜单 信息*/
IF (countinsert > 0) then
 
  id_1:= :new.id;
  frontpagename_1:= :new.frontpagename;
  isactive_1:= :new.isactive;
  publishtype_1:= :new.publishtype;

    SELECT COUNT(defaultIndex) into defaultIndex_1
      FROM MainMenuInfo 
     WHERE defaultparentId =1;
       

    IF (isactive_1 = 1 AND publishtype_1 = 1) then
        
        linkAddress_1 := concat('/docs/news/NewsDsp.jsp?id=',trunc(id_1));
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
            frontpagename_1,
            linkAddress_1,
            'mainFrame',
            1,
            1,
            defaultIndex_1,
            0,
            0,
            0,
            9
        );

        /*更新新闻设置的顺序号*/
        UPDATE MainMenuInfo
           SET defaultIndex = defaultIndex_1 + 1
         WHERE defaultparentId =1
           AND labelId IS NOT NULL;

    END if;
END if;

/*删除 如果删除的新闻页 是活跃状态(isactive = 1) 并且是发布类型是用户(publishType = 1) 那么在 MainMenuInfo 中删除相应的 新闻页的菜单 信息*/
IF (countinsert = 0) then

    id_1 :=:old.id;
    
    SELECT defaultIndex into defaultIndex_1 
      FROM MainMenuInfo 
     WHERE linkAddress = concat('/docs/news/NewsDsp.jsp?id=',trunc(id_1));
    
    DELETE FROM MainMenuInfo WHERE linkAddress = concat('/docs/news/NewsDsp.jsp?id=',trunc(id_1));

    /*更新大于删除记录Index 的 defaultIndex 减1*/
    FOR mainMenuInfo_cursor in(
    SELECT id FROM MainMenuInfo 
     WHERE defaultParentId = 1
       AND defaultIndex > defaultIndex_1 )


    loop
        updateId:=mainMenuInfo_cursor.id;
        UPDATE MainMenuInfo 
           SET defaultIndex = updateIndex
         WHERE id = updateId;

        updateIndex := updateIndex + 1;

    END loop;
END if;
end;
/


