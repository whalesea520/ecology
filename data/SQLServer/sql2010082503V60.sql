ALTER PROCEDURE HrmResourceShare(@resourceid_1 INT, @departmentid_1 INT, @subcompanyid_1 INT, @managerid_1 INT, @seclevel_1 INT, @managerstr_1 VARCHAR(500), @olddepartmentid_1 INT, @oldsubcompanyid_1 INT, @oldmanagerid_1 INT, @oldseclevel_1 INT, @oldmanagerstr_1 VARCHAR(500), @flag_1 INT, @flag INT OUTPUT, @msg VARCHAR(80) OUTPUT)  AS
/*					人员ID		部门ID			分部ID		经理ID			安全级别		所有上级																		标志位：添加为0；修改为1*/
DECLARE
 @supresourceid_1 INT,
 @docid_1  INT,
 @crmid_1  INT,
 @prjid_1  INT,
 @cptid_1  INT,
 @sharelevel_1  INT,
 @countrec  INT,
 @countdelete  INT,
 @contractid_1  INT,
 @contractroleid_1 INT,
 @sharelevel_Temp INT,
 @workPlanId_1  INT

/* 如果部门和安全级别信息被修改 */
IF(
 (@flag_1 = 1 AND (
   @departmentid_1 <> @olddepartmentid_1
   OR @oldsubcompanyid_1 <> @subcompanyid_1
   OR @seclevel_1 <> @oldseclevel_1
   OR @oldseclevel_1 IS NULL
   )
 ) OR @flag_1 = 0
)
BEGIN

    /* 修改目录许可表 */
    IF (@flag_1=1 AND ((@olddepartmentid_1 <> @departmentid_1) OR (@oldseclevel_1 <> @seclevel_1) OR (@oldsubcompanyid_1 <> @subcompanyid_1))) BEGIN
        EXECUTE Doc_DirAcl_DUserP_BasicChange @resourceid_1, @olddepartmentid_1, @oldsubcompanyid_1, @oldseclevel_1
    END
    IF ((@flag_1=0) or (@olddepartmentid_1 <> @departmentid_1) OR (@oldseclevel_1 <> @seclevel_1) OR (@oldsubcompanyid_1 <> @subcompanyid_1)) BEGIN
        EXECUTE Doc_DirAcl_GUserP_BasicChange @resourceid_1, @departmentid_1, @subcompanyid_1, @seclevel_1
    END

    /* 该人新建文档目录的列表 */
    EXEC DocUserCategory_InsertByUser @resourceid_1,'0','',''



 /* ------- DOC 部分 -------  */
 /*如果部门做了更换 需要把文档共享表中的同部门记录做修改*/
 IF ((@flag_1 = 1 AND @departmentid_1<>@olddepartmentid_1) OR @flag_1 = 0)
 BEGIN
  UPDATE shareinnerdoc SET content=@departmentid_1 WHERE type=3 AND  srcfrom=85 AND opuser=@resourceid_1
 END

 /*如果分部做了变化，需要把文档共享表中的同分部相关的记录做修改*/
 IF ((@flag_1 = 1 AND @subcompanyid_1<>@oldsubcompanyid_1) OR @flag_1 = 0)
 BEGIN
  UPDATE shareinnerdoc SET content=@subcompanyid_1 WHERE type=2 AND srcfrom=84 AND opuser=@resourceid_1
 END

    /* ------- CRM  部分 -----新的共享方式下，修改部门，分部和等级不影响共享-- */
    DECLARE @managerstr_11 VARCHAR(500)
    /* ------- PROJ 部分 ------- */

    /* 定义临时表变量 */
    DECLARE @temptablevaluePrj  TABLE(prjid INT,sharelevel INT)

    /*  将所有的信息现放到 @temptablevaluePrj 中 */
    /*  自己的项目2 */
    DECLARE prjid_cursor CURSOR FOR
    SELECT id FROM Prj_ProjectInfo WHERE manager = @resourceid_1
    OPEN prjid_cursor
    FETCH NEXT FROM prjid_cursor INTO @prjid_1
    WHILE @@fetch_status=0
    BEGIN
        INSERT INTO @temptablevaluePrj VALUES(@prjid_1, 2)
        FETCH NEXT FROM prjid_cursor INTO @prjid_1
    END
    CLOSE prjid_cursor DEALLOCATE prjid_cursor


    /* 自己下级的项目3 */
    /* 查找下级 */

    SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5),@resourceid_1) + ',%'

    DECLARE subprjid_cursor CURSOR FOR
    SELECT id FROM Prj_ProjectInfo WHERE ( manager IN (SELECT DISTINCT id FROM HrmResource WHERE ','+managerstr LIKE @managerstr_11 ) )
    OPEN subprjid_cursor
    FETCH NEXT FROM subprjid_cursor INTO @prjid_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(prjid) FROM @temptablevaluePrj WHERE prjid = @prjid_1
        IF @countrec = 0  INSERT INTO @temptablevaluePrj VALUES(@prjid_1, 3)
        FETCH NEXT FROM subprjid_cursor INTO @prjid_1
    END
    CLOSE subprjid_cursor DEALLOCATE subprjid_cursor

    /* 作为项目管理员能看到的项目4 */
    DECLARE roleprjid_cursor CURSOR FOR
   SELECT DISTINCT t1.id FROM Prj_ProjectInfo  t1, hrmrolemembers  t2  WHERE t2.roleid=9 AND t2.resourceid= @resourceid_1 AND (t2.rolelevel=2 OR (t2.rolelevel=0 AND t1.department=@departmentid_1) OR  (t2.rolelevel=1 AND t1.subcompanyid1=@subcompanyid_1 ))
    OPEN roleprjid_cursor
    FETCH NEXT FROM roleprjid_cursor INTO @prjid_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(prjid) FROM @temptablevaluePrj WHERE prjid = @prjid_1
        IF @countrec = 0  INSERT INTO @temptablevaluePrj VALUES(@prjid_1, 4)
        FETCH NEXT FROM roleprjid_cursor INTO @prjid_1
    END
    CLOSE roleprjid_cursor DEALLOCATE roleprjid_cursor


    /* 由项目的共享获得的权利 1 2 */
    DECLARE shareprjid_cursor CURSOR FOR
    SELECT DISTINCT t2.relateditemid , t2.sharelevel FROM Prj_ShareInfo  t2  WHERE  ( (t2.foralluser=1 AND t2.seclevel<=@seclevel_1)  OR ( t2.userid=@resourceid_1 ) OR (t2.departmentid=@departmentid_1 AND t2.seclevel<=@seclevel_1)  )
    OPEN shareprjid_cursor
    FETCH NEXT FROM shareprjid_cursor INTO @prjid_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(prjid) FROM @temptablevaluePrj WHERE prjid = @prjid_1
        IF @countrec = 0
        BEGIN
            INSERT INTO @temptablevaluePrj VALUES(@prjid_1, @sharelevel_1)
        END
        FETCH NEXT FROM shareprjid_cursor INTO @prjid_1 , @sharelevel_1
    END
    CLOSE shareprjid_cursor DEALLOCATE shareprjid_cursor


    DECLARE shareprjid_cursor CURSOR FOR
    SELECT DISTINCT t2.relateditemid , t2.sharelevel FROM Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers  t3  WHERE  t1.id = t2.relateditemid AND  t3.resourceid=@resourceid_1 AND t3.roleid=t2.roleid AND t3.rolelevel>=t2.rolelevel AND t2.seclevel<=@seclevel_1 AND ( (t2.rolelevel=0  AND t1.department=@departmentid_1) OR (t2.rolelevel=1 AND t1.subcompanyid1=@subcompanyid_1) OR (t3.rolelevel=2) )
    OPEN shareprjid_cursor
    FETCH NEXT FROM shareprjid_cursor INTO @prjid_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(prjid) FROM @temptablevaluePrj WHERE prjid = @prjid_1
        IF @countrec = 0
        BEGIN
            INSERT INTO @temptablevaluePrj VALUES(@prjid_1, @sharelevel_1)
        END
        FETCH NEXT FROM shareprjid_cursor INTO @prjid_1 , @sharelevel_1
    END
    CLOSE shareprjid_cursor DEALLOCATE shareprjid_cursor



    /* 项目成员5 (内部用户) */
    DECLARE @members_1 VARCHAR(200)
    SET @members_1 = '%,' + CONVERT(VARCHAR(5),@resourceid_1) + ',%'
    DECLARE inuserprjid_cursor CURSOR FOR
    SELECT  id FROM Prj_ProjectInfo   WHERE  (','+members+','  LIKE  @members_1)  AND isblock='1'
    OPEN inuserprjid_cursor
    FETCH NEXT FROM inuserprjid_cursor INTO @prjid_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(prjid) FROM @temptablevaluePrj WHERE prjid = @prjid_1
        IF @countrec = 0
        BEGIN
            INSERT INTO @temptablevaluePrj VALUES(@prjid_1, 5)
        END
        FETCH NEXT FROM inuserprjid_cursor INTO @prjid_1
    END
    CLOSE inuserprjid_cursor DEALLOCATE inuserprjid_cursor


    /* 删除原有的与该人员相关的所有项目权 */
    DELETE FROM PrjShareDetail WHERE userid = @resourceid_1 AND usertype = 1

    /* 将临时表中的数据写入共享表 */
    DECLARE allprjid_cursor CURSOR FOR
    SELECT * FROM @temptablevaluePrj
    OPEN allprjid_cursor
    FETCH NEXT FROM allprjid_cursor INTO @prjid_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN
        INSERT INTO PrjShareDetail( prjid, userid, usertype, sharelevel) VALUES(@prjid_1, @resourceid_1,1,@sharelevel_1)
        FETCH NEXT FROM allprjid_cursor INTO @prjid_1 , @sharelevel_1
    END
    CLOSE allprjid_cursor DEALLOCATE allprjid_cursor


    /* ------- CPT 部分 ------- */

    /* 定义临时表变量 */
    DECLARE @temptablevalueCpt  TABLE(cptid INT,sharelevel INT)

    /*  将所有的信息现放到 @temptablevalueCpt 中 */
    /*  自己的资产2 */
    DECLARE cptid_cursor CURSOR FOR
    SELECT id FROM CptCapital WHERE resourceid = @resourceid_1
    OPEN cptid_cursor
    FETCH NEXT FROM cptid_cursor INTO @cptid_1
    WHILE @@fetch_status=0
    BEGIN
        INSERT INTO @temptablevalueCpt VALUES(@cptid_1, 2)
        FETCH NEXT FROM cptid_cursor INTO @cptid_1
    END
    CLOSE cptid_cursor DEALLOCATE cptid_cursor

    /*  资产最后的修改者 */
    DECLARE cptid_cursor CURSOR FOR
    SELECT id FROM CptCapital WHERE lastmoderid = @resourceid_1
    OPEN cptid_cursor
    FETCH NEXT FROM cptid_cursor INTO @cptid_1
    WHILE @@fetch_status=0
    BEGIN
        INSERT INTO @temptablevalueCpt VALUES(@cptid_1, 1)
        FETCH NEXT FROM cptid_cursor INTO @cptid_1
    END
    CLOSE cptid_cursor DEALLOCATE cptid_cursor

    /* 自己下级的资产1 */
    /* 查找下级 */

    SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5),@resourceid_1) + ',%'

    DECLARE subcptid_cursor CURSOR FOR
    SELECT id FROM CptCapital WHERE ( resourceid IN (SELECT DISTINCT id FROM HrmResource WHERE ','+managerstr LIKE @managerstr_11 ) )
    OPEN subcptid_cursor
    FETCH NEXT FROM subcptid_cursor INTO @cptid_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(cptid) FROM @temptablevalueCpt WHERE cptid = @cptid_1
        IF @countrec = 0  INSERT INTO @temptablevalueCpt VALUES(@cptid_1, 1)
        FETCH NEXT FROM subcptid_cursor INTO @cptid_1
    END
    CLOSE subcptid_cursor DEALLOCATE subcptid_cursor


    /* 由资产的共享获得的权利 1 2 */
    DECLARE sharecptid_cursor CURSOR FOR
    SELECT DISTINCT t2.relateditemid , t2.sharelevel FROM CptCapitalShareInfo  t2  WHERE  ( (t2.foralluser=1 AND t2.seclevel<=@seclevel_1)  OR ( t2.userid=@resourceid_1 ) OR (t2.departmentid=@departmentid_1 AND t2.seclevel<=@seclevel_1)  )
    OPEN sharecptid_cursor
    FETCH NEXT FROM sharecptid_cursor INTO @cptid_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(cptid) FROM @temptablevalueCpt WHERE cptid = @cptid_1
        IF @countrec = 0
        BEGIN
            INSERT INTO @temptablevalueCpt VALUES(@cptid_1, @sharelevel_1)
        END
        FETCH NEXT FROM sharecptid_cursor INTO @cptid_1 , @sharelevel_1
    END
    CLOSE sharecptid_cursor DEALLOCATE sharecptid_cursor


    DECLARE sharecptid_cursor CURSOR FOR
    SELECT DISTINCT t2.relateditemid , t2.sharelevel FROM CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 WHERE t1.id=t2.relateditemid AND t3.resourceid= @resourceid_1 AND t3.roleid=t2.roleid AND t3.rolelevel>=t2.rolelevel AND t2.seclevel<= @seclevel_1 AND ( (t2.rolelevel=0  AND t1.departmentid= @departmentid_1 ) OR (t2.rolelevel=1 AND t1.departmentid=t4.id AND t4.subcompanyid1= @subcompanyid_1 ) OR (t3.rolelevel=2) )
    OPEN sharecptid_cursor
    FETCH NEXT FROM sharecptid_cursor INTO @cptid_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(cptid) FROM @temptablevalueCpt WHERE cptid = @cptid_1
        IF @countrec = 0
        BEGIN
            INSERT INTO @temptablevalueCpt VALUES(@cptid_1, @sharelevel_1)
        END
        FETCH NEXT FROM sharecptid_cursor INTO @cptid_1 , @sharelevel_1
    END
    CLOSE sharecptid_cursor DEALLOCATE sharecptid_cursor



    /* 删除原有的与该人员相关的所有资产权 */
    DELETE FROM CptShareDetail WHERE userid = @resourceid_1 AND usertype = 1

    /* 将临时表中的数据写入共享表 */
    DECLARE allcptid_cursor CURSOR FOR
    SELECT * FROM @temptablevalueCpt
    OPEN allcptid_cursor
    FETCH NEXT FROM allcptid_cursor INTO @cptid_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN
        INSERT INTO CptShareDetail( cptid, userid, usertype, sharelevel) VALUES(@cptid_1, @resourceid_1,1,@sharelevel_1)
        FETCH NEXT FROM allcptid_cursor INTO @cptid_1 , @sharelevel_1
    END
    CLOSE allcptid_cursor DEALLOCATE allcptid_cursor


     /* ------- 客户合同部分2003-11-06杨国生 ------- */

    /* 定义临时表变量 */
    DECLARE @temptablevaluecontract  TABLE(contractid INT,sharelevel INT)

    /*  将所有的信息现放到 @temptablevaluecontract 中 */

    /* 自己下级的客户合同 3 */

    SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5),@resourceid_1) + ',%'

    DECLARE subcontractid_cursor CURSOR FOR
    SELECT id FROM CRM_Contract WHERE ( manager IN (SELECT DISTINCT id FROM HrmResource WHERE ','+managerstr LIKE @managerstr_11 ) )
    OPEN subcontractid_cursor
    FETCH NEXT FROM subcontractid_cursor INTO @contractid_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(contractid) FROM @temptablevaluecontract WHERE contractid = @contractid_1
        IF @countrec = 0  INSERT INTO @temptablevaluecontract VALUES(@contractid_1, 3)
        FETCH NEXT FROM subcontractid_cursor INTO @contractid_1
    END
    CLOSE subcontractid_cursor DEALLOCATE subcontractid_cursor


    /*  自己是 manager 的客户合同 2 */
    DECLARE contractid_cursor CURSOR FOR
    SELECT id FROM CRM_Contract WHERE manager = @resourceid_1
    OPEN contractid_cursor
    FETCH NEXT FROM contractid_cursor INTO @contractid_1
    WHILE @@fetch_status=0
    BEGIN
        INSERT INTO @temptablevaluecontract VALUES(@contractid_1, 2)
        FETCH NEXT FROM contractid_cursor INTO @contractid_1
    END
    CLOSE contractid_cursor DEALLOCATE contractid_cursor



    /* 作为客户合同管理员能看到的 */
    DECLARE roleids_cursor CURSOR FOR
    SELECT roleid FROM SystemRightRoles WHERE rightid = 396
    OPEN roleids_cursor
    FETCH NEXT FROM roleids_cursor INTO @contractroleid_1
    WHILE @@fetch_status=0
    BEGIN

       DECLARE rolecontractid_cursor CURSOR FOR
       SELECT DISTINCT t1.id FROM CRM_Contract  t1, hrmrolemembers  t2  WHERE t2.roleid=@contractroleid_1 AND t2.resourceid=@resourceid_1 AND (t2.rolelevel=2 OR (t2.rolelevel=0 AND t1.department=@departmentid_1 ) OR (t2.rolelevel=1 AND t1.subcompanyid1=@subcompanyid_1 ));

        OPEN rolecontractid_cursor
        FETCH NEXT FROM rolecontractid_cursor INTO @contractid_1
        WHILE @@fetch_status=0
        BEGIN
            SELECT @countrec = count(contractid) FROM @temptablevaluecontract WHERE contractid = @contractid_1
            IF @countrec = 0
            BEGIN
                INSERT INTO @temptablevaluecontract VALUES(@contractid_1, 2)
            END
            ELSE
            BEGIN
                SELECT @sharelevel_1 = sharelevel FROM ContractShareDetail WHERE contractid = @contractid_1 AND userid = @resourceid_1 AND usertype = 1
                IF @sharelevel_1 = 1
                BEGIN
                     UPDATE ContractShareDetail SET sharelevel = 2 WHERE contractid = @contractid_1 AND userid = @resourceid_1 AND usertype = 1
                END
            END
            FETCH NEXT FROM rolecontractid_cursor INTO @contractid_1
        END
        CLOSE rolecontractid_cursor DEALLOCATE rolecontractid_cursor

     FETCH NEXT FROM roleids_cursor INTO @contractroleid_1
     END
     CLOSE roleids_cursor DEALLOCATE roleids_cursor


    /* 由客户合同的共享获得的权利 1 2 */
    DECLARE sharecontractid_cursor CURSOR FOR
    SELECT DISTINCT t2.relateditemid , t2.sharelevel FROM Contract_ShareInfo  t2  WHERE  ( (t2.foralluser=1 AND t2.seclevel<=@seclevel_1)  OR ( t2.userid=@resourceid_1 ) OR (t2.departmentid=@departmentid_1 AND t2.seclevel<=@seclevel_1)  )
    OPEN sharecontractid_cursor
    FETCH NEXT FROM sharecontractid_cursor INTO @contractid_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(contractid) FROM @temptablevaluecontract WHERE contractid = @contractid_1
        IF @countrec = 0
        BEGIN
            INSERT INTO @temptablevaluecontract VALUES(@contractid_1, @sharelevel_1)
        END
        ELSE
        BEGIN
            SELECT @sharelevel_Temp = sharelevel FROM @temptablevaluecontract WHERE contractid = @contractid_1
            IF ((@sharelevel_Temp = 1) AND (@sharelevel_1 = 2))
            UPDATE @temptablevaluecontract SET sharelevel = @sharelevel_1 WHERE contractid = @contractid_1
        END
        FETCH NEXT FROM sharecontractid_cursor INTO @contractid_1 , @sharelevel_1
    END
    CLOSE sharecontractid_cursor DEALLOCATE sharecontractid_cursor



    DECLARE sharecontractid_cursor CURSOR FOR
    SELECT DISTINCT t2.relateditemid , t2.sharelevel FROM CRM_Contract t1 ,  Contract_ShareInfo  t2,  HrmRoleMembers  t3  WHERE  t1.id = t2.relateditemid AND t3.resourceid=@resourceid_1 AND t3.roleid=t2.roleid AND t3.rolelevel>=t2.rolelevel AND t2.seclevel<=@seclevel_1 AND ( (t2.rolelevel=0  AND t1.department=@departmentid_1) OR (t2.rolelevel=1 AND t1.subcompanyid1=@subcompanyid_1) OR (t3.rolelevel=2) )
    OPEN sharecontractid_cursor
    FETCH NEXT FROM sharecontractid_cursor INTO @contractid_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(contractid) FROM @temptablevaluecontract WHERE contractid = @contractid_1
        IF @countrec = 0
        BEGIN
            INSERT INTO @temptablevaluecontract VALUES(@contractid_1, @sharelevel_1)
        END
        ELSE
        BEGIN
            SELECT @sharelevel_Temp = sharelevel FROM @temptablevaluecontract WHERE contractid = @contractid_1
            IF ((@sharelevel_Temp = 1) AND (@sharelevel_1 = 2))
            UPDATE @temptablevaluecontract SET sharelevel = @sharelevel_1 WHERE contractid = @contractid_1
        END
        FETCH NEXT FROM sharecontractid_cursor INTO @contractid_1 , @sharelevel_1
    END
    CLOSE sharecontractid_cursor DEALLOCATE sharecontractid_cursor


    /* 自己下级的客户合同  (客户经理及经理线)*/

    SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5),@resourceid_1) + ',%'

    DECLARE subcontractid_cursor CURSOR FOR
    SELECT t2.id FROM CRM_CustomerInfo t1 , CRM_Contract t2 WHERE ( t1.manager IN (SELECT DISTINCT id FROM HrmResource WHERE ','+managerstr LIKE @managerstr_11 ) ) AND (t2.crmId = t1.id)
    OPEN subcontractid_cursor
    FETCH NEXT FROM subcontractid_cursor INTO @contractid_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(contractid) FROM @temptablevaluecontract WHERE contractid = @contractid_1
        IF @countrec = 0  INSERT INTO @temptablevaluecontract VALUES(@contractid_1, 1)
        FETCH NEXT FROM subcontractid_cursor INTO @contractid_1
    END
    CLOSE subcontractid_cursor DEALLOCATE subcontractid_cursor


    /*  自己是 manager 的客户 (客户经理及经理线) */
    DECLARE contractid_cursor CURSOR FOR
    SELECT t2.id FROM CRM_CustomerInfo t1 , CRM_Contract t2 WHERE (t1.manager = @resourceid_1 ) AND (t2.crmId = t1.id)
    OPEN contractid_cursor
    FETCH NEXT FROM contractid_cursor INTO @contractid_1
    WHILE @@fetch_status=0
    BEGIN
        INSERT INTO @temptablevaluecontract VALUES(@contractid_1, 1)
        FETCH NEXT FROM contractid_cursor INTO @contractid_1
    END
    CLOSE contractid_cursor DEALLOCATE contractid_cursor


    /* 删除原有的与该人员相关的所有权 */
    DELETE FROM ContractShareDetail WHERE userid = @resourceid_1 AND usertype = 1

    /* 将临时表中的数据写入共享表 */
    DECLARE allcontractid_cursor CURSOR FOR
    SELECT * FROM @temptablevaluecontract
    OPEN allcontractid_cursor
    FETCH NEXT FROM allcontractid_cursor INTO @contractid_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN
        INSERT INTO ContractShareDetail( contractid, userid, usertype, sharelevel) VALUES(@contractid_1, @resourceid_1,1,@sharelevel_1)
        FETCH NEXT FROM allcontractid_cursor INTO @contractid_1 , @sharelevel_1
    END
    CLOSE allcontractid_cursor DEALLOCATE allcontractid_cursor


    /*================== 处理日程 ==================*/
    /*新的共享方式下，修改人员的部门，分部和等级不影响共享*/
    /* 日程共享结束 */



