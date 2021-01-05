insert into SystemRights (id,rightdesc,righttype,detachable) values (644,'总部菜单维护','7',1)
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (644,7,'总部菜单维护','总部菜单维护')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (644,8,'headquarter menu maintain','headquarter menu maintain')
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4144,'总部菜单维护','HeadMenu:Maint',644)
/

insert into SystemRights (id,rightdesc,righttype,detachable) values (645,'分部菜单维护','7',1)
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (645,7,'分部菜单维护','分部菜单维护')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (645,8,'subcompany menu maintain','subcompany menu maintain')
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4145,'分部菜单维护','SubMenu:Maint',645)
/

insert into SystemRightToGroup (groupid,rightid) values (1,644)
/
insert into SystemRightToGroup (groupid,rightid) values (1,645)
/

ALTER TABLE LeftMenuConfig ADD  resourceid integer NULL
/
ALTER TABLE LeftMenuConfig ADD  resourcetype char(1) NULL
/
ALTER TABLE LeftMenuConfig ADD  locked char(1) NULL
/
ALTER TABLE LeftMenuConfig ADD  lockedById integer NULL
/
ALTER TABLE LeftMenuConfig ADD  useCustomName char(1) NULL
/
ALTER TABLE LeftMenuConfig ADD  customName varchar2(100) NULL
/
UPDATE LeftMenuConfig SET resourceid = userid,resourcetype = 3,locked = 0,lockedById = 0,useCustomName = 0
WHERE resourceid is NULL
/

UPDATE LeftMenuConfig SET useCustomName = '1',
LeftMenuConfig.customName = (SELECT customName FROM LeftMenuInfo WHERE id = LeftMenuConfig.infoid )
WHERE EXISTS (SELECT 1 FROM LeftMenuInfo WHERE id = LeftMenuConfig.infoid AND useCustomName > 0)
/

CREATE INDEX INDEX_LeftMenuConfig ON LeftMenuConfig
(infoId,resourceid,resourcetype,userId,lockedById)
/

INSERT INTO SequenceIndex(indexdesc,currentid) SELECT 'LeftMenuSysId',Max(Id) from LeftMenuInfo
/

INSERT INTO HtmlLabelIndex values(18986,'功能菜单维护')
/
INSERT INTO HtmlLabelInfo VALUES(18986,'功能菜单维护',7)
/
INSERT INTO HtmlLabelInfo VALUES(18986,'Left Menu Maintenance',8)
/


call MMConfig_U_ByInfoInsert (11,16)
/
call MMInfo_Insert (478,18986,'功能菜单维护','/systeminfo/menuconfig/LeftMenuMaintenanceFrame.jsp','mainFrame',11,1,16,0,'',0,'',0,'','',0,'','',9)
/
INSERT INTO HtmlLabelIndex values(19050,'即下级分部管理员以及用户都不可对该菜单进行维护，包括自定义名称、显示隐藏、编辑删除（指新建的菜单）操作。') 
/

