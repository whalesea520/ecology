
/*由于新闻页的变化 DocFrontpage 表的更改，更新 MainMenuInfo 配置信息*/
drop TRIGGER Tri_UMMInfo_ByDocFrontpage
/

CREATE  TRIGGER Tri_UMMInfo_ByDocFrontpage after  insert or update or delete ON DocFrontpage 
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
IF (countinsert > 0 and countdelete is null) then
 
  id_1:= :new.id;
  frontpagename_1:= :new.frontpagename;
  isactive_1:= :new.isactive;
  publishtype_1:= :new.publishtype;

    SELECT COUNT(defaultIndex) into defaultIndex_1
      FROM MainMenuInfo 
     WHERE defaultparentId =1;
       

    IF (isactive_1 = 1 AND publishtype_1 = 1) then
        
        linkAddress_1 := concat('/docs/news/NewsDsp.jsp?id=',To_CHAR(id_1));
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
            id_1*-1,
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

/*如果做update操作*/

IF (countinsert > 0 and  countdelete >0) then

  id_1:= :new.id;
  frontpagename_1:= :new.frontpagename;
  isactive_1:= :new.isactive;
  publishtype_1:= :new.publishtype;
  
  SELECT COUNT(defaultIndex) into defaultIndex_1 FROM MainMenuInfo  WHERE defaultparentId =1;   
  linkAddress_1 := concat('/docs/news/NewsDsp.jsp?id=',To_CHAR(id_1));
  update  MainMenuInfo set menuName=frontpagename_1,linkAddress=linkAddress_1,defaultIndex=defaultIndex_1 where id = id_1*-1;      
  
END if;

/*删除 如果删除的新闻页 是活跃状态(isactive = 1) 并且是发布类型是用户(publishType = 1) 那么在 MainMenuInfo 中删除相应的 新闻页的菜单 信息*/
IF (countinsert is null) then

    id_1 :=:old.id;
    
    SELECT defaultIndex into defaultIndex_1 
      FROM MainMenuInfo 
     WHERE linkAddress = concat('/docs/news/NewsDsp.jsp?id=',To_CHAR(id_1));
    
    DELETE FROM MainMenuInfo WHERE linkAddress = concat('/docs/news/NewsDsp.jsp?id=',To_CHAR(id_1));

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