END        /* 结束修改了部门和安全级别的情况 */

/* 对于修改了经理字段 */
/* ------- DOC 部分 -------  */
/*只需要把docshareinner表中相应的经理做改动就可以了 81：表创建者上级*/
IF (@flag_1 = 1 AND @managerid_1 <> @oldManagerid_1)
BEGIN
UPDATE shareinnerdoc SET content=@managerid_1 WHERE srcfrom=81 AND opuser=@resourceid_1
END

/* 对于修改了经理字段 */
IF ( (@flag_1 = 1 AND @managerstr_1 <> @oldmanagerstr_1) OR @flag_1 = 0 )
BEGIN
    IF ( @managerstr_1 IS NOT NULL AND len(@managerstr_1) > 1 )  /* 有上级经理 */
    BEGIN

        SET @managerstr_1 = ',' + @managerstr_1

    /* ------- CRM 部分 -----新的共享方式下，修改经理在weaver.crm.CrmShareBase.setShareForNewManager中处理-- */


    /* ------- PROJ 部分 ------- */
    DECLARE supuserid_cursor CURSOR FOR
        SELECT DISTINCT t1.id , t2.id FROM HrmResource t1, Prj_ProjectInfo t2 WHERE @managerstr_1 LIKE '%,'+CONVERT(VARCHAR(5),t1.id)+',%' AND  t2.manager = @resourceid_1;
        OPEN supuserid_cursor
        FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @prjid_1
        WHILE @@fetch_status=0
        BEGIN
            SELECT @countrec = count(prjid) FROM PrjShareDetail WHERE prjid = @prjid_1 AND userid= @supresourceid_1 AND usertype= 1
            IF @countrec = 0
            BEGIN
                INSERT INTO PrjShareDetail( prjid, userid, usertype, sharelevel) VALUES(@prjid_1,@supresourceid_1,1,3)
            END
            FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @prjid_1
        END
        CLOSE supuserid_cursor DEALLOCATE supuserid_cursor


    /* ------- CPT 部分 ------- */
    DECLARE supuserid_cursor CURSOR FOR
        SELECT DISTINCT t1.id , t2.id FROM HrmResource t1, CptCapital t2 WHERE @managerstr_1 LIKE '%,'+CONVERT(VARCHAR(5),t1.id)+',%' AND  t2.resourceid = @resourceid_1;
        OPEN supuserid_cursor
        FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @cptid_1
        WHILE @@fetch_status=0
        BEGIN
            SELECT @countrec = count(cptid) FROM CptShareDetail WHERE cptid = @cptid_1 AND userid= @supresourceid_1 AND usertype= 1
            IF @countrec = 0
            BEGIN
                INSERT INTO CptShareDetail( cptid, userid, usertype, sharelevel) VALUES(@cptid_1,@supresourceid_1,1,1)
            END
            FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @cptid_1
        END
        CLOSE supuserid_cursor DEALLOCATE supuserid_cursor

         /* ------- 客户合同部分 经理改变 2003-11-06杨国生------- */
        DECLARE supuserid_cursor CURSOR FOR
        SELECT DISTINCT t1.id , t2.id FROM HrmResource t1, CRM_Contract t2 WHERE @managerstr_1 LIKE '%,'+CONVERT(VARCHAR(5),t1.id)+',%' AND  t2.manager = @resourceid_1;
        OPEN supuserid_cursor
        FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @contractid_1
        WHILE @@fetch_status=0
        BEGIN
            SELECT @countrec = count(contractid) FROM ContractShareDetail WHERE contractid = @contractid_1 AND userid= @supresourceid_1 AND usertype= 1
            IF @countrec = 0
            BEGIN
                INSERT INTO ContractShareDetail( contractid, userid, usertype, sharelevel) VALUES(@contractid_1,@supresourceid_1,1,3)
            END
            FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @contractid_1
        END
        CLOSE supuserid_cursor DEALLOCATE supuserid_cursor

        DECLARE supuserid_cursor CURSOR FOR
        SELECT DISTINCT t1.id , t3.id FROM HrmResource t1, CRM_CustomerInfo t2 ,CRM_Contract t3 WHERE @managerstr_1 LIKE '%,'+CONVERT(VARCHAR(5),t1.id)+',%' AND  t2.manager = @resourceid_1  AND t2.id = t3.crmId;
        OPEN supuserid_cursor
        FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @contractid_1
        WHILE @@fetch_status=0
        BEGIN
            SELECT @countrec = count(contractid) FROM ContractShareDetail WHERE contractid = @contractid_1 AND userid= @supresourceid_1 AND usertype= 1
            IF @countrec = 0
            BEGIN
                INSERT INTO ContractShareDetail( contractid, userid, usertype, sharelevel) VALUES(@contractid_1,@supresourceid_1,1,1)
            END
            FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @contractid_1
        END
        CLOSE supuserid_cursor DEALLOCATE supuserid_cursor




    END             /* 有上级经理判定结束 */
END   /* 修改经理的判定结束 */
GO