INSERT INTO HtmlLabelInfo VALUES(19050,'即下级分部管理员以及用户都不可对该菜单进行维护，包括自定义名称、显示隐藏、编辑删除（指新建的菜单）操作。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19050,'lower lever user cannot maintain the menu',8) 
/
 
INSERT INTO HtmlLabelIndex values(19051,'即下级分部管理员以及用户都不可对该菜单进行显示隐藏的操作') 
/
INSERT INTO HtmlLabelInfo VALUES(19051,'即下级分部管理员以及用户都不可对该菜单进行显示隐藏的操作',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19051,'lower lever user cannot view the menu',8) 
/
 
INSERT INTO HtmlLabelIndex values(19052,'即下级分部管理员以及用户都不可对该菜单进行自定义名称的操作') 
/
INSERT INTO HtmlLabelInfo VALUES(19052,'即下级分部管理员以及用户都不可对该菜单进行自定义名称的操作',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19052,'lower lever user cannot change the menu''s custom name',8) 
/

INSERT INTO HtmlLabelIndex values(19053,'当前操作将会影响(总部或分部下)所有人员,包括当前维护人员') 
/
INSERT INTO HtmlLabelInfo VALUES(19053,'当前操作将会影响(总部或分部下)所有人员,包括当前维护人员',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19053,'This operation will change all lower level user''s menu,involve current operator',8) 
/
 


INSERT INTO HtmlLabelIndex values(19014,'同步信息') 
/
INSERT INTO HtmlLabelInfo VALUES(19014,'同步信息',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19014,'Sync Info',8) 
/
 
INSERT INTO HtmlLabelIndex values(19016,'同步下级分部人员') 
/
INSERT INTO HtmlLabelInfo VALUES(19016,'同步下级分部人员',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19016,'Synchronize subCompany user',8) 
/
 
INSERT INTO HtmlLabelIndex values(19048,'高级模式') 
/
INSERT INTO HtmlLabelInfo VALUES(19048,'高级模式',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19048,'Advanced',8) 
/
 
INSERT INTO HtmlLabelIndex values(19049,'模块') 
/
INSERT INTO HtmlLabelInfo VALUES(19049,'模块',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19049,'module',8) 
/
 
INSERT INTO HtmlLabelIndex values(19054,'菜单类型') 
/
INSERT INTO HtmlLabelInfo VALUES(19054,'菜单类型',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19054,'Menu Type',8) 
/

INSERT INTO HtmlLabelIndex values(19056,'默认显示方式') 
/
INSERT INTO HtmlLabelInfo VALUES(19056,'默认显示方式',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19056,'default display usage',8) 
/


CREATE or replace TRIGGER Tri_ULeftMenuConfig_ByInfo after  insert or update or delete ON LeftMenuInfo 
for each row
Declare 
        id_1 integer;
        defaultIndex_1 integer;
        countdelete   integer;
        countinsert   integer;
        userId_1 integer;
		isCustom_1 char(1);
		useCustomName_1 char(1);
		customName_1 varchar2(100);
begin
    countdelete := :old.id;
    countinsert := :new.id;

    IF (countinsert > 0 AND countdelete is null) then
        id_1 := :new.id;
        defaultIndex_1 := :new.defaultIndex;
		isCustom_1 := :new.isCustom;
		useCustomName_1 := :new.useCustomName;
		customName_1 := :new.customName;
		
		if(isCustom_1 = '0' OR isCustom_1 IS NULL) then
		
	
		FOR hrmCompany_cursor in( 
		SELECT id FROM HrmCompany order by id)
		loop
			userId_1 := hrmCompany_cursor.id;
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(0,id_1,1,defaultIndex_1,userId_1,'1',0,0,useCustomName_1,customName_1);
		END loop; 


	
		FOR hrmSubCompany_cursor in( 
		SELECT id FROM HrmSubCompany order by id)
		loop
			userId_1 := hrmSubCompany_cursor.id;
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(0,id_1,1,defaultIndex_1,userId_1,'2',0,0,useCustomName_1,customName_1);
		END loop; 
		
		
	
		FOR hrmResourcemanager_cursor in( 
		SELECT id FROM HrmResourceManager order by id)
		loop
			userId_1 := hrmResourcemanager_cursor.id;
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(userId_1,id_1,1,defaultIndex_1,userId_1,'3',0,0,useCustomName_1,customName_1);
		END loop; 
		
	  
        FOR hrmResource_cursor in( 
        SELECT id FROM HrmResource order by id)   
        loop
            userId_1:=hrmResource_cursor.id;
	        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(userId_1,id_1,1,defaultIndex_1,userId_1,'3',0,0,useCustomName_1,customName_1);
        END loop;
		end if;
    END if;


    IF (countinsert is null) then
       id_1 := :old.id;            
       DELETE FROM LeftMenuConfig WHERE infoId = id_1;
    END if;
end;
/

CREATE OR REPLACE PROCEDURE LeftMenuConfig_Insert_All
(flag out integer,
msg  out varchar2) as

  id_1           integer;
  defaultIndex_1 integer;
  userId         integer;

  CURSOR hrmCompany_cursor IS
    SELECT id FROM HrmCompany order by id;

  CURSOR leftMenuInfo_cursor IS
    SELECT id, defaultIndex FROM LeftMenuInfo;

  CURSOR hrmSubCompany_cursor IS
    SELECT id FROM HrmSubCompany order by id;

  CURSOR hrmResourceManager_cursor IS
    SELECT id FROM HrmResourceManager order by id;

  CURSOR hrmResource_cursor IS
    SELECT id FROM HrmResource order by id;

begin

  /*总部*/

  OPEN hrmCompany_cursor;
  LOOP

    FETCH hrmCompany_cursor
      INTO userId;
    EXIT WHEN hrmCompany_cursor%NOTFOUND;

    OPEN leftMenuInfo_cursor;
    LOOP
      FETCH leftMenuInfo_cursor
        INTO id_1, defaultIndex_1;
      EXIT WHEN leftMenuInfo_cursor%NOTFOUND;

      INSERT INTO LeftMenuConfig
        (userId,
         infoId,
         visible,
         viewIndex,
         resourceid,
         resourcetype,
         locked,
         lockedById,
         useCustomName)
      VALUES
        (userId, id_1, 1, defaultIndex_1, userId, '1', 0, 0, 0);

    END LOOP;

    CLOSE leftMenuInfo_cursor;

  END LOOP;
  CLOSE hrmCompany_cursor;

  /*分部*/

  OPEN hrmSubCompany_cursor;

  LOOP
    FETCH hrmSubCompany_cursor
      INTO userId;
    EXIT WHEN hrmSubCompany_cursor%NOTFOUND;

    OPEN leftMenuInfo_cursor;
    LOOP
      FETCH leftMenuInfo_cursor
        INTO id_1, defaultIndex_1;
      EXIT WHEN leftMenuInfo_cursor%NOTFOUND;

      INSERT INTO LeftMenuConfig
        (userId,
         infoId,
         visible,
         viewIndex,
         resourceid,
         resourcetype,
         locked,
         lockedById,
         useCustomName)
      VALUES
        (userId, id_1, 1, defaultIndex_1, userId, '2', 0, 0, 0);

    END LOOP;

    CLOSE leftMenuInfo_cursor;

  END LOOP;
  CLOSE hrmSubCompany_cursor;

  /*系统管理员*/

  OPEN hrmResourceManager_cursor;
  LOOP

    FETCH hrmResourceManager_cursor
      INTO userId;
    EXIT WHEN hrmResourceManager_cursor%NOTFOUND;

    OPEN leftMenuInfo_cursor;
    LOOP

      FETCH leftMenuInfo_cursor
        INTO id_1, defaultIndex_1;
      EXIT WHEN leftMenuInfo_cursor%NOTFOUND;

      INSERT INTO LeftMenuConfig
        (userId,
         infoId,
         visible,
         viewIndex,
         resourceid,
         resourcetype,
         locked,
         lockedById,
         useCustomName)
      VALUES
        (userId, id_1, 1, defaultIndex_1, userId, '3', 0, 0, 0);
    END LOOP;

    CLOSE leftMenuInfo_cursor;

  END LOOP;
  CLOSE hrmResourceManager_cursor;

  /*用户*/

  OPEN hrmResource_cursor;

  LOOP

    FETCH hrmResource_cursor
      INTO userId;
    EXIT WHEN hrmResource_cursor%NOTFOUND;

    OPEN leftMenuInfo_cursor;

    LOOP
      FETCH leftMenuInfo_cursor
        INTO id_1, defaultIndex_1;
      EXIT WHEN leftMenuInfo_cursor%NOTFOUND;

      INSERT INTO LeftMenuConfig
        (userId,
         infoId,
         visible,
         viewIndex,
         resourceid,
         resourcetype,
         locked,
         lockedById,
         useCustomName)
      VALUES
        (userId, id_1, 1, defaultIndex_1, userId, '3', 0, 0, 0);

    END LOOP;

    CLOSE leftMenuInfo_cursor;

  END LOOP;
  CLOSE hrmResource_cursor;

  flag := 1;
  msg  := 'ok';


end;
/

create or replace procedure LeftMenuConfig_InsertByUserId
(userId_1 integer,
flag     out integer,
msg      out varchar2) as

  id_1           integer;
  defaultIndex_1 integer;
  subcompany_id  integer;
  locked         char(1);
  locked_by_id   integer;

  tmp_count_1 integer;
  tmp_count_2 integer;
  tmp_count_3 integer;
  tmp_count_4 integer;

  CURSOR leftMenuInfo_cursor IS
  /*只添加系统定义的左菜单*/ /*及管理员添加的维护菜单*/
    SELECT id, defaultIndex
      FROM LeftMenuInfo
     WHERE isCustom = '0'
        OR isCustom IS NULL
        OR isCustom = '2';

  CURSOR leftMenuInfo_cursor_1(c_userId_1 int) IS
    select subcompanyid
      from SysRoleSubcomRight
     where roleid in
           (select a.roleid
              from HrmRoleMembers a, SystemRightRoles b
             where a.roleid = b.roleid
               and a.resourceid = c_userId_1
               and b.rightid =
                   (select rightid
                      from SystemRightDetail
                     where rightdetail = 'SubMenu:Maint'))
     group by subcompanyid;

begin

  OPEN leftMenuInfo_cursor;
  LOOP
  
    FETCH leftMenuInfo_cursor
      INTO id_1, defaultIndex_1;
  
    EXIT WHEN leftMenuInfo_cursor%NOTFOUND;
  
    locked_by_id := 0;
    locked       := '0';
  
    /*管理员*/
    SELECT count(0)
      into tmp_count_1
      FROM HrmResourceManager
     WHERE id = userId_1;
    IF (tmp_count_1 > 0) THEN
      SELECT count(0)
        into tmp_count_2
        FROM LeftMenuConfig
       WHERE infoid = id_1
         AND resourceId = 1
         AND resourceType = '1'
         AND locked > 0;
    
      IF (tmp_count_2 > 0) THEN
        SELECT id
          INTO locked_by_id
          FROM LeftMenuConfig
         WHERE infoid = id_1
           AND resourceId = 1
           AND resourceType = '1';
      ELSE
      
        OPEN leftMenuInfo_cursor_1(userId_1);
        LOOP
          FETCH leftMenuInfo_cursor_1
            INTO subcompany_id;
        
          EXIT WHEN leftMenuInfo_cursor_1%NOTFOUND;
        
          SELECT count(0)
            into tmp_count_3
            FROM LeftMenuConfig
           WHERE infoid = id_1
             AND resourceId = subcompany_id
             AND resourceType = '2'
             AND locked > 0;
        
          IF (tmp_count_3 > 0) THEN
            SELECT id
              INTO locked_by_id
              FROM LeftMenuConfig
             WHERE infoid = id_1
               AND resourceId = subcompany_id
               AND resourceType = '2';
            EXIT;
          ELSE
            SELECT count(0)
              into tmp_count_4
              FROM LeftMenuConfig
             WHERE infoid = id_1
               AND resourceId = subcompany_id
               AND resourceType = '2'
               AND lockedbyid > 0;
          
            IF (tmp_count_4 > 0) THEN
              SELECT lockedbyid
                INTO locked_by_id
                FROM LeftMenuConfig
               WHERE infoid = id_1
                 AND resourceId = subcompany_id
                 AND resourceType = '2';
              EXIT;
            END IF;
          END IF;
        
        END LOOP;
      END IF;
    ELSE
      /*用户*/
      SELECT count(0)
        into tmp_count_1
        FROM LeftMenuConfig
       WHERE infoid = id_1
         AND resourceId = 1
         AND resourceType = '1'
         AND locked > 0;
      IF (tmp_count_1 > 0) THEN
        SELECT id
          INTO locked_by_id
          FROM LeftMenuConfig
         WHERE infoid = id_1
           AND resourceId = 1
           AND resourceType = '1';
      ELSE
        SELECT subcompanyid1
          into subcompany_id
          FROM HrmResource
         WHERE id = userId_1;
      
        SELECT count(0)
          into tmp_count_2
          FROM LeftMenuConfig
         WHERE infoid = id_1
           AND resourceId = subcompany_id
           AND resourceType = '2'
           AND locked > 0;
      
        IF (tmp_count_2 > 0) THEN
          SELECT id
            into locked_by_id
            FROM LeftMenuConfig
           WHERE infoid = id_1
             AND resourceId = subcompany_id
             AND resourceType = '2';
        ELSE
        
          SELECT count(0)
            into tmp_count_3
            FROM LeftMenuConfig
           WHERE infoid = id_1
             AND resourceId = subcompany_id
             AND resourceType = '2'
             AND lockedbyid > 0;
          IF (tmp_count_3 > 0) THEN
            SELECT lockedbyid
              into locked_by_id
              FROM LeftMenuConfig
             WHERE infoid = id_1
               AND resourceId = subcompany_id
               AND resourceType = '2';
          END IF;
        END IF;
      END IF;
    END IF;
  
    IF (locked_by_id > 0) THEN
      locked := '1';
    END IF;

    INSERT INTO LeftMenuConfig
      (userId,
       infoId,
       visible,
       viewIndex,
       resourceid,
       resourcetype,
       locked,
       lockedById,
       useCustomName)
    VALUES
      (userId_1,
       id_1,
       1,
       defaultIndex_1,
       userId_1,
       '3',
       locked,
       locked_by_id,
       '0');
  
  END LOOP;

  CLOSE leftMenuInfo_cursor;

  flag := 1;
  msg  := 'ok';

end;
/

create or replace procedure LeftMenuConfig_U_ByInfoInsert
(menuLevel_1    integer,
 parentId_1     integer,
 defaultIndex_1 integer,
 flag           out int,
 msg            out varchar2) as

  old_updateId      integer;
  old_resourceId    integer;
  old_resourceType  char(1);
  old_parentId      integer;
  
  curr_updateId     integer;
  curr_resourceId   integer;
  curr_resourceType char(1);
  curr_parentId     integer;
  
  indexCount        integer;

  CURSOR leftmenuviewindex_cursor1(c_defaultIndex_1 integer) IS
    SELECT t2.id, t2.resourceId, t2.resourceType, t1.parentid
      FROM LeftMenuInfo t1, LeftMenuConfig t2
     WHERE t1.id = t2.infoId
       AND (t1.parentid IS NULL OR t1.parentid = 0)
       AND t2.viewIndex >= c_defaultIndex_1
     ORDER BY resourceid,
              resourcetype,
              parentId,
              defaultIndex,
              viewindex,
              infoid;

  CURSOR leftmenuviewindex_cursor2(c_parentId_1 integer, c_defaultIndex_1 integer) IS
    SELECT t2.id, t2.resourceId, t2.resourceType, t1.parentid
      FROM LeftMenuInfo t1, LeftMenuConfig t2
     WHERE t1.id = t2.infoId
       AND t1.parentId = c_parentId_1
       AND t2.viewIndex >= c_defaultIndex_1
     ORDER BY resourceid,
              resourcetype,
              parentId,
              defaultIndex,
              viewindex,
              infoid;

begin

  /*顶级菜单*/
  IF (defaultIndex_1 < 1) THEN
    indexCount := 1;
  ELSE
    indexCount := defaultIndex_1;
  END IF;

  IF (menuLevel_1 = 1) THEN
  
    OPEN leftmenuviewindex_cursor1(defaultIndex_1);
    LOOP
    
      FETCH leftmenuviewindex_cursor1
        INTO curr_updateId, curr_resourceId, curr_resourceType, curr_parentId;
      EXIT WHEN leftmenuviewindex_cursor1%NOTFOUND;
    
      IF (curr_resourceId = old_resourceId AND
         curr_resourceType = old_resourceType AND
         (curr_parentId = old_parentId OR
         (curr_parentId IS NULL AND old_parentId IS NULL)) AND
         curr_updateId != old_updateId) THEN
      
        indexCount := indexCount + 1;
      
        UPDATE LeftMenuConfig
           SET viewIndex = indexCount
         WHERE id = curr_updateId;
      
      ELSE
      
        IF (defaultIndex_1 < 1) THEN
          indexCount := 1;
        ELSE
          indexCount := defaultIndex_1;
        END IF;
      
        UPDATE LeftMenuConfig
           SET viewIndex = indexCount
         WHERE id = curr_updateId;
      
      END IF;
    
      old_updateId     := curr_updateId;
      old_resourceId   := curr_resourceId;
      old_resourceType := curr_resourceType;
      old_parentId     := curr_parentId;
    
    END LOOP;
  
    CLOSE leftmenuviewindex_cursor1;
  
  ELSE
  
    IF (defaultIndex_1 < 1) THEN
      indexCount := 1;
    ELSE
      indexCount := defaultIndex_1;
    END IF;
  
    OPEN leftmenuviewindex_cursor2(parentId_1, defaultIndex_1);
    LOOP
    
      FETCH leftmenuviewindex_cursor2
        INTO curr_updateId, curr_resourceId, curr_resourceType, curr_parentId;
      EXIT WHEN leftmenuviewindex_cursor2%NOTFOUND;
    
      IF (curr_resourceId = old_resourceId AND
         curr_resourceType = old_resourceType AND
         (curr_parentId = old_parentId OR
         (curr_parentId IS NULL AND old_parentId IS NULL)) AND
         curr_updateId != old_updateId) THEN
      
        indexCount := indexCount + 1;
      
        UPDATE LeftMenuConfig
           SET viewIndex = indexCount
         WHERE id = curr_updateId;
      
      ELSE
        IF (defaultIndex_1 < 1) THEN
          indexCount := 1;
        ELSE
          indexCount := defaultIndex_1;
        END IF;
      
        UPDATE LeftMenuConfig
           SET viewIndex = indexCount
         WHERE id = curr_updateId;
      
      END IF;
    
      old_updateId     := curr_updateId;
      old_resourceId   := curr_resourceId;
      old_resourceType := curr_resourceType;
      old_parentId     := curr_parentId;
    
    END LOOP;
  
    CLOSE leftmenuviewindex_cursor2;
  
  END IF;

  flag := 1;
  msg  := 'ok';
  
end;
/

/*增加个人功能区菜单配置信息*/
create or replace procedure LeftMenuInfo_Insert(id_1              integer,
                                                labelId_1         integer,
                                                iconUrl_1         varchar2,
                                                linkAddress_1     varchar2,
                                                menuLevel_1       integer,
                                                parentId_1        integer,
                                                defaultIndex_1    integer,
                                                useCustomName_1   varchar2,
                                                customName_1      varchar2,
                                                relatedModuleId_1 integer,
                                                isCustom_1        varchar2,
                                                flag              out integer,
                                                msg               out varchar2) AS

  updateId    integer;
  updateIndex integer;

  CURSOR leftMenuInfo_cursor1(c_defaultIndex_1 integer) is
    SELECT id
      FROM LeftMenuInfo
     WHERE parentId IS NULL
       AND defaultIndex >= c_defaultIndex_1
     ORDER BY defaultIndex;

  CURSOR leftMenuInfo_cursor2(c_parentId_1 integer, c_defaultIndex_1 integer) is
    SELECT id
      FROM LeftMenuInfo
     WHERE parentId = c_parentId_1
       AND defaultIndex >= c_defaultIndex_1
     ORDER BY defaultIndex;

begin

  /*顶级菜单*/
  IF (menuLevel_1 = 1) THEN
  
    updateIndex := defaultIndex_1;
  
    /*更新大于插入记录Index 的 defaultIndex 加1*/
  
    OPEN leftMenuInfo_cursor1(defaultIndex_1);
  
    LOOP
    
      FETCH leftMenuInfo_cursor1
        INTO updateId;
    
      EXIT WHEN leftMenuInfo_cursor1%NOTFOUND;
    
      updateIndex := updateIndex + 1;
      UPDATE LeftMenuInfo
         SET defaultIndex = updateIndex
       WHERE id = updateId;
    
    END LOOP;
  
    CLOSE leftMenuInfo_cursor1;
  
    INSERT INTO LeftMenuInfo
      (id,
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
    VALUES
      (id_1,
       labelId_1,
       NULL,
       NULL,
       menuLevel_1,
       NULL,
       defaultIndex_1,
       useCustomName_1,
       customName_1,
       relatedModuleId_1,
       isCustom_1);
  ELSE
  
    updateIndex := defaultIndex_1;
    /*更新大于插入记录Index 的 defaultIndex 加1*/
  
    OPEN leftMenuInfo_cursor2(parentId_1,defaultIndex_1);
    LOOP
    
      FETCH leftMenuInfo_cursor2
        INTO updateId;
      EXIT WHEN leftMenuInfo_cursor1%NOTFOUND;
    
      updateIndex := updateIndex + 1;
    
      UPDATE LeftMenuInfo
         SET defaultIndex = updateIndex
       WHERE id = updateId;
    END LOOP;
  
    CLOSE leftMenuInfo_cursor2;
  
    INSERT INTO LeftMenuInfo
      (id,
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
    VALUES
      (id_1,
       labelId_1,
       iconUrl_1,
       linkAddress_1,
       menuLevel_1,
       parentId_1,
       defaultIndex_1,
       useCustomName_1,
       customName_1,
       relatedModuleId_1,
       isCustom_1);
  END IF;

  flag := 1;
  msg  := 'ok';

end;
/


create or replace procedure LMConfig_U_ByInfoInsert(menuLevel_1    integer,
                                                    parentId_1     integer,
                                                    defaultIndex_1 integer) AS
  old_updateId      integer;
  old_resourceId    integer;
  old_resourceType  char(1);
  old_parentId      integer;
  curr_updateId     integer;
  curr_resourceId   integer;
  curr_resourceType char(1);
  curr_parentId     integer;
  indexCount        integer;

  CURSOR leftmenuviewindex_cursor1(c_defaultIndex_1 integer) IS
    SELECT t2.id, t2.resourceId, t2.resourceType, t1.parentid
      FROM LeftMenuInfo t1, LeftMenuConfig t2
     WHERE t1.id = t2.infoId
       AND (t1.parentid IS NULL OR t1.parentid = 0)
       AND t2.viewIndex >= c_defaultIndex_1
     ORDER BY resourceid,
              resourcetype,
              parentId,
              viewindex,
              defaultIndex,
              infoid desc;

  CURSOR leftmenuviewindex_cursor2(c_parentId_1 integer, c_defaultIndex_1 integer) IS
    SELECT t2.id, t2.resourceId, t2.resourceType, t1.parentid
      FROM LeftMenuInfo t1, LeftMenuConfig t2
     WHERE t1.id = t2.infoId
       AND t1.parentId = c_parentId_1
       AND t2.viewIndex >= c_defaultIndex_1
     ORDER BY resourceid,
              resourcetype,
              parentId,
              viewindex,
              defaultIndex,
              infoid desc;

begin

  /*顶级菜单*/
  IF (menuLevel_1 = 1) THEN
  
    IF (defaultIndex_1 < 1) THEN
      indexCount := 1;
    ELSE
      indexCount := defaultIndex_1;
    END IF;
  
    OPEN leftmenuviewindex_cursor1(defaultIndex_1);
    LOOP
    
      FETCH leftmenuviewindex_cursor1
        INTO curr_updateId, curr_resourceId, curr_resourceType, curr_parentId;
      EXIT WHEN leftmenuviewindex_cursor1%NOTFOUND;
    
      IF (curr_resourceId = old_resourceId AND
         curr_resourceType = old_resourceType AND
         (curr_parentId = old_parentId OR
         (curr_parentId IS NULL AND old_parentId IS NULL)) AND
         curr_updateId != old_updateId) THEN
      
        indexCount := indexCount + 1;
      
     
      
      ELSE
      
        IF (defaultIndex_1 < 1) THEN
          indexCount := 1;
        ELSE
          indexCount := defaultIndex_1;
        END IF;
      

      
      END IF;
    
      old_updateId     := curr_updateId;
      old_resourceId   := curr_resourceId;
      old_resourceType := curr_resourceType;
      old_parentId     := curr_parentId;
    
    END LOOP;
  
    CLOSE leftmenuviewindex_cursor1;
  
  ELSE
  
    IF (defaultIndex_1 < 1) THEN
      indexCount := 1;
    ELSE
      indexCount := defaultIndex_1;
    END IF;
  
    OPEN leftmenuviewindex_cursor2(parentId_1, defaultIndex_1);
    LOOP
    
      FETCH leftmenuviewindex_cursor2
        INTO curr_updateId, curr_resourceId, curr_resourceType, curr_parentId;
      EXIT WHEN leftmenuviewindex_cursor1%NOTFOUND;
    
      IF (curr_resourceId = old_resourceId AND
         curr_resourceType = old_resourceType AND
         (curr_parentId = old_parentId OR
         (curr_parentId IS NULL AND old_parentId IS NULL)) AND
         curr_updateId != old_updateId) THEN
      
        indexCount := indexCount + 1;
      
       
      
      ELSE
      
        IF (defaultIndex_1 < 1) THEN
          indexCount := 1;
        ELSE
          indexCount := defaultIndex_1;
        END IF;
      
 
      
      END IF;
    
      old_updateId     := curr_updateId;
      old_resourceId   := curr_resourceId;
      old_resourceType := curr_resourceType;
      old_parentId     := curr_parentId;
    
    END LOOP;
  
    CLOSE leftmenuviewindex_cursor2;
  
  END IF;
end;
/